

'******** 메탈파이터 기본형 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM 자세 AS BYTE
DIM Action_mode AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 모터ONOFF AS BYTE


DIM S6 AS BYTE
DIM S7 AS BYTE
DIM S8 AS BYTE

DIM S11 AS BYTE
DIM S12 AS BYTE
DIM S13 AS BYTE
DIM S14 AS BYTE


'**** 기울기센서포트 설정

CONST 앞뒤기울기AD포트 = 2
CONST 좌우기울기AD포트 = 3


'*****  2012년 이전 센서 ****
'CONST 기울기확인시간 = 10  'ms
'CONST min = 100			'뒤로넘어졌을때
'CONST max = 160			'앞으로넘어졌을때
'CONST COUNT_MAX = 30
'

'**** 2012년 사용 센서 *****
CONST 기울기확인시간 = 5  'ms
CONST MIN = 61			'뒤로넘어졌을때
CONST MAX = 107			'앞으로넘어졌을때
CONST COUNT_MAX = 20
'*********************************

CONST 하한전압 = 103	'약6V전압

PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,0,0,0		'모터12~17번
DIR G6D,0,1,1,0,1,0		'모터18~23번


'***** 초기선언 *********************************
모터ONOFF = 0

'****초기위치 *****************************
OUT 52,0	'눈 LED 켜기

GOSUB MOTOR_ON

SPEED 5
GOSUB 전원초기자세
GOSUB 기본자세


GOTO MAIN
'************************************************
'************************************************

MOTOR_FAST_ON:

    MOTOR G6B
    MOTOR G6C
    MOTOR G6A
    MOTOR G6D

    모터ONOFF = 0
    RETURN

    '************************************************
    '************************************************
MOTOR_ON:

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2
    MOTORMODE G6C,2,2,2
    RETURN
    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3
    MOTORMODE G6C,3,3,3
    RETURN

    '************************************************
    '*******기본자세관련*****************************
    '************************************************
전원초기자세:
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,100,  45,  90, 100, 100, 100
    MOVE G6C,100,  45,  90, 100, 100, 100
    WAIT
    자세 = 0
    RETURN
    '************************************************
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    자세 = 0

    RETURN
    '************************************************
기본자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    자세 = 0
    RETURN
    '************************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    자세 = 2
    RETURN
    '************************************************
앉은자세:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    자세 = 1

    RETURN

    '************************************************
RX_EXIT:
    'GOSUB SOUND_STOP
    ERX 4800, A, MAIN

    GOTO RX_EXIT
    '************************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN


    '************************************************
    '******* 피에조 소리 관련 ***********************
    '************************************************


시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
엔터테이먼트음:
    TEMPO 220
    MUSIC "O28B>4D8C4E<8B>4D<8B>4G<8E>4C"
    RETURN
    '************************************************
게임음:
    TEMPO 210
    MUSIC "O23C5G3#F5G3A5G"
    RETURN
    '************************************************
파이트음:
    TEMPO 210
    MUSIC "O15A>C<A>3D"
    RETURN
    '************************************************
경고음:
    TEMPO 180
    MUSIC "O13A"
    DELAY 300

    RETURN
    '************************************************
비프음:
    TEMPO 180
    MUSIC "A"
    DELAY 300

    RETURN
    '************************************************
싸이렌음:
    TEMPO 180
    MUSIC "O22FC"
    DELAY 10
    RETURN
    '************************************************

축구게임음:
    TEMPO 180
    MUSIC "O28A#GABA"
    RETURN
    '************************************************

장애물게임음:
    TEMPO 200
    MUSIC "O37C<C#BCA"
    RETURN
    '************************************************
    '************************************************

    '**********************************************
    '**********************************************
    '**** 카메라포즈 ******************************
