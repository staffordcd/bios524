ods graphics on;

proc freq data = sashelp.class;
    tables sex /plots=freqplot;
run;
ods graphics off;

ods graphics on;
  proc univariate data= sashelp.heart normal;
  var weight;
  histogram weight/ normal;
  probplot weight/ normal;
  run;
ods graphics off;

/*--------------------------------------------------------
Scatterplot :
--------------------------------------------------------*/ 
ods graphics on;
proc gplot data=sashelp.heart;
     plot cholesterol *weight
          / vminor=0 vaxis=50 to 500 by 50
            hminor=0 haxis=10 to 300 by 10;
    quit;
run;
ods graphics off;

ods graphics on;
proc gplot data=sashelp.heart;
     plot cholesterol *weight;
     plot2 systolic * weight;
     quit;
run;
ods graphics off;

ods graphics on;
proc gplot data=sashelp.heart;
     plot (cholesterol  systolic)*weight /overlay;
     quit;
run;
ods graphics off;

ods graphics on;
proc gchart data=sashelp.heart;
     hbar sex / sumvar=cholesterol type=mean;
run;
quit;
ods graphics off;

ods graphics on;
proc sgplot data=sashelp.heart;
     hbar sex / response=cholesterol stat=mean;
run;
quit;

proc boxplot data=sashelp.heart;
     plot cholesterol*sex /maxpanels = 200;
run;
quit;

ods graphics off;
