libname bios 'c:/bios524/data/';

data raw;
input PatientName $25. / StreetAddress $30. / City $ State $ Zipcode $ / Phone 6;

datalines; 
Sonya Larson             
10054 Plum Tree Rd      
Buffalo NY 10068  
716-555-1348             
Peter Simpson            
605 Glendover Dr      
Isabel KS 67065         
316-555-6566             
Kip Holfser             
902 West Blvd           
Lansing, MI 48910        
517-555-0227             
Chan Rong         
3052 East Bank Way       
Lithonia GA 30058        
912-555-0025             
Mary Peters              
10036 Lake View Dr      
Greenbay, WI 54311         
608-555-9031             
Randy Nguyen             
100 49th Street          
Harrisburg, PA 19057   
717-555-7773 
;
run;