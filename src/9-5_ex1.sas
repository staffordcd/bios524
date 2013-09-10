/* read in the data from the file, add the add'l variables we need */
/* can't get the file aliasing to work, error when SAS tries to open the wrong path? 
    works fine when explicit INFILE as below
*/

data Encounters;
    * informat ENC_DATE MMDDYY10. DOB MMDDYY10.;
    infile "c:\bios524\data\Encounters.txt";
    input ID $ 1-9 ENC_DATE MMDDYY10. SEX 20 DOB MMDDYY10.; * don't need col nums for dates, as length is implicit in INFORMAT;
    * the variables like age and twowkfu are automagically associated with the data set.;
    /* for age calc, see
    http://support.sas.com/documentation/cdl/en/lefunctionsref/64814/HTML/default/p1pmmr2dtec32an1vbsqmm3abil5.htm#n1hxxgh4x8gx82n1tdzndva45dgo
    */
    label ENC_DATE = "Encounter Date";
    age = floor(yrdif(dob, enc_date, 'AGE'));
    adult = (age >= 18); * use logical variable here to categorize patients;
    format TwoWkFU enc_date dob mmddyy10.;
    TwoWkFU = enc_date + 14;
run;

/* create custom output format to handle numerical to text for sex and adult */
proc format;
    value adult 0 = "Child"
                1 = "Adult";

    value sex 1 = "Male"
               2 = "Female"; 
run;

/* calculate frequency of data, print as sex vs. age table w/ nice formatting*/
proc freq data = Encounters;
    format adult adult. sex sex.;
    tables sex * adult;
run;
