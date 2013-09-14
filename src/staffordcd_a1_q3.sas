/*--------------------------------------------------------
Christian Stafford
Assignment #1, Question 3
Completed: 
Description: 
--------------------------------------------------------*/

/*--------------------------------------------------------
read in data with given input formats
--------------------------------------------------------*/
data raw;
    infile "c:\bios524\data\build.txt";
    input income comma9.2 mort 10-13 @14 sales comma9.2 @24 date date9.;
run;

/*--------------------------------------------------------
print out nicely-formatted output
--------------------------------------------------------*/
proc print data = raw;
    title "Income and Expenses";
    format income dollar9.2 sales dollar9.2 date date9.;
run;
