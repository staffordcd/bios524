/*--------------------------------------------------------
Christian Stafford
Assignment #1, Question 2
Completed: 9/15/13
Description: Creates a basic student grade book, computing each student's average score.

NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
    SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>
--------------------------------------------------------*/

/*--------------------------------------------------------
read in student and test data
--------------------------------------------------------*/
data students;
    * infile "c:\bios524\data\testscores.txt"; * I keep my data files in a separate dir, changed below to default per instructions;
    infile "c:\bios524\testscores.txt";
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
