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
Enumerate the different products available; don't really care about the statistics per se.
(for part a)
**************************************/
proc freq data = raw(keep = product);
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

proc print data = summed label;
    label total = "Total Sales";
    format total dollar12.2;
    title "Products by Overall Sales";
    title2 "(Answer 1b)";
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
proc print data = summed label;
    title "Highest Sales in Education Division - 1994";
    title2 "(Answer 1d)";
    format total dollar12.2;
    label total = "Total Sales";
run;

/**************************************
a. the products are Bed, Chair, Desk, Sofa, Table 
b. the product with the highest overall sales during the reporting period was desk.
c. Canada: Desk; Germany: Sofa; USA: Chair
d. Chair is the best-selling item from Education division in 1994.

**************************************/