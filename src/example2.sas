data bios524.two;
input ID HEIGHT WEIGHT GENDER$ AGE; *	$ used to indicate char variable;
datalines;
1 68 144 M 23
2 78 202 M 34
3 62 99 F 37
4 61 101 F 45
;
proc print data = bios524.two;
title "Example 2";
title2 "Student Demographics";
run;
