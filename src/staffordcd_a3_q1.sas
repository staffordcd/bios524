/*******************************
Name: Christian Stafford
Assignment #3 Q1
Completed: 
Description: Categorize and describe various statistics about product sales

NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
    SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>
*******************************/

libname bios 'c:/bios524/data/';

/**************************************
Read in the raw sales data
**************************************/
data raw;
    set bios.prdsale;
run;

/**************************************
peek at the raw data - removed for production
**************************************/
/*proc contents data = raw;*/
/*run;*/

/**************************************
Enumerate the different products available; don't really care about the statistics per se.
(for part a)
**************************************/
proc freq data = raw(keep = product);
    ods noproctitle; * turn off that odious "The X Procedure" nonsense;
    title "The Products as Reported";
    title2 "(Answer 1a)";
    tables product /nocum nopercent;
run;

/**************************************
Find product w/ overall highest sales during the reporting period.

Use the by-grouping to segregate by product, and use an accumulator (total)
to track the total sales of that product.

To use by-grouping, must sort first.
**************************************/
proc sort data = raw;
    by product;
run;

data summed(keep = product total);
    set raw;
    by product;
    if first.product then total = 0;
    total + actual;
    if last.product then output;
run;

/**************************************
sort the data so the best seller is at the top
**************************************/
proc sort data = summed;
    by descending total;
run;

proc print data = summed(obs = 1) noobs label;
    label total = "Total Sales";
    format total dollar12.2;
    title "Overall Top-Selling Product";
    title2 "(Answer 1b)";
run;

/**************************************
I'm creating a lot of intermediate data sets, so delete the temp. data set for housekeeping purposes
**************************************/
proc delete data = summed;
run;

/**************************************
Find the product with the highest sales per country.

Sort by country, then use unsorted by-grouping with product.
Use accumulator (total) to track the sales amount.

NB: output displays only the data requested
**************************************/
proc sort data = raw;
    by country;
run;

data summed;
    set raw;
    by product notsorted;

    if first.product then total = 0;
    total + actual;

    if last.product then output;
    format total dollar12.2;
    keep product country total;
run;

/**************************************
Sort the summary dataset by country and total, then output the last
entry in each country by-group: will be the highest total sales
due to this sort.
**************************************/
proc sort data = summed;
    by country total;
run;

data highest;
    set summed;
    by country;
    if last.country then output;
run;

/**************************************
Report results!
**************************************/
proc print data = highest label;
    label total = "Total Sales";
    format total dollar12.2;
    title "Highest Sales by Country";
    title2 "(Answer 1c)";
run;

/**************************************
I'm creating a lot of intermediate data sets, so delete the temp. data set for housekeeping purposes
**************************************/
proc delete data = summed highest;
run;

/**************************************
Find product with highest sales in Education division in 1994

Subset out the data to make it easier to work with
**************************************/
data edu_1994;
    set raw;
    if lowcase(division) eq "education" and year = 1994 then output;
run;

/**************************************
Tally up the total sales by product, must sort first.
**************************************/
proc sort data = edu_1994;
    by product;
run;

data summed(keep = product total);
    set edu_1994;
    by product;
    if first.product then total = 0;
    total + actual;
    if last.product then output;
run;

/**************************************
sort the data appropriately prior to printing
**************************************/
proc sort data = summed;
    by descending total;
run;

/**************************************
Print results
**************************************/
proc print data = summed(obs = 1) noobs label;
    title "Top-Selling Product in Education Division - 1994";
    title2 "(Answer 1d)";
    format total dollar12.2;
    label total = "Total Sales";
run;

/**************************************
I'm creating a lot of intermediate data sets, so delete the temp. data set for housekeeping purposes
**************************************/
proc delete data = summed edu_1994;
run;

/**************************************
Identify which products sold better than expected in the US, by division

Subset out all US data, then sort by division and product for starters
**************************************/
data us_sales;
    set raw;
    if lowcase(country) eq "u.s.a." then output;
    format actual predict dollar12.2;
run;

proc sort data = us_sales;
    by division product;
run;

/**************************************
Find overall difference between predicted and actual sales by product within division
**************************************/
data diff;
    set us_sales;
    by division product;
    if first.product then do
        tot_act = 0;
        tot_pred = 0;
        tot_prod_diff = 0;
    end;
    tot_pred + predict;
    tot_act + actual;
    tot_prod_diff + (actual - predict);
    if last.product then output;

    format tot_act tot_pred tot_prod_diff dollar12.2;
    label tot_act = "Actual Sales";
    label tot_pred = "Predicted Sales";
    label tot_prod_diff = "Difference (act-pred)";
run;

/**************************************
Segregate sales data based on positive or negative total sales
**************************************/
data good_sales poor_sales;
    set diff;
    if tot_prod_diff > 0 then output good_sales;
    else output poor_sales;
    keep division product tot_pred tot_act tot_prod_diff;
run;

/**************************************
report data
**************************************/
proc print data = good_sales label;
    by division;
    title "Product Sales Outperforming Predictions, by Division";
    title2 "(Answer 1e)";
run;

/**************************************
I'm creating a lot of intermediate data sets, so delete the temp. data set for housekeeping purposes
**************************************/
proc delete data = good_sales poor_sales diff us_sales;
run;

/**************************************
Question 1, Part F

Show sales data for German, consumer-division, office, Q1, 1993

Subset out the desired data
**************************************/
data deu_sales;
    set raw;
    if lowcase(country) eq "germany" and lowcase(division) eq "consumer"
        and lowcase(prodtype) eq "office" and quarter = 1 and year = 1993 then
            output;
run;

/**************************************
display the data
**************************************/
proc print data = deu_sales;
    title "Sales Data for Germany";
    title2 "Consumer Division, Office";
    title3 "Q1, 1993";
    title4 "(Answer 1f)";
run;
    
/**************************************
a. the products are Bed, Chair, Desk, Sofa, Table 
b. the product with the highest overall sales during the reporting period was desk.
c. Canada: Desk; Germany: Sofa; USA: Chair
d. Chair is the best-selling item from Education division in 1994.
e. Bed, Chair, Table beat the predicted sales in Consumer; Chair, Desk, Sofa beat predictions in Education.
f. see above code.
**************************************/