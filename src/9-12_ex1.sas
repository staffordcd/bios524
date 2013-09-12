/*
    Recoding exercise.
    Make up some height and weight input, recode it, create cross-table
*/

data htwt;
    input ID HT WT;
    datalines;
    1001 60 100
    1002 38 200
    1003 49 150
    1004 64 209
    1005 38 201
    1006 99 999
    1000 1 1
run;

/*
    recode data, assigning height groups and weight groups per the
    specified parameters. Select-when more logical to me here than
    chains of if-else.
*/
data htwt2;
    set htwt;
    select;
        when (0 <= ht < 37) ht_grp = 1;
        when (37 <= ht < 49) ht_grp = 2;
        when (49 <= ht < 61) ht_grp = 3;
        when (ht > 60) ht_grp = 4;
    end;

    select;
        when (0 <= wt <= 100) wt_grp = 1;
        when (101 <= wt <= 200) wt_grp = 2;
        when (wt > 200) wt_grp = 3;
    end;
run; 

/*
    make custom format so the output is more intelligible
*/
proc format;
    value ht_fmt
        1 = "0 - 36"
        2 = "37 - 48"
        3 = "49 - 60"
        4 = "above 60";

    value wt_fmt
        1 = "0 - 100"
        2 = "101 - 200"
        3 = "above 200";
run;

/*
    print cross tabulation with pretty format
*/
proc freq data = htwt2;
    format ht_grp ht_fmt. wt_grp wt_fmt.;
    tables ht_grp * wt_grp;
run;
