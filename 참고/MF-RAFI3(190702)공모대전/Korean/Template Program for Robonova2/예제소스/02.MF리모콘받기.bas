
'****************************************
'***** 메탈파이터 기초 프로그램 *******
'****************************************

'******* 변수선언 ***********************
DIM A AS BYTE
'***************************************
TEMPO 220
MUSIC "O23EAB7EA>3#C"
'***** 메인 반복루틴 ********************
MAIN:

    ERX 4800,A,MAIN

    IF A = 1 THEN
        MUSIC "C"
    ELSEIF A = 2 THEN
        MUSIC "D"
    ELSEIF A = 3 THEN
        MUSIC "E"
    ELSEIF A = 4 THEN
        MUSIC "F"
    ELSEIF A = 5 THEN
        MUSIC "G"
    ELSEIF A = 6 THEN
        MUSIC "A"
    ELSEIF A = 7 THEN
        MUSIC "B"
    ELSEIF A = 8 THEN
        MUSIC ">C<"
    ELSEIF A = 9 THEN
        MUSIC ">D<"
    ELSEIF A = 10 THEN
        MUSIC ">E<"		
    ENDIF

    GOTO MAIN
    '***************************************
