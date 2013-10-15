%macro loopit;
    %let var1 = Age;
    %let var2 = Height;
    %let var3 = Weight;

    %do i = 1 %to 3;
        proc means;
            var &&var&i;
            Title "Analysis for the Variable &&var&i";
    %end;
%mend loopit;

%macro wantrslt(giverslt);
	%let results = %upcase(&giverslt);
	%if &results = YES %then
        %do;
            proc means;
                var _numeric_;
                Title "Results for Numeric Variables";
            run;
        %end;
	%else
        %put NOTE: No results requested; %* Appears in log;
%mend wantrslt;

%wantrslt(yes);
%wantrslt(no);


data one;
    input age height weight @@;
    datalines;
34 60 130 45 70 201 50 68 188
;
run;

%loopit
