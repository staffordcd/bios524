/*******************************
Name: Christian Stafford
Assignment #4
Completed: 
Description: 
*******************************/

libname bios "c:/bios524/data/";

/**************************************
import the excel file

needed to specify DBMS=xls to get around an incompatibility between x64 SAS
and x86 MS Office; I can't guarantee this will work on any system other than 
my own!
**************************************/
proc import out=brainsize DBMS = xls replace
    datafile="c:/bios524/data/iq_brain.xls";
/*    datafile="c:/bios524/iq_brain.xls";*/
run;

/**************************************
assign a unique ID to each subject, should be able to just use _N_ since
the idx value itself is arbitrary and need only be unique

separate based on birth order

I don't know why, but for some reason the OUTPUT cmd is removing the
data from brainsize?  I've adjusted the output cmds below to make sure
brainsize isn't emptied out.
**************************************/
data bios.order1 bios.order2 brainsize;
    set brainsize;
    subcode = _N_;
    if order = 1 then output bios.order1 brainsize; * output to brainsize as well, otherwise it "loses" the record;
    else if order = 2 then output bios.order2 brainsize;    * ditto;
run;

/**************************************
Macro to calculate some summary statistics on a specified dataset(s)

I (shamelessly) ripped a lot of this out of the example script we were given in class, Macro Examples 2012.sas.
**************************************/
%macro sum_stats(type = N, varlist = all, whereby = );
/**************************************
use the auto-numer facility baked in to the macro variables to go over order1, order2
**************************************/
    %if &type = N %then %do i = 1 %to &num_sets;
        proc means data = &base_name&i mean std alpha = 0.05 clm;
        var
        %if %bquote(&varlist) = all %then _numeric_;
        %else &varlist;
        ;
        title "Stuff!";
    %end;
%mend sum_stats;

/**************************************
set a macro var specifying the data we're interested in, using like
a const
**************************************/
%let cool_data = ccmidsa fiq hc totsa totvol weight;
%let base_name = bios.order;
%let num_sets = 2;
%sum_stats(varlist = &cool_data);