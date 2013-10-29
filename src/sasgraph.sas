
ods graphics on;

proc freq data= sashelp.class;
tables sex;
run;

ods graphics off;

ods rtf style=Journal
   body="classreport.rtf"
   path="C:\Documents and Settings\ndmukhopadhy\My Documents\bios524\";
ods graphics on;

  proc freq data= sashelp.heart;
  tables smoking_status;
  tables weight_status*smoking_status;
  run;

  ods graphics off;
  ods rtf close;

ods graphics on / imagefmt=jpg;

  proc freq data= sashelp.heart;
  tables smoking_status;
  tables weight_status*smoking_status;
  run;

  ods graphics off;

  ods graphics on;
  proc univariate data= sashelp.heart normal;
  var weight;
  histogram weight/ normal;
  probplot weight/ normal;
  run;

  ods graphics off;

  /*  too many graphics  */

  ods graphics on;
  ods trace on;
  proc ttest data= sashelp.heart ; 
  class sex;
  var cholesterol;
  run;

  ods trace off;
  ods graphics off;

  /*  So revise accordingly  */

  ods graphics on;
  ods exclude qqplot;

  proc ttest data= sashelp.heart ; 
  class sex;
  var cholesterol;
  run;

 
  ods graphics off;
 

/*   SCATTER PLOT  */

goptions border vsize=7in  hsize=7.5in;
title h=1 c=red 'Framingham Heart study';

proc gplot data=sashelp.heart;
     plot cholesterol *weight
          / vminor=0 vaxis=50 to 500 by 50
            hminor=0 haxis=10 to 300 by 10;
run;

quit;

/*   BAR PLOT    */

proc gchart data=sashelp.heart;
     hbar sex / sumvar= cholesterol  type=mean;
run;
quit;

proc sgplot data=sashelp.heart;
     hbar sex / response=cholesterol stat=mean;
run;
quit;

/*   BOX PLOT  */

proc sort data =sashelp.heart out=fram;
by smoking;
run;

proc boxplot data=fram;
     plot cholesterol*smoking;
run;
quit;
