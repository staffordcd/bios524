/*******************************
Name: Christian Stafford
Assignment #5
Completed: 
Description: getting to know SAS IML
*******************************/

proc iml;
    title "Problem 1";
    A = {120 143 145 96 89,
        132 145 130 103 93,
        145 145 132 108 97,
        151 154 120 114 101};
    print A;
    
    overall_mean = A[:];
    print overall_mean;

    row_mean = A[,:];
    print row_mean;

    col_mean = A[:,];
    print col_mean;

    row_max = A[,<>];
    print row_max;

    col_range = A[<>,] - A[><,];
    print col_range;

    row_main_eff = A[,:] - A[:];
    print row_main_eff;

    col_main_eff = A[:,] - A[:];
    print col_main_eff;

    quit;
run;

proc iml;
    A = {1 1 0 0,
        1 1 0 0,
        1 0 1 0,
        1 0 0 0,
        1 0 0 1,
        1 0 0 0};

    B = {1 2,
        0 1,
        1 2,
        0 2,
        1 2,
        0 0};

    y = {7,
        4,
        7,
        5,
        8,
        1};
    
    title "Problem 2";
    print A;
    print B;
    print y;

    

    quit;
run;