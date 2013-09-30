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

/*--------------------------------------------------------
Create & display distribution statistics of recipient race (rec_race) - Q1c.
--------------------------------------------------------*/
proc freq data = raw;
    title "Distribution by Recipient Race";
    tables rec_race;
    format rec_race race.;
run;

/*--------------------------------------------------------
Create different race format to group types differently - Q1d.
--------------------------------------------------------*/
proc format;
    value broad_race    1 = "White"
                        2 = "Black"
                        3-7 = "Asian/Pacific Islander/Arabian/Indian Subcontinent/American Indian/Alaska native"
                        998 = "Missing"
                        999 = "Missing"
                        8 = "Missing"
                        . = "Missing";
run;

/*--------------------------------------------------------
Cross-classify recipient race and donor race using broad race definition,
create table with only raw counts of transplants (Q1d),
--------------------------------------------------------*/
proc freq data = raw;
    title "Cross-tabulation of Donor vs. Recipient Race";
    title2 "Broad race categorization";
    tables rec_race * don_race /nopercent norow nocol nocum;
    format rec_race don_race broad_race.;
run;

/*--------------------------------------------------------
Format to categorize ages into chunks
--------------------------------------------------------*/
proc format;
    value age_bracket   0-10 = "0-10 years"
                        11-20 = "11-20 years"
                        21-30 = "21-30 years"
                        31-40 = "31-40 years"
                        41-50 = "41-50 years"
                        51-60 = "51-60 years"
                        61-999 = "61+ years";
run;

/*--------------------------------------------------------
Show tables of recipient age by age bracket, and of donor age by age bracket.
--------------------------------------------------------*/
proc freq data = raw;
    title "Organ Recipients and Donors";
    title2 "by age bracket";
    tables rec_age don_age;
    format rec_age don_age age_bracket.;
run;

/*--------------------------------------------------------
Clean the raw data for some calculations.

NB: discards missing values, discards values other than Y or N.
--------------------------------------------------------*/
data cleaned;
    set raw;
    if gftfail ne "Y" and gftfail ne "N" then delete;
run;

/*--------------------------------------------------------
Create table of graft failures by sex
--------------------------------------------------------*/
proc freq data = cleaned;
    title "Proportion of Graft Failures";
    title2 "by sex";
    tables gftfail * rec_sex;
run;


/*--------------------------------------------------------
Answers to Q1:
    b. Per instructions in class, only the recipients are classified as patients; thus, there are 4682 patients in the data set.

--------------------------------------------------------*/
