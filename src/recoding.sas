* data recoding;
Data GRADES;
Input ID SCORE @@;
DATALINES;
1 55 2 65 3 74 4 76 5 88 6 92 7 94 8 96 9 98
;
PROC PRINT DATA= GRADES;
Title 'Raw Data';
RUN;
DATA RECODE;
    SET GRADES;
    IF 0 LE SCORE LT 65 THEN GRADE=0;
    ELSE IF 65 LE SCORE LT 70 THEN GRADE=1;
    ELSE IF 70 LE SCORE LT 80 THEN GRADE=2;
    ELSE IF 80 LE SCORE LT 90 THEN GRADE=3;
    ELSE IF SCORE GE 90 THEN GRADE=4;
RUN;
PROC PRINT DATA=RECODE;
TITLE 'Recoded Data';
RUN;
DATA RECODE;
    SET GRADES;
    SELECT; * select can be more efficient than if/else;
        WHEN (0 LE SCORE LT 65) GRADE=0;
        WHEN (65 LE SCORE LT 70) GRADE=1;
        WHEN (70 LE SCORE LT 80) GRADE=2;
        WHEN (80 LE SCORE LT 90) GRADE=3;
        WHEN (SCORE GE 90) GRADE=4;
    END;
RUN;
/*
    the above approaches create new variables to do the recoding;
    often, the duplication can be really inefficient. Using a PROC FORMAT
    can format the data without copying it, which is more efficient.
*/

PROC FORMAT;
    VALUE SCOREFMT
        0-64='Fail' /* SCOREFMT is name of new format, can be anything */
        65-69='Low Pass'
        70-79='Pass'
        80-89='High Pass'
        90-HIGH='Honors'; *HIGH is a keyword, range includes 90 to the highest value found;
RUN;
PROC FREQ DATA=GRADES;
    TITLE 'Using FORMAT instead of copying';
    TABLES SCORE;
    FORMAT SCORE SCOREFMT.;
RUN;
