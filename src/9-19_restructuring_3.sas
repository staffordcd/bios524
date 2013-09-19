/*--------------------------------------------------------
From the PPT:
    Produce a printout that contains the following variables:
        Week
        Weight
        Change
        CumulativeLoss
    Produce a different page for each patient.
    Include the patient ID and start date in the title information.
--------------------------------------------------------*/

libname bios "c:\bios524\data";

data bios.raw_3;
    /*--------------------------------------------------------
    contrast this approach with the approach in restructuring_2:
    this one reads things in "long way first" rather than "wide
    way first"
    --------------------------------------------------------*/
    infile "c:\bios524\data\weightloss.txt";
    input pid $ 1-9 @10 initdate date9. @;
    * initialize change and cumulative loss to 0 here: implicit do loop will reset them for each pt;
    change = 0;
    cumulative_loss = 0;
    do week = 1 to 12;
        prevwt = wt;
        input wt 3. @;
        if week > 1 then do;
            change = wt - prevwt;
            cumulative_loss + change;
        end;
        drop prevwt;
        output;
    end;
run;

proc sort data = bios.raw_3 out = bios.sorted_3;
    by pid initdate;
run;

proc print data = bios.sorted_3 label;
    by pid initdate;
    format initdate date9.;
    label wt = "Weight"
        change = "Change in Weight"
        cumulative_loss = "Cumulative Loss";
    pageby pid;
    title "Report for #byval1";
    title2 "Start date: #byval2";
    var week wt change cumulative_loss;
run;
