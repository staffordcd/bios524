/*--------------------------------------------------------
Christian Stafford
Assignment #2, Question 1
Completed: 
Description: 
--------------------------------------------------------*/

/*--------------------------------------------------------
read in the raw data, formatting it as necessary.
add labels to the variables to make them more descriptive

length statements used here to eliminate wonky reading/assignment I was getting
--------------------------------------------------------*/
data raw;
    infile "c:\bios524\data\transplant.txt";
    length rec_sex $ 1 livstat $ 1 gftfail $ 1 don_type $ 1 ;
    input @1 id $ @7 txm @10 txd @13 txy @18 t 4. @22 livstat $ @23 gftfail $ @25 don_type $ @26 prev_ki $ @28 prev_num @32 rec_race 3. @35 rec_sex $
        @ 37 rec_age @41 don_race 3. @44 don_sex $ @46 don_age;
    label id = "Patient ID"
        txm = "Month of Transplant"
        txd = "Day of Transplant"
        txy = "Year of Transplant"
        t = "Survival Time (days)"
        livstat = "Patient Alive?"
        gftfail = "Graft Failure?"
        don_type = "Donor Type"
        prev_ki = "Previous transplant?"
        prev_num = "No. of Prev. Transplants"
        rec_race = "Recipient Race"
        rec_sex = "Recipient Gender"
        rec_age = "Recipient Age"
        don_race = "Donor Race"
        don_sex = "Donor Gender"
        don_age = "Donor Age";
run;

/*--------------------------------------------------------
display some summary information about the data set (Q1, part B)
--------------------------------------------------------*/
proc contents data = raw;
    title  "Contents of Raw Dataset";
run;

/*--------------------------------------------------------
set up format to classify all 'undetermined' 'unknown' or
'other' races as 'missing'
--------------------------------------------------------*/
proc format;
    value race  1 = "White"
                2 = "Black"
                3 = "American Indian / Alaskan Native"
                4 = "Asian"
                5 = "Pacific Islander"
                6 = "Mideast / Arabian"
                7 = "Indian Sub-continent"
                998 = "Missing"
                999 = "Missing"
                8 = "Missing"
                . = "Missing";
run;

proc freq data = combined_race_info;

run;

/*--------------------------------------------------------
Answers to Q1:
    b. There are 4682 records in the data set, but if we're to count the recipient and donor as discrete patients, there are 9364 total patients.

--------------------------------------------------------*/
