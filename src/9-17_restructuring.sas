libname bios "c:\bios524\data";

/*--------------------------------------------------------
want to restructure data like this:
PID InitialDate Week Weight Change CumulativeLoss
where
PID: Patient identification (character)
InitDate: Initial date, first weight measure (SAS date)
Week: Week of measure (1-12) (numeric)
Weight: Weight for current week (numeric)
Change: Change in weight from previous week (numeric)
CumulativeLoss: Cumulative change in weight to current week (numeric)

weight and CumulativeLoss will be calculated fields
--------------------------------------------------------*/

data bios.replicated;
    set bios.weightloss;
    array week_weights{12} weight1-weight12;
    change = 0;
    cumulative_change = 0;
    do week = 1 to 12;
        weight = week_weights{week};
        if(week > 1) then change = week_weights{week} - week_weights{week - 1};
        cumulative_change + change;
        output;
    end;
    drop weight1-weight12 week;
run;


