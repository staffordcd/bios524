%macro namesx(name=, number=);
%do n=1 %to &number;
	&name.x&n
%end;
%mend namesx;


data %namesx(name=dsn, number =3);  /* equivalent to data dsnx1 dsnx2 dsnx3 */


%macro whatstep(info=, mydata=);
 %if &info= print %then 
 	%do; 
	  proc print data = &mydata;
	  run;
	%end;

%else %if &info = report %then 
	%do; 
options nodate nonumber ps=18 ls=70; 
		proc report data = &mydata; 
			column manager  dept sales;
			where sector = 'se';
			format manager $mgrfmt. dept $deptfmt. sales dollar11.2; 
			title 'Sales for the Southeast Sector';
		run;
	%end; 
%mend whatstep;

%whatstep(info=print, mydata=grocery)  /* equivalently proc print data = grocery; run;*/
%whatstep(info= PRINT, mydata= grocery)   /* does not work the same way */
