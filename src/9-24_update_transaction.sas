/*--------------------------------------------------------
updates usually come about like this, where there is a master file and
a transaction file that enumerates what needs to be changed (updated!)
in the master file
--------------------------------------------------------*/

data master;
    input id dept$ salary dollar6.;
    datalines;
    1 parts 13000
    2 person 21000
    3 parts 15000
    4 exec 55000
    5 . 18000
;
run;

data trans;
    input id dept$ salary dollar12.; * dollar12 here to include enough space for commas and currency symbol;
    datalines;
    2 . 22000
    3 sales 24000
    5 records .
;
run;

data new_master;
    update master trans;
    by id;
run;

proc print data = new_master;
    format salary dollar12.2;
    title 'Updated Master Data Set';
run;
