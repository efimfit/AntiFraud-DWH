#---cleaning all tables------

delete from itde1.efim_meta_tables;
delete from  itde1.efim_stg_accounts;
delete from  itde1.efim_stg_cards;
delete from  itde1.efim_stg_clients;
delete from  itde1.efim_stg_passport_blacklist;
delete from  itde1.efim_stg_terminals;
delete from  itde1.efim_stg_transactions;
delete from itde1.efim_dwh_dim_accounts;
delete from itde1.efim_dwh_dim_cards;
delete from itde1.efim_dwh_dim_clients;
delete from itde1.efim_dwh_dim_terminals;
delete from itde1.efim_dwh_fact_transactions;
delete from itde1.efim_dwh_fact_pssprt_blcklst;
delete from itde1.efim_rep_fraud;

#-----init metadata------------------

insert into itde1.efim_meta_tables(db_name, table_name, last_update)
values('ITDE1', 'EFIM_DWH_DIM_ACCOUNTS', to_date('1800-01-01', 'YYYY-MM-DD'));

insert into itde1.efim_meta_tables(db_name, table_name, last_update)
values('ITDE1', 'EFIM_DWH_DIM_CARDS', to_date('1800-01-01', 'YYYY-MM-DD'));

insert into itde1.efim_meta_tables(db_name, table_name, last_update)
values('ITDE1', 'EFIM_DWH_DIM_CLIENTS', to_date('1800-01-01', 'YYYY-MM-DD'));

insert into itde1.efim_meta_tables(db_name, table_name, last_update)
values('ITDE1', 'EFIM_DWH_FACT_PSSPRT_BLCKLST', to_date('1800-01-01', 'YYYY-MM-DD'));

insert into itde1.efim_meta_tables(db_name, table_name, last_update)
values('ITDE1', 'EFIM_DWH_DIM_TERMINALS', to_date('1800-01-01', 'YYYY-MM-DD'));

insert into itde1.efim_meta_tables(db_name, table_name, last_update)
values('ITDE1', 'EFIM_DWH_FACT_TRANSACTIONS', to_date('1800-01-01', 'YYYY-MM-DD'));

