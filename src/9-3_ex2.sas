* another example of do loops, and forced output statement;
data ttube;
/*  
    could replace the generic counter vars with their counterparts, e.g. replace
    do j=1 to 2 with Gtype=1 to 2, etc.
*/
do j=1 to 2;
  Gtype=j;
  do i=1 to 3;
      Ptype=i;
      do l=1 to 3;
          input y @@;
          output;
      end;
   end;
end;
cards;
280 290 285
300 310 295
290 285 290
230 235 240
260 240 235
220 225 230
;
run;
