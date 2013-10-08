data vital;
    title2 'Patient vital statistics';
    input patient $ age gender $ hbp;   
datalines;
ABC 24 M 120
DEF 65 F 178
GHI 67 M 159
JKL 87 M 128
MNO 35 M 188
PQR 34 F 217
STU 63 F 178
VWX 34 F 189
XYZ 46 M 165
;
run;

* print internal table names to the log, makes picking the desired output easier;
ods trace on;

* tell sas to write to an external html file;
ods html file = "c:\bios524\ods_exercise_out.html";

/*--------------------------------------------------------
create frequency table of gender distribution

written to external HTML file
--------------------------------------------------------*/
proc freq data = vital;
    tables gender;
run;

* turn off ODS trace;
ods trace off;

* close HTML file;
ods html close;
