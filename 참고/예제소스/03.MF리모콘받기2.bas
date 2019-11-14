
'****************************************
'***** 메탈파이터 기초 프로그램 *******
'****************************************

'******* 변수선언 ***********************
DIM A AS BYTE
DIM A_old AS BYTE

TEMPO 220
MUSIC "O23EAB7EA>3#C"

'***** 메인 반복루틴 ********************
MAIN:

    ERX 4800,A,MAIN
    A_old = A
    
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    GOTO MAIN
    
    
    '******************
    '******************

KEY1:

	MUSIC "C"
    GOTO MAIN
    '******************
KEY2:

	MUSIC "D"
    GOTO MAIN
    '******************
KEY3:

	MUSIC "E"
    GOTO MAIN
    '******************
KEY4:

	MUSIC "F"
    GOTO MAIN
    '******************
KEY5:
	MUSIC "G"
    GOTO MAIN
    '******************
KEY6:

	MUSIC "A"
    GOTO MAIN
    '******************
KEY7:


	MUSIC "B"
    GOTO MAIN
    '******************
KEY8:


	MUSIC ">C<"
    GOTO MAIN
    '******************
KEY9:


	MUSIC ">D<"

    GOTO MAIN
    '******************
KEY10: '0


	MUSIC ">E<"
    GOTO MAIN
    '******************
KEY11: ' ▲




    GOTO MAIN
    '******************
KEY12: ' ▼




    GOTO MAIN
    '******************
KEY13: '▶




    GOTO MAIN
    '******************
KEY14: ' ◀




    GOTO MAIN
    '******************
KEY15: ' A


    GOTO MAIN
    '******************
KEY16: ' POWER



    GOTO MAIN
    '******************
KEY17: ' C



    GOTO MAIN
    '******************
KEY18: ' E


    GOTO MAIN
    '******************


KEY19: ' P2



    GOTO MAIN
    '******************
KEY20: ' B	




    GOTO MAIN
    '******************
KEY21: ' △



    GOTO MAIN
    '******************
KEY22: ' *	




    GOTO MAIN
    '******************
KEY23: ' G


    GOTO MAIN
    '******************
KEY24: ' #



    GOTO MAIN
    '******************
KEY25: ' P1


    GOTO MAIN
    '******************
KEY26: ' ■

    GOTO MAIN
    '******************
KEY27: ' D




    GOTO MAIN
    '******************
KEY28: ' ◁



    GOTO MAIN
    '******************
KEY29: ' □


    GOTO MAIN
    '******************
KEY30: ' ▷


    GOTO MAIN
    '******************
KEY31: ' ▽


    GOTO MAIN
    '******************

KEY32: ' F



    GOTO MAIN
    '******************

