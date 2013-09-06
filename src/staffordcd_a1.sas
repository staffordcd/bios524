/*--------------------------------------------------------
    Christian Stafford
    Assignment 1
    Completed:
    Description:
--------------------------------------------------------*/


data treedat;
    input ID 1-4 SPECIES $ 6-11 INIT_CIRC 13-16 FERT_CODE $ 18 FIN_CIRC 20-23;
    datalines;
1111 Pine   62.1 X 86.0
1110 Oak    43.1 X 76.9
6116 Maple  51.6 Y 56.5
1138 Oak    41.3 Z 53.7
5210 Maple  41.0 X 61.9
1217 Maple  62.7 Y 63.4
3214 Pine   33.4 X 66.9
2213 Pine   44.3 X 72.3
6247 Oak    52.4 Y 36.6
1301 Beech  74.0 Y 76.2
1319 Maple  52.9 Z 63.2
1318 Maple  61.8 Z 77.3
6315 Pine   42.5 Y 47.6
1312 Pine   51.2 X 96.2
1329 Oak    64.2 Y 66.7
6356 Oak    53.5 Z 74.5
1365 Beech  74.6 X 84.4
1374 Beech  51.7 X 92.1
1383 Beech  92.8 Y 99.2
1392 Beech  63.9 Z 86.1
;
run;
