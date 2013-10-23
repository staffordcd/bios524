/*******************************
Name: Christian Stafford
Assignment #3 Q2
Completed: 
Description: Update a PBRN dataset with new clinic information and calculate various
    metrics about the patient population and how they interact with the network.

NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
    SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>
*******************************/

libname bios524 'c:/bios524/data/';

/**************************************
needed to make this library assignment last time we used the ClinID format

I'm building the ClinID format fresh, using the script provided in class.
**************************************/
libname library 'c:/bios524/data/';

/**************************************
Read in the extant data sets
**************************************/
data pt_raw(rename = (clinid = clinicid));
    set bios524.patients;
run;

data clinic_raw;
    set bios524.clinics;
run;

/**************************************
Create the new clinics, format accordingly
**************************************/
data new_clinics;
    length contact $ 25 clinicid $ 3;
    format clinicid$ $clinid. phone phonum. DOEntry;
    informat doentry mmddyy8.;
    input clinicid $ contact $ phone NumPhys DOEntry;

    * I like comma-delmited data, if the input data contains whitespace(s) within fields;
    infile datalines delimiter = ','; 
    datalines;
    RPC,J. Pierpont Finch,8044453243110,4,07/23/99
    SIM,Nathan Detroit,8042235587330,3,02/22/99
    ;
run;    

/**************************************
Append the new clinics to the extant clinic data
**************************************/
proc append base = clinic_raw data = new_clinics;
run;

/**************************************
reformat the dates in DOV and DOB to make them easier to work with;
they don't have any time data associated with them, so there isn't any
informational loss

reformat clinic id
**************************************/
data pt_raw;
    set pt_raw;
    format dob dov mmddyy8. clinicid $clinid.;
    dob = datepart(dob);
    dov = datepart(dov);
run;

/**************************************
generate a list of patients eligible for participation:
pt index visit is 1st visit after clinic enters network
index visit is either S or H
index visit is NOT pt's 1st visit
pt age >= 18 at the time of the index visit

will take a few passes to whittle the data down in a stepwise fashion... my brain won't let me do this all at once.

derived age calculation from information at http://support.sas.com/publishing/authors/extras/61860_update.pdf

assign a globally-unique id to each pt
**************************************/
data pt_age;
    set pt_raw;

    age = INT(INTCK('MONTH', dob, dov)/12); 
    IF MONTH(dob) = MONTH(dov) THEN age = age - (DAY(dob) > DAY(dov));
    pt_guid = cat(clinicid, famid, patcode);
run;

/**************************************
Working toward picking out the eligible patients.
**************************************/
proc sort data = pt_age;
    by clinicid;
run;

proc sort data = clinic_raw;
    by ClinicID;
run;

/**************************************
Create a new dataset that contains all the clinic and pt demographic data
**************************************/
data pt_merged;
    merge pt_age clinic_raw;
    by clinicid;
    
run;

proc sort data = pt_merged;
    by pt_guid dov;
run;

/**************************************
Label index visits - is this a potential index visit?
0 == no, 1 == yes

First pass leaves dupes, but 2nd pass rectifies them.
**************************************/
data pt_merged;
    set pt_merged;
    by pt_guid;
    idx_visit = 0;
    if dov >= doentry and not first.pt_guid then
        idx_visit = 1;
run;

data index_visits;
    set pt_merged;
    by pt_guid idx_visit;
    if idx_visit and first.idx_visit then
        output;
run;

/**************************************
Having established which is the idx visit, apply
the other eligibility rules, keeping only patient ID and clinic code
per the instructions.
**************************************/
data eligible_pts(keep = pt_guid clinicid);
    set index_visits;
    if age >= 18 and (upcase(rfv) eq "S" or upcase(rfv) eq "H") then output;
run;

/**************************************
sort the eligible patients by clinic id and pt id
**************************************/
proc sort data = eligible_pts;
    by clinicid pt_guid;
run;

/**************************************
this was for me, I'll leave it commented out
**************************************/
/*proc print data = eligible_pts;*/
/*run;*/
/**/
/*proc freq data = eligible_pts;*/
/*run;*/

