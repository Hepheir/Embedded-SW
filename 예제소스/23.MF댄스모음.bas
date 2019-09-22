

'******** 메탈파이터 기본형 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM 자세 AS BYTE
DIM Action_mode AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER
DIM DELAY_TIME AS BYTE
DIM DELAY_TIME2 AS BYTE
DIM TEMP AS BYTE
DIM 물건집은상태 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 넘어진확인 AS BYTE

DIM 반복횟수 AS BYTE
DIM 기울기센서측정여부 AS BYTE
DIM 홍보모드방향지시여부 AS BYTE


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

'*******************
CONST 하한전압 = 103	'약6V전압

PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,0,0,0		'모터12~17번
DIR G6D,0,1,1,0,1,0		'모터18~23번


'***** 초기선언 *********************************
모터ONOFF = 0
보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
넘어진확인 = 0
기울기센서측정여부 = 1
홍보모드방향지시여부 = 0
물건집은상태 = 0
'****Action_mode(초기액션모드)******************
Action_mode = 0	'D(CODE 27):댄스모드


'****초기위치 *****************************
OUT 52,0	'눈 LED 켜기

GOSUB MOTOR_ON
GOSUB SOUND_VOLUME_30

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
    물건집은상태 = 0
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
    '******* 사운드모듈관련 *************************
    '************************************************
SOUND_홍보1:
    PRINT "SOUND 48!"
    RETURN
SOUND_홍보2:
    PRINT "SOUND 49!"
    RETURN
SOUND_홍보3:
    PRINT "SOUND 50!"
    RETURN
SOUND_홍보4:
    PRINT "SOUND 51!"
    RETURN
SOUND_홍보5:
    PRINT "SOUND 52!"
    RETURN
SOUND_홍보6:
    PRINT "SOUND 53!"
    RETURN
SOUND_홍보7:
    PRINT "SOUND 54!"
    RETURN
SOUND_홍보8:
    PRINT "SOUND 55!"
    RETURN
SOUND_홍보9:
    PRINT "SOUND 56!"
    RETURN
    '************************************************
SOUND_국민체조곡: '
    PRINT "SOUND 47!"
    RETURN
SOUND_로보링크주제곡: '
    PRINT "SOUND 46!"
    RETURN
SOUND_안녕하세요: '
    PRINT "SOUND 12!"
    RETURN
SOUND_안녕하세요미니로봇에서개발된메탈파이터입니다: '
    PRINT "SOUND 0!"
    RETURN

    '************************************************
SOUND_MODE_SELECT:
    IF Action_mode = 0 THEN			
        GOSUB  SOUND_댄스모드
    ELSEIF Action_mode = 1 THEN		
        GOSUB SOUND_격투모드
    ELSEIF Action_mode = 2 THEN		
        GOSUB SOUND_게임모드
    ELSEIF Action_mode = 3 THEN		
        GOSUB SOUND_축구모드
    ELSEIF Action_mode = 4 THEN		
        GOSUB SOUND_장애물경주모드
    ELSEIF Action_mode = 5 THEN		
        GOSUB SOUND_카메라모드
    ELSEIF Action_mode = 6 THEN		
        GOSUB SOUND_홍보모드
    ENDIF

    RETURN
    '************************************************
SOUND_댄스모드:
    PRINT "SOUND 1!"
    RETURN
SOUND_격투모드:
    PRINT "SOUND 2!"
    RETURN
SOUND_게임모드:
    PRINT "SOUND 3!"
    RETURN
SOUND_축구모드:
    PRINT "SOUND 4!"
    RETURN
SOUND_장애물경주모드:
    PRINT "SOUND 5!"
    RETURN
SOUND_홍보모드:
    PRINT "SOUND 6!"
    RETURN
SOUND_카메라모드:
    PRINT "SOUND 7!"
    RETURN
SOUND_청기올려:
    PRINT "SOUND 26!"
    RETURN
SOUND_청기내려:
    PRINT "SOUND 27!"
    RETURN
SOUND_백기올려:
    PRINT "SOUND 28!"
    RETURN
SOUND_백기내려:
    PRINT "SOUND 29!"
    RETURN


SOUND_BGM1:
    PRINT "AUTO 31!"
    RETURN
SOUND_BGM2:
    PRINT "AUTO 32!"
    RETURN
SOUND_BGM3:
    PRINT "AUTO 33!"
    RETURN
SOUND_BGM4:
    PRINT "AUTO 34!"
    RETURN
SOUND_BGM5:
    PRINT "AUTO 35!"
    RETURN
SOUND_BGM6:
    PRINT "AUTO 36!"
    RETURN
SOUND_BGM7:
    PRINT "AUTO 37!"
    RETURN
SOUND_BGM8:
    PRINT "AUTO 38!"
    RETURN
SOUND_BGM9:
    PRINT "AUTO 39!"
    RETURN
SOUND_BGM10:
    PRINT "AUTO 40!"
    RETURN
SOUND_BGM11:
    PRINT "AUTO 41!"
    RETURN
SOUND_BGM12:
    PRINT "AUTO 42!"
    RETURN

SOUND_ALL_OFF_MSG:
    PRINT "SOUND 20!"
    DELAY 1500
    GOSUB SOUND_VOLUME_0
    RETURN

SOUND_ALL_ON_MSG:
    GOSUB SOUND_VOLUME_30
    PRINT "SOUND 21!"

    RETURN

SOUND_ON_OK_MSG:
    PRINT "SOUND 22!"
    RETURN

SOUND_가위:
    PRINT "SOUND 23!"
    RETURN
SOUND_바위:
    PRINT "SOUND 24 !"
    RETURN
SOUND_보:
    PRINT "SOUND 25 !"
    RETURN
SOUND_Walk_Move:
    PRINT "SOUND 45 !"
    RETURN
SOUND_Walk_Ready:
    PRINT "PLAYNUM 43 !"
    RETURN
SOUND_walk:
    PRINT "SOUND 43 !"
    RETURN
SOUND_REPLAY:
    PRINT "!"
    RETURN

SOUND_VOLUME_50:
    PRINT "VOLUME 50 !"
    RETURN

SOUND_VOLUME_40:
    PRINT "VOLUME 40 !"
    RETURN

SOUND_VOLUME_30:
    PRINT "VOLUME 30 !"
    RETURN
SOUND_VOLUME_20:
    PRINT "VOLUME 20 !"
    RETURN
SOUND_VOLUME_10:
    PRINT "VOLUME 10 !"
    RETURN

SOUND_VOLUME_0:
    PRINT "VOLUME 0 !"
    RETURN



SOUND_STOP:
    PRINT "STOP !"
    RETURN

SOUND_UP:
    PRINT "UP 5 !"
    RETURN

SOUND_DOWN:
    PRINT "DOWN 5 !"
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
    '************************************************
뒤로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON				

    GOSUB Arm_motor_mode1
    GOSUB Leg_motor_mode1


    SPEED 15
    MOVE G6A,100, 150, 170,  40, 100
    MOVE G6D,100, 150, 170,  40, 100
    MOVE G6B, 150, 150,  45
    MOVE G6C, 150, 150,  45
    WAIT

    SPEED 15
    MOVE G6A,  100, 155,  110, 120, 100
    MOVE G6D,  100, 155,  110, 120, 100
    MOVE G6B, 190, 80,  15
    MOVE G6C, 190, 80,  15
    WAIT

    GOSUB Leg_motor_mode2
    SPEED 15	
    MOVE G6A,  100, 165,  25, 162, 100
    MOVE G6D,  100, 165,  25, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    DELAY 50
    SPEED 12	
    MOVE G6A,  100, 150,  25, 162, 100
    MOVE G6D,  100, 150,  25, 162, 100
    MOVE G6B,  140, 15, 90
    MOVE G6C,  140, 15, 90
    WAIT


    SPEED 8
    MOVE G6A,  100, 138,  25, 155, 100
    MOVE G6D,  100, 138,  25, 155, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    DELAY 100
    SPEED 10
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    넘어진확인 = 1
    RETURN


    '**********************************************
앞으로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB Arm_motor_mode1
    GOSUB Leg_motor_mode1


    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 10
    GOSUB 기본자세
    넘어진확인 = 1
    RETURN

    '******************************************
    '************************************************
    '****** 보행 관련********************************
    '************************************************

    '**********************************************	
    '**********************************************	
    '************************************************
오른쪽옆으로20:

    GOSUB SOUND_Walk_Move
    SPEED 12
    MOVE G6D, 93,  90, 120, 105, 104, 100
    MOVE G6A,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세

    GOTO RX_EXIT
    '**********************************************

왼쪽옆으로20:

    GOSUB SOUND_Walk_Move
    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 104, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세
    GOTO RX_EXIT

    '**********************************************

오른쪽옆으로70:
    GOSUB SOUND_Walk_Move
    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6D, 102,  76, 147, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 10
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB 기본자세

    GOTO RX_EXIT
    '*************

왼쪽옆으로70:
    GOSUB SOUND_Walk_Move

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 10
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15	
    GOSUB 기본자세

    GOTO RX_EXIT
    '************************************************

    '************************************************
천천히왼쪽옆으로50:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT


    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 76,  72, 160,  82, 128,  100
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT

    SPEED 5
    MOVE G6A,94,  76, 145,  93, 106, 100
    MOVE G6D,94,  76, 145,  93, 106, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT	
    '***********************
    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 76,  72, 160,  82, 120,  100
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT

    SPEED 6
    MOVE G6D, 85,  80, 140, 95, 110, 100
    MOVE G6A,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 2
    GOSUB 기본자세
    GOSUB All_motor_Reset	
    RETURN

    '**********************************************
    '************************************************
천천히오른쪽옆으로50:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT

    SPEED 5
    MOVE G6D, 85,  80, 140, 95, 114, 100
    MOVE G6A,112,  76, 146,  93, 98, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT


    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 76,  72, 160,  82, 128,  100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,
    WAIT

    SPEED 5
    MOVE G6D,94,  76, 145,  93, 106, 100
    MOVE G6A,94,  76, 145,  93, 106, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT	
    '***********************
    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 76,  72, 160,  82, 120,  100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,
    WAIT

    SPEED 6
    MOVE G6A, 85,  80, 140, 95, 110, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT

    SPEED 2
    GOSUB 기본자세
    GOSUB All_motor_Reset	
    RETURN

    '**********************************************

    '************************************************
    '*******기타모션 관련****************************
    '************************************************

인사1:
    GOSUB SOUND_안녕하세요미니로봇에서개발된메탈파이터입니다
    GOSUB All_motor_mode3
    SPEED 6
    MOVE G6A,100,  70, 125, 150, 100
    MOVE G6D,100,  70, 125, 150, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    DELAY 1000
    SPEED 6
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN
    '************************************************
인사2:
    GOSUB All_motor_mode3
    SPEED 4
    MOVE G6A, 108,  76, 146,  93,  94
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6B,110,  30,  80
    MOVE G6C,90,  30,  80
    WAIT

    SPEED 8
    MOVE G6D, 90, 95, 115, 105, 112
    MOVE G6A,113,  76, 146,  93,  94
    MOVE G6B,130,  30,  80
    MOVE G6C,75,  30,  80
    WAIT

    SPEED 8
    MOVE G6A,112,  86, 120, 120,  94
    MOVE G6D,90, 100, 155,  71, 112
    MOVE G6B,140,  30,  80
    MOVE G6C,70,  30,  80
    WAIT


    SPEED 10
    MOVE G6A,108,  85, 110, 140,  94
    MOVE G6D,85, 97, 145,  91, 112
    MOVE G6B,150,  20,  40
    MOVE G6C,60,  30,  80
    WAIT

    DELAY 1000
    '*******************
    GOSUB leg_motor_mode2
    SPEED 6
    MOVE G6D, 90, 95, 115, 105, 110
    MOVE G6A,114,  76, 146,  93,  96
    MOVE G6B,130,  30,  80
    MOVE G6C,75,  30,  80
    WAIT

    SPEED 8
    MOVE G6A, 108,  76, 146,  93,  94
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6B,110,  30,  80
    MOVE G6C,90,  30,  80
    WAIT

    SPEED 3
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN
    '************************************************