비상자세:
    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6A, 88,  71, 152,  91, 110, 100
    MOVE G6D,112,  76, 146,  93,  92, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT


    SPEED 10
    MOVE G6A, 90,  98, 105,  115, 115, 100
    MOVE G6D,114,  74, 145,  98,  93, 100
    MOVE G6B,100,  150,  150
    MOVE G6C,100,  150,  150
    WAIT

    SPEED 6
    MOVE G6A, 90, 121,  36, 105, 115,  100
    MOVE G6D,114,  60, 146, 138,  93,  100
    WAIT

    SPEED 6
    GOSUB Leg_motor_mode2
    MOVE G6A, 90,  98, 135,  44, 115,  100
    MOVE G6D,114,  45, 170, 160,  93,  100
    MOVE G6B,170,  120,  120 , , , 60
    MOVE G6C,170,  120,  120
    WAIT

비상자세_WAIT:
    ERX 4800,A,비상자세_WAIT
    IF A <> 26 THEN ' ■버튼
        GOSUB 비프음
        GOTO 비상자세_WAIT
    ENDIF

    SPEED 4
    MOVE G6A, 85,  98, 105,  115, 115, 100
    MOVE G6D,115,  74, 145,  98,  93, 100
    MOVE G6B,100,  150,  150, , , 100
    MOVE G6C,100,  150,  150
    WAIT

    SPEED 8
    MOVE G6A, 85,  71, 152,  91, 110, 100
    MOVE G6D,108,  76, 146,  93,  92, 100
    MOVE G6B,100,  70,  80
    MOVE G6C,100,  70,  80
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  80
    MOVE G6C,100,  35,  80
    WAIT

    SPEED 2
    GOSUB 기본자세	
    GOSUB All_motor_Reset



    RETURN
    '**********************************************
파이터자세:

    SPEED 6
    MOVE G6B, 120,  40,  90
    MOVE G6C, 120,  40,  90
    WAIT

    SPEED 6
    MOVE G6A,  70,  78, 141, 95, 127, 100
    MOVE G6D,  97, 107,  93, 116, 102, 100
    MOVE G6B, 145,  66,  87, , ,  50
    MOVE G6C, 170,  15,  32, , ,
    WAIT

    GOSUB All_motor_mode3
파이터자세_WAIT:
    ERX 4800,A,파이터자세_WAIT
    IF A <> 26 THEN ' ■버튼
        GOSUB 비프음
        GOTO 파이터자세_WAIT
    ENDIF
    GOSUB All_motor_Reset
    SPEED 6
    MOVE G6B, 120,  40,  90
    MOVE G6C, 120,  40,  90
    WAIT
    SPEED 8
    GOSUB 기본자세

    RETURN
    '**********************************************
옆찌르기자세:

    SPEED 8
    MOVE G6A, 63, 76,  160, 85, 130	
    MOVE G6D, 88, 125,  70, 120, 115
    MOVE G6B,100,  70,  100, , ,  150
    MOVE G6C,100, 125, 108
    WAIT

    GOSUB All_motor_mode3
옆찌르기자세_WAIT:
    ERX 4800,A,옆찌르기자세_WAIT
    IF A <> 26 THEN ' ■버튼
        GOSUB 비프음
        GOTO 옆찌르기자세_WAIT
    ENDIF
    GOSUB All_motor_Reset
    SPEED 8
    GOSUB 기본자세


    RETURN
    '**********************************************
한발들기자세:
    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D,112,  77, 146,  93,  92, '60	
    MOVE G6A, 80,  71, 152,  91, 112,' 60
    MOVE G6C,100,  100,  100, , , ,
    MOVE G6B,100,  100,  100, , , ,	
    WAIT
    SPEED 8
    MOVE G6D,113,  77, 146,  93,  92, 100	
    MOVE G6A,80,  150,  27, 140, 114, 100
    MOVE G6C,100,  100,  100, , ,
    MOVE G6B,100,  100,  100, , , 100
    WAIT
    GOSUB All_motor_mode3
한발들기자세_WAIT:
    ERX 4800,A,한발들기자세_WAIT
    IF A <> 26 THEN ' ■버튼
        GOSUB 비프음
        GOTO 한발들기자세_WAIT
    ENDIF

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D,112,  77, 146,  93,  92, 100		
    MOVE G6A, 80, 88, 125, 100, 115, 100
    MOVE G6B,100,  100,  100, , , ,
    MOVE G6C,100,  100,  100, , , ,
    WAIT

    SPEED 4
    GOSUB 기본자세
    GOSUB Leg_motor_mode1

    RETURN
    '**********************************************
