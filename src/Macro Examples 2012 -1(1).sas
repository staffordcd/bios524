
/*-----------------------------------------------------------------------------------------*
    Another Macro Example

    Simple summaries of either numeric or character variables are performed.

    The user enters three parameters:
        dsn - The SAS data set to be analyzed.  The last data set created (&syslast) will be used by default.
        type - Data type.  Numeric is default.  If the user enters anything other than N, character is assumed.
        varlist - List of variables to be processed.  Default is either all numeric or all character variables.
        whereby - A valid "where" condition, enclosed in parentheses.

*------------------------------------------------------------------------------------------*/


    libname classmac "c:\bios524\classlib\sasmacros";
    options mstored=yes sasmstore=classmac symbolgen mlogic;

    %macro summary(dsn=&syslast,type=N,varlist=all,whereby=) / store;

        %if &type=N %then
            %do;                                                        %* Process numeric variables;
                proc means data=&dsn n min q1 median q3 max mean std;
                    var 
                    /* bquote checks to make sure the STRING is "all"*/
                    %if %bquote(&varlist)=all %then _numeric_;            %* Default: all numeric variables;
                    %else &varlist;                                        %* User supplied varlist is used;
                    ;
                    title "Analysis of Numeric Data";
            %end;
        %else
            %do;                                                        %* Process character variables;
                proc freq data=&dsn;
                    tables 
                    %if %bquote(&varlist)=all %then _character_;        %* Default: all numeric variables;
                    %else &varlist;                                        %* User supplied varlist is used;
                    ;    
                    title "Analysis of Character Data";
            %end;
        %if %bquote(&whereby)= %then;                                    %* If no whereby value, do nothing;
        %else
            %do;                                                        %* User supplied where condition is used;
                where &whereby;
                ;
                title2 "Data are restricted to &whereby";
            %end;
        run;
        title;
    %mend summary;

    %summary(dsn=sashelp.class)
    %summary(dsn=sashelp.class,type=C,varlist=sex)
    %summary(dsn=sashelp.class,type=N,varlist=age,whereby=(sex="M"))

    libname classlib "c:\bios524\classlib";
    %summary(dsn=classlib.hlthsrvy,varlist=PF--MH,whereby=(smoke in (1,2)))        * Note variable list PF--MH;

    data test;
        input x y $ @@;
        datalines;
    23 A 56 B 79 C 86 D 100 E 23 F 44 G 
    22 H 21 I 20 J 18 K  17 L 58 M 18 N 99 O
    ;

    %summary

    %summary(varlist=y)        * This produces an error, check the SAS Log;