인사3:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  70,  80
    MOVE G6B,160,  35,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    '인사
    SPEED 8
    MOVE G6A,100,  55, 145,  145, 100, 100
    MOVE G6D,100,  55, 145,  145, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    DELAY 1000
    '일어나기
    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  70,  80
    MOVE G6B,160,  40,  80
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOSUB All_motor_Reset


    RETURN
    '************************************************


환호성:
    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode2
    SPEED 15
    MOVE G6A,100,  80, 145,  75, 100
    MOVE G6D,100,  80, 145,  75, 100
    MOVE G6B,100,  180,  120
    MOVE G6C,100,  180,  120
    WAIT	

    SPEED 10
    FOR i = 1 TO 2

        MOVE G6B,100,  145,  100
        MOVE G6C,100,  145,  100
        WAIT

        MOVE G6B,100,  180,  130
        MOVE G6C,100,  180,  130
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN
    ''************************************************
승리세레모니1:
    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode2
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  180,  120
    MOVE G6C,100,  180,  120
    WAIT	

    SPEED 10
    FOR i = 1 TO 3

        MOVE G6B,100,  145,  100
        MOVE G6C,100,  145,  100
        WAIT

        MOVE G6B,100,  180,  130
        MOVE G6C,100,  180,  130
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN
    ''************************************************
승리세레모니2:
    SPEED 10
    GOSUB 기본자세
    GOSUB All_motor_mode3

    SPEED 8

    MOVE G6A, 100, 163,  75,  15, 100
    MOVE G6D, 100, 163,  75,  15, 100
    MOVE G6B,185, 100, 90
    MOVE G6C,185, 100, 90
    WAIT

    SPEED 2

    MOVE G6A, 100, 165,  70,  10, 100, 100
    MOVE G6D, 100, 165,  70,  10, 100, 100
    MOVE G6B,185, 100, 90
    MOVE G6C,185, 100, 90
    WAIT

    DELAY 400
    SPEED 15
    FOR I = 1 TO 5

        MOVE G6B,185, 20, 50
        MOVE G6C,185, 20, 50
        WAIT

        MOVE G6B,185, 70, 80
        MOVE G6C,185, 70, 80
        WAIT

    NEXT I

    MOVE G6B,100, 70, 80
    MOVE G6C,100, 70, 80
    WAIT

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A, 100, 145,  70,  80, 100, 100
    MOVE G6D, 100, 145,  70,  80, 100, 100
    MOVE G6B,100, 40, 90
    MOVE G6C,100, 40, 90
    WAIT

    SPEED 8
    MOVE G6A,100, 121,  80, 110, 101, 100
    MOVE G6D,100, 121,  80, 110, 101, 100
    MOVE G6B,100,  40,  80, , ,
    MOVE G6C,100,  40,  80, , ,
    WAIT

    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN
    ''************************************************
    ''************************************************
승리세레모니3:
    GOSUB All_motor_mode3
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  180,  120
    WAIT	

    SPEED 10
    FOR i = 1 TO 4

        MOVE G6C,100,  145,  100
        WAIT

        MOVE G6C,100,  180,  130
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN
    ''************************************************

패배액션1:
    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 140,  37, 140, 100, 100
    MOVE G6D,100, 140,  37, 140, 100, 100
    WAIT

    SPEED 3
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 8
    MOVE G6B,140
    MOVE G6C,140
    WAIT
    SPEED 4
    MOVE G6A,95, 163,  28, 160, 105
    MOVE G6D,95, 163,  28, 160, 105
    MOVE G6B,160,  15,  90
    MOVE G6C,185,  20,  85
    WAIT

    DELAY 400
    SPEED 10
    FOR i = 1 TO 8
        MOVE G6C,165,  20,  85
        WAIT
        MOVE G6C,188,  20,  85
        WAIT  	
    NEXT i
    DELAY 500

    GOSUB Leg_motor_mode3

    SPEED 10	
    MOVE G6A,  100, 165,  28, 162, 100
    MOVE G6D,  100, 165,  28, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    SPEED 10	
    MOVE G6A,  100, 150,  27, 162, 100
    MOVE G6D,  100, 150,  27, 162, 100
    MOVE G6B,  140, 15, 90
    MOVE G6C,  140, 15, 90
    WAIT

    SPEED 6
    MOVE G6A,  100, 138,  28, 155, 100
    MOVE G6D,  100, 138,  28, 155, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    GOSUB Leg_motor_mode2
    SPEED 8
    GOSUB 기본자세

    RETURN

    ''************************************************
패배액션2:
    GOSUB Arm_motor_mode3
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  185,  170
    WAIT	

    SPEED 4
    FOR i = 1 TO 8
        MOVE G6C,100,  170,  185
        WAIT

        MOVE G6C,100,  185,  170
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN
    ''************************************************
    ''************************************************
안아주기:
    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  92
    MOVE G6B,100,  60,  80
    MOVE G6C,160,  50,  80
    WAIT

    SPEED 15
    MOVE G6A, 85,  76, 145, 94, 110
    MOVE G6D,108,  81, 135,  98, 98
    MOVE G6B,100,  60,  80
    MOVE G6C,160,  50,  80
    WAIT

    SPEED 6
    MOVE G6A, 90,  92, 115, 109, 125, 100
    MOVE G6D,103,  76, 141,  98,  82, 100
    MOVE G6B,160,  50,  80
    MOVE G6C,188,  50,  80
    WAIT	

    SPEED 5
    FOR i = 1 TO 6

        MOVE G6B,160,  50,  50
        MOVE G6C,188,  50,  50
        WAIT

        MOVE G6B,160,  55,  80
        MOVE G6C,188,  55,  80
        WAIT
    NEXT i


    SPEED 10
    MOVE G6A, 85,  76, 145, 94, 110
    MOVE G6D,108,  81, 135,  98, 98
    MOVE G6B,100,  40,  80
    MOVE G6C,160,  60,  80
    WAIT

    SPEED 10
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  92
    MOVE G6B,100,  40,  80
    MOVE G6C,140,  60,  90
    WAIT

    SPEED 6
    MOVE G6A, 95,  75, 146,  93, 105
    MOVE G6D,109,  76, 146,  93,  92
    WAIT

    SPEED 3
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN


    ''************************************************
숨쉬기운동:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6B, 150,  35, 70,
    MOVE G6C, 150,  35, 70,
    MOVE G6A,100,  63, 135, 140, 100,
    MOVE G6D,100,  63, 135, 140, 100,
    WAIT

    FOR I = 1 TO 4
        SPEED 7
        MOVE G6B, 155,  40, 90,
        MOVE G6C, 155,  40, 90,
        WAIT

        SPEED 5
        MOVE G6A,100,  58, 135, 155, 100,
        MOVE G6D,100,  58, 135, 155, 100,
        WAIT

        SPEED 7
        MOVE G6B, 155,  20, 70,
        MOVE G6C, 155,  20, 70,
        WAIT

        SPEED 5
        MOVE G6A,100,  48, 160, 135, 100,
        MOVE G6D,100,  48, 160, 135, 100,
        WAIT
    NEXT I


    SPEED 6
    MOVE G6A,100,  65, 135, 140, 100,
    MOVE G6D,100,  65, 135, 140, 100,
    MOVE G6B, 155,  40, 80,
    MOVE G6C, 155,  40, 80,
    WAIT

    SPEED 6
    GOSUB 기본자세
    GOSUB All_motor_Reset 	
    RETURN
    '************************************************




    '******************************************************
앞으로덤블링:

    SPEED 15
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,130,  30,  85
    MOVE G6C,130,  30,  85
    WAIT

    SPEED 10	
    MOVE G6A, 100, 165,  55, 165, 100, 100
    MOVE G6D, 100, 165,  55, 165, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT

    SPEED 15
    MOVE G6A,100, 160, 110, 140, 100, 100
    MOVE G6D,100, 160, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,140,  70,  20
    WAIT

    SPEED 15
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  71, 177, 162, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  70, 120, 30, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70
    WAIT
    DELAY 50

    SPEED 15
    MOVE G6A,100, 110, 70,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 160, 115
    MOVE G6C,190, 160, 115
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  70,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 155, 120
    MOVE G6C,190, 155, 120
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 13
    GOSUB 앉은자세

    SPEED 10
    GOSUB 기본자세

    RETURN

    '**********************************************
    '**********************************************
뒤로덤블링:

    SPEED 15
    MOVE G6A,100, 170,  71,  23, 100, 100
    MOVE G6D,100, 170,  71,  23, 100, 100
    MOVE G6B, 80,  50,  70
    MOVE G6C, 80,  50,  70
    WAIT	

    MOVE G6A,100, 133,  49,  23, 100, 100
    MOVE G6D,100, 133,  49,  23, 100, 100
    MOVE G6B, 45, 116,  15
    MOVE G6C, 45, 116,  15
    WAIT

    SPEED 15
    MOVE G6A,100, 133,  49,  23, 100, 100
    MOVE G6D,100,  70, 180, 160, 100, 100
    MOVE G6B, 45,  50,  70
    MOVE G6C, 45,  50,  70
    WAIT


    SPEED 15
    MOVE G6A,100, 133, 180, 160, 100, 100
    MOVE G6D,100,  133, 180, 160, 100, 100
    MOVE G6B, 10,  50,  70
    MOVE G6C, 10,  50,  70
    WAIT

    HIGHSPEED SETON

    MOVE G6A,100, 95, 180, 160, 100, 100
    MOVE G6D,100, 95, 180, 160, 100, 100
    MOVE G6B,160,  50,  70
    MOVE G6C,160,  50,  70
    WAIT

    HIGHSPEED SETOFF '

    SPEED 15
    MOVE G6A,100, 130, 120,  80, 100, 100
    MOVE G6D, 100, 130, 120,  80, 100, 100
    MOVE G6B,160, 160,  10
    MOVE G6C,160, 160,  10
    WAIT
    '
    SPEED 15
    MOVE G6A,100, 145, 150,  90, 100, 100
    MOVE G6D, 100, 145, 150,  90, 100, 100
    MOVE G6B,180, 90,  10
    MOVE G6C,180, 90,  10
    WAIT

    SPEED 10
    MOVE G6A, 100, 145,  85, 150, 100, 100
    MOVE G6D, 100, 145,  85, 150, 100, 100
    MOVE G6B,185,  40, 60
    MOVE G6C,185,  40, 60
    WAIT

    SPEED 15
    MOVE G6A, 100, 165,  55, 155, 100, 100
    MOVE G6D, 100, 165,  55, 155, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT	

    GOSUB Leg_motor_mode2
    SPEED 15	
    MOVE G6A,  100, 165,  27, 162, 100
    MOVE G6D,  100, 165,  27, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    SPEED 10	
    MOVE G6A,  100, 150,  27, 162, 100
    MOVE G6D,  100, 150,  27, 162, 100
    MOVE G6B,  140, 15, 90
    MOVE G6C,  140, 15, 90
    WAIT

    SPEED 6
    MOVE G6A,  100, 138,  27, 155, 100
    MOVE G6D,  100, 138,  27, 155, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    DELAY 100
    SPEED 10
    GOSUB 기본자세
    RETURN
    '************************************************
