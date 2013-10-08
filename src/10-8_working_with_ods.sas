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

/*  
    retain only the specified table
    NB: selection will apply to every proc statement, so make sure to switch it off!
    
    can also choose to not retain anything with ods exclude;
*/
ods select basicmeasures;

* retain all the tables (like the default behavior);
ods select all;

/*  
    print the contents of the BasicMeasures table to the new dataset agemeas
    NB: any additional proc output will be sent to this data set, unless
    the ods output is changed
*/
ods output basicmeasures=agemeas;

/*
    disable output to output window
*/
ods listing close;

/*
    Can only have 1 output type active at a time, i.e. they're mutually exclusive.
    output to rtf, html, pdf file
    
    destination close stmts after proc univariate below
*/
*ods rtf file = "c:\bios524\ods_rtf.rtf";
*ods html file = "c:\bios524\ods_html.html";
ods pdf file = "c:\bios524\ods_pdf.pdf";

proc univariate data = vital;
    var age;
run;

* turn off ODS trace;
ods trace off;

* close RTF output file;
*ods rtf close;

* close HTML file;
*ods html close;

*close pdf;
ods pdf close;
