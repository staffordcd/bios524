data Encounters;
    *informat ENC_DATE MMDDYY10. DOB MMDDYY10.;
    infile "c:\bios524\data\Encounters.txt";
    input ID $ 1-9 ENC_DATE MMDDYY10. SEX 20 DOB MMDDYY10.; * don't need col nums for dates, as length is implicit in INFORMAT;
    format ENC_DATE MMDDYY10.;
run;
