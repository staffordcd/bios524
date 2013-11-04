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
the idx value itself is arbitrary

separate based on birth order
**************************************/
data bios.order1 bios.order2 brainsize;
    set brainsize;
    subcode = _N_;
    select;
        when(order = 1)
            output bios.order1;
        when(order = 2)
            output bios.order2;
    end;

run;