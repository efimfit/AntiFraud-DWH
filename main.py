import jaydebeapi
import pandas as pd
import os
import glob
import shutil

#----------Oracle connection-----------
#----------------------------------------

conn = jaydebeapi.connect(
'oracle.jdbc.driver.OracleDriver',
'jdbc:oracle:thin:itde1/bilbobaggins@de-oracle.chronosavant.ru:1521/deoracle',
['itde1', 'bilbobaggins'],
'/home/itde1/ojdbc8.jar')
curs = conn.cursor()
conn.autocommit=False

#-----------Cleaning staging tables------------
#------------------------------------------------

commands = open('sql_scripts/clean_stg.sql', 'r').read().split(';')
i = 0
while i < len(commands) - 1: 
	curs.execute(commands[i])
	i = i + 1

#-------Parsing csv, xlsx files-----------------
#-----------------------------------------------

transactions_file = glob.glob('transactions_*')[0]
passport_file = glob.glob('passport_blacklist_*')[0]
terminals_file = glob.glob('terminals_*')[0]

transactions_data = pd.read_csv(transactions_file, sep=';', dtype=str)
passport_data = pd.read_excel( passport_file, dtype=str, sheet_name='blacklist')
terminals_data = pd.read_excel( terminals_file, dtype=str, sheet_name='terminals')

#----------Reflesh meta for terminals---------------------
#-----------------------------------------------------------

our_date = os.path.basename(terminals_file).split('.')[0].split('_')[1]
curs.execute("""update itde1.efim_meta_tables
	set last_update = to_date(?, 'DDMMYYYY')
	where db_name = 'ITDE1'
	and table_name = 'EFIM_DWH_DIM_TERMINALS' """
	, [our_date] )


# ---------Rename and moving files to archive----------
#----------------------------------------------------------

shutil.move(transactions_file, 'archive/' + transactions_file + '.backup')
shutil.move(passport_file, 'archive/' + passport_file + '.backup')
shutil.move(terminals_file, 'archive/' + terminals_file + '.backup')


#----------Upload fact transactions and passports (without staging step)------------
#----------------------------------------------------------------------------------------

curs.executemany("""insert into itde1.efim_dwh_fact_transactions(
		trans_id,
		trans_date,
		amt,
		card_num,
		oper_type,
		oper_result,
		terminal)
	values (?, to_date(?, 'YYYY-MM-DD HH24:MI:SS'), replace(?, ',', '.'), ?, ?, ?, ?)
	""", transactions_data.values.tolist())

#------delete at first to avoid overwriting--------
curs.execute("delete from itde1.efim_dwh_fact_pssprt_blcklst")

curs.executemany("""insert into itde1.efim_dwh_fact_pssprt_blcklst(
		entry_dt,
		passport_num)
	values (to_date(?,'YYYY-MM-DD HH24:MI:SS'),?)
	""", passport_data.values.tolist())

#---------Upload stg_terminals-----------
#-------------------------------------------

curs.executemany("""insert into itde1.efim_stg_terminals(
		terminal_id,
		terminal_type,
		terminal_city,
		terminal_address)
	values (?,?,?,?)
	""", terminals_data.values.tolist())

#---------------Upload dwh_terminals--------------
#-----------------------------------------------------

curs.execute("""merge into itde1.efim_dwh_dim_terminals tgt
	using itde1.efim_stg_terminals stg
	on (tgt.terminal_id = stg.terminal_id)
	when matched then update set
		tgt.terminal_type =        stg.terminal_type,
		tgt.terminal_city =         stg.terminal_city,
		tgt.terminal_address =   stg.terminal_address,
		tgt.update_dt =            (select last_update from itde1.efim_meta_tables
				       where db_name = 'ITDE1' and table_name = 'EFIM_DWH_DIM_TERMINALS')
	when not matched then insert (tgt.terminal_id, tgt.terminal_type, tgt.terminal_city, tgt.terminal_address, tgt.create_dt) 
	values (stg.terminal_id, stg.terminal_type, stg.terminal_city, stg.terminal_address, 
		(select last_update from itde1.efim_meta_tables
		where db_name = 'ITDE1' and table_name = 'EFIM_DWH_DIM_TERMINALS')) 
""")


#---------------Upload stg and dwh from bank tables--------------
#---------------------------------------------------------------------

commands = open('sql_scripts/upload_bank_tables.sql', 'r').read().split(';')
i = 0
while i < len(commands) - 1: 
	curs.execute(commands[i])
	i = i + 1


#---------Reflesh metadata--------------
#-----------------------------------------

commands = open('sql_scripts/reflesh_meta.sql', 'r').read().split(';')
i = 0
while i < len(commands) - 1: 
	curs.execute(commands[i])
	i = i + 1

#--------------Create report-----------------
#---------------------------------------------

commands = open('sql_scripts/report.sql', 'r').read().split(';')
i = 0
while i < len(commands) - 1: 
	curs.execute(commands[i])
	i = i + 1

curs.execute("commit")
curs.close()
conn.close()
