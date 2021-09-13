# :white_check_mark: AntiFraud-DWH

## Description
Design an ETL process that receives a daily data upload
(provided 3 days in advance) uploading it to the datastore and daily
building report
### :page_facing_up: Uploading data

Every day, some information systems unload the following three
file:
1. List of transactions for the current day. The format is CSV.
2. List of terminals in full slice. The format is XLSX.
3. List of passports included in the "black list" - cumulative with
the beginning of the month. The format is XLSX.
Information about cards, accounts and customers is stored in the Oracle DBMS in the BANK schema.
You are provided with an unload for the last three days, it needs to be processed


### :page_facing_up: Storage structure
The data should be loaded into the storage with the following structure
(the names of the entities are indicated essentially, without the peculiarities of the naming rules,
indicated below):


### :page_facing_up: Building a report
Based on the results of the download, it is necessary to build a showcase daily
reporting on fraudulent transactions. The showcase is built by accumulation,
each new report fits into the same table with a new report_dt.
The showcase should contain the following fields:
* event_dt The time when the event occurred. If the event occurred by the result of several actions - the duration of the action is indicated,
which established the fact of fraud.
* passport Passport number of the client who committed the fraudulent
operation.
* fio Full name of the customer who committed the fraudulent transaction.
* phone Phone number of the customer who committed the fraudulent
operation.
* event_type Description of the type of fraud.
* report_dt Time to build the report.


### :page_facing_up: File handling
The uploaded files are named according to the following pattern:
- transactions_DDMMYYYY.txt
- passport_blacklist_DDMMYYYY.xlsx
- terminals_DDMMYYYY.xlsx
It is assumed that one such file comes in one day. After
downloading the corresponding file it should be renamed to file with
with the extension .backup so that the file is not searched for the next time and
moved to archive directory:
- transactions_DDMMYYYY.txt.backup
- passport_blacklist_DDMMYYYY.xlsx.backup
- terminals_DDMMYYYY.xlsx.backup
