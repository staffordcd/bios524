/*
Solutions are in IML Exercises file.
*/

libname LIBRARY "c:/bios524/data/";

    
proc iml;
    reset deflib = library;
    use clinics;
    show contents;

    read all var {NumPhys} into FTE;

    mean_fte = fte[:];
    max_fte = fte[<>];
    min_mean_fte = fte[loc(fte > mean_fte)][><];
    print min_mean_fte;

    read all var {ClinicID} into clinic;

    matches = clinic[loc(fte = min_mean_fte)];
    print matches[format = $clinid.];

    /*
    ex 2
    */
   *** Regression Example ***;
    X = J(5,1) || (1:5)`;  * back tick will transpose data vector     * Create first two columns of X;
    X = X || X[,2] ## 2;                                      * Third column is square of second;
    Y = {1,5,9,23,36};                                    * Regression Y values on X;

    beta_hat = inv(X` * X) * X` * Y;                            * Parameter estimates;
    beta_hat_two = Solve((X` * X), X` * Y);                    * Another way;

    Y_hat = X * beta_hat;                                   * Predicted values of Y from regression;
    Residuals = Y - Y_hat;                                  * Difference between Y and pred. Y;

    Parameters={"intercept", "linear", "quadratic"};    * Use of an IMLMLIB module;
    Run Regress(X,Y,Parameters,,,,);                    * You get lots of output;


    /*
    last exercise
    */
    m = {10 13 16,
         9 10 14,
         5 7 9};
    
    overall_mean = m[:];
    print overall_mean;
    row_means = m[,:];
    print row_means;
    col_means = m[:,];
    print col_means;
    row_diff_mean = row_means - overall_mean;
    print row_diff_mean;
    col_diff_mean = col_means - overall_mean;
    print col_diff_mean;







quit;                           * Quit IML session;