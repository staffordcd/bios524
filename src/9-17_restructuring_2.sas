libname bios "c:\bios524\data";

data bios.raw;
    infile "c:\bios524\data\weightloss.txt";
    input pid $ 1-9 @10 initdate date9. @19 (weight1-weight12)(3.);
run; 

data bios.cleaned;
    set bios.raw;
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
