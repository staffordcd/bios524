/*--------------------------------------------------------
Christian Stafford
Assignment 1
Completed: 9/15/13
Description: Analyzes tree circumference data to determine which type of
    fertilizer contributes the most to growth.

NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
    SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>

--------------------------------------------------------*/

/*--------------------------------------------------------
Reads tree data as specified in program spec.
--------------------------------------------------------*/
data treedat;
    input ID 1-4 SPECIES $ 6-11 INIT_CIRC 13-16 FERT_CODE $ 18 FIN_CIRC 20-23;
    datalines;
1111 Pine   62.1 X 86.0
1110 Oak    43.1 X 76.9
6116 Maple  51.6 Y 56.5
1138 Oak    41.3 Z 53.7
5210 Maple  41.0 X 61.9
1217 Maple  62.7 Y 63.4
3214 Pine   33.4 X 66.9
2213 Pine   44.3 X 72.3
6247 Oak    52.4 Y 36.6
1301 Beech  74.0 Y 76.2
1319 Maple  52.9 Z 63.2
1318 Maple  61.8 Z 77.3
6315 Pine   42.5 Y 47.6
1312 Pine   51.2 X 96.2
1329 Oak    64.2 Y 66.7
6356 Oak    53.5 Z 74.5
1365 Beech  74.6 X 84.4
1374 Beech  51.7 X 92.1
1383 Beech  92.8 Y 99.2
1392 Beech  63.9 Z 86.1
;
run;

/*--------------------------------------------------------
calculate the initial and final diameter of each tree
by dividing the circumference by an approximation of pi.

calculate desired growth statistics of each tree.
--------------------------------------------------------*/
data calc_growth_stats;
    set treedat;
    * find initial and ending circ of each tree;
    i_diam = init_circ / 3.1416;
    e_diam = fin_circ / 3.1416;
    
    * calc growth stat;
    diff_diam = e_diam - i_diam;
run;

/*--------------------------------------------------------
find the median value, and put it in the data table, step 1.

I blatantly stole most of this from http://www.nesug.org/proceedings/nesug07/cc/cc45.pdf
and adapted it for my purposes. it's a little ugly (appends the median to each row, see step 2)
but gets the job done. There may be a better way to do this, but, if so, I can't find it!
--------------------------------------------------------*/
proc means data = calc_growth_stats median noprint;
    var diff_diam;
    output out = add(drop = _TYPE_ _FREQ_) median = median;
run;
/*--------------------------------------------------------
step 2, also blatantly stolen / adapted from the above-referenced resource!
--------------------------------------------------------*/
data calc_growth_stats;
    if _N_ = 1 then set add;
    set calc_growth_stats;
run;

/*--------------------------------------------------------
categorize tree growth as either high or low
--------------------------------------------------------*/
data stratify_growth;
    set calc_growth_stats;
    select;
        when (diff_diam >= median) CAT_DIA_CHG = "high";
        when (diff_diam < median) CAT_DIA_CHG = "low";
    end;
run;

/*--------------------------------------------------------
plot freq. of fertilizer * CAT_DIA_CHG
--------------------------------------------------------*/
proc freq data = stratify_growth;
    title "Fertilizer Code vs. Diameter Change";
    tables FERT_CODE * CAT_DIA_CHG;
run;
