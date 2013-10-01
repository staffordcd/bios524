/*--------------------------------------------------------
exercise from 10/1 - merging data
--------------------------------------------------------*/

libname bios524 "c:\bios524\data";

/*--------------------------------------------------------
get a look at the data. the _ALL_ works to display every data set in
the specified library
--------------------------------------------------------*/
/*proc contents data = bios524._ALL_;*/
/*run;*/

/*--------------------------------------------------------
concatenate all the 4-month data prior to further data munging

need to rename fourmoncs_t wght column to weight, but don't want to change it in the
original data set

need to fix length of Q1 variable, as it differs across the data sets

use in options with if/select to add variable with source of data set to concat set

format weight variable to "best guess" i.e. numeric here
--------------------------------------------------------*/
data four_month_concat;
    length Q1 trt $3.;
    label trt = "Treatment Arm";
    label wt = "Weight";
    set bios524.fourmoncs_gc(in = ec) bios524.fourmoncs_mhl(in = mhl)
        bios524.fourmoncs_t(rename=(wght=weight) in = t) bios524.fourmoncs_uc(in = uc);
    select;
        when(ec) trt = "ec";
        when(mhl) trt = "mhl";
        when(t) trt = "t";
        when(uc) trt = "uc";
    end;
    wt = input(weight, best.);
    drop weight;
run;

/*--------------------------------------------------------
find means of each treatment arm, need to sort first
--------------------------------------------------------*/
proc sort data = four_month_concat;
    by trt;
run;

proc means data = four_month_concat;
    by trt;
    var wt;
run;

/*--------------------------------------------------------
can use a format to help find outliers
--------------------------------------------------------*/
proc format;
    value chkwt 100-325 = "normal range";
run;

proc freq data = four_month_concat;
    tables wt;
    format wt chkwt.;
run;

/*--------------------------------------------------------
produce table of counseling type, formatting everything in Q1 to Yes or No
and making treatment type pretty
--------------------------------------------------------*/
proc format;
    value $yn   "1", "Y" = "Yes"
                "2", "N" = "No";

    value $type "t" = "Telephone"
                "mhl" = "MyHealthyLiving"
                "gc" = "Group Classes"
                "ec" = "Electronic Care"
                "uc" = "Usual Care";
run;

proc freq data = four_month_concat;
    tables trt * q1;
    format q1 $yn. trt $type.;
run;