proc format;
    value $rfv_code "S" = "Sick Visit"
                    "H" = "Health Mgmt Exam"
                    "F" = "Follow-up"
                    "N" = "Nurse visit";
run;

/**************************************
distribution of visit reasons across all clinics
**************************************/
proc freq data = pt_raw;
    ods noproctitle; * turn off that odious "The X Procedure" nonsense;
    tables rfv;
    format rfv $rfv_code.;
    label RFV = "Reason for Visit";
    title "Distribution of Visit Codes";
    title2 "Across All Clinics";
    title3 "(question 4)";
run;

/**************************************
calculate the number of visits to each clinic over the range of dates in data set

since the 2 new clinics don't have any data associated with them, make sure they show
up as 0 visits.
**************************************/
proc sort data = pt_merged;
    by clinicid;
run;

data visits(keep = visits clinicid);
    set pt_merged;
    by clinicid;
    if first.clinicid then visits = 0;
    /* this will keep any zero-visit clinics from collecting a visit*/
    if dov then visits + 1;
    if last.clinicid then output;
run;

proc print data = visits label;
    title "Total Number of Visits to Clincs";
    title2 "(question 5)";
    label clinicid = "Clinic";
    label visits = "Total Visits";
run;

/**************************************
calculate the average number of visits per patient for each clinic
**************************************/
proc sort data = pt_merged;
    by pt_guid;
run;

data avg_pt_visit;
    set pt_merged;
    by pt_guid;
    if first.pt_guid then pt_visits = 0;
    * again, make sure we don't increment zero-patient clinics;
    if patcode not in("", ".") then pt_visits + 1;
    if last.pt_guid then output;
    keep clinicid pt_guid PatCode FamID pt_visits;
run;
proc sort data = avg_pt_visit;
    by clinicid;
run;

proc means data = avg_pt_visit mean;
    by clinicid;
    var pt_visits;
    label pt_visits = "Number of Visits";
    title "Average Number of Visits Per Patient";
    title2 "by Clinic";
    title3 "(question 6)";
run;

/**************************************
find mean and sd of age of pts by clinic, and % distribution of gender

want to de-dupe to count each pt only once, and use Jan 1, 2001 as the ref date
for age calculation
**************************************/
data dedupe;
    set pt_merged;
    by pt_guid;
    format ref_date mmddyy8.;
    ref_date = "01JAN2000"d;
    age_at_ref = INT(INTCK('MONTH', dob, ref_date)/12); 
    IF MONTH(dob) = MONTH(ref_date) THEN age_at_ref = age_at_ref - (DAY(dob) > DAY(ref_date));
    keep gender pt_guid age clinicid ref_date age_at_ref;
run;

proc sort data = dedupe nodupkey;
    by pt_guid;
run;

proc sort data = dedupe;
    by clinicid;
run;

proc means data = dedupe mean std;
    by clinicid;
    var age_at_ref;
    title "Mean and Standard Deviation of Age, by Clinic";
    title2 "Using Reference Date Jan 1, 2001";
    title3 "(question 7, first part)";
run;

proc freq data = dedupe;
    by clinicid;
    tables Gender /nocol nocum;
    title "Gender Distribution by Clinic";
    title2 "(question 7, second part)";
run;

/**************************************
count of all eligible pts, by clinic
**************************************/
proc means data = eligible_pts;
    by clinicid;
    title "Number of Eligible Patients, by Clinic";
    title2 "(question 8)";
run;

/**************************************
age and gender distribution of eligible pts across all clinics

use age at index visit
**************************************/
data eligible_ages;
    merge eligible_pts(in = ep) index_visits(in = iv);
    by pt_guid;
    if ep and iv then output;
    keep clinicid pt_guid age gender;
run;
proc sort data = eligible_ages;
    by age;
run;

proc freq data = eligible_ages;
/* wasn't sure if you wanted age * gender, or age and gender, so here are each!    */
    title "Distribution of Age and Gender of Eligible Patients, all clinics";
    title2 "(question 9)";
    tables age * Gender;
run;

proc freq data = eligible_ages;
    title "Distribution of Age of Eligible Patients, all clinics";
    tables age;
run;
proc freq data = eligible_ages;
    title "Distribution of Gender of Eligible Patients, all clinics";
    tables Gender;
run;