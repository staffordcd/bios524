/*--------------------------------------------------------
student record counter - see how long it took for
a student to take 10 classes
--------------------------------------------------------*/

data raw;
    input name $ class1-class5;
    datalines;
    Jim	5  3  8  8  4
Jose  6  4  6  7  7
Irin	3  6  7  7  4
Deb	8  9  4  5  8
;
run;

data count_courses;
    set raw;
    array class class1-class5;
    total = 0;
    do i = 1 to dim(class) until (total >= 10);
        total = total + class{i};
    end;
    if total < 10 then year = .;
    else year = i;
    drop i total;
run;
