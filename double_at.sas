* double-at input modifier;
DATA SHORTWAY;
/*
w/o @@: pulls in 1, 2, 6, 9; ignores the rest
w/ @@: reads X,Y coords until it exhausts all the data
*/
* INPUT X Y;
INPUT X Y @@;
DATALINES;
1 2 3 4 5 6
6 9 10 12 13 14
;
PROC PRINT DATA=SHORTWAY;
TITLE 'Example 11.2';
RUN;
