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

data pt_base_wt(rename = (weightkg = base_weight));
    set vitals_raw;
    by pat_id;
    if first.pat_id then output;
    drop visit unsched_ contact_ height_c;
run;

/**************************************
create a dataset with base height, convert to meters
**************************************/
data pt_base_ht;
    set vitals_raw;
    height_m = height_c / 100;
    if height_c then output;
run;

proc sort data = pt_base_ht;
    by pat_id;
run;

data pt_base_ht;
    set pt_base_ht;
    by pat_id;
    if first.pat_id then output;
    keep pat_id height_c height_m;
run;

/**************************************
merge the datasets, so we have one set with all the base height and weight info
**************************************/
data pt_base(rename = (height_c = base_height));
    merge pt_base_ht(in = h) pt_base_wt(in = w);
    by pat_id;
    if h and w then output;
run;

/**************************************
calculate BMI based on height and weight
**************************************/
data pt_base;
    set pt_base;
    base_bmi = base_weight / (height_m ** 2);
run;

/**************************************
start building up a way to calculate change in BMI and weight from visit to visit
**************************************/
data merged;
    merge pt_base(in = pb) vitals_raw(in = vr);
    by pat_id;
    if pb and vr then output;
run;

