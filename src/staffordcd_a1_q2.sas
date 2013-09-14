/*--------------------------------------------------------
Christian Stafford
Assignment #1, Question 2
Completed: 
Description: 
--------------------------------------------------------*/

/*--------------------------------------------------------
read in student and test data
--------------------------------------------------------*/
data students;
    infile "c:\bios524\data\testscores.txt";
    input name $ id t1 t2 t3 t4;
run;

/*--------------------------------------------------------
find each student's average test score
--------------------------------------------------------*/
data student_avg;
    set students;
    average = mean(t1, t2, t3, t4);
run;

/*--------------------------------------------------------
print the records
--------------------------------------------------------*/
proc print data = student_avg;
    title "Student Gradebook";
    format id SSN.;
run;