공차기자세:
    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6A,110,  77, 145,  93,  92, 100	
    MOVE G6D, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    SPEED 10
    MOVE G6A,113,  75, 145,  100,  95	
    MOVE G6D, 83,  85, 122,  105, 114
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6A,113,  73, 145,  85,  95	
    MOVE G6D, 83,  20, 172,  155, 114
    MOVE G6C,50
    MOVE G6B,150
    WAIT
공차기자세_WAIT:
    ERX 4800,A,공차기자세_WAIT
    IF A <> 26 THEN ' ■버튼
        GOSUB 비프음
        GOTO 공차기자세_WAIT
    ENDIF

    SPEED 10
    MOVE G6A,113,  72, 145,  97,  95
    MOVE G6D, 83,  58, 122,  130, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT	

    SPEED 8
    MOVE G6A,113,  77, 145,  95,  95	
    MOVE G6D, 80,  80, 142,  95, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,110,  77, 145,  93,  93, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1



    RETURN
    '**********************************************
비전자세:
    SPEED 6
    MOVE G6C, 100,  40,  90
    MOVE G6B, 150,  40,  90
    WAIT
    SPEED 10
    MOVE G6C,100,  100,  100,
    MOVE G6B,190,  15,  15, , , 100
    WAIT

    GOSUB All_motor_mode3
    SPEED 8
    MOVE G6A,96,  106, 89,  123, 130, 100
    MOVE G6D,85,  76, 145,  93, 85, 100
    MOVE G6C,100,  110,  110,
    MOVE G6B,160,  15,  20, , , 160
    WAIT

비전자세_WAIT:
    ERX 4800,A,비전자세_WAIT
    IF A <> 26 THEN ' ■버튼
        GOSUB 비프음
        GOTO 비전자세_WAIT
    ENDIF

    SPEED 6
    MOVE G6C, 100,  40,  90
    MOVE G6B, 150,  40,  90, , , 100
    WAIT
    GOSUB Leg_motor_mode2
    SPEED 6
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    RETURN
    '**********************************************
복고댄스자세:
    GOSUB Leg_motor_mode2
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80, , ,100
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  90
    MOVE G6C,100,  40,  90
    WAIT


    SPEED 5
    MOVE G6A, 80,  74, 146, 94, 116, 100
    MOVE G6D,108,  81, 137,  98, 98, 100
    MOVE G6B,100,  70,  90
    MOVE G6C,100,  70,  90	
    WAIT

    SPEED 5
    MOVE G6A,94,  76, 145,  93, 106, 100
    MOVE G6D,94,  76, 145,  93, 106, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT	

    SPEED 4
    MOVE G6C,100,  150,  140
    MOVE G6B,100,  100,  100, , ,70
    MOVE G6D, 95,  94, 145,  45, 107,
    MOVE G6A, 89,  94, 145,  45, 113,
    WAIT


복고댄스자세_WAIT:
    ERX 4800,A,복고댄스자세_WAIT
    IF A <> 26 THEN ' ■버튼
        GOSUB 비프음
        GOTO 복고댄스자세_WAIT
    ENDIF
    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 95, 100
    MOVE G6D,100,  76, 145,  93, 95, 100
    MOVE G6B,100,  30,  80, , ,100
    MOVE G6C,100,  30,  80
    WAIT
    SPEED 5
    GOSUB 기본자세



    RETURN
    '**********************************************
보행자세:

    GOSUB Leg_motor_mode3
    SPEED 4
    '왼쪽기울기
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6A, 108,  76, 146,  93,  94
    MOVE G6C, 100,35
    MOVE G6B, 100,35
    WAIT

    SPEED 10'보행속도
    '오른발들기
    MOVE G6D, 90, 100, 115, 105, 114
    MOVE G6A,113,  78, 146,  93,  94
    MOVE G6C,70,35
    MOVE G6B,130,30
    WAIT

보행자세_WAIT:
    ERX 4800,A,보행자세_WAIT
    IF A <> 26 THEN ' ■버튼
        GOSUB 비프음
        GOTO 보행자세_WAIT
    ENDIF

    SPEED 5

    '왼쪽기울기2
    MOVE G6A, 106,  76, 146,  93,  96		
    MOVE G6D,  88,  71, 152,  91, 106
    MOVE G6B, 100,35
    MOVE G6C, 100,35
    WAIT	


    SPEED 3
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN

    '******************************************
