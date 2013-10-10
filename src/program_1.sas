/*******************************************************************************/
/* Example Program 1 - Output Excel Spreadsheet and PDF w/ Shoes data */
/* Note: multiple statements on a line to demonstrate features */
/* for use with the Enterprise Guide PDF */
/*******************************************************************************/
data Ex_Shoes_Data;
    set sashelp.shoes;
    AverageSalesPerStore = sales / stores;
    label AverageSalesPerStore = 'Average Sales Per Store';
    format AverageSalesPerStore dollar12.2;
run;

ods listing close;
ods tagsets.ExcelXP path = 'C:\bios524\'
    file='EG Basic_Report.xls' style=statdoc
    options (sheet_name = 'Example 1'
    frozen_headers = 'Yes' autofilter = 'All' );
title "Simple SAS Code Example 1";

proc print data=Ex_Shoes_Data noobs label;
run;

ods tagsets.ExcelXP close;
ods listing;

/*******************************************************************/
/* Create PDF Report */
/*******************************************************************/
ods listing close;
ods pdf file = 'C:\bios524\EG Shoes_Report.pdf';

proc report data = Ex_Shoes_Data;
    column ("Location" (Region Subsidiary Stores))
        Product
        ("Sales" (Sales AverageSalesPerStore))
    ;
    define region / order "Region";
    define Subsidiary / order "Subsidiary";
    define Stores / display "Number of Stores";
    define Product / display "Product";
    define Sales / Sum "Sales";
    define AverageSalesPerStore / Sum "Avg Sales per Store";
    break after region / summarize;
    rbreak after / summarize;
run;

ods pdf close;
ods listing;