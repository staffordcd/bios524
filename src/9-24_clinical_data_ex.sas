/*--------------------------------------------------------
clinical data set script

make sure formats are ok - run "making clind format.sas" to build them
from scratch.

'library' library is a special thing in SAS, it's the only other place SAS will
look for alternative, and/or custom-defined, formats (e.g. the ClinID or phone formats)
--------------------------------------------------------*/
* see comment above;
libname library "c:\bios524\data\";

/*--------------------------------------------------------
pull out only those clinics that patients have visited, then
sort the data and de-dupe it
--------------------------------------------------------*/
data library.involved_clinics;
    set library.patients;
    keep clinid;
    format clinid $clinid.
run;

proc sort data = library.involved_clinics nodupkey;
    by clinid;
run;

/*--------------------------------------------------------
to create temporary tables for single-patient and 
multiple-pt. families:

sort by clinid, then famid, then patcode, don't hold dupes
since we don't want to track the raw # of visits
--------------------------------------------------------*/
proc sort data = library.patients out = patients_dedup nodupkey;
    by clinid famid patcode;
run;

data single_pt_fam multiple_pt_fam;
    set patients_dedup;
    * use BY to enable first.abc and last.abc functionality;
    by clinid famid;
    * implicit way of saying ;
    if First.famid & Last.famid then
        output single_pt_fam;
    else output multiple_pt_fam;
run;

proc print data = single_pt_fam;
    var famid patcode;
    id clinid;
    by clinid;
run;