앞으로눕기:

    SPEED 10
    MOVE G6A,100, 155,  25, 140, 100,
    MOVE G6D,100, 155,  25, 140, 100,
    MOVE G6B,130,  50,  85
    MOVE G6C,130,  50,  85
    WAIT

    SPEED 3
    MOVE G6A, 100, 165,  50, 160, 100,
    MOVE G6D, 100, 165,  50, 160, 100,
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT

    SPEED 10
    MOVE G6A,100, 130, 120,  80, 100,
    MOVE G6D,100, 130, 120,  80, 100,
    MOVE G6B,125, 160,  10
    MOVE G6C,125, 160,  10
    WAIT	

    SPEED 12
    GOSUB 기본자세

    RETURN
    '**********************************************
    '******************************************
뒤로눕기:

    SPEED 10
    MOVE G6A,100, 165,  40, 100, 100,
    MOVE G6D,100, 165,  40, 100, 100,
    MOVE G6B,110,  70,  50
    MOVE G6C,110,  70,  50
    WAIT

    SPEED 10
    MOVE G6A,100, 165,  70, 15, 100,
    MOVE G6D,100, 165,  70, 15, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    SPEED 15
    MOVE G6A,100, 126,  60, 50, 100,
    MOVE G6D,100, 126,  60, 50, 100,
    MOVE G6B,20,  30,  90
    MOVE G6C,20,  30,  90
    WAIT

    SPEED 10
    MOVE G6A,100, 10,  83, 140, 100,
    MOVE G6D,100, 10,  83, 140, 100,
    MOVE G6B,20,  130,  15
    MOVE G6C,20,  130,  15
    WAIT

    SPEED 10
    MOVE G6A,100, 10,  100, 115, 100,
    MOVE G6D,100, 10,  100, 115, 100,
    MOVE G6B,100,  130,  15
    MOVE G6C,100,  130,  15
    WAIT

    SPEED 10
    GOSUB 기본자세

    RETURN
    '******************************************


    '**********************************************
    '**********************************************
왼쪽덤블링:
    GOSUB Leg_motor_mode1
    SPEED 15
    GOSUB 기본자세


    SPEED 15
    MOVE G6D,100, 125,  62, 132, 100, 100
    MOVE G6A,100, 125,  62, 132, 100, 100
    MOVE G6B,105, 150, 140
    MOVE G6C,105, 150, 140
    WAIT

    SPEED 7
    MOVE G6D,83 , 108,  85, 125, 105, 100
    MOVE G6A,108, 125,  62, 132, 110, 100
    MOVE G6B,105, 155, 145
    MOVE G6C,105, 155, 145
    WAIT


    SPEED 10
    MOVE G6D,89,  125,  62, 130, 110, 100
    MOVE G6A,110, 125,  62, 130, 122, 100
    WAIT
    SPEED 8
    MOVE G6D, 89, 125,  62, 130, 150, 100
    MOVE G6A,106, 125,  62, 130, 150, 100
    MOVE G6B,105, 167, 190
    MOVE G6C,105, 167, 190
    WAIT

    SPEED 6
    MOVE G6D,120, 125,  62, 130, 170, 100
    MOVE G6A,104, 125,  62, 130, 170, 100
    WAIT

    SPEED 12
    MOVE G6D,120, 125,  62, 130, 183, 100
    MOVE G6A,110, 125,  62, 130, 185, 100
    WAIT

    DELAY 400

    SPEED 14
    MOVE G6D,120, 125,  62, 130, 168, 100
    MOVE G6A,120, 125  62, 130, 185, 100
    MOVE G6B,105, 120, 145
    MOVE G6C,105, 120, 145
    WAIT

    SPEED 12
    MOVE G6D,105, 125,  62, 130, 183, 100
    MOVE G6A, 86, 112,  73, 127, 100, 100
    MOVE G6B,105, 120, 135
    MOVE G6C,105, 120, 135
    WAIT

    SPEED 8
    MOVE G6D,107, 125,  62, 132, 113, 100
    MOVE G6A, 82, 110,  90, 120,  100, 100
    MOVE G6B,105, 50, 80
    MOVE G6C,105, 50, 80
    WAIT

    SPEED 6
    MOVE G6A,97, 125,  62, 132, 102, 100
    MOVE G6D,97, 125,  62, 132, 102, 100
    MOVE G6B,100, 50, 80
    MOVE G6C,100, 50, 80
    WAIT

    SPEED 10
    GOSUB 기본자세
    RETURN
    '**********************************************
    '**********************************************
오른쪽덤블링:
    GOSUB Leg_motor_mode1
    SPEED 15
    GOSUB 기본자세


    SPEED 15
    MOVE G6A,100, 125,  62, 132, 100, 100
    MOVE G6D,100, 125,  62, 132, 100, 100
    MOVE G6B,105, 150, 140
    MOVE G6C,105, 150, 140
    WAIT

    SPEED 7
    MOVE G6A,83 , 108,  85, 125, 105, 100
    MOVE G6D,108, 125,  62, 132, 110, 100
    MOVE G6B,105, 155, 145
    MOVE G6C,105, 155, 145
    WAIT


    SPEED 10
    MOVE G6A,89,  125,  62, 130, 110, 100
    MOVE G6D,110, 125,  62, 130, 122, 100
    WAIT
    SPEED 8
    MOVE G6A, 89, 125,  62, 130, 150, 100
    MOVE G6D,106, 125,  62, 130, 150, 100
    MOVE G6B,105, 167, 190
    MOVE G6C,105, 167, 190
    WAIT

    SPEED 6
    MOVE G6A,120, 125,  62, 130, 170, 100
    MOVE G6D,104, 125,  62, 130, 170, 100
    WAIT

    SPEED 12
    MOVE G6A,120, 125,  62, 130, 183, 100
    MOVE G6D,110, 125,  62, 130, 185, 100
    WAIT

    DELAY 400

    SPEED 14
    MOVE G6A,120, 125,  60, 130, 168, 100
    MOVE G6D,120, 125  60, 130, 185, 100
    MOVE G6B,105, 120, 145
    MOVE G6C,105, 120, 145
    WAIT

    SPEED 12
    MOVE G6A,105, 125,  62, 130, 183, 100
    MOVE G6D, 86, 112,  73, 127, 100, 100
    MOVE G6B,105, 120, 135
    MOVE G6C,105, 120, 135
    WAIT

    SPEED 8
    MOVE G6A,107, 125,  62, 132, 113, 100
    MOVE G6D, 82, 110,  90, 120,  100, 100
    MOVE G6B,105, 50, 80
    MOVE G6C,105, 50, 80
    WAIT

    SPEED 6
    MOVE G6A,97, 125,  62, 132, 102, 100
    MOVE G6D,97, 125,  62, 132, 102, 100
    MOVE G6B,100, 50, 80
    MOVE G6C,100, 50, 80
    WAIT

    SPEED 10
    GOSUB 기본자세
    RETURN
    '**********************************************
    '**********************************************
왼발로앉고일어서기:

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A,112,  77, 146,  93,  92' 60	
    MOVE G6D, 80,  71, 152,  91, 112', 60
    MOVE G6C,100,  100,  100, , , ,
    MOVE G6B,100,  100,  100, , , ,	
    WAIT


    SPEED 8
    MOVE G6A,113,  77, 146,  93,  92, 100	
    MOVE G6D,80,  150,  27, 143, 114, 100
    MOVE G6C,100,  100,  100, , , ,
    MOVE G6B,100,  100,  100, , , ,	
    WAIT

    DELAY 500


    SPEED 8
    MOVE G6A,113, 152,  27, 140, 92, 100
    MOVE G6D,85, 154,  27, 143, 114, 100,
    MOVE G6C,100,  100,  100
    MOVE G6B,100,  100,  100
    WAIT

    GOSUB Leg_motor_mode1
    DELAY 1000

    SPEED 3
    MOVE G6A,115, 152,  35, 140, 92, 100
    WAIT

    SPEED 8
    MOVE G6A,113,  77, 146,  93, 92, 100
    WAIT

    GOSUB Leg_motor_mode2
    DELAY 500

    MOVE G6A,112,  77, 146,  93,  92, 100		
    MOVE G6D, 80, 88, 125, 100, 115, 100
    MOVE G6B,100,  100,  100, , , ,
    MOVE G6C,100,  100,  100, , , ,
    WAIT


    SPEED 4
    GOSUB 기본자세
    GOSUB Leg_motor_mode1

    RETURN
    '******************************************	
오른발로앉고일어서기:

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
    MOVE G6C,100,  100,  100, , , ,
    MOVE G6B,100,  100,  100, , , ,	
    WAIT

    DELAY 500

    SPEED 8
    MOVE G6D,113, 152,  27, 140, 92, 100
    MOVE G6A,85, 154,  27, 140, 114, 100,
    MOVE G6C,100,  100,  100
    MOVE G6B,100,  100,  100
    WAIT

    GOSUB Leg_motor_mode1
    DELAY 1000

    SPEED 3
    MOVE G6D,115, 152,  35, 140, 92, 100
    WAIT

    SPEED 8
    MOVE G6D,113,  77, 146,  93, 92, 100
    WAIT

    GOSUB Leg_motor_mode2
    DELAY 500


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
    '********************************************	
물구나무서기:
    GOSUB 앞으로눕기
    GOSUB Arm_motor_mode1
    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6B, 115,  45,  70,  ,  ,  ,
    MOVE G6C,115,  45,  70,  ,  ,  ,
    WAIT

    MOVE G6A,100, 125,  65,  10, 100
    MOVE G6D,100, 125,  65,  10, 100
    MOVE G6B, 130,  45,  70,  ,  ,  ,
    MOVE G6C,130,  45,  70,  ,  ,  ,
    WAIT

    SPEED 6
    MOVE G6A,100,  89, 129,  57, 100,
    MOVE G6D, 100,  89, 129,  57, 100
    MOVE G6B, 180,  45,  70,  ,  ,  ,
    MOVE G6C, 180,  45,  70,  ,  ,  ,
    WAIT

    MOVE G6A,100,  64, 169,  60, 100,
    MOVE G6D, 100,  64, 169,  60, 100
    MOVE G6B, 190,  45,  70,  ,  ,  ,
    MOVE G6C, 190,  45,  70,  ,  ,  ,
    WAIT
    DELAY 500

    SPEED 12

    FOR i = 1 TO 4

        MOVE G6A,100, 141,  30, 120, 100
        MOVE G6D, 100,  64, 169,  60, 100
        WAIT

        MOVE G6D,100, 141,  30, 120, 100
        MOVE G6A, 100,  64, 169,  60, 100
        WAIT

    NEXT i

    MOVE G6A,100,  64, 169,  60, 100,
    MOVE G6D, 100,  64, 169,  60, 100
    MOVE G6B, 190,  45,  70,  ,  ,  ,
    MOVE G6C, 190,  45,  70,  ,  ,  ,
    WAIT

    DELAY 300

    SPEED 4
    FOR i = 1 TO 3


        MOVE G6A,70,  64, 169,  60, 130,
        MOVE G6D, 70,  64, 169,  60, 130
        WAIT

        MOVE G6A,100,  64, 169,  60, 100,
        MOVE G6D, 100,  64, 169,  60, 100
        WAIT
    NEXT i

    DELAY 300	
    SPEED 10
    MOVE G6A,100,  89, 129,  65, 100,
    MOVE G6D,100,  89, 129,  65, 100
    MOVE G6B, 180,  45,  70,  ,  ,  ,
    MOVE G6C, 180,  45,  70,  ,  ,  ,
    WAIT

    SPEED 10
    MOVE G6A,100, 125,  65,  10, 100,
    MOVE G6D, 100, 125,  65,  10, 100
    MOVE G6B, 160,  45,  70,  ,  ,  ,
    MOVE G6C, 160,  45,  70,  ,  ,  ,
    WAIT

    SPEED 10
    MOVE G6A,100, 125,  65,  10, 100,
    MOVE G6D, 100, 125,  65,  10, 100
    MOVE G6B, 110,  45,  70,  ,  ,  ,
    MOVE G6C, 110,  45,  70,  ,  ,  ,
    WAIT
    SPEED 10
    GOSUB 기본자세

    GOSUB 뒤로일어나기

    RETURN
    '**********************************************	