미안한자세:
    GOSUB Arm_motor_mode3
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  185,  170
    WAIT	
    SPEED 4
    MOVE G6B,100,  30,  80, , ,130
    MOVE G6C,90,  170,  185
    WAIT

미안한자세_WAIT:
    ERX 4800,A,미안한자세_WAIT
    IF A <> 26 THEN ' ■버튼
        GOSUB 비프음
        GOTO 미안한자세_WAIT
    ENDIF

    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN

    '**********************************************
    '******************************************	
MAIN: '라벨설정


    ERX 4800,A,MAIN
    A_old = A

    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************
    '*******************************************

KEY1:

    IF 자세 = 0 THEN
        GOSUB 비상자세
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY2:

    IF 자세 = 0 THEN
        GOSUB 파이터자세
    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY3:

    IF 자세 = 0 THEN
        GOSUB 옆찌르기자세
    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY4:

    IF 자세 = 0 THEN
        GOSUB 한발들기자세
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY5:

    IF 자세 = 0 THEN
        GOSUB 공차기자세
    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY6:

    IF 자세 = 0 THEN
        GOSUB 비전자세
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY7:

    IF 자세 = 0 THEN
        GOSUB 복고댄스자세
    ENDIF



    GOTO RX_EXIT
    '*******************************************
KEY8:

    IF 자세 = 0 THEN
        GOSUB 보행자세
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY9:


    IF 자세 = 0 THEN
        GOSUB 미안한자세
    ENDIF



    GOTO RX_EXIT
    '*******************************************
KEY10: '0





    GOTO RX_EXIT
    '*******************************************
KEY11: ' ▲





    GOTO RX_EXIT
    '*******************************************
KEY12: ' ▼





    GOTO RX_EXIT
    '*******************************************
KEY13: '▶




    GOTO RX_EXIT
    '*******************************************
KEY14: ' ◀




    GOTO RX_EXIT
    '*******************************************
KEY15: ' A


    GOTO RX_EXIT
    '*******************************************
KEY16: ' POWER



    GOTO RX_EXIT

    '*******************************************
KEY17: ' C


    GOTO RX_EXIT
    '*******************************************
KEY18: ' E

    GOTO RX_EXIT
    '*******************************************


KEY19: ' P2



    GOTO RX_EXIT
    '*******************************************
KEY20: ' B	


    GOTO RX_EXIT
    '*******************************************
KEY21: ' △


    GOTO RX_EXIT
    '*******************************************
KEY22: ' *	



    GOTO RX_EXIT
    '*******************************************
KEY23: ' G

    GOTO RX_EXIT
    '*******************************************
KEY24: ' #


    GOTO RX_EXIT
    '*******************************************
KEY25: ' P1



    GOTO RX_EXIT
    '*******************************************
KEY26: ' ■


    SPEED 5
    GOSUB 기본자세	
    GOSUB All_motor_Reset
    GOTO RX_EXIT
    '*******************************************
KEY27: ' D




    GOTO RX_EXIT
    '*******************************************
KEY28: ' ◁



    GOTO RX_EXIT
    '*******************************************
KEY29: ' □



    IF 자세 = 0 THEN
        GOSUB Leg_motor_mode3

        SPEED 10
        MOVE G6A,100, 140,  37, 140, 100, 100
        MOVE G6D,100, 140,  37, 140, 100, 100
        WAIT

        SPEED 3
        GOSUB 앉은자세	
    ELSE
        GOSUB Leg_motor_mode2


        SPEED 6
        MOVE G6A,100, 140,  37, 140, 100, 100
        MOVE G6D,100, 140,  37, 140, 100, 100
        WAIT

        SPEED 10
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY30: ' ▷


    GOTO RX_EXIT
    '*******************************************
KEY31: ' ▽


    GOTO RX_EXIT
    '*******************************************

KEY32: ' F



    GOTO RX_EXIT
    '*******************************************











