/*--------------------------------------------------------
Christian Stafford
Assignment #1, Question 5
Completed: 9/15/13
Description: calculate some summary statistics about the ages of a sample, infer population parameters from
    these statistics. Answers to questions are at the end of the script.

    NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
        SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>
--------------------------------------------------------*/

/*--------------------------------------------------------
read in raw data (age in years)
--------------------------------------------------------*/
data raw;
    input @@ age;
    datalines;
30  46  45  47  21  21  21  21  29  20  20  20  45
36  20  42  53  36  38  42  48  38  19  40  71  42
18  46  40  38  24  38  41  18  18  50  24  18  27
34  17  38  16  17  55  16  20  16  20  53  19  85
15  49  43  14  41  46  54  57  62  64  29  32  49
60  60  52  27  59  73  63  44  47  51  53  29  72
;

/*--------------------------------------------------------
calculate summary stats of the input (questions a and b)
--------------------------------------------------------*/
proc means data = raw mean stddev min q1 median q3 max;
    title "Summary Statistics for Age";
    var age;
run;

/*--------------------------------------------------------
calculate the 95% CI for the mean age (question c)
--------------------------------------------------------*/
proc univariate data = raw cibasic; * return basic conf. interval info about raw;
    ods select BasicIntervals; * don't print the whole univariate report, just the CI info;
    title "95% Confidence Interval for Mean Age";
    var age;
run;

/*--------------------------------------------------------
Answers to questions

    a.  mean = 37.9743590
        std. deviation = 16.8438006

    b.  min = 14.0
        Q1 = 21.0
        median = 38.0
        Q3 = 49.0
        max = 85

    c.  95% ci of the mean is 34.17667 - 41.77205, and the estimate
        is 37.97436
--------------------------------------------------------*/
