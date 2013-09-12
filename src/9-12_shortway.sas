* read in multiple categories the short way;
data shortway;
    input
        ID 1-3 /* standard input range indicator */
        @4 (Q1-Q5)(1.) /* starting at position 4, Q1-Q5 are each 1 number long */
        @9 (Q6-Q10 HEIGHT AGE)(2.); /* starting at position 9, Q6-Q10, height, and age are each 2 numbers long */
    datalines;
1011132410161415156823
1021433212121413167221
1032334214141212106628
1041553216161314126622
;

run;
