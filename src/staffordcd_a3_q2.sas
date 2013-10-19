/*******************************
Name: Christian Stafford
Assignment #3 Q2
Completed: 
Description: Update a PBRN dataset with new clinic information and calculate various
    metrics about the patient population and how they interact with the network.

NOTE: unless otherwise specified, code has been heavily inspired by snippets available from the
    SAS Programmer's Bookshelf, <http://support.sas.com/documentation/onlinedoc/bookshelf/94/desktop.html>
*******************************/

libname bios524 'c:/bios524/data/';

/**************************************
needed to make this library assignment last time we used the ClinID format

I'm building the ClinID format fresh, using the script provided in class.
**************************************/
libname library 'c:/bios524/data/';

/**************************************
Read in the extant data sets
**************************************/
data pt_raw;
    set bios524.patients;
run;

data clinic_raw;
    set bios524.clinics;
run;

/**************************************
Create the new clinics, format accordingly
**************************************/
data new_clinics;
    length contact $ 25 clinicid $ 3;
    format clinicid$ $clinid. phone phonum. DOEntry date9.;
    informat doentry mmddyy8.;
    input clinicid $ contact $ phone NumPhys DOEntry;
    infile datalines delimiter = ',';
    datalines;
    RPC,J. Pierpont Finch,8044453243110,4,07/23/99
    SIM,Nathan Detroit,8042235587330,3,02/22/99
    ;
run;    

/**************************************
Append the new clinics to the extant clinic data
**************************************/
proc append base = clinic_raw data = new_clinics;
run;