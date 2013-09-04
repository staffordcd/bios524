* exercise 2;
* filename and libname don't have to appear in either a data or proc block;
filename EHRData "c:\bios524\EHRData.txt"; * alias EHRData to the actual file, saves typing;
libname EHRLib "c:\bios524"; 

Data EHRLib.EHRData;
	infile EHRData delimiter=",";
	input Age BMI Sex $ Smoking $;
run;

Proc Freq data=EHRLib.EHRData;
    title 'Sex/Smoking Table';
	Tables Sex Smoking;
run;

Proc Means data=EHRLib.EHRData;
    title 'Age/BMI Table';
	Var Age BMI;
run;