복고댄스:

    DIM w1 AS BYTE
    GOSUB Leg_motor_mode2
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80
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
    MOVE G6A,94,  94, 145,  45, 106
    MOVE G6D,94,  94, 145,  45, 106
    WAIT	

    HIGHSPEED SETON


    FOR I= 1 TO 3
        SPEED 6
        FOR w1= 0 TO 2

            MOVE G6B,100,  150,  140,
            MOVE G6C,100,  100,  190,
            MOVE G6A, 95,  94, 145,  45, 107,
            MOVE G6D, 89,  94, 145,  45, 113,
            WAIT

            MOVE G6C,100,  150,  140,
            MOVE G6B,100,  100,  190,
            MOVE G6D, 95,  94, 145,  45, 107,
            MOVE G6A, 89,  94, 145,  45, 113,
            WAIT

        NEXT w1

        SPEED 12
        MOVE G6C,100,  100,  190,
        MOVE G6B,100,  75,  100,
        MOVE G6A, 95,  94, 145,  45, 107,
        MOVE G6D, 89,  94, 145,  45, 113,
        WAIT

        SPEED 12
        MOVE G6C,100,  150,  140,
        MOVE G6B,100,  100,  100,
        MOVE G6D, 95,  94, 145,  45, 107,
        MOVE G6A, 89,  94, 145,  45, 113,
        WAIT

        DELAY 200
        SPEED 6
        FOR w1= 0 TO 2


            MOVE G6B,100,  150,  140,
            MOVE G6C,100,  100,  190,
            MOVE G6A, 95,  94, 145,  45, 107,
            MOVE G6D, 89,  94, 145,  45, 113,
            WAIT

            MOVE G6C,100,  150,  140,
            MOVE G6B,100,  100,  190,
            MOVE G6D, 95,  94, 145,  45, 107,
            MOVE G6A, 89,  94, 145,  45, 113,
            WAIT

        NEXT w1

        SPEED 15
        MOVE G6B,100,  100,  190,
        MOVE G6C,100,  75,  100,
        MOVE G6D, 89,  94, 145,  45, 113,
        MOVE G6A, 95,  94, 145,  45, 107,
        WAIT

        SPEED 12
        MOVE G6B,100,  150,  140,
        MOVE G6C,100,  100,  100,
        MOVE G6D, 95,  94, 145,  45, 107,
        MOVE G6A, 89,  94, 145,  45, 113,
        WAIT

        DELAY 100
    NEXT I
    HIGHSPEED SETOFF

    GOSUB Arm_motor_mode3	
    GOSUB Leg_motor_mode1
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 98, 100
    MOVE G6D,100,  76, 145,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    SPEED 5
    DELAY 50
    GOSUB 기본자세


    RETURN

    '************************************************

    '******************************************	


비상:

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
    MOVE G6A, 90,  98, 105,  64, 115,  100
    MOVE G6D,114,  42, 170, 160,  93,  100
    MOVE G6B,100, 160, 180
    MOVE G6C,100, 160, 180
    WAIT

    SPEED 10
    MOVE G6A, 90, 117,  41, 113, 115,  60
    MOVE G6D,114,  33, 176, 160,  93,  60
    MOVE G6B,100, 160, 180
    MOVE G6C,100, 160, 180
    WAIT


    FOR i = 0 TO 2
        SPEED 7
        MOVE G6A, 90, 117,  41, 113, 115,  100
        MOVE G6D,114,  33, 176, 160,  93,  100
        MOVE G6B,100, 180, 130, , ,  70
        MOVE G6C,100, 180, 130, , ,
        WAIT
        SPEED 15
        MOVE G6A, 90,  63, 165,  47, 115,  100
        MOVE G6D,114,  43, 176, 160,  93,  100
        MOVE G6B,100,  70,  50, , ,
        MOVE G6C,100,  70,  50, , ,
        WAIT
    NEXT i

    FOR i = 0 TO 3
        SPEED 6
        MOVE G6A, 90,  74, 176,  32, 115,  100
        MOVE G6D,114,  39, 176, 160,  93,  100
        MOVE G6B,170, 169, 117, , , 130
        MOVE G6C,170, 169, 117, , ,
        WAIT

        SPEED 15
        HIGHSPEED SETON
        MOVE G6A, 90,  36, 154,  32, 115,  100
        MOVE G6D,114,  39, 176, 160,  93,  100
        MOVE G6B,170,  40,  70, , ,
        MOVE G6C,170,  40,  70, , ,
        WAIT
        DELAY 100
        HIGHSPEED SETOFF
    NEXT i
    '****************

    SPEED 1
    HIGHSPEED SETON
    FOR i = 1 TO 15
        SPEED i
        MOVE G6B,170,  80,  80
        MOVE G6C,170,  80,  80
        WAIT

        MOVE G6B,170,  120,  120
        MOVE G6C,170,  120,  120
        WAIT
    NEXT i
    DELAY 100
    HIGHSPEED SETOFF
    DELAY 500
    '****************
    SPEED 6
    MOVE G6A, 90,  98, 105,  64, 115,  100
    MOVE G6D,114,  39, 170, 160,  93,  100
    MOVE G6B,100, 160, 180
    MOVE G6C,100, 160, 180
    WAIT


    MOVE G6A, 90, 121,  36, 105, 115,  100
    MOVE G6D,114,  60, 146, 138,  93,  100
    MOVE G6B,100,  150,  150
    MOVE G6C,100,  150,  150
    WAIT

    SPEED 4
    MOVE G6A, 85,  98, 105,  115, 115, 100
    MOVE G6D,115,  74, 145,  98,  93, 100
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
    '******************************************
    '******************************************
비행:

    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6D, 88,  71, 152,  91, 110, 100
    MOVE G6A,112,  76, 146,  93,  92, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT


    SPEED 10
    MOVE G6D, 90,  98, 105,  115, 115, 100
    MOVE G6A,114,  74, 145,  98,  93, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT

    SPEED 6
    MOVE G6D, 90, 121,  36, 105, 115,  100
    MOVE G6A,114,  60, 146, 138,  93,  100
    MOVE G6B,130,  100,  100
    MOVE G6C,130,  100,  100
    WAIT

    SPEED 6
    GOSUB Leg_motor_mode2
    MOVE G6D, 90,  98, 145,  54, 115,  100
    MOVE G6A,114,  45, 170, 160,  93,  100
    MOVE G6B,170, 100, 100
    MOVE G6C,170, 100, 100
    WAIT

    GOSUB Leg_motor_mode4
    '****************
    FOR I = 0 TO 3
        SPEED 6
        MOVE G6D, 90,  98, 145,  54, 115,  100
        MOVE G6A,114,  45, 170, 160,  93,  100
        MOVE G6B,170, 150, 140
        MOVE G6C,170, 50, 70
        WAIT

        SPEED 6
        MOVE G6D, 90,  98, 145,  54, 115,  100
        MOVE G6A,114,  45, 170, 160,  93,  100
        MOVE G6C,170, 150, 140
        MOVE G6B,170, 50, 70
        WAIT

    NEXT I
    DELAY 300

    SPEED 10
    MOVE G6D, 90,  98, 145,  54, 115,  100
    MOVE G6A,114,  45, 170, 160,  93,  100
    MOVE G6B,170, 100, 100
    MOVE G6C,170, 100, 100
    WAIT

    '****************
    SPEED 5
    MOVE G6D, 90,  98, 105,  64, 115,  100
    MOVE G6A,114,  45, 170, 160,  93,  100
    MOVE G6B,170, 100, 100
    MOVE G6C,170, 100, 100
    WAIT
    GOSUB Leg_motor_mode2

    SPEED 5
    MOVE G6D, 90, 121,  36, 105, 115,  100
    MOVE G6A,113,  64, 146, 138,  93,  100
    MOVE G6B,140,  100,  100
    MOVE G6C,140,  100,  100
    WAIT

    SPEED 4
    MOVE G6D, 85,  98, 105,  115, 115, 100
    MOVE G6A,113,  74, 145,  98,  93, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT

    SPEED 8
    MOVE G6D, 85,  71, 152,  91, 110, 100
    MOVE G6A,108,  76, 146,  93,  92, 100
    MOVE G6B,100,  70,  80
    MOVE G6C,100,  70,  80
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  80
    MOVE G6C,100,  35,  80
    WAIT

    SPEED 2
    GOSUB 기본자세	
    GOSUB All_motor_Reset
    RETURN
    '******************************************
    '************************************************
앞뒤기울기측정:
    '  IF 기울기센서측정여부 = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN GOSUB 기울기앞
    IF A > MAX THEN GOSUB 기울기뒤

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN  GOSUB 뒤로일어나기
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN GOSUB 앞으로일어나기
    RETURN
    '**************************************************
좌우기울기측정:
    '  IF 기울기센서측정여부 = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
        RETURN

    ENDIF
    RETURN
    '**************************************************
    '**************************************************
오른발공차기:
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
    HIGHSPEED SETON

    SPEED 15
    MOVE G6A,113,  73, 145,  85,  95	
    MOVE G6D, 83,  20, 172,  155, 114
    MOVE G6C,50
    MOVE G6B,150
    WAIT


    DELAY 400
    HIGHSPEED SETOFF


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
    DELAY 400

    RETURN


    '******************************************
왼발공차기:

    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6D,110,  77, 145,  93,  92, 100	
    MOVE G6A, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    SPEED 10
    MOVE G6D,113,  75, 145,  100,  95	
    MOVE G6A, 83,  85, 122,  105, 114
    WAIT

    GOSUB Leg_motor_mode2
    HIGHSPEED SETON

    SPEED 15
    MOVE G6D,113,  73, 145,  85,  95	
    MOVE G6A, 83,  20, 172,  155, 114
    MOVE G6B,50
    MOVE G6C,150
    WAIT


    DELAY 400
    HIGHSPEED SETOFF


    SPEED 10
    MOVE G6D,112,  72, 145,  97,  95
    MOVE G6A, 83,  58, 122,  130, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,	
    WAIT	

    SPEED 8
    MOVE G6D,113,  77, 145,  95,  95	
    MOVE G6A, 80,  80, 142,  95, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT	

    SPEED 8
    MOVE G6D,110,  77, 145,  93,  93, 100	
    MOVE G6A, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    DELAY 400

    RETURN

    '******************************************
    '**************************************
LED_ON_OFF2:

    OUT 52,1
    DELAY 150

    OUT 52,0
    DELAY 150
    RETURN
    '**************************************
LED_ON_OFF:

    OUT 52,1
    DELAY 150
    OUT 52,0
    DELAY 150

    OUT 52,1
    DELAY 150
    OUT 52,0
    DELAY 150
    RETURN
    '**************************************
    '**************************************
