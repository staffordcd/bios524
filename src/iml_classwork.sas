libname LIBRARY "c:/bios524/data/";

    
proc iml;
    reset deflib = library;
    use clinics;
    show contents;

    read all var {NumPhys} into FTE;

    mean_fte = fte[:];
    max_fte = fte[<>];
    min_mean_fte = fte[loc(fte > mean_fte)][><];
    print min_mean_fte;

    read all var {ClinicID} into clinic;

    matches = clinic[loc(fte = min_mean_fte)];
    print matches[format = $clinid.];