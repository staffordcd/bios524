* read data for 7 widgets, each has 3 trials;
data a;
    do part = 1 to 7;
        do rep = 1 to 3;
            input trial @;
            output;
        end;
    end;    
    datalines;
50 49 50
52 52 51
53 50 50
48 49 48
52 50 49
50 51 50
47 46 49
;