샹송백댄서2:

    GOSUB All_motor_mode3

    GOSUB LED_ON_OFF2

    '오른쪽기울기2:
    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80, 100, 100, 100
    MOVE G6C,100,  40,  80, 100, 100, 100
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  90, 100, 100, 100
    MOVE G6C,100,  40,  90, 100, 100, 100
    WAIT


    SPEED 5
    MOVE G6A, 80,  74, 146, 94, 116, 100
    MOVE G6D,108,  81, 137,  98, 98, 100
    MOVE G6B,100,  70,  90, 100, 100, 100
    MOVE G6C,100,  70,  90, 100, 100, 100 	
    WAIT

    SPEED 4
    MOVE G6A,98,  76, 145,  93, 103, 100
    MOVE G6D,98,  76, 145,  93, 103, 100
    MOVE G6B,100,  100,  100, 100, 100, 100
    MOVE G6C,100,  100,  100, 100, 100, 100
    WAIT	


    GOSUB LED_ON_OFF2
    '**** 노래시작자세******
    SPEED 3
    MOVE G6A,98,  76, 145,  93, 103, 100
    MOVE G6D,98,  76, 145,  93, 103, 100
    WAIT

    '**********************************
    FOR i = 0 TO 3
        SPEED 4
        MOVE G6A,108,  92, 119,  106, 99
        MOVE G6D,86,  76, 145,  94, 107
        WAIT

        SPEED 4
        MOVE G6A,102,  78, 139,  98, 84
        MOVE G6D,92,  90, 115,  110, 122
        WAIT

        SPEED 4
        MOVE G6D,108,  92, 119,  106, 99
        MOVE G6A,86,  76, 145,  94, 107
        WAIT

        SPEED 4
        MOVE G6D,102,  78, 139,  98, 84
        MOVE G6A,92,  90, 115,  110, 122
        WAIT

    NEXT i

    SPEED 3
    MOVE G6A,108,  92, 119,  106, 99
    MOVE G6D,86,  76, 145,  94, 107
    MOVE G6B,, , , , ,80
    WAIT

    GOSUB Leg_motor_mode1
    SPEED 4
    MOVE G6A,98,  76, 145,  93, 98, 100
    MOVE G6D,98,  76, 145,  93, 98, 100
    MOVE G6B,100,  100,  100, 100, 100, 100
    MOVE G6C,100,  100,  100, 100, 100, 100
    WAIT



    SPEED 6
    GOSUB 기본자세

    GOSUB All_motor_Reset


    RETURN
    '******************************************
좌우뒤들기댄스:

    GOSUB All_motor_Reset

    SPEED 8
    MOVE G6A,88,  76, 145,  93, 110
    MOVE G6D,88,  76, 145,  93, 110
    MOVE G6B,100,  40,  90
    MOVE G6C,100,  40,  90
    WAIT

    DELAY 500
    HIGHSPEED SETON

    SPEED 8	
    MOVE G6B,100,  100,  120
    MOVE G6C,100,  50,  90
    WAIT

    SPEED 15
    MOVE G6B,100,  150,  180
    MOVE G6C,100,  60,  100
    WAIT
    DELAY 400

    HIGHSPEED SETOFF
    GOSUB Arm_motor_mode3
    SPEED 6
    MOVE G6B,100,  150,  150
    MOVE G6C,100,  150,  150
    WAIT

    HIGHSPEED SETON
    GOSUB Arm_motor_mode1
    SPEED 8
    MOVE G6C,100,  150,  100
    MOVE G6B,100,  100,  100
    WAIT
    DELAY 300

    SPEED 15
    MOVE G6C,100,  150,  150
    MOVE G6B,100,  50,  100
    WAIT
    DELAY 300
    HIGHSPEED SETOFF

    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode4

    FOR I = 2 TO 5
        TEMP = I * 3
        SPEED TEMP
        MOVE G6A,  99,  96, 111, 107,  82,
        MOVE G6D,  72,  89, 120, 103, 142,
        MOVE G6B, 170,  70,  50,  ,  ,
        MOVE G6C,  100, 140, 150,  ,  ,
        WAIT

        MOVE G6D,  99,  96, 111, 107,  82,
        MOVE G6A,  72,  89, 120, 103, 142,
        MOVE G6C, 170,  70,  50,  ,  ,
        MOVE G6B,  100, 140, 150,  ,  ,
        WAIT
    NEXT I

    HIGHSPEED SETON
    FOR I = 2 TO 4
        TEMP = I * 3
        SPEED TEMP
        MOVE G6A,  99,  96, 111, 107,  82,
        MOVE G6D,  72,  89, 120, 103, 142,
        MOVE G6B, 170,  70,  50,  ,  ,
        MOVE G6C,  100, 140, 150,  ,  ,
        WAIT

        MOVE G6D,  99,  96, 111, 107,  82,
        MOVE G6A,  72,  89, 120, 103, 142,
        MOVE G6C, 170,  70,  50,  ,  ,
        MOVE G6B,  100, 140, 150,  ,  ,
        WAIT
    NEXT I

    HIGHSPEED SETOFF

    DELAY 300
    GOSUB Leg_motor_mode1
    SPEED 15
    MOVE G6A,98,  76, 145,  93, 98, 100
    MOVE G6D,98,  76, 145,  93, 98, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    GOSUB 기본자세


    RETURN
    '**********************************************
    '******************************************
아리랑댄스:

    GOSUB All_motor_Reset

    HIGHSPEED SETON
    SPEED 8
    MOVE G6A,88,  76, 145,  93, 110
    MOVE G6D,88,  76, 145,  93, 110
    MOVE G6B,100,  100, 100
    MOVE G6C,100,  100,  100
    WAIT

    DELAY 300



    HIGHSPEED SETOFF

    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode4

    FOR I = 1 TO 8
        SPEED 10
        MOVE G6A,  99,  96, 111, 107,  82,
        MOVE G6D,  72,  89, 120, 103, 142,
        MOVE G6B,100,  170, 150
        MOVE G6C,100,  70,  70
        WAIT

        SPEED 10
        MOVE G6A,  87,  92, 115, 105,  112,
        MOVE G6D,  87,  92, 115, 105, 112,
        MOVE G6B,100,  80, 180
        MOVE G6C,100,  120,  20
        WAIT

        '***************************
        SPEED 10
        MOVE G6D,  99,  96, 111, 107,  82,
        MOVE G6A,  72,  89, 120, 103, 142,
        MOVE G6C,100,  170, 150
        MOVE G6B,100,  70,  70
        WAIT

        SPEED 10
        MOVE G6A,  87,  92, 115, 105,  112,
        MOVE G6D,  87,  92, 115, 105, 112,
        MOVE G6C,100,  80, 180
        MOVE G6B,100,  120,  20
        WAIT
    NEXT I

    SPEED 15
    MOVE G6A,  87,  92, 115, 105,  112,
    MOVE G6D,  87,  92, 115, 105, 112,
    MOVE G6C,100,  80, 90
    MOVE G6B,100,  80,  90
    WAIT

    DELAY 300
    GOSUB Leg_motor_mode1
    SPEED 15
    MOVE G6A,98,  76, 145,  93, 98, 100
    MOVE G6D,98,  76, 145,  93, 98, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    GOSUB 기본자세


    RETURN
    '**********************************************
날개짓하며일어나기:
    GOSUB All_motor_mode3

    SPEED 10
    MOVE G6A,100, 140,  37, 140, 100, 100
    MOVE G6D,100, 140,  37, 140, 100, 100
    WAIT

    SPEED 3
    GOSUB 앉은자세

    HIGHSPEED SETON
    FOR i = 1 TO 2
        SPEED 6
        MOVE G6B,100,  150,  115
        MOVE G6C,100,  150,  115
        WAIT   	

        SPEED 8
        MOVE G6B,100,  40,  80
        MOVE G6C,100,  40,  80
        WAIT
    NEXT i
    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6B,100,  150,  115
    MOVE G6C,100,  150,  115
    WAIT

    SPEED 6
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    MOVE G6A,100, 133,  50, 132, 100, 100
    MOVE G6D,100, 133,  50, 132, 100, 100
    WAIT

    SPEED 10
    MOVE G6B,100,  150,  115
    MOVE G6C,100,  150,  115
    WAIT


    SPEED 6
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    MOVE G6A,100, 120,  80, 112, 100, 100
    MOVE G6D,100, 120,  80, 112, 100, 100
    WAIT

    SPEED 10
    MOVE G6B,100,  150,  115
    MOVE G6C,100,  150,  115
    WAIT

    SPEED 6
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    MOVE G6A,100, 88,  125, 100, 100, 100
    MOVE G6D,100, 88,  125, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6B,100,  150,  115
    MOVE G6C,100,  150,  115
    WAIT

    SPEED 6
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    MOVE G6A,100, 76,  145, 93, 100, 100
    MOVE G6D,100, 76,  145, 93, 100, 100
    WAIT

    FOR i = 1 TO 3
        SPEED 10
        MOVE G6B,100,  150,  115
        MOVE G6C,100,  150,  115
        WAIT

        SPEED 10
        MOVE G6B,100,  40,  80
        MOVE G6C,100,  40,  80
        WAIT
    NEXT i

    HIGHSPEED SETOFF
    SPEED 5
    GOSUB 기본자세
    GOSUB All_motor_Reset       	
    RETURN


    '**********************************************

샹송댄스:

    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80, 100, 100, 100
    MOVE G6C,160,  30,  80, 100, 100, 100
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,110,  76, 145,  93, 98, 100
    MOVE G6B,100,  40,  90, , , 55
    MOVE G6C,185,  15,  15	
    WAIT


    SPEED 4
    MOVE G6A, 80,  74, 145, 94, 116, 100
    MOVE G6D,108,  81, 135,  98, 98, 100
    MOVE G6B,100,  40,  90, , , 55
    MOVE G6C,185,  15,  15	
    WAIT

    SPEED 6
    MOVE G6A,98,  76, 145,  93, 103, 100
    MOVE G6D,98,  76, 145,  93, 103, 100
    MOVE G6B,100,  40,  90, , , 100
    MOVE G6C,185,  30,  10	
    WAIT	

    '**** 노래시작자세******
    SPEED 5
    MOVE G6A,98,  79, 145,  83, 103, 100
    MOVE G6D,98,  79, 145,  83, 103, 100
    MOVE G6B,100, 50, 90, , , 100
    MOVE G6C,185,  30,  10	
    WAIT
    '**** 노래시작자세******

    SPEED 4
    FOR I = 0 TO 1

        MOVE G6B,100,  80,  90, , , 80
        MOVE G6C,180,  30,  10	
        WAIT	

        MOVE G6B,100,  60,  90, , , 120
        MOVE G6C,185,  35,  10	
        WAIT	

    NEXT I


    SPEED 4
    MOVE G6A,95, 100, 145,  53, 105, 100
    MOVE G6D,95,  60, 145,  93, 105, 100
    MOVE G6B,100, 40, 90, , , 145
    WAIT

    SPEED 5
    FOR I = 0 TO 1

        MOVE G6B,100,  120,  120, , , 80
        MOVE G6C,180,  30,  10	
        WAIT	

        MOVE G6B,100,  80,  90, , , 120
        MOVE G6C,185,  35,  10	
        WAIT	

    NEXT I

    SPEED 4
    MOVE G6A,98,  79, 145,  83, 103, 100
    MOVE G6D,98,  79, 145,  83, 103, 100
    MOVE G6B,100, 40, 90, , ,100
    WAIT


    SPEED 4
    MOVE G6D,95, 100, 145,  53, 105, 100
    MOVE G6A,95,  60, 145,  93, 105, 100
    MOVE G6B,, , , , , 55
    WAIT


    SPEED 4
    FOR I = 0 TO 1

        MOVE G6B,120, 60, 90, , ,80
        WAIT
        MOVE G6B,80, 40, 90, , , 120
        WAIT

    NEXT I

    SPEED 4
    MOVE G6A,98,  79, 145,  83, 103, 100
    MOVE G6D,98,  79, 145,  83, 103, 100
    MOVE G6B,100, 50, 70, , , 100
    MOVE G6C,185,  40,  10	
    WAIT

    '******************************************

    '***좌우음악심취1*****
    SPEED 3
    MOVE G6A,108,  95, 119,  96, 99
    MOVE G6D,86,  82, 145,  83, 107
    MOVE G6B,80, 50, 80, , , 70
    MOVE G6C,185,  20,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,100, 120, 110, , , 60
    MOVE G6C,175,  40,  10	
    WAIT


    SPEED 3
    MOVE G6D,108,  95, 119,  96, 99
    MOVE G6A,86,  82, 145,  83, 107
    MOVE G6B,100, 130, 120, , , 70
    MOVE G6C,185,  40,  10	
    WAIT

    SPEED 4
    MOVE G6D,112,  82, 139,  86, 84
    MOVE G6A,80,  79, 145,  83, 122
    MOVE G6B,120, 50, 70, , , 100
    MOVE G6C,185,  30,  10	
    WAIT


    '***좌우음악심취2-1*****
    SPEED 4
    MOVE G6A,108,  78, 119,  136, 99
    MOVE G6D,86,  65, 145,  123, 107
    MOVE G6B,120, 40, 80, , , 110
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,120, 20, 80, , , 120
    MOVE G6C,175,  40,  10	
    WAIT

    SPEED 4
    MOVE G6A,108,  78, 119,  136, 99
    MOVE G6D,86,  65, 145,  123, 107
    MOVE G6B,120, 40, 80, , , 90
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,120, 20, 80, , , 70
    MOVE G6C,190,  20,  10	
    WAIT

    '***좌우음악심취2*****
    SPEED 4
    MOVE G6A,108,  95, 119,  96, 99
    MOVE G6D,86,  82, 145,  83, 107
    MOVE G6B,100, 40, 90, , , 80
    MOVE G6C,185,  20,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,100, 80, 95, , , 70
    MOVE G6C,175,  40,  10	
    WAIT

    SPEED 3
    MOVE G6D,108,  95, 119,  96, 99
    MOVE G6A,86,  82, 145,  83, 107
    MOVE G6B,70, 130, 120, , , 110
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6D,108,  86, 139,  76, 90
    MOVE G6A,85,  83, 145,  73, 122
    MOVE G6B,150, 40, 70, , , 120
    MOVE G6C,190,  30,  10	
    WAIT


    SPEED 5
    FOR I = 0 TO 2
        MOVE G6B,150, 40, 70, , , 110
        MOVE G6C,190,  20,  10	
        WAIT
        MOVE G6B,150, 40, 70, , , 90
        MOVE G6C,185,  30,  10	
        WAIT
    NEXT I

    '***좌우음악심취3*****
    SPEED 4
    MOVE G6A,108,  78, 119,  136, 99
    MOVE G6D,86,  65, 145,  123, 107
    MOVE G6B,120, 40, 80, , , 110
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,190, 20, 80, , , 120
    MOVE G6C,175,  40,  10	
    WAIT

    SPEED 4
    MOVE G6D,105,  102, 119,  76, 99
    MOVE G6A,87,  89, 145,  63, 107
    MOVE G6B,80, 150, 120, , , 50
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6D,100,  82, 139,  91, 84
    MOVE G6A,95,  104, 105,  102, 122
    MOVE G6B,150, 100, 90, , , 60
    MOVE G6C,185,  20,  10	
    WAIT

    SPEED 4
    FOR I = 0 TO 2
        MOVE G6B,150, 100, 90, , ,70
        MOVE G6C,190,  20,  10	
        WAIT
        MOVE G6B,190, 100, 90, , ,90
        MOVE G6C,185,  30,  10	
        WAIT
    NEXT I

    '************
    SPEED 3
    MOVE G6D,100,  72, 139,  101, 84
    MOVE G6A,95,  114, 105,  92, 122
    MOVE G6B,150, 100, 90, , , 120
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,100,  72, 139,  101, 84
    MOVE G6D,95,  114, 105,  92, 122
    MOVE G6B,150, 100, 90, , , 60
    MOVE G6C,185,  30,  10	
    WAIT
    '****************
    SPEED 3
    MOVE G6D,100,  72, 139,  101, 84
    MOVE G6A,95,  114, 105,  92, 122
    MOVE G6B,150, 70, 80, , , 90
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,100,  72, 139,  101, 84
    MOVE G6D,95,  114, 105,  92, 122
    MOVE G6B,120, 130, 120, , , 60
    MOVE G6C,185,  30,  10	
    WAIT
    '************
    SPEED 3
    MOVE G6A,98,  87, 145,  63, 103, 100
    MOVE G6D,98,  87, 145,  63, 103, 100
    MOVE G6B,60, 180, 110, , , 100
    MOVE G6C,190,  30,  10	
    WAIT
    GOSUB LED_ON_OFF2
    SPEED 5
    FOR I = 0 TO 3
        MOVE G6B,, , , , , 95
        MOVE G6C,190,  40,  10	
        WAIT
        MOVE G6B,, , , , , 105
        MOVE G6C,190,  30,  10	
        WAIT    	

    NEXT I	

    '*************************

    DELAY 1000

    SPEED 8
    MOVE G6A,98,  87, 145,  63, 103, 100
    MOVE G6D,98,  87, 145,  63, 103, 100
    MOVE G6B,120,  80,  80
    MOVE G6C,120,  80,  80
    WAIT

    GOSUB Leg_motor_mode1
    SPEED 7
    MOVE G6A,102,  76, 145,  93, 98, 100
    MOVE G6D,102,  76, 145,  93, 98, 100
    WAIT

    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    GOSUB 인사3

    RETURN

    '************************************************

뽕뽕송댄스:

    GOSUB All_motor_mode3


    '**** 노래시작자세로가기******

    SPEED 12
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  92
    MOVE G6B,130,  60,  90
    MOVE G6C,160,  30,  80
    WAIT

    SPEED 12
    MOVE G6A, 85,  80, 140, 95, 114
    MOVE G6D,110,  76, 145,  93, 98
    MOVE G6B,150,  80,  90
    MOVE G6C,185,  15,  15	
    WAIT


    SPEED 12
    MOVE G6A, 80,  74, 145, 94, 116
    MOVE G6D,108,  81, 135,  98, 98
    MOVE G6B,180,  90, 90
    MOVE G6C,185,  15,  15	
    WAIT

    SPEED 6
    MOVE G6A,100,  96, 105,  113, 110
    MOVE G6D,85,  76, 145,  93, 105
    MOVE G6B,180,  90, 90
    MOVE G6C,185,  15,  15	
    WAIT	

    DELAY 300

    FOR i = 1 TO 2

        SPEED 4
        MOVE G6D,100,  96, 105,  113, 110
        MOVE G6A,85,  76, 145,  93, 105
        MOVE G6B,180,  90, 90
        MOVE G6C,185,  15,  15	
        WAIT	


        SPEED 4
        MOVE G6A,100,  96, 105,  113, 110
        MOVE G6D,85,  76, 145,  93, 105
        MOVE G6B,180,  90, 90
        MOVE G6C,185,  15,  15	
        WAIT

    NEXT i

    ' SPEED 6
    '    FOR i = 1 TO 4
    '        MOVE G6B,180,  90, 90
    '        MOVE G6C,175,  20,  13	
    '        WAIT
    '
    '        MOVE G6B,180,  90, 90
    '        MOVE G6C,188,  20,  18	
    '        WAIT   	
    '    NEXT i
    DELAY 300

    SPEED 8
    MOVE G6D,100,  96, 105,  113, 110
    MOVE G6A,85,  76, 145,  93, 105
    MOVE G6C,180,  90, 90
    MOVE G6B,185,  15,  15	
    WAIT	

    FOR i = 1 TO 2

        SPEED 4
        MOVE G6A,100,  96, 105,  113, 110
        MOVE G6D,85,  76, 145,  93, 105
        MOVE G6C,180,  90, 90
        MOVE G6B,185,  15,  15	
        WAIT

        SPEED 4
        MOVE G6D,100,  96, 105,  113, 110
        MOVE G6A,85,  76, 145,  93, 105
        MOVE G6C,180,  90, 90
        MOVE G6B,185,  15,  15	
        WAIT	

    NEXT i

    ' SPEED 6
    '    FOR i = 1 TO 4
    '        MOVE G6C,180,  90, 90
    '        MOVE G6B,175,  20,  13	
    '        WAIT
    '
    '        MOVE G6C,180,  90, 90
    '        MOVE G6B,188,  20,  18	
    '        WAIT   	
    '    NEXT i	 	
    DELAY 300

    SPEED 10
    MOVE G6D,95,  80, 130,  110, 105
    MOVE G6A,95,  80, 130,  110, 105
    MOVE G6C,100,  70, 80
    MOVE G6B,100,  70,  80	
    WAIT		

    GOSUB Leg_motor_mode1
    SPEED 7
    MOVE G6A,102,  76, 145,  93, 98, 100
    MOVE G6D,102,  76, 145,  93, 98, 100
    WAIT

    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN
    '************************************************
덤벼액션:
    GOSUB All_motor_mode3

    SPEED 10
    MOVE G6B,100,  40,  80
    MOVE G6C,180,  30,  80
    WAIT


    SPEED 15
    FOR i = 1 TO 3
        MOVE G6B,80,  40,  90
        MOVE G6C,185,  15,  80	
        WAIT

        MOVE G6B,80,  40,  90
        MOVE G6C,185,  15,  20	
        WAIT
    NEXT i

    SPEED 10
    MOVE G6B,80,  40,  90
    MOVE G6C,185,  25,  90	
    WAIT
    DELAY 400

    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN

    '************************************************

    '************************************************
    '************************************************
    '************************************************
    '************************************************

    '******************************************
매트릭스피하기:
    SPEED 10
    GOSUB 기본자세
    GOSUB All_motor_mode3

    SPEED 8

    MOVE G6A, 100, 163,  75,  15, 100, 100
    MOVE G6D, 100, 163,  75,  15, 100, 100
    MOVE G6B,185, 120, 130, 100, 100, 100
    MOVE G6C,185, 120, 130, 100, 100, 100
    WAIT

    SPEED 2

    MOVE G6A, 100, 168,  70,  10, 100, 100
    MOVE G6D, 100, 168,  70,  10, 100, 100
    MOVE G6B,185, 120, 130
    MOVE G6C,185, 120, 130
    WAIT

    DELAY 1000
    SPEED 10
    FOR I = 1 TO 5

        MOVE G6B,185, 20, 50
        MOVE G6C,185, 20, 50
        WAIT

        MOVE G6B,185, 70, 80
        MOVE G6C,185, 70, 80
        WAIT

    NEXT I

    MOVE G6B,100, 70, 80
    MOVE G6C,100, 70, 80
    WAIT

    SPEED 10
    FOR I = 1 TO 5

        MOVE G6B,100, 90, 90
        MOVE G6C,100, 90, 90
        WAIT

        MOVE G6B,100, 40, 70
        MOVE G6C,100, 40, 70
        WAIT

    NEXT I

    DELAY 500
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A, 100, 145,  70,  80, 100, 100
    MOVE G6D, 100, 145,  70,  80, 100, 100
    MOVE G6B,100, 40, 90, 100, 100, 100
    MOVE G6C,100, 40, 90, 100, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100, 121,  80, 110, 101, 100
    MOVE G6D,100, 121,  80, 110, 101, 100
    MOVE G6B,100,  40,  80, , ,
    MOVE G6C,100,  40,  80, , ,
    WAIT

    SPEED 8
    GOSUB 기본자세
    RETURN
    '******************************************
