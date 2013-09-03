* use a basic do loop in the input statement to auto-populate a variable;
* use the single @ to do some implicit flow control (keeps the next input stmt from going to next line);
Data a;
    * single @ here "holds" the pressure at 120 for each temp, then at 130 for each temp, etc.;
    Input pressure @;
    Do temp = 250 to 270 by 10;
        * single @ here keeps the input buffer looking at the same line so each strength can be read;
        Input strength @;
        /* output does a 'buffer flush' to make sure data is written out at the end of each step;
           otherwise, only the last data point would be written to the data set (the default behavior
           of the do loop is to only execute OUTPUT when it terminates). Comment out OUTPUT below 
           to see this in action.
        */
        Output;
    End;
    Datalines;
120 9.6 11.28 9.00
130 9.69 10.1 9.57
140 8.43 11.01 9.03
150 9.98 10.44 9.8
; 
Run;
