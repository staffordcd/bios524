/*--------------------------------------------------------
Christian Stafford
Assignment #2, Question 1
Completed: 
Description: 
--------------------------------------------------------*/

/*--------------------------------------------------------
read in the raw data, formatting it as necessary.

length statements used here to eliminate wonky reading/assignment
--------------------------------------------------------*/
data raw;
    infile "c:\bios524\data\transplant.txt";
    length rec_sex $ 1 livstat $ 1 gftfail $ 1 ;
    input @1 id $ @7 txm @10 txd @13 txy @18 t 4. @22 livstat $ @23 gftfail $ @25 don_type $ @26 prev_ki $ @28 prev_num @32 rec_race 3. @35 rec_sex $
        @ 37 rec_age @41 don_race $ @44 don_sex $ @46 don_age;
    label id 
run;

