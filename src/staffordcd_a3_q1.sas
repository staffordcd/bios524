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
    format total dollar12.2.
run;

proc sort data = summed;
    by descending total;
run;

proc print data = summed;
    format total dollar10.2;
run;



    
/**************************************
a. the products are Bed, Chair, Desk, Sofa, Table 
b. the product with the highest overall sales during the reporting period was desk.
**************************************/