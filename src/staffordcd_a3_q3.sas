/*******************************
Name: Christian Stafford
Assignment #3 Q3
Completed: 
Description: 

NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
    SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>
*******************************/

libname bios524 "c:/bios524";

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
start building up a way to calculate current change in BMI and weight using base as a reference point
**************************************/
data merged;
    merge pt_base(in = pb) vitals_raw(in = vr);
    by pat_id;
    if pb and vr then output;
run;

data diffs;
    set merged;
    delta_wt = weightkg - base_weight;
    delta_bmi = (weightkg / (height_m ** 2)) - base_bmi;
run;

/**************************************
summarize the diffs by mean and std dev for each week
**************************************/
proc sort data = visit_raw;
    by pat_id;
run;

proc sort data = diffs;
    by pat_id;
run;

data merged;
    merge diffs(in = d) visit_raw(in = vr);
    by pat_id;
    if d and vr then output;
run;

proc sort data = merged;
    by visweek;
run;

proc means data = merged n mean std;
    by visweek;
    label visweek = "Visit Week";
    var delta_bmi delta_wt;
    title "Changes in BMI and Weight";
    title2 "Mean and Standard Deviation";
    title3 "by Week";
    title4 "(question 3 part c)";
run;
