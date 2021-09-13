--1st case------------------

insert into itde1.efim_rep_fraud (event_dt, passport, fio, phone, event_type, report_dt)
select 
	trans.trans_date as event_id, 
	clients.passport_num, 
	clients.last_name || ' ' || clients.first_name || ' ' || clients.patronymic as fio, 
	clients.phone, 
	'1' event_type,
	(select last_update from itde1.efim_meta_tables where db_name = 'ITDE1'
	and table_name = 'EFIM_DWH_DIM_TERMINALS') as report_dt
from itde1.efim_dwh_dim_clients clients
left join itde1.efim_dwh_dim_accounts accounts
	on clients.client_id = accounts.client
left join itde1.efim_dwh_dim_cards cards
	on accounts.account_num = cards.account_num
left join itde1.efim_dwh_fact_transactions trans
	on trim(cards.card_num) = trim(trans.card_num)
where (clients.passport_num in (select passport_num from itde1.efim_dwh_fact_pssprt_blcklst)
or clients.passport_valid_to < (select last_update from itde1.efim_meta_tables where db_name = 'ITDE1'
		and table_name = 'EFIM_DWH_DIM_TERMINALS'))
and trunc(trans.trans_date) = (select last_update from itde1.efim_meta_tables where db_name = 'ITDE1'
		and table_name = 'EFIM_DWH_DIM_TERMINALS');

--2nd case--------------

insert into itde1.efim_rep_fraud (event_dt, passport, fio, phone, event_type, report_dt)
select 
	trans.trans_date as event_id, 
	clients.passport_num, 
	clients.last_name || ' ' || clients.first_name || ' ' || clients.patronymic as fio, 
	clients.phone, 
	'1' event_type,
	(select last_update from itde1.efim_meta_tables where db_name = 'ITDE1'
	and table_name = 'EFIM_DWH_DIM_TERMINALS') as report_dt
from itde1.efim_dwh_dim_clients clients
left join itde1.efim_dwh_dim_accounts accounts
	on clients.client_id = accounts.client
left join itde1.efim_dwh_dim_cards cards
	on accounts.account_num = cards.account_num
left join itde1.efim_dwh_fact_transactions trans
	on trim(cards.card_num) = trim(trans.card_num)
where accounts.valid_to < (select last_update from itde1.efim_meta_tables where db_name = 'ITDE1'
		and table_name = 'EFIM_DWH_DIM_TERMINALS')
and trunc(trans.trans_date) = (select last_update from itde1.efim_meta_tables where db_name = 'ITDE1'
		and table_name = 'EFIM_DWH_DIM_TERMINALS');