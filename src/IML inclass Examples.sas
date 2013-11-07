*** Bios 524: IML Class Examples ****;

    libname classlib "c:\bios524\data";                         * Modify as needed;

proc iml;                           * Invoke IML;
    reset nocenter;                 * Make output left justified;

   *** Simple example ***;
    M={3 2 -4, 5 -4 0, 0 3 10};     * Assign 3x3 matrix;
    B={11, 9, 42};                  * Assign 3-dim column vector;
    A=solve(M,B);                   * Solve system of linear equations;
    print M, B, A;                  * Display matrix values;
       B2=M*A;                      * Check solution;
       print B2;

   *** Assigning values to matrices ***;
    reset nolog print;              * Auto prints to output, not log;
    c=12.5;                         * Scalar value (1x1);
    x={5 10 7 12};                  * Row vector (1x4);
    y={2, -4, 6};                   * Column vector (3x1);
    M={3 2 -4, 5 -4 0, 0 3 10};     * Matrix (3x3);
    N={'BOB','FRED','ALICE'};       * Character vector (3x1);
        print c x y, M, N;          * Display matrix values;

   *** Transpose of a vector or matrix ***;
    x2=x`; y2=y`; M2=M`; N2=N`;     * Flips columns/rows;

   *** Creating matrices with functions and operators;
    RI=1:10;                        * Row index;
    CI=(5:9)`;                      * Column index (transpose);
    RevI=5:1;                       * Reverse index;
    CharI='X1':'X10';               * Character index;
    Series1=do(2,10,1);             * Series of values;
    Series2=do(2,20,2);

   *** Special matrix functions ***;
    Iden=I(5);                      * Identity matrix (5x5);
    Const1=J(12,4);                 * 12x4 matrix of 1's;
    Const0=J(3,3,0);                * 3x3 matrix of 0's;
    Diag1=diag(x);                  * Diagonal matrix, X on diagonal;
    Diag2=diag(M);                  * Diagnoal matrix, diagonal of M;
    VecD=vecdiag(M);                * Column vector, diagonal of M;

   *** Basic matrix operations ***;
    S1=J(5,5)+I(5);                 * Addition;
    S2=J(5,5)-I(5);                 * Subtraction;

    Print M A;
    B2=M*A;                         * Matrix multiplication - #cols of M matches # rows of A;
    B3=B2*2;                        * Scalar multiplication - each element of B2 is doubled;
    B4=M#M;                         * Elementwise multiplication;
    B5=M#2;                         * Scalar multiplication - each element of B2 is doubled;

    D1=B5/M;                        * Elementwise division - note the missing values;
    D2=B5/2;                        * Scalar division - each element of B5 is halved;
    D3=2/B5;                        * Scalar division;

    M3=M*M*M; MP3=M**3;             * Matrix power;
    M4=M#M#M; MP4=M##3;             * Elementwise power;

    MbyM=M || M;                    * Horizontal concatenation;
    MoverM= M // M;                 * Vertical concatenation;

   *** Logical Operations ***;
    Print M;
    Mpos=(M>0);                     * True element comparisons are set to 1.  Others to 0;
    If M^=0 then D1=B5/M;           * All elements of M must be greater than zero;
        Else Print "Cannot perform operation";
    T1=0:7; T2=(0:3)||(0:3);
        TandT=T1 & T2;              * AND operator. Both elements must be 1 to be true (=1);
        TorT =T1 | T2;              * OR operator.  At least one element is 1 to be true;
        Not_T1=^T1;                 * 0's converted to 1's, nonzeros converted to 0;

   *** Subscripts ***;
    Print M;
    Part1=M[2,2];                   * Select the element on the 2nd row, 2nd column;
    Part2=M[2,];                    * Select the second row;
    Part3=M[,2];                    * Select the second column;
    Part4=M[1:2,2:3];               * Select the upper-right 2x2 submatrix;
    Part4[2,2]=2;                   * Assign values to submatrix;

    Mnoneg=M;
    print M Mnoneg;
    Mloc=loc(M<0);                  * LOC: returns cell locations where comparison is true;
    Mnoneg[loc(M<0)]=0;             * Assign 0 to all negative values in M (or Mnonneg);
    Mloc=loc(Mnoneg=0);             * LOC: returns cell locations where comparison is true;

   *** Subscript Reduction ***;
    Print M;
    SumColumns =M[,+];              * Sums values across columns for each row;
        SumColumns=M[,1]+M[,2]+M[,3];   * Same result;
    SumRows    =M[+,];              * Sums values across rows for each column;
        SumRows=M[1,]+M[2,]+M[3,];      * Same result;

    MultColumns=M[,#];              * Product of values across columns;
    MultRows   =M[#,];              * Product of values across rows;

    MaxinCol   =M[<>,];             * Select the maximum column value in each column;
    MaxinMat   =M[<>];              * Select the maximum value in the matrix;
    MinRow     =M[,><];             * Select the minimum row value in each row;
    MinMat     =M[><];              * Select the minimum value in the matrix;
    MinMax     =M[<>,][><];         * Select the minimum value among maximums in each column;
    MaxMin     =M[,><][<>];         * Select the maximum value among minimums in each row;

    Print M;
    MaxIndex   =M[<:>];             * Index (location) of the maximum value;
    MinIndex   =M[>:<];             * Index (location) of the minimum value (first case);

    CMeans     =M[:,];              * Mean of each column (column means);
    RMeans     =M[,:];              * Mean of each row (row means);
    MeanofM    =M[:];               * Mean over all values of matrix;

    ColSS      =M[##,];             * Sum of squares for each column;
    RowSS      =M[,##];             * Sum of squares for each row;
    SSofM      =M[##];              * Sum of squares over all values of matrix;

   *** Open a SAS Data Set for Reading ***;
    reset nolog noprint;

    Use classlib.Hlthsrvy  Nobs NN;                                          * Open the data set;
    Read All var {PF RP BP GH VT SF RE MH} Into SF36;               * Read the data;

    reset print;
    PartofSF36= SF36[1:10,];                                        * Assign subset to view;

    Coef={20.1360 0.1852 0.1039 0.1348 0.1237 
                  0.0138 -0.0034 -0.0582 -0.1225}`;                 * Assign coefficients;

    reset noprint;
    PCS = (J(NN,1,1) || SF36) * Coef;                               * PCS scores;
    reset print;
    SomePCS = PCS[1:10,];                                           * Some PCS scores;
    MeanPCS = ((J(NN,1,1) || SF36) * Coef)[:];                      * Mean PCS;

  *** Create a new SAS data set from a matrix;
    
    Read All var {subjid} Into SubjID;                              * Read Subject IDs;

    reset deflib=work;                                              * Set WORK default library;
    Create PCS var{subjid pcs};                                     * Create a SAS data set;
    Append;                                                         * Append to the data set;

    Create SF36 from SF36;                                          * SAS data set from matrix;

    Show Contents;                                                  * Contents of current data;

    Show Datasets;                                                  * Show all open data sets;

    SetIn Classlib.Hlthsrvy;                                        * Make data set current;
    Show Contents;

    Close PCS;                                                      * Close the data set;
    Show Datasets;

   *** Regression Example ***;
    X= J(5,1)||(1:5)`;                                  * Create first two columns of X;
    X=X||X[,2]##2;                                      * Third column is square of second;
    Y={1,5,9,23,36};                                    * Regression Y values on X;

    beta_hat=inv(X`*X)*X`*Y;                            * Parameter estimates;
    beta_hat_two=Solve((X`*X),X`*Y);                    * Another way;

    Y_hat=X*beta_hat;                                   * Predicted values of Y from regression;
    Residuals=Y-Y_hat;                                  * Difference between Y and pred. Y;

    Parameters={"intercept", "linear", "quadratic"};    * Use of an IMLMLIB module;
    Run Regress(X,Y,Parameters,,,,);                    * You get lots of output;

    quit;                           * Quit IML session;
