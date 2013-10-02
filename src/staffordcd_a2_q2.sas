/*--------------------------------------------------------
Christian Stafford
Assignment #2, Question 2
Completed: 
Description: 
--------------------------------------------------------*/

libname bios524 "c:\bios524\data";

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
data reshape;
    set bios524.psa(rename=(visit1date=date1 visit2date=date2 visit3date=date3 visit4date=date4
                            visit5date=date5 visit6date=date6 visit7date=date7
                            visit1psa=psa1 visit2psa=psa2 visit3psa=psa3 visit4psa=psa4
                            visit5psa=psa5 visit6psa=psa6 visit7psa=psa7));
run;