연속댄스1: '48 sec
    GOSUB SOUND_BGM10
    GOSUB 환호성
    DELAY 500

    GOSUB 오른발로앉고일어서기
    DELAY 500

    GOSUB 왼발로앉고일어서기
    DELAY 500

    GOSUB 샹송백댄서2
    DELAY 500

    GOSUB 복고댄스
    DELAY 500

    GOSUB 인사3
    GOSUB SOUND_STOP
    RETURN


    '******************************************
연속댄스2: '80 sec
    GOSUB SOUND_BGM7
    GOSUB 매트릭스피하기
    DELAY 500

    GOSUB 숨쉬기운동
    DELAY 500

    GOSUB 뽕뽕송댄스
    DELAY 500

    GOSUB 날개짓하며일어나기
    DELAY 500

    GOSUB 비상
    DELAY 500

    GOSUB 좌우뒤들기댄스
    DELAY 500

    GOSUB 인사2
    GOSUB SOUND_STOP
    RETURN
    '******************************************
종합댄스1: ' sec
    GOSUB SOUND_로보링크주제곡

    GOSUB 인사3	

    GOSUB 패배액션2
    DELAY 200

    GOSUB 샹송백댄서2
    DELAY 200

    GOSUB 복고댄스
    DELAY 500

    '*********************
    GOSUB 숨쉬기운동
    DELAY 200

    GOSUB 비행
    DELAY 200

    GOSUB 뽕뽕송댄스
    DELAY 200

    GOSUB 오른발로앉고일어서기
    DELAY 200

    GOSUB 아리랑댄스
    DELAY 200

    GOSUB 날개짓하며일어나기
    DELAY 200

    GOSUB 매트릭스피하기
    DELAY 200

    GOSUB 비상
    DELAY 200

    GOSUB 좌우뒤들기댄스
    DELAY 300

    '  GOSUB 샹송댄스
    '    DELAY 500

    GOSUB 물구나무서기
    DELAY 200

    GOSUB 인사2

    GOSUB SOUND_STOP
    RETURN
    '******************************************
종합댄스2: '46 sec
    GOSUB SOUND_BGM2

    GOSUB 아리랑댄스
    GOSUB 샹송댄스
    GOSUB 비행
    GOSUB SOUND_STOP
    RETURN
    '******************************************
종합댄스3: '
    GOSUB SOUND_BGM5
    GOSUB 샹송댄스
    GOSUB SOUND_STOP

    RETURN
    '******************************************

    '**********************************************
국민체조시작:
    GOSUB SOUND_국민체조곡
    GOSUB 국민체조_1	'시작
    GOSUB 국민체조_2	'다리운동
    GOSUB 국민체조_3	'팔운동
    GOSUB 국민체조_4	'머리운동
    GOSUB 국민체조_5 	'가슴운동
    GOSUB 국민체조_6	'옆꾸리운동
    GOSUB 국민체조_7	'등배운동
    GOSUB 국민체조_8 	'몸통운동

    GOSUB 국민체조_9	'온몸운동
    GOSUB 국민체조_10   '뜀뛰기운동
    GOSUB 국민체조_11   '팔다리운동
    GOSUB 국민체조_12	'숨고르기



    RETURN
    '**********************************************
    '**********************************************

국민체조_1: '시작
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    FOR i = 1 TO 4'7

        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6C,110,  30,  80
        MOVE G6B,110,  30,  80
        WAIT

        MOVE G6D,100,  85, 125,  105, 100, 100
        MOVE G6A,100,  85, 125,  105, 100, 100
        MOVE G6C,90,  30,  80
        MOVE G6B,90,  30,  80
        WAIT


    NEXT i

    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,110,  30,  80
    MOVE G6B,110,  30,  80
    WAIT

    SPEED 4
    FOR i = 1 TO 4

        MOVE G6C,120,  30,  80
        MOVE G6B,80,  30,  80
        WAIT

        MOVE G6C,80,  30,  80
        MOVE G6B,120,  30,  80
        WAIT

    NEXT i

    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    RETURN
    '**********************************************

국민체조_2: '다리운동
    GOSUB All_motor_mode3

    FOR i = 1 TO 4
        SPEED 7
        MOVE G6D,100,  74, 145,  90, 100, 100
        MOVE G6A,100,  74, 145,  90, 100, 100
        MOVE G6C,180,  30,  80
        MOVE G6B,180,  30,  80
        WAIT
        DELAY 100

        SPEED 11
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6C,100,  185,  100
        MOVE G6B,100,  185,  100
        WAIT
        DELAY 100

        SPEED 9
        MOVE G6A,100, 60, 178, 76, 100, 100
        MOVE G6D,100, 60, 178, 76, 100, 100
        MOVE G6C,100,  100,  100
        MOVE G6B,100,  100,  100
        WAIT

        DELAY 100
        SPEED 7
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  30,  80, 100, 100, 100
        MOVE G6C,100,  30,  80, 100, 100, 100
        WAIT
        DELAY 100


    NEXT i


    SPEED 8
    MOVE G6B,130,  30,  80, 100, 100, 100
    MOVE G6C,130,  30,  80, 100, 100, 100
    WAIT

    SPEED 8
    MOVE G6B,130,  15,  60, 100, 100, 100
    MOVE G6C,130,  15,  60, 100, 100, 100
    WAIT

    SPEED 8
    MOVE G6B,130,  15,  60, 100, 100, 100
    MOVE G6C,130,  15,  60, 100, 100, 100
    WAIT

    FOR i = 1 TO 4
        SPEED 8
        MOVE G6A,100,  110, 60,  153, 100, 100
        MOVE G6D,100,  110, 60,  153, 100, 100
        MOVE G6B,150,  20,  80, 100, 100, 100
        MOVE G6C,150,  20,  80, 100, 100, 100
        WAIT

        SPEED 5
        MOVE G6A,100,  122, 40,  160, 100, 100
        MOVE G6D,100,  122, 40,  160, 100, 100
        MOVE G6B,150,  20,  80, 100, 100, 100
        MOVE G6C,150,  20,  80, 100, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  110, 60,  153, 100, 100
        MOVE G6D,100,  110, 60,  153, 100, 100
        MOVE G6B,150,  15,  60, 100, 100, 100
        MOVE G6C,150,  15,  60, 100, 100, 100
        WAIT


        SPEED 5
        MOVE G6A,100,  122, 40,  160, 100, 100
        MOVE G6D,100,  122, 40,  160, 100, 100
        MOVE G6B,150,  20,  80, 100, 100, 100
        MOVE G6C,150,  20,  80, 100, 100, 100
        WAIT
        DELAY 100

        SPEED 10
        MOVE G6A,100,  33, 170,  155, 100, 100
        MOVE G6D,100,  33, 170,  155, 100, 100
        MOVE G6B,170,  15,  60, 100, 100, 100
        MOVE G6C,170,  15,  60, 100, 100, 100
        WAIT
        DELAY 100

        SPEED 8
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  80, 100, 100, 100
        MOVE G6C,100,  40,  80, 100, 100, 100
        WAIT
        DELAY 100

    NEXT i



    RETURN

    '**********************************************

국민체조_3: '팔운동

    FOR i = 1 TO 3
        SPEED 9
        MOVE G6A,100, 60, 173, 76, 100, 100
        MOVE G6D,100, 60, 173, 76, 100, 100
        MOVE G6C,185,  30,  80
        MOVE G6B,185,  30,  80
        WAIT
        DELAY 100

        SPEED 8
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6C,100,  30,  90
        MOVE G6B,100,  30,  90
        WAIT

        DELAY 100

    NEXT i

    FOR i = 1 TO 3
        SPEED 10
        MOVE G6A,100, 63, 173, 76, 100, 100
        MOVE G6D,100, 63, 173, 76, 100, 100
        MOVE G6C,60,  180,  130
        MOVE G6B,60,  180,  130
        WAIT
        DELAY 100

        SPEED 11
        MOVE G6A,100,  76, 145,  90, 100, 100
        MOVE G6D,100,  76, 145,  90, 100, 100
        MOVE G6C,130,  30,  90
        MOVE G6B,130,  30,  90
        WAIT

        DELAY 100

    NEXT i


    RETURN


    '**********************************************

국민체조_4: '머리운동
    GOSUB All_motor_mode3
    SPEED 9
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  40,  80
    MOVE G6B,70,  40,  80
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT

    SPEED 9
    MOVE G6A,94,  68, 125,  155, 105, 100
    MOVE G6D,94,  68, 125,  155, 105, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT


    FOR i = 1 TO 1



        SPEED 9
        MOVE G6A,104,  78, 110,  160, 100, 100
        MOVE G6D,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60, , , 50
        WAIT

        SPEED 7
        MOVE G6A,104,  70, 130,  146, 95, 100
        MOVE G6D,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 9
        MOVE G6A,100,  86, 145,  75, 95, 100
        MOVE G6D,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT


        '***************************

        SPEED 9
        MOVE G6D,100,  86, 145,  75, 95, 100
        MOVE G6A,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60, , , 150
        WAIT

        SPEED 7
        MOVE G6D,104,  70, 130,  146, 95, 100
        MOVE G6A,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 9
        MOVE G6D,104,  78, 110,  160, 100, 100
        MOVE G6A,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

    NEXT i


    SPEED 9
    MOVE G6A,104,  78, 110,  160, 100, 100
    MOVE G6D,84,  68, 125,  155, 115, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60, , , 50
    WAIT

    SPEED 7
    MOVE G6A,100,  86, 145,  75, 95, 100
    MOVE G6D,84,  81, 155,  70, 115, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT

    SPEED 6
    MOVE G6D,94,  85, 145,  75, 105, 100
    MOVE G6A,94,  85, 145,  75, 105, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60, , , 100
    WAIT
    DELAY 100

    FOR i = 1 TO 2

        SPEED 9
        MOVE G6A,100,  86, 145,  75, 95, 100
        MOVE G6D,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60,
        MOVE G6B,70,  20,  60,, , 50
        WAIT

        SPEED 8
        MOVE G6A,104,  70, 130,  146, 95, 100
        MOVE G6D,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 8
        MOVE G6A,104,  78, 110,  160, 100, 100
        MOVE G6D,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60,
        WAIT

        SPEED 8
        MOVE G6D,104,  78, 110,  160, 100, 100
        MOVE G6A,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60, , , 150
        WAIT

        SPEED 8
        MOVE G6D,104,  70, 130,  146, 95, 100
        MOVE G6A,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 9
        MOVE G6D,100,  86, 145,  75, 95, 100
        MOVE G6A,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT


        '***************************



    NEXT i

    SPEED 8
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60, , , 100
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT



    RETURN


    '**********************************************

