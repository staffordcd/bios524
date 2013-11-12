libname bios 'c:/bios524/data/';

/**************************************
add the specified data.  I added temporary char variables, rawcity and rawphone, that I
compress the undersirable characters out of and store in their 'permanant' variables, then
drop the temporary variables- I hope this isn't in violation of the spirit of the assignment!
**************************************/
data raw(drop = rawphone rawcity);
    length phone 6;
    length city $ 25;
    length zipcode $ 5;
    * use the line pointer, the slash character, to accommodate the structure of the input data;
    input PatientName $25. / StreetAddress $30. / rawCity $ State $ Zipcode $ / rawphone $16.;
    phone = compress(rawphone, '-');
    city = compress(rawcity, ',');
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

/**************************************
add the state names to the raw data, using the abbreviated
state name as the key
**************************************/
data with_states;
    set raw;
    statename = stnamel(state);
run;

/**************************************
validate the city/state/zip combinations
**************************************/

/**************************************
per http://support.sas.com/documentation/cdl/en/lefunctionsref/63354/HTML/default/viewer.htm#n1h2lg5jz7wxh3n1c00jubsktp75.htm
this will allow me to see how recently the zip code data was updated; on my system it was 6/20/2013.

I'll leave this commented out for production.

Found the SCAN function courtesy of http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a000214639.htm
**************************************/
/**/
/*proc contents data=SASHELP.ZIPCODE;   */
/*run;*/
data validate;
    set with_states;

    * set up several variables for use in validation...;
    length scan_state  $ 2;
    stnamel = stnamel(state);
    zipnamel = zipnamel(zipcode);
    zipstate = zipstate(zipcode);
    zcity = zipcity(zipcode);
    * now, the above vars contain the "calculated" data, which I'll compare to the input data in a later step;

    * give me the first word, trimmed of surrounding spaces ('r' flag), should be the city;
    scan_city = scan(zcity, 1, ',', 'r'); 
    * give me the second word, trimmed of surrounding spaces ('r' flag), should be the state abbrev.;
    scan_state = scan(zcity, 2, ',', 'r'); 

    * if the "calculated" data don't match the input data, set the zipcode as instructed;
    if scan_city ne city or scan_state ne state then zipcode = "??";

    keep PatientName StreetAddress City statename Zipcode Phone;
run;
/**/
/*proc print data = validate;*/
/*    var  stnamel zipnamel zipstate zipcode city ;*/
/*run;*/

/**************************************
Generate output
**************************************/
proc print data = validate label;
    title "Mailing Address Data";
    title2 "(using input)";
    label   patientname = "Patient Name"
            StreetAddress = "Street Address"
            city = "City"
            statename = "State"
            Zipcode = "ZIP"
            phone = "Phone Number";

    var PatientName StreetAddress City statename Zipcode Phone;
run;

/**************************************
Reflection upon the data:

- The zip for Buffalo, NY isn't valid; according to the USPS ZIP checker, such a zip code does not exist.

- The string "Greenbay" in the input data does not equal "Green Bay" from the calculated data, so this gets
    kicked out as bogus data.  Some data preprocessing to ensure weird inconsistencies like this are caught
    would be beneficial; alternatively, just have the user input the city/state and let the computer do the lookup,
    which is much less error-prone.  Naturally, validate the data that are generated in case there's some 
    dodgy ZIP information in SAS.

- The string "Harrisbu" in the input data does not equal "Harrisburg" from the calculated data, in much the same
    way as above.  Plus the ZIP in the Harrisburg address actually maps to Levittown, PA.  Again, a good way around
    this would be some preprocessing or, my preference, only have the input of the city/state and let the lookup 
    functions take care of the rest.  Smaller data set, less room for error, and just less work in the long run!

    We could cross-reference the area code and exchange with a particular area, but with the proliferation of cell
    phones and the way they've de-coupled phone numbers from physical location, that becomes a pretty bad way to make an educated guess.
    I think I'll try something below.
**************************************/

/**************************************
Here there be monsters....
**************************************/
data testing_a_hypothesis;
    length phone 6;
    length zipcode $ 5;
    * use the line pointer, the slash character, to accommodate the structure of the input data;
    input PatientName $25. / StreetAddress $30. / rawCity $ State $ Zipcode $/ rawphone $16.;
    phone = compress(rawphone, '-');
    city = compress(rawcity, ',');
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

/**************************************
This isn't a super robust algorithm, but it tackles the mismatch issues reasonably well in this data set.
**************************************/
data lookup_functions_FTW;
    set testing_a_hypothesis;

    length city_name $30.;
    lu_state = zipstate(zipcode);
    lu_city = zipcity(zipcode);

    * if the zip code isn't valid, use the city name that was input;
    * and just skip the zip code... they're stupid anyway and the letter will still make it to the address;
    if lu_city eq ' ' then do;
        city_name = city;
        zipcode = '';
    end;
    * otherwise, use the city name that the lookup function provides;
    else city_name = scan(lu_city, 1, ',', 'r');
    * I imagine there's a way to do some SQL-fu on the ZIP data file to make it searchable by city name, but that's beyond my ken and motivation;

run;

proc print data = lookup_functions_FTW label;
    title "Mailing Address Data";
    title "(using lookup functions more liberally)";
    label   patientname = "Patient Name"
            StreetAddress = "Street Address"
            city_name = "City"
            state = "State"
            Zipcode = "ZIP"
            phone = "Phone Number";
    var PatientName StreetAddress city_name State zipcode phone;
run;