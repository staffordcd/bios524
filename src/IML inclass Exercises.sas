*** Bios 524: IML Class Exercises ****;

proc iml;							* Invoke IML;
	reset nocenter nolog print;		* Auto prints to output, not log - output is not centered;

   *** Exercise 1 ***;
	A={2 3 4, 						/* Assign values to the matrices */
       3 4 7, 
       2 3 3}; 
	B={5 6, 
       3 4, 
       4 6};

	Sum_of_A=A[+];					* Find the sum;
		Sum_of_A=sum(A);				* Same result;
	ColSum_of_B=B[+,];				* Sum of each column of B;
	ProdAB=A*B;						* Find the matrix product;
	C=6*A[,1:2]-5*B;				* Find a linear combination of the first two rows 
									  of A and of B;
		SumPosC=C[loc(C>0)][+];		* Add up the positive elements of C;
		C[loc(C<0)]=0;				* Set the negative elements of C equal to zero;
	U=solve(A,B);					* Solve for U in AU=B;

   *** Exercise 2 ***;
	libname library "c:\bios524\classlib";
	reset deflib=library;
	use clinics;							* Open CLINICS for reading;
	show contents;							* What are the variables and attributes?;

	read all var{NumPhys} into FTE;			* Get the number of FTE physicians;

	MeanFTE=FTE[:];							* Mean FTE;
	MaxFTE=FTE[<>];							* Maximum FTE;
	MinFTE=FTE[loc(FTE>MeanFTE)][><];		* Minimum FTE that is greater than the mean;

	read all var{ClinicID} into Clinic;		* Get clinic ids;
	SelectClinics=Clinic[loc(FTE=MinFTE)];	* Select clinics with FTE=MinFTE;
	Print SelectClinics[format=$ClinID.];	* Show clinic names using custom format;

   *** Exercise 3 ***;
	Means={10 13 16, 9 10 14, 5 7 9};					* Means in 3x3 table;
	Mu=Means[:];										* Overall mean;
	RowMu=Means[,:];									* Row means;
	ColMu=Means[:,];									* Column means;

	*** Contrasts are matrices where each row and/or column adds up to zero. ***;
	RowContrasts=RowMu - Mu;					* Row contrasts;
	ColContrasts=ColMu - Mu;					* Column contrasts;
	Interaction=Means 									/* Interaction contrasts */
				- RowContrasts@J(1,3) 
				- J(3,1)@ColContrasts 					/* Note: @ is the direct product */
				- Mu;									/* or the Kronecker product.     */

	*** A more general approach. This provides estimates for different parameters ***;
	Contrast={1 0 -1, 1 -2 1}`;							* 3x2 matrix of contrasts;
	RowContrast=Contrast@J(3,1);						* Contrasts amongst rows;
	ColContrast=J(3,1)@Contrast;						* Contrasts amongst columns;
	Interaction=Contrast@Contrast;						* Interaction contrasts;
	Intercept=J(3,1)@J(3,1);							* Intercept: Column of ones;

	Y=ColVec(Means);									* Converts 3x3 to 9X1 column of values;

	X=Intercept||RowContrast||ColContrast||Interaction; * "Design" matrix;
	Parameters=inv(X`*X)*X`*Y;							* Estimated parameters;
	Parameters=Solve(X`*X,X`*Y);						* Solving the 'normal equations';
	Means2=X*Parameters;								* Back to the means;
	Means2=Shape(Means2,3,3);							* Shape the vector into a matrix;

	*** Going beyond... into Analysis of Variance ***;

	reset noprint;
	A=RowContrast;
	SSRow = Y`*A*inv(A`*A)*A`*Y;						* Sum of squares for row;
	B=ColContrast;
	SSCol = Y`*B*inv(B`*B)*B`*Y;						* Sum of squares for column;
	AB=Interaction;
	SSInt = Y`*AB*inv(AB`*AB)*AB`*Y;					* Sum of squares for interaction;

	TotalCorrected= SSRow + SSCol + SSInt;				* Total corrected sum of squares;

	Print SSRow SSCol SSInt TotalCorrected;

	reset deflib=work;									* Setup for output data set;
	RowVar=(1:3)`@J(3,1);								* Var to identify row;
	ColVar=J(3,1)@(1:3)`;								* Var to identify column;
	anovadata=RowVar||ColVar||Y||X;						* Data for the SAS data set;
	create anova from anovadata 						/* Create SAS data set and name vars */
		   [colname={"RowVar" "ColVar" "Y" "Intercept"
					 "Row1" "Row2" "Col1" "Col2"
					 "Int1" "Int2" "Int3" "Int4"}];
	append from anovadata;								* Write to the data set;

	show contents;

	quit;							* Quit IML session;

   *** Compute the parameter estimates with Proc Req ***;
	Proc REG data=Anova;
		model Y = Row1 Row2 Col1 Col2 Int1-Int4;
	run;
	quit;

   *** Compute the sums of squares with Proc Anova ***;
	Proc ANOVA data=Anova;
		Class RowVar ColVar;
		Model Y = RowVar ColVar RowVar*ColVar;
	run;
	quit;