* simple list input;
DATA  LISTINP; 
    length NAME $ 25; * fixes length of variable to 25 chars;
	INPUT NAME $ HEIGHT WEIGHT GENDER $ AGE;
	BMI=Weight*0.4536 / (Height*0.0254)**2;
	DATALINES; 
Johnson 68 144 M 23 
Smithfield 78 228 M 34 
Kerns 62 99 F 37 
Billings 61 101 F 45 
; 
PROC PRINT DATA=LISTINP; 
	TITLE 'BMI Example of List Input'; 
RUN;
