libname bios524 "c:\bios524";

data bios524.one;
input quiz;
cards;
6
7
10
8
9
9
3
6
5
10
;
proc print;
run;
proc univariate data=one;
var quiz;
run;
