--stg cards----------------

insert into itde1.efim_stg_cards(card_num, account, create_dt, update_dt)
select card_num, account, create_dt, update_dt
from bank.cards
where coalesce(update_dt, create_dt) > (select last_update
	from itde1.efim_meta_tables
	where db_name = 'ITDE1' and table_name = 'EFIM_DWH_DIM_CARDS');


--dwh cards----------------
merge into itde1.efim_dwh_dim_cards tgt
using itde1.efim_stg_cards stg
on (tgt.card_num = stg.card_num)
when matched then update set
	tgt.account_num =    stg.account,
	tgt.create_dt =  stg.create_dt,
	tgt.update_dt = stg.update_dt
when not matched then insert (tgt.card_num, tgt.account_num, tgt.create_dt, tgt.update_dt)
values (stg.card_num, stg.account, stg.create_dt, stg.update_dt);

		

--stg clients----------------
insert into itde1.efim_stg_clients(client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone, create_dt, update_dt)
select client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone, create_dt, update_dt
from bank.clients
where coalesce(update_dt, create_dt) > (select last_update
	from itde1.efim_meta_tables
	where db_name = 'ITDE1' and table_name = 'EFIM_DWH_DIM_CLIENTS');


--dwh clients----------------
merge into itde1.efim_dwh_dim_clients tgt
using itde1.efim_stg_clients stg
on (tgt.client_id = stg.client_id)
when matched then update set
	tgt.last_name =           stg.last_name,
	tgt.first_name =           stg.first_name,
	tgt.patronymic =          stg.patronymic,
	tgt.date_of_birth =       stg.date_of_birth,
	tgt.passport_num =      stg.passport_num,
	tgt.passport_valid_to = stg.passport_valid_to,
	tgt.phone =                 stg.phone,
	tgt.create_dt =             stg.create_dt,
	tgt.update_dt =            stg.update_dt
when not matched then insert (tgt.client_id, tgt.last_name, tgt.first_name, tgt.patronymic, tgt.date_of_birth, tgt.passport_num, tgt.passport_valid_to, tgt.phone, tgt.create_dt, 		tgt.update_dt)
values (stg.client_id, stg.last_name, stg.first_name, stg.patronymic, stg.date_of_birth, stg.passport_num, stg.passport_valid_to, stg.phone, stg.create_dt, stg.update_dt);



--stg accounts----------------
insert into itde1.efim_stg_accounts(account, valid_to, client, create_dt, update_dt)
select account, valid_to, client, create_dt, update_dt
from bank.accounts
where coalesce(update_dt, create_dt) > (select last_update
	from itde1.efim_meta_tables
	where db_name = 'ITDE1' and table_name = 'EFIM_DWH_DIM_ACCOUNTS');


--dwh accounts----------------
merge into itde1.efim_dwh_dim_accounts tgt
using itde1.efim_stg_accounts stg
on (tgt.account_num = stg.account)
when matched then update set
	tgt.valid_to =    stg.valid_to,
	tgt.client =       stg.client,
	tgt.create_dt =  stg.create_dt,
	tgt.update_dt = stg.update_dt
when not matched then insert (tgt.account_num, tgt.valid_to, tgt.client, tgt.create_dt, tgt.update_dt)
values (stg.account, stg.valid_to, stg.client, stg.create_dt, stg.update_dt);