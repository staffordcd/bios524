/*--------------------------------------------------------
Christian Stafford
Assignment #2, Question 2
Completed: 
Description: 
--------------------------------------------------------*/

libname bios524 "c:\bios524\data";

/*--------------------------------------------------------
Re-shape visit data and PSA readings for each pt from wide
to long.
--------------------------------------------------------*/
data reshape;
    set bios524.psa;
run;


