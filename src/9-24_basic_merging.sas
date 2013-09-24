data demog1;
    input id gender$ state$;
    datalines;
    1 m ny
    5 m ny
    2 f nj
    3 f nj
    4 m ny
;
run;

data employee;
    input id dept$ salary dollar6.0;
    datalines;
    1 parts 21000
    2 sales 45000
    3 parts 20000
    5 sales 35000
    6 sales 45000
;
run;

proc sort data = demog1;
    by id;
run;

data both;
/*--------------------------------------------------------
if the data exists in both data sets, only then do the merge
--------------------------------------------------------*/
    merge demog1(in = a) employee(in = b);
    if a and b;
        by id;
run;
