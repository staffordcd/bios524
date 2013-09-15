/*--------------------------------------------------------
Christian Stafford
Assignment #1, Question 3
Completed: 9/15/13
Description: tabulate financial information, printing it nicely to the screen

NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
    SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>
--------------------------------------------------------*/

/*--------------------------------------------------------
read in data with given input formats
--------------------------------------------------------*/
data raw;
    * infile "c:\bios524\data\build.txt"; * I keep my data in a different dir, changed below to default per instructions;
    infile "c:\bios524\build.txt"; 
    input income comma9.2 mort 10-13 @14 sales comma9.2 @24 date date9.;
run;

/*--------------------------------------------------------
print out nicely-formatted output
--------------------------------------------------------*/
proc print data = raw label;
    options nodate;
    *var income sales date mort;
    title "Income and Expenses";
    label income = "Income"
        sales = "Sales"
        mort = "Mortgage"
        date = "Date";
    format income dollar9.2 sales dollar9.2 date date9.;
run;
