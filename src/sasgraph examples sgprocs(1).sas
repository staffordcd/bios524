*Create the scatter plot. In the SCATTER statement, 
the GROUP= option groups the data by the SEX variable.;
ods listing sge = on;
proc sgplot data=sashelp.class;
  scatter x=height y=weight / group=sex;
run;


*Create the scatter plot. In the SCATTER statement, ;
*the GROUP= option groups the data by the TYPE variable. ;
*The GROUPDISPLAY option specifies that the grouped;
*markers are clustered. The CLUSTERWIDTH option specifies ;
*the width of the group clusters.;

proc sgplot data=sashelp.revhub2;
  scatter x=hub y=revenue / 
    group=type groupdisplay=cluster clusterwidth=0.5;
  xaxis type=discrete;
run;

*Specify the data set and the title.;

proc sgplot data=sashelp.stocks
  (where=(date >= "01jan2000"d and stock = "IBM"));
  title "Stock Trend";

*Create the series plots.;

  series x=date y=close;
  series x=date y=low;
  series x=date y=high;
run;

*Create the regression plot. The CLM option adds 
*confidence limits for the mean predicted values. 
*The CLI option adds confidence limits for the 
*individual predicted values.;

proc sgplot data=sashelp.class;
  reg x=height y=weight / CLM CLI;
run;

/*Adding a Prediction Ellipse to a Scatter Plot 
Set the title and create the scatter plot.*/

proc sgplot data=sashelp.iris;
  title "Iris Petal Dimensions";
  scatter x=petallength y=petalwidth;

*Create the ellipse.;

  ellipse x=petallength y=petalwidth;

*Position the Legend. The LOCATION= option places 
  the legend inside of the plot area. The POSITION= 
  option places the legend at the bottom right.;

  keylegend / location=inside position=bottomright;
run;

********************************************************
*Creating Lines and Bands from Pre-Computed Data ;

*Set the title and create the first band plot. The 
LEGENDLABEL= option in the BAND statement specifies 
the label for the band plot in the legend.;

proc sgplot data=sashelp.classfit;
  title "Fit and Confidence Band from Precomputed Data";
  band x=height lower=lower upper=upper /
       legendlabel="95% CLI" name="band1";
  

*Create the second band plot. The LEGENDLABEL= option 
specifies the label for the band plot in the legend. 
The FILLATTRS= option specifies the style element for the fill.;

  band x=height lower=lowermean upper=uppermean /
       fillattrs=GraphConfidence2
       legendlabel="95% CLM" name="band2";
  scatter x=height y=weight;
  series x=height y=predict / lineattrs=GraphPrediction
         legendlabel="Predicted Fit" name="series";

*Create the scatter and series plots. The LINEATTRS= option 
in the SERIES statement specifies the style attribute for the 
series plot. The LEGENDLABEL= option in the SERIES statement 
specifies the legend label for the series plot.

Create a legend for the graph. The quoted strings specify the 
names of the plots that you want to include in the legend. 
The LOCATION= option places the legend inside of the plot area. 
The POSITION= option places the legend in the bottom right 
corner of the graph.;

  keylegend "series" "band1" "band2" / location=inside
position=bottomright;
run;

/*Create the dot plot. The RESPONSE= option specifies the 
response variable. The STAT= option specifies that the mean 
statistic is used to analyze the graph. The LIMITSTAT= option 
specifies that the limit statistic is the standard deviation. 
The NUMSTD= option specifies that one standard deviation is used.
*/
proc sgplot data=sashelp.class(where=(age<16));
  dot age / response=height stat=mean
            limitstat=stddev numstd=1;
run;

*Set the title, set a label for the X axis, and create the histogram.;

proc sgplot data=sashelp.heart;
  title "Cholesterol Distribution";
  histogram cholesterol;

*Create the density plots. The TYPE= option specifies which 
  density equation is used.;

  density cholesterol;
  density cholesterol / type=kernel;

*Position the Legend The LOCATION= option places the legend 
  inside of the plot area. The POSITION= option places the 
  legend at the top right.;

  keylegend / location=inside position=topright;
run;

*Create Horizontal the box plot. The CATEGORY= option 
specifies the category variable.;

proc sgplot data=sashelp.heart;
  title "Cholesterol Distribution by Weight Class";
  hbox cholesterol / category=weight_status;
run;
title;


*Create the Bar-line Chart.The Y2AXIS option assigns 
the line plot to the Y2 axis.;

proc sgplot data=sashelp.stocks (where=(date >= "01jan2000"d
                                 and date <= "01jan2001"d
                                 and stock = "IBM"));
   title "Stock Volume vs. Close";
   vbar date / response=volume;
   vline date / response=close y2axis;
run;
title;

/*Create the high-low chart.The HIGH, LOW, and CLOSE variables 
are used in the HIGHLOW statement. In addition, the plot subsets 
the data by year and by company.
*/
title "Stock High, Low, and Close"; 
proc sgplot data=sashelp.stocks;
  where Date >= '01JAN2005'd and stock='IBM';
  highlow x=date high=high low=low 
    / close=close;
run;
title;

**   sgpanel examples  **************************;

*Create the panel and specify the title.;

proc sgpanel data=sashelp.heart noautolegend;
  title "Cholesterol Distribution in Heart Study";

*Specify the classification variable for the panel.;

  panelby sex;

*Create the histogram and density plots.;

  histogram cholesterol;
  density cholesterol;
run;


title;

/*Panels of regression curves;
Create the panel and specify the title.*/

proc sgpanel data=sashelp.iris;
  title "Scatter plot for Fisher iris data";

/*Specify the classification variable for the panel. 
  The COLUMNS= option specifies the number of columns in the panel.*/

  panelby species / columns=3;
 

/*Create the regression curve. The CLI option creates 
  individual predicted value confidence limits. The CLM 
  option creates mean value confidence limits.*/

 reg x=sepallength y=sepalwidth / cli clm;
run;


title;

* Panel of bar charts ;
*Create the panel and set the title.;

proc sgpanel data=sashelp.prdsale;
  title "Yearly Sales by Product";

*Specify the classification variable for the panel. 
  The NOVARNAME option specifies that the variable name 
  is not shown in the heading for each cell. 
  The COLUMNS= option specifies the number of columns in the panel.;

  panelby year / novarname columns=1;

*Create the horizontal bar chart. The RESPONSE= option 
  specifies the response variable for the chart.;

  hbar product / response=actual;
run;


title;

*Create the panel and specify a title.;
ods listing sge=on;
proc sgpanel data=sashelp.prdsale;
  where product in ("CHAIR" "SOFA");
  title "Yearly Sales by Product";

*Specify the classification variable for the panel. 
  The SPACING= option specifies the number of pixels 
  between the panels in the plot. The NOVARNAME option 
  specifies that the classification variable name is not 
  shown in the headings for each cell.;

  panelby year / spacing=5 novarname;

*Create the vertical line plot. The RESPONSE= option 
  specifies the response variable. The GROUP= option 
  specifies the group variable.;

  vline month / response=actual group=product;
run;


title;
