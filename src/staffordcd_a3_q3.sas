/*******************************
Name: Christian Stafford
Assignment #3 Q3
Completed: 
Description: 

NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
    SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>
*******************************/

libname bios524 "c:/bios524/data/";

/**************************************
read in raw data
**************************************/
data vitals_raw;
    set bios524.vitals;
run;

data visit_raw;
    set bios524.visit;
run;

/**************************************
create dataset with base weight: earliest known weight of pt
**************************************/
proc sort data = vitals_raw;
    by pat_id visit;
run;

data pt_base_weight(rename = (weightkg = base_weight));
    set vitals_raw;
    by pat_id;
    if first.pat_id then output;
    drop visit unsched_ contact_;
run;