국민체조_5: '가슴운동
    GOSUB All_motor_mode3
    SPEED 8
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  40,  80
    MOVE G6B,70,  40,  80
    WAIT


    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  20,  50
    MOVE G6B,70,  20,  50
    WAIT

    FOR j = 1 TO 2
        FOR i = 1 TO 2

            SPEED 4
            MOVE G6A, 100,  74, 175,  45, 100, 100
            MOVE G6D, 100,  74, 175,  45, 100, 100
            MOVE G6B,  60,  30,  30, 100, 100, 100
            MOVE G6C,  60,  30,  30, 100, 100, 100
            WAIT

            SPEED 4
            MOVE G6A, 100,  80, 145,  85, 100, 100
            MOVE G6D, 100,  80, 145,  85, 100, 100
            MOVE G6C,70,  20,  50
            MOVE G6B,70,  20,  50
            WAIT

        NEXT i

        SPEED 6
        MOVE G6A, 100,  64, 145,  135, 100, 100
        MOVE G6D, 100,  64, 145,  135, 100, 100
        MOVE G6B,  60,  30,  30, 100, 100, 100
        MOVE G6C,  60,  30,  30, 100, 100, 100
        WAIT

        FOR i = 1 TO 2

            SPEED 3
            MOVE G6A, 100,  64, 145,  135, 100, 100
            MOVE G6D, 100,  64, 145,  135, 100, 100
            MOVE G6B,  60,  30,  30, 100, 100, 100
            MOVE G6C,  60,  30,  30, 100, 100, 100
            WAIT

            SPEED 3
            MOVE G6A, 100,  74, 125,  145, 100, 100
            MOVE G6D, 100,  74, 125,  145, 100, 100
            MOVE G6C,70,  20,  50
            MOVE G6B,70,  20,  50
            WAIT

        NEXT i

    NEXT j

    SPEED 5
    MOVE G6A, 100,  64, 145,  135, 100, 100
    MOVE G6D, 100,  64, 145,  135, 100, 100
    MOVE G6B,  60,  30,  30, 100, 100, 100
    MOVE G6C,  60,  30,  30, 100, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT



    RETURN


    '**********************************************

국민체조_6: '옆꾸리운동
    GOSUB All_motor_mode3

    FOR j = 1 TO 2
        FOR i = 1 TO 2

            SPEED 10
            MOVE G6D,96,  116, 67,  133, 130, 100
            MOVE G6A,85,  86, 125,  103, 85, 100
            MOVE G6C,100,  45,  90,
            MOVE G6B,100,  180,  140,, , 160
            WAIT

            SPEED 11
            MOVE G6D,96,  86, 125,  103, 110, 100
            MOVE G6A,91,  76, 145,  93, 100, 100
            MOVE G6C,100,  35,  80,
            MOVE G6B,100,  35,  80,, , 100
            WAIT
        NEXT i
        '***********************************
        FOR i = 1 TO 2

            SPEED 10
            MOVE G6A,96,  116, 67,  133, 130, 100
            MOVE G6D,85,  86, 125,  103, 85, 100
            MOVE G6B,100,  45,  90,, , 40
            MOVE G6C,100,  180,  140,
            WAIT

            SPEED 11
            MOVE G6A,96,  86, 125,  103, 110, 100
            MOVE G6D,91,  76, 145,  93, 100, 100
            MOVE G6B,100,  35,  80,, , 100
            MOVE G6C,100,  35,  80,
            WAIT
        NEXT i
    NEXT j

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,, , 100
    MOVE G6C,100,  30,  80,
    WAIT


    RETURN
    '**********************************************
국민체조_7: '등배운동

    GOSUB All_motor_mode3

    FOR j = 1 TO 2
        FOR i = 1 TO 2
            SPEED 5
            MOVE G6A,100,  33, 178,  155, 100
            MOVE G6D,100,  33, 178,  155, 100
            MOVE G6B,165,  15,  90
            MOVE G6C,165,  15,  90
            WAIT

            SPEED 5
            MOVE G6A,100,  76, 145,  93, 100
            MOVE G6D,100,  76, 145,  93, 100
            MOVE G6B,100,  30,  80
            MOVE G6C,100,  30,  80
            WAIT

        NEXT i


        FOR i = 1 TO 2

            SPEED 4
            MOVE G6A, 100,  74, 175,  45, 100, 100
            MOVE G6D, 100,  74, 175,  45, 100, 100
            MOVE G6B,  60,  30,  30, 100, 100, 100
            MOVE G6C,  60,  30,  30, 100, 100, 100
            WAIT

            SPEED 4
            MOVE G6A, 100,  80, 145,  85, 100, 100
            MOVE G6D, 100,  80, 145,  85, 100, 100
            MOVE G6C,70,  20,  50
            MOVE G6B,70,  20,  50
            WAIT

        NEXT i

        SPEED 10
        MOVE G6C,100,  40,  90
        MOVE G6B,100,  40,  90
        WAIT
    NEXT j


    RETURN
    '**********************************************
국민체조_8: '몸통운동
    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT


    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT

    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    DELAY 150
    '*****************
    SPEED 12
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT



    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT

    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    DELAY 150
    '*****************
    SPEED 12
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT


    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT

    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    DELAY 150
    '*****************


    RETURN

    '**********************************************
국민체조_9: '온몸운동
    GOSUB All_motor_mode3

    FOR i = 1 TO 5
        SPEED 12
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6C,100,  30,  80
        MOVE G6B,100,  30,  80
        WAIT

        SPEED 10
        MOVE G6A,100, 140,  37, 140, 100, 100
        MOVE G6D,100, 140,  37, 140, 100, 100
        MOVE G6B,120,  30,  80
        MOVE G6C,120,  30,  80


        SPEED 6
        MOVE G6A,100, 143,  28, 142, 100, 100
        MOVE G6D,100, 143,  28, 142, 100, 100
        WAIT


        DELAY 100

        SPEED 8
        MOVE G6A,100, 137,  37, 140, 100, 100
        MOVE G6D,100, 137,  37, 140, 100, 100
        WAIT

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,189,  70,  80
        MOVE G6C,189,  70,  80
        WAIT

        SPEED 15
        MOVE G6C,189,  40,  15
        MOVE G6B,189,  40,  15
        WAIT

        DELAY 100

        SPEED 15
        MOVE G6C,100,  40,  80
        MOVE G6B,100,  40,  80
        WAIT

    NEXT i

    RETURN

    '**********************************************
    '**********************************************
국민체조_10: '뜀뛰기운동
    GOSUB All_motor_mode3

    FOR j = 1 TO 2
        FOR i = 1 TO 3
            SPEED 8
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 8
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6C,80,  30,  80
            MOVE G6B,120,  30,  80
            WAIT

            '*************
            SPEED 8
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 8
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6B,80,  30,  80
            MOVE G6C,120,  30,  80
            WAIT

        NEXT i


        FOR i = 1 TO 3
            SPEED 12
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 12
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6C,80,  30,  80
            MOVE G6B,120,  30,  80
            WAIT

            '*************
            SPEED 12
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 12
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6B,80,  30,  80
            MOVE G6C,120,  30,  80
            WAIT

        NEXT i

    NEXT j


    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    RETURN

    '**********************************************
    '**********************************************
국민체조_11: '팔다리운동


    FOR i = 1 TO 4
        SPEED 12
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  100,  100
        MOVE G6C,100,  100,  100
        WAIT


        SPEED 10
        MOVE G6A,100, 140,  37, 140, 100, 100
        MOVE G6D,100, 140,  37, 140, 100, 100
        MOVE G6B,160,  20,  40
        MOVE G6C,160,  20,  40
        WAIT


        SPEED 10
        MOVE G6A,100, 143,  28, 142, 100, 100
        MOVE G6D,100, 143,  28, 142, 100, 100
        MOVE G6B,160,  20,  40
        MOVE G6C,160,  20,  40
        WAIT


        DELAY 100

        SPEED 8
        MOVE G6A,100, 137,  37, 140, 100, 100
        MOVE G6D,100, 137,  37, 140, 100, 100
        WAIT

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  100,  100
        MOVE G6C,100,  100,  100
        WAIT

    NEXT i

    RETURN

    '**********************************************
    '**********************************************
국민체조_12: '숨고르기


    SPEED 12
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT


    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT
    '******************

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 8
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT
    '******************
    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 6
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT
    '******************

    SPEED 4
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    '******************
    SPEED 4
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT
    '******************

    SPEED 2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT



    RETURN

    '**********************************************

    '**********************************************
    '**********************************************

모터ONOFF_LED:
    IF 모터ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    RETURN
    '**********************************************
LOW_Voltage:

    B = AD(6)

    IF B < 하한전압 THEN
        GOSUB 경고음

    ENDIF

    RETURN
    '**********************************************
    '******************************************	
MAIN: '라벨설정


    'GOSUB LOW_Voltage
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정


    ERX 4800,A,MAIN
    A_old = A

    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************
    '*******************************************

KEY1:




    GOTO RX_EXIT
    '*******************************************
KEY2:




    GOTO RX_EXIT
    '*******************************************
KEY3:



    GOTO RX_EXIT
    '*******************************************
KEY4:

 

    GOTO RX_EXIT
    '*******************************************
KEY5:



    GOTO RX_EXIT
    '*******************************************
KEY6:
 



    GOTO RX_EXIT
    '*******************************************
KEY7:


    GOTO RX_EXIT
    '*******************************************
KEY8:


    GOTO RX_EXIT
    '*******************************************
KEY9:



    GOTO RX_EXIT
    '*******************************************
KEY10: '0

 

    GOTO RX_EXIT
    '*******************************************
KEY11: ' ▲

        IF 자세 = 0 THEN
            
        ENDIF
 

    GOTO RX_EXIT
    '*******************************************
KEY12: ' ▼

        IF 자세 = 0 THEN
            
        ENDIF
 

    GOTO RX_EXIT
    '*******************************************
KEY13: '▶

  
        IF 자세 = 0 THEN
            GOSUB 천천히오른쪽옆으로50
        ENDIF
 

    GOTO RX_EXIT
    '*******************************************
KEY14: ' ◀

        IF 자세 = 0 THEN
            GOSUB  천천히왼쪽옆으로50
        ENDIF
 

    GOTO RX_EXIT
    '*******************************************
KEY15: ' A


        IF 자세 = 0 THEN
           
        ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY16: ' POWER

    GOTO RX_EXIT

    '*******************************************
KEY17: ' C

  
        IF 자세 = 0 THEN
            GOSUB 연속댄스1
        ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY18: ' E

        IF 자세 = 0 THEN
            GOSUB 종합댄스1

        ENDIF

    GOTO RX_EXIT
    '*******************************************


KEY19: ' P2


        IF 자세 = 0 THEN
           
        ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY20: ' B	


        IF 자세 = 0 THEN
            
        ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY21: ' △

        IF 자세 = 0 THEN
            GOSUB 앞으로덤블링
        ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY22: ' *	

        IF 자세 = 0 THEN

            GOSUB 물구나무서기
        ENDIF



    GOTO RX_EXIT
    '*******************************************
KEY23: ' G

        IF 자세 = 0 THEN
            GOSUB 국민체조시작'종합댄스3
        ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY24: ' #

        IF 자세 = 0 THEN
           
        ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY25: ' P1


        IF 자세 = 0 THEN
            
        ENDIF
 

    GOTO RX_EXIT
    '*******************************************
KEY26: ' ■
    GOSUB SOUND_STOP

    GOSUB Arm_motor_mode3
    SPEED 10
    MOVE G6B, , 60
    MOVE G6C, , 60
    WAIT	
    SPEED 8
    GOSUB 기본자세
    
    GOTO RX_EXIT
    '*******************************************
KEY27: ' D

        IF 자세 = 0 THEN
            GOSUB 연속댄스2
        ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY28: ' ◁


        IF 자세 = 0 THEN
            GOSUB 왼쪽덤블링
        ENDIF

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
        GOSUB MOTOR_OFF
    ELSE
        GOSUB MOTOR_ON
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


        IF 자세 = 0 THEN
            GOSUB 오른쪽덤블링
        ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY31: ' ▽

        IF 자세 = 0 THEN
            GOSUB 뒤로덤블링
        ENDIF

    GOTO RX_EXIT
    '*******************************************

KEY32: ' F


        IF 자세 = 0 THEN
            GOSUB 종합댄스2
        ENDIF


    GOTO RX_EXIT
    '*******************************************











