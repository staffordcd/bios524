/*--------------------------------------------------------
Christian Stafford
Assignment #1, Question 4
Completed: 9/15/13
Description: analyze income vs. ethnicity information, visualize with a frequency table and cross table.
    Entries missing data or marked "NA" will be discarded.

NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
    SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>
--------------------------------------------------------*/

/*--------------------------------------------------------
read in the raw data.

treating income as a string because the data are more categorical in nature than truly numerical.
data has header, so start reading data at line 2
--------------------------------------------------------*/
data raw;
    *infile "c:\bios524\data\hw1.1.txt" firstobs = 2; * I keep my data in a different dir, changed below to default;
    infile "c:\bios524\hw1.1.txt" firstobs = 2;
    length income $ 11;
    input rid ethnicity $ income $;
run;

/*--------------------------------------------------------
omit data where either income or ethnicity are N/A or missing
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
