/*--------------------------------------------------------
clinical data set script

make sure formats are ok - run "making clind format.sas" to build them
from scratch.

'library' library is a special thing in SAS, it's the only other place SAS will
look for alternative, and/or custom-defined, formats (e.g. the ClinID or phone formats)
--------------------------------------------------------*/
* see comment above;
libname library "c:\bios524\data\";

