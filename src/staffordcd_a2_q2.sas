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
    array visit_dates{*} visit1date--visit7date;
    array visit_psas{*} visit1psa--visit7psa;
    do visit = 1 to 7;
        date = visit_dates(visit);
        psa = visit_psas(visit);
        output;
    end;
            drop visit date;
run;
