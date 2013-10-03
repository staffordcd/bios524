/*--------------------------------------------------------
Christian Stafford
Assignment #2, Question 2
Completed: 10/2/2013
Description: Reshape prostate screening data, then analyze
it to find information about relapses within the group.
--------------------------------------------------------*/

libname bios524 "c:\bios524";

/*--------------------------------------------------------
Re-shape visit data and PSA readings for each pt from wide
to long.

I know there's bound to be a better way of batch renaming stuff, but
I'm not comfortable enough with the macro language to fake my way through,
so here's a bunch of ugly code! Yay!

The end result (I think) will let me step through visit1-visit7 or
psa1-psa7... SAS didn't seem to like when the number was in the 
middle of the variable name and I tried to walk across a range.
--------------------------------------------------------*/
data pre_reshape;
    set bios524.psa(rename=(visit1date=date1 visit2date=date2 visit3date=date3 visit4date=date4
                            visit5date=date5 visit6date=date6 visit7date=date7
                            visit1psa=psa1 visit2psa=psa2 visit3psa=psa3 visit4psa=psa4
                            visit5psa=psa5 visit6psa=psa6 visit7psa=psa7));
run;

/*--------------------------------------------------------
Now that the columns are named more sanely, let's actually
reshape the data from wide to long. I know I'm going to need
an accumulator for PSA levels, so I'm tacking it on here.

Since we're going through this data here anyway, might as
well classify it WRT relapse status and days. 

I added pt 201 to my data set, who should have total PSA of 0.9, as a way to check
my work; it looks like all patients relapsed in the un-altered data set.
--------------------------------------------------------*/
data reshape;
    set pre_reshape;
    array psas psa1-psa7;
    array dates date1-date7;
    cumul_psa = 0;
    do visit = 1 to 7;
        psa = psas(visit);
        cumul_psa = cumul_psa + psa;
        date = dates(visit);
        status = 0;
        if cumul_psa >= 1.0 then
            do;
                rel_days = date - dates(1);
                status = 1;
            end;
        else;
            do;
                rel_date = .;
            end;
        output;
    end;
    format date mmddyy10.;
    keep patid visit date psa cumul_psa rel_days status;
run;

/*--------------------------------------------------------
categorize patients based on relapse or not.  need to
sort with a first-pass de-dupe on both id and status,
then do a second-pass de-dupe just on id.

this is a bit of a hack way to do this, but it seems to
work ok.
--------------------------------------------------------*/
proc sort data = reshape out = sorted nodupkey;
    by  patid descending status;
run;

proc sort data = sorted out = deduped nodupkey;
    by patid;
run;

/*--------------------------------------------------------
Now that everything should be nicely de-duped, categorize pts
by relapse status
--------------------------------------------------------*/
data relapsed non_relapsed;
    set deduped;
    if status then output relapsed;
    else output non_relapsed;
    keep patid rel_days;
run;

/*--------------------------------------------------------
quick visualization to check my findings, i'll leave it commented out
--------------------------------------------------------*/
/*proc gchart data = deduped;*/
/*    title "Deduped Pt. Cumulative PSA";*/
/*    block cumul_psa;*/
/*run;*/

/*--------------------------------------------------------
print the requested summary statistics

non_relapsed is empty, so it will only display the "No Observations in..."
message in the log.
--------------------------------------------------------*/
proc means data = relapsed n mean std median q1 q3;
    title "Relapsed Patients";
    var rel_days;
run;

proc means data = non_relapsed n mean std median q1 q3;
    title "Non-Relapsed Patients";
    var rel_days;
run;
