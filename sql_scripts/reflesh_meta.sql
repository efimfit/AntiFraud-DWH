update itde1.efim_meta_tables
set last_update = (select max (coalesce (update_dt, create_dt)) from itde1.efim_stg_cards)
	where db_name='ITDE1' and table_name='EFIM_DWH_DIM_CARDS'
	and (select max (coalesce (update_dt, create_dt)) from itde1.efim_stg_cards) is not null;

update itde1.efim_meta_tables
set last_update = (select max (coalesce (update_dt, create_dt)) from itde1.efim_stg_accounts)
	where db_name='ITDE1' and table_name='EFIM_DWH_DIM_ACCOUNTS'
	and (select max (coalesce (update_dt, create_dt)) from itde1.efim_stg_accounts) is not null;

update itde1.efim_meta_tables
set last_update = (select max (coalesce (update_dt, create_dt)) from itde1.efim_stg_clients)
	 where db_name='ITDE1' and table_name='EFIM_DWH_DIM_CLIENTS'
	 and (select max (coalesce (update_dt, create_dt)) from itde1.efim_stg_clients) is not null;