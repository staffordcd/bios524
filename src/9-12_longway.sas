/*
    Reading in lots of data categories the long way
*/

DATA LONGWAY;
    INPUT ID 1-3
    Ql 4
    Q2 5
    Q3 6
    Q4 7
    Q5 8
    Q6 9-10
    Q7 11-12
    Q8 13-14
    Q9 15-16
    Q10 17-18
    HEIGHT 19-20
    AGE 21-22;
DATALINES;
1011132410161415156823
1021433212121413167221
1032334214141212106628
1041553216161314126622
;
run;
PROC PRINT DATA=LONGWAY;
TITLE 'Example 9.1';
RUN;
