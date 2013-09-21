/*--------------------------------------------------------
Christian Stafford
Assignment #2, Question 1
Completed: 
Description: 
--------------------------------------------------------*/

data raw;
    infile "c:\bios524\data\transplant.txt";
    input @1 id $ @7 txm
run;
