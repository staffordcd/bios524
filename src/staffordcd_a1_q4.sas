/*--------------------------------------------------------
Christian Stafford
Assignment #1, Question 4
Completed: 
Description: 
--------------------------------------------------------*/
/*--------------------------------------------------------
read in the raw data.

treating income as a string because the data are more categorical in nature than truly numerical.
--------------------------------------------------------*/
data raw;
    infile "c:\bios524\data\hw1.1.txt" firstobs = 2;
    length income $ 11;
    input rid ethnicity $ income $;
run;

/*--------------------------------------------------------
drop data where either income or ethnicity are N/A or missing
--------------------------------------------------------*/
data full_records;
    set raw;
    if missing(ethnicity) or missing(income) or income eq "NA" then delete;
run;

proc format;
    value $ ethnicity   "AA" = "African-American"
                        "CA" = "Caucasian";

    value $ income  "<25000" = "< $25000"
                    "25000-50000" = "$25000-$50000"
                    "50000-75000" = "$50000-$75000"
                    ">75000" = "> $75000";
                        
/*--------------------------------------------------------
print the freq table of the 4 income categories
--------------------------------------------------------*/
proc freq data = full_records;
    title "Income Stratification";
    tables income / out = income_table;
run;

/*--------------------------------------------------------
print the income*ethnicity table
--------------------------------------------------------*/
proc freq data = full_records;
    title "Income vs. Ethnicity";
    format income $income. ethnicity $ethnicity.;
    tables income * ethnicity;
run;
