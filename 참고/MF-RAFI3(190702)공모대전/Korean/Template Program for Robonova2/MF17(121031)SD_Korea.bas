

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
DIM 댄스멈춤 AS BYTE

DIM info_index AS BYTE

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
CONST min = 61			'뒤로넘어졌을때
CONST max = 107			'앞으로넘어졌을때
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
'Action_mode = 1	'F(CODE 32):파이트모드
'Action_mode = 2	'G(CODE 23):게임모드
'Action_mode = 3	'B(CODE 20):축구모드
'Action_mode = 4	'E(CODE 18):장애물경주모드
'Action_mode = 5	'C(CODE 17):카메라모드
'Action_mode = 6	'A(CODE 15):홍보모드



'****초기위치 *****************************
OUT 52,0	'눈 LED 켜기

GOSUB MOTOR_ON



SPEED 5
GOSUB 전원초기자세
GOSUB 기본자세

PRINT "VOLUME 150 !"


GOSUB SOUND_MODE_SELECT


GOTO MAIN
'************************************************
'************************************************

MOTOR_FAST_ON:
    GOSUB MOTOR_GET

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
MR_SOUND_OPEN:
    PRINT "OPEN MRSOUND.MRS !"
    RETURN
    '************************************************
SOUND_홍보1:
    PRINT "SOUND 48!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_홍보2:
    PRINT "SOUND 49!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_홍보3:
    PRINT "SOUND 50!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_홍보4:
    PRINT "SOUND 51!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_홍보5:
    PRINT "SOUND 52!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_홍보6:
    PRINT "SOUND 53!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_홍보7:
    PRINT "SOUND 54!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_홍보8:
    PRINT "SOUND 55!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_홍보9:
    PRINT "SOUND 56!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
    '************************************************
SOUND_국민체조곡: '
    PRINT "SOUND 47!"
    RETURN
SOUND_종합댄스곡: '
    PRINT "SOUND 46!"
    RETURN
SOUND_안녕하세요: '
    PRINT "SOUND 12!"
    RETURN
SOUND_안녕하세요미니로봇에서개발된메탈파이터입니다: '
    PRINT "SOUND 0!"
    RETURN
    '************************************************
MRSOUND_OPEN:
    PRINT "OPEN MRSOUND.mrs !"
    RETURN
    '************************************************
SOUND_MODE_SELECT:
    GOSUB MR_SOUND_OPEN

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
SOUND_MUSIC42:
    PRINT "SOUND 42!"
    RETURN

SOUND_ALL_OFF_MSG:
    PRINT "SOUND 20!"
    DELAY 1500
    GOSUB SOUND_VOLUME_0
    RETURN

SOUND_ALL_ON_MSG:
    PRINT "VOLUME 150 !"
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


SOUND_VOLUME_0:
    PRINT "VOLUME 0 !"
    RETURN

SOUND_STOP:
    PRINT "STOP !"
    RETURN

SOUND_UP:
    PRINT "UP 10 !"
    RETURN

SOUND_DOWN:
    PRINT "DOWN 10 !"
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
    '*******************************************
DANCE_STOP:

    ERX 4800,A ,DANCE_GOGO
    IF A = 26  THEN
        댄스멈춤 = 1
    ENDIF

DANCE_GOGO:

    RETURN
    '************************************************
    '******************************************
STOP_MAIN:
    PRINT "STOP !"
    GOSUB All_motor_mode3

    HIGHSPEED SETOFF
    SPEED 6
    MOVE G6B,, 50, 100
    MOVE G6C,, 50, 100
    WAIT
    SPEED 6
    GOSUB 기본자세
    댄스멈춤 = 0


    GOTO RX_EXIT
    '*******************************************
뒤로일어나기:

    IF 모터ONOFF = 1 THEN
        GOSUB MOTOR_ON
    ENDIF
    HIGHSPEED SETOFF
    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세

    MOVE G6A,90, 130, 120,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT



    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    GOSUB 기본자세

    넘어진확인 = 1
    RETURN

    '**********************************************
앞으로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB All_motor_Reset


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

    GOSUB Leg_motor_mode3

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

전진보행50:
    GOSUB SOUND_Walk_Ready
    보행속도 = 10'5
    좌우속도 = 5'8'3
    좌우속도2 = 4'5'2
    넘어진확인 = 0
    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        '오른쪽기울기
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 146,  93,  94
        MOVE G6B,100,35
        MOVE G6C,100,35
        WAIT

        SPEED 10'보행속도
        '왼발들기
        MOVE G6A, 90, 100, 115, 105, 114
        MOVE G6D,113,  78, 146,  93,  94
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO 전진보행50_1	
    ELSE
        보행순서 = 0

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
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 전진보행50_2	

    ENDIF


    '*******************************


전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 163, 113, 114
    MOVE G6D,110,  77, 146,  93,  94
    WAIT

    GOSUB SOUND_REPLAY

    SPEED 좌우속도
    'GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,110,  76, 144, 100,  93
    MOVE G6D,85, 93, 155,  71, 112
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 보행속도
    'GOSUB Leg_motor_mode2
    '오른발들기10
    MOVE G6A,111,  77, 146,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, 전진보행50_2
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        'GOSUB Leg_motor_mode3
        SPEED 5

        '왼쪽기울기2
        MOVE G6A, 106,  76, 146,  93,  96		
        MOVE G6D,  88,  71, 152,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT	


        SPEED 3
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        ' GOSUB 자이로OFF
        GOTO RX_EXIT
    ENDIF
    '**********


전진보행50_2:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,85,  44, 163, 113, 114
    MOVE G6A,110,  77, 146,  93,  94
    WAIT

    GOSUB SOUND_REPLAY

    SPEED 좌우속도
    'GOSUB Leg_motor_mode3
    '오른발중심이동
    MOVE G6D,110,  76, 144, 100,  93
    MOVE G6A, 85, 93, 155,  71, 112
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    SPEED 보행속도
    'GOSUB Leg_motor_mode2
    '왼발들기10
    MOVE G6A, 90, 100, 105, 110, 114
    MOVE G6D,111,  77, 146,  93,  94
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ERX 4800,A, 전진보행50_1
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        'GOSUB Leg_motor_mode3
        SPEED 5

        '오른쪽기울기2
        MOVE G6D, 106,  76, 146,  93,  96		
        MOVE G6A,  88,  71, 152,  91, 106
        MOVE G6C, 100,35
        MOVE G6B, 100,35
        WAIT

        SPEED 3
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        ' GOSUB 자이로OFF
        GOTO RX_EXIT
    ENDIF


    GOTO 전진보행50_1
    '************************************************
    '************************************************
    '************************************************
후진보행50:
    GOSUB SOUND_Walk_Ready
    보행속도 = 12'6
    좌우속도 = 6'3
    좌우속도2 = 4'2
    넘어진확인 = 0
    GOSUB Leg_motor_mode3



    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        '오른쪽기울기
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 146,  93,  94
        MOVE G6B,100,35
        MOVE G6C,100,35
        WAIT

        SPEED 10'보행속도
        '왼발들기
        MOVE G6A, 90, 95, 115, 105, 114
        MOVE G6D,113,  78, 146,  93,  94
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO 후진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 4
        '왼쪽기울기
        MOVE G6D,  88,  71, 152,  91, 110
        MOVE G6A, 108,  76, 146,  93,  94
        MOVE G6C, 100,35
        MOVE G6B, 100,35
        WAIT

        SPEED 10'보행속도
        '오른발들기
        MOVE G6D, 90, 95, 115, 105, 114
        MOVE G6A,113,  78, 146,  93,  94
        MOVE G6C,90
        MOVE G6B,110
        WAIT

        GOTO 후진보행50_2

    ENDIF


후진보행50_1:
    SPEED 보행속도
    GOSUB Leg_motor_mode2
    '오른발중심이동
    MOVE G6D,110,  76, 144, 100,  93
    MOVE G6A, 90, 93, 155,  71, 112
    WAIT
    GOSUB SOUND_REPLAY

    SPEED 좌우속도2
    GOSUB Leg_motor_mode3
    '오른발뻣어착지
    MOVE G6D,90,  46, 163, 110, 114
    MOVE G6A,110,  77, 147,  90,  94
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    SPEED 보행속도
    '오른발들기10
    MOVE G6A,112,  77, 147,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, 후진보행50_2
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '왼쪽기울기2
        MOVE G6A, 106,  76, 146,  93,  96		
        MOVE G6D,  88,  71, 152,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT	

        SPEED 3
        GOSUB 기본자세
        'GOSUB Leg_motor_mode1
        ' GOSUB 자이로OFF
        GOTO RX_EXIT
    ENDIF
    '**********

후진보행50_2:
    SPEED 보행속도
    GOSUB Leg_motor_mode2
    '왼발중심이동
    MOVE G6A,110,  76, 144, 100,  93
    MOVE G6D,90, 93, 155,  71, 112
    WAIT
    GOSUB SOUND_REPLAY

    SPEED 좌우속도2
    GOSUB Leg_motor_mode3
    '왼발뻣어착지
    MOVE G6A, 90,  46, 163, 110, 114
    MOVE G6D,110,  77, 147,  90,  94
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    SPEED 보행속도
    '왼발들기10
    MOVE G6A, 90, 100, 105, 110, 114
    MOVE G6D,112,  76, 147,  93,  94
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ERX 4800,A, 후진보행50_1
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '왼쪽기울기2
        MOVE G6D, 106,  76, 146,  93,  96		
        MOVE G6A,  88,  71, 152,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT	

        SPEED 3
        GOSUB 기본자세
        'GOSUB Leg_motor_mode1
        ' GOSUB 자이로OFF
        GOTO RX_EXIT
    ENDIF  	

    GOTO 후진보행50_1
    '**********************************************
    '******************************************
전진달리기50:
    넘어진확인 = 0
    GOSUB SOUND_Walk_Ready
    SPEED 12
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기50_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기50_4
    ENDIF


    '**********************

전진달리기50_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  78, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


전진달리기50_2:
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  89,  100
    WAIT

    GOSUB SOUND_REPLAY

전진달리기50_3:
    MOVE G6A,103,  70, 145, 103,  100
    MOVE G6D, 95, 88, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진달리기50_4
    IF A <> A_old THEN  GOTO 전진달리기50_멈춤

    '*********************************

전진달리기50_4:
    MOVE G6D,95,  95, 100, 120, 104
    MOVE G6A,104,  78, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


전진달리기50_5:
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  89,  100
    WAIT

    GOSUB SOUND_REPLAY

전진달리기50_6:
    MOVE G6D,103,  70, 145, 103,  100
    MOVE G6A, 95, 88, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진달리기50_1
    IF A <> A_old THEN  GOTO 전진달리기50_멈춤


    GOTO 전진달리기50_1


전진달리기50_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************

    '******************************************
후진달리기40:
    넘어진확인 = 0
    SPEED 10
    GOSUB SOUND_Walk_Ready
    HIGHSPEED SETON
    GOSUB Leg_motor_mode5

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,88,  73, 145,  96, 102
        MOVE G6D,104,  73, 145,  96, 100
        WAIT

        GOTO 후진달리기40_1
    ELSE
        보행순서 = 0
        MOVE G6D,88,  73, 145,  96, 102
        MOVE G6A,104,  73, 145,  96, 100
        WAIT


        GOTO 후진달리기40_4
    ENDIF


    '**********************

후진달리기40_1:
    'SPEED 10
    MOVE G6A,92,  92, 100, 115, 104
    MOVE G6D,103,  74, 145,  96,  100
    MOVE G6B, 120
    MOVE G6C,80
    'WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

후진달리기40_2:
    'SPEED 10
    MOVE G6A,95,  100, 122, 95, 104
    MOVE G6D,103,  70, 145,  102,  100
    'WAIT

후진달리기40_3:
    'SPEED 10
    MOVE G6A,103,  90, 145, 80, 100
    MOVE G6D,92,  64, 145,  108,  102
    'WAIT
    GOSUB SOUND_REPLAY



    ERX 4800,A, 후진달리기40_4
    IF A <> A_old THEN  GOTO 후진달리기40_멈춤
    '*********************************

후진달리기40_4:
    'SPEED 10
    MOVE G6D,92,  92, 100, 115, 104
    MOVE G6A,103,  74, 145,  96,  100
    MOVE G6C, 120
    MOVE G6B,80
    'WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

후진달리기40_5:

    MOVE G6D,95,  100, 122, 95, 104
    MOVE G6A,103,  70, 145,  102,  100


후진달리기40_6:

    MOVE G6D,103,  90, 145, 80, 100
    MOVE G6A,92,  64, 145,  108,  102
    ' WAIT
    GOSUB SOUND_REPLAY

    ERX 4800,A, 후진달리기40_1
    IF A <> A_old THEN  GOTO 후진달리기40_멈춤

    GOTO  후진달리기40_1 	

후진달리기40_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************

    '******************************************
안정화멈춤:
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB 안정화자세
    SPEED 15
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    RETURN

    '******************************************
    '**********************************************

    '******************************************
전진종종걸음:
    넘어진확인 = 0
    GOSUB SOUND_Walk_Ready
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종걸음_4
    ENDIF


    '**********************

전진종종걸음_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


전진종종걸음_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

전진종종걸음_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진종종걸음_4
    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

    '*********************************

전진종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


전진종종걸음_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

전진종종걸음_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진종종걸음_1
    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤


    GOTO 전진종종걸음_1


전진종종걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '******************************************
후진종종걸음:
    넘어진확인 = 0
    GOSUB SOUND_Walk_Ready
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 후진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 후진종종걸음_4
    ENDIF


    '**********************

후진종종걸음_1:
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT


후진종종걸음_2:
    MOVE G6A,95,  90, 135, 90, 104
    MOVE G6D,104,  77, 146,  91,  100
    WAIT

후진종종걸음_3:
    MOVE G6A, 103,  79, 146,  89, 100
    MOVE G6D,95,   65, 146, 103,  102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 후진종종걸음_4
    IF A <> A_old THEN  GOTO 후진종종걸음_멈춤

    '*********************************

후진종종걸음_4:
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT


후진종종걸음_5:
    MOVE G6A,104,  77, 146,  91,  100
    MOVE G6D,95,  90, 135, 90, 104
    WAIT

후진종종걸음_6:
    MOVE G6D, 103,  79, 146,  89, 100
    MOVE G6A,95,   65, 146, 103,  102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 후진종종걸음_1
    IF A <> A_old THEN  GOTO 후진종종걸음_멈춤


    GOTO 후진종종걸음_1


후진종종걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '**********************************************

전진달리기30: '보폭이 짧게
    넘어진확인 = 0
    GOSUB SOUND_Walk_Ready
    SPEED 12
    HIGHSPEED SETON

    IF 보행순서 = 0 THEN
        MOVE G6A,100,  80, 119, 118, 103
        MOVE G6D,102,  75, 149,  93,  100
        MOVE G6B, 80,  30,  80
        MOVE G6C,120,  30,  80

        보행순서 = 1
        GOTO 전진달리기30_2
    ELSE
        MOVE G6D,100,  80, 119, 118, 103
        MOVE G6A,102,  75, 149,  93,  100
        MOVE G6C, 80,  30,  80
        MOVE G6B,120,  30,  80

        보행순서 = 0
        GOTO 전진달리기30_4

    ENDIF



    '********************************************
전진달리기30_1:

    '왼발들기10:
    MOVE G6A,100,  80, 119, 118, 103
    MOVE G6D,102,  75, 147,  93,  100
    MOVE G6B, 80,  30,  80
    MOVE G6C,120,  30,  80
    GOSUB SOUND_REPLAY

    ERX 4800, A, 전진달리기30_2
    GOSUB 기본자세
    HIGHSPEED SETOFF
    GOTO RX_EXIT

전진달리기30_2:

    '왼발중심이동1:
    MOVE G6A,102,  74, 140, 106,  100
    MOVE G6D, 95, 105, 124,  93, 103
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

전진달리기30_3:
    '오른발들기10:
    MOVE G6D,100,  80, 119, 118, 103
    MOVE G6A,102,  75, 147,  93,  100
    MOVE G6C, 80,  30,  80
    MOVE G6B,120,  30,  80
    GOSUB SOUND_REPLAY



    ERX 4800, A, 전진달리기30_4
    GOSUB 기본자세
    HIGHSPEED SETOFF
    GOTO RX_EXIT

전진달리기30_4:
    '오른발중심이동1:
    MOVE G6D,102,  74, 140, 106,  100
    MOVE G6A, 95, 105, 124,  93, 103
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    '************************************************


    GOTO 전진달리기30_1


    GOTO RX_EXIT

    '*********************************************
    '******************************************
집고달리기:
    넘어진확인 = 0
    GOSUB SOUND_Walk_Ready
    SPEED 15
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  85, 101
        MOVE G6D,101,  77, 145,  85, 98
        WAIT

        GOTO 집고달리기_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  85, 101
        MOVE G6A,101,  77, 145,  85, 98
        WAIT

        GOTO 집고달리기_4
    ENDIF


    '**********************

집고달리기_1:
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6D,104,  77, 145,  87,  102
    WAIT
    DELAY 5

집고달리기_2:
    MOVE G6D,104,  79, 145,  82,  100
    MOVE G6A,95,  85, 130, 95, 104
    WAIT
    DELAY 5
집고달리기_3:
    MOVE G6A,103,   85, 130, 95,  100
    MOVE G6D, 97,  79, 145,  82, 102
    WAIT
    DELAY 5
    GOSUB SOUND_REPLAY
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고달리기_4
    IF A <> A_old THEN  GOTO 집고달리기_멈춤

    '*********************************

집고달리기_4:
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6A,104,  77, 145,  87,  102
    WAIT


집고달리기_5:
    MOVE G6D,95,  85, 130, 95, 104
    MOVE G6A,104,  79, 145,  82,  100
    WAIT

집고달리기_6:
    MOVE G6D,103,   85, 130, 95,  100
    MOVE G6A, 97,  79, 145,  82, 102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고달리기_1
    IF A <> A_old THEN  GOTO 집고달리기_멈춤


    GOTO 집고달리기_1


집고달리기_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 145,  85, 101, 100
    MOVE G6D,98,  76, 145,  85, 101, 100
    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '******************************************
집고후진걸음:
    넘어진확인 = 0
    GOSUB SOUND_Walk_Ready
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  85, 101
        MOVE G6D,101,  77, 145,  85, 98
        WAIT

        GOTO 집고후진걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  85, 101
        MOVE G6A,101,  77, 145,  85, 98
        WAIT

        GOTO 집고후진걸음_4
    ENDIF


    '**********************

집고후진걸음_1:
    MOVE G6D,104,  77, 146,  83,  102
    MOVE G6A,95,  95, 120, 92, 104
    WAIT


집고후진걸음_2:
    MOVE G6A,95,  90, 135, 82, 104
    MOVE G6D,104,  77, 146,  83,  100
    WAIT

집고후진걸음_3:
    MOVE G6A, 103,  79, 146,  81, 100
    MOVE G6D,95,   65, 146, 95,  102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고후진걸음_4
    IF A <> A_old THEN  GOTO 집고후진걸음_멈춤

    '*********************************

집고후진걸음_4:
    MOVE G6D,95,  95, 120, 92, 104
    MOVE G6A,104,  77, 146,  83,  102
    WAIT


집고후진걸음_5:
    MOVE G6A,104,  77, 146,  83,  100
    MOVE G6D,95,  90, 135, 82, 104
    WAIT

집고후진걸음_6:
    MOVE G6D, 103,  79, 146,  81, 100
    MOVE G6A,95,   65, 146, 95,  102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고후진걸음_1
    IF A <> A_old THEN  GOTO 집고후진걸음_멈춤


    GOTO 집고후진걸음_1


집고후진걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 145,  85, 101, 100
    MOVE G6D,98,  76, 145,  85, 101, 100
    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    DELAY 400


    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '*********************************************	
전진앉아보행:
    GOSUB All_motor_mode3
    SPEED 9

전진앉아보행_1:

    MOVE G6A,114, 143,  28, 142,  96, 100
    MOVE G6D, 87, 135,  28, 155, 110, 100
    WAIT


    MOVE G6D,98, 126,  28, 160, 102, 100
    MOVE G6A,98, 160,  28, 125, 102, 100
    WAIT

    ERX 4800, A, 전진앉아보행_2
    SPEED 6
    IF  물건집은상태 = 0 THEN
        GOSUB 앉은자세
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        자세 = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT

전진앉아보행_2:
    MOVE G6D,113, 143,  28, 142,  96, 100
    MOVE G6A, 87, 135,  28, 155, 110, 100
    WAIT

    MOVE G6A,98, 126,  28, 160, 102, 100
    MOVE G6D,98, 160,  28, 125, 102, 100
    WAIT

    ERX 4800, A, 전진앉아보행_1
    SPEED 6
    IF  물건집은상태 = 0 THEN
        GOSUB 앉은자세
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        자세 = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT


    GOTO 전진앉아보행_1
    '*****************************
후진앉아보행:
    GOSUB All_motor_mode3
    SPEED 8

후진앉아보행_1:

    MOVE G6D,113, 140,  28, 142,  96, 100
    MOVE G6A, 87, 140,  28, 140, 110, 100
    WAIT

    MOVE G6A,98, 155,  28, 125, 102, 100
    MOVE G6D,98, 121,  28, 160, 102, 100
    WAIT

    ERX 4800, A, 후진앉아보행_2
    SPEED 6
    IF  물건집은상태 = 0 THEN
        GOSUB 앉은자세
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        자세 = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT

후진앉아보행_2:
    MOVE G6A,113, 140,  28, 142,  96, 100
    MOVE G6D, 87, 140,  28, 140, 110, 100
    WAIT


    MOVE G6D,98, 155,  28, 125, 102, 100
    MOVE G6A,98, 121,  28, 160, 102, 100
    WAIT

    ERX 4800, A, 후진앉아보행_1
    SPEED 6
    IF  물건집은상태 = 0 THEN
        GOSUB 앉은자세
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        자세 = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT


    GOTO 후진앉아보행_1
    '*****************************		

앉아오른쪽옆으로:
    GOSUB All_motor_mode3
    SPEED 6
    MOVE G6A,110, 145,  28, 140, 100, 100
    MOVE G6D, 86, 145,  28, 140, 105, 100
    WAIT

    SPEED 5
    MOVE G6A, 90, 145,  28, 140, 110, 100
    MOVE G6D, 90, 145,  28, 140, 110, 100
    WAIT

    SPEED 6 	
    MOVE G6A, 80, 135,  45, 135, 105, 100
    MOVE G6D,108, 145,  28, 140, 100, 100
    WAIT

    SPEED 4 		
    MOVE G6A, 90, 145,  28, 140, 100, 100
    MOVE G6D,106, 145,  28, 140, 100, 100
    WAIT

    SPEED 3
    IF  물건집은상태 = 0 THEN
        GOSUB 앉은자세
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        자세 = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT
    '*****************************	
앉아왼쪽옆으로:
    GOSUB All_motor_mode3
    SPEED 6
    MOVE G6D,110, 145,  28, 140, 100, 100
    MOVE G6A, 86, 145,  28, 140, 105, 100
    WAIT

    SPEED 5
    MOVE G6D, 90, 145,  28, 140, 110, 100
    MOVE G6A, 90, 145,  28, 140, 110, 100
    WAIT

    SPEED 6 	
    MOVE G6D, 80, 135,  45, 135, 105, 100
    MOVE G6A,108, 145,  28, 140, 100, 100
    WAIT

    SPEED 4 		
    MOVE G6D, 90, 145,  28, 140, 100, 100
    MOVE G6A,106, 145,  28, 140, 100, 100
    WAIT

    SPEED 3
    IF  물건집은상태 = 0 THEN
        GOSUB 앉은자세
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        자세 = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT
    '**********************************************
    '************************************************
안내장전달:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6B,188,  15,  80
    MOVE G6C,188,  15,  80
    WAIT


    GOSUB All_motor_Reset
    물건집은상태 = 3
    RETURN
    '************************************************
    '************************************************
안내장들기:
    GOSUB All_motor_mode3
    SPEED 3
    MOVE G6A,100,  73, 145,  85, 100
    MOVE G6D,100,  73, 145,  85, 100
    MOVE G6B,165,  30,  80
    MOVE G6C,165,  30,  80
    WAIT


    DELAY 2000
    '**** 잡는간격조절 ************
    MOVE G6B,165,  15,  80
    MOVE G6C,165,  15,  80
    WAIT

    GOSUB All_motor_Reset
    물건집은상태 = 2
    RETURN
    '************************************************
    '**********************************************

안내장들고전진보행50:
    넘어진확인 = 0
    보행속도 = 10
    좌우속도 = 3
    좌우속도2 = 4

    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 3
        '오른쪽기울기
        MOVE G6A, 88,  68, 152,  83, 110
        MOVE G6D,108,  73, 146,  85,  94
        WAIT

        SPEED 10'보행속도
        '왼발들기
        MOVE G6A, 90, 97, 115, 98, 114
        MOVE G6D,112,  75, 146,  85,  94
        WAIT


        GOTO 안내장들고전진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 3
        '왼쪽기울기
        MOVE G6D,  88,  68, 152,  83, 110
        MOVE G6A, 108,  73, 146,  85,  94
        WAIT

        SPEED 10'보행속도
        '오른발들기
        MOVE G6D, 90, 97, 115, 98, 114
        MOVE G6A,112,  75, 146,  85,  94
        WAIT


        GOTO 안내장들고전진보행50_2	

    ENDIF


    '*******************************


안내장들고전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 90,  41, 163, 105, 114
    MOVE G6D,110,  74, 146,  85,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,110,  73, 144, 92,  93
    MOVE G6D,90, 90, 155,  63, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2
    '오른발들기10
    MOVE G6A,111,  74, 146,  85, 94
    MOVE G6D,90, 97, 105, 102, 114
    WAIT
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF
    ERX 4800,A, 안내장들고전진보행50_2
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '왼쪽기울기2
        MOVE G6A, 106,  73, 146,  85,  96		
        MOVE G6D,  88,  68, 152,  82, 106
        WAIT	


        SPEED 3
        MOVE G6A,100,  73, 145,  85, 100, 100
        MOVE G6D,100,  73, 145,  85, 100, 100
        WAIT
        GOSUB Leg_motor_mode1
        ' GOSUB 자이로OFF
        GOTO RX_EXIT
    ENDIF
    '**********


안내장들고전진보행50_2:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,90,  41, 163, 105, 114
    MOVE G6A,110,  74, 146,  85,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '오른발중심이동
    MOVE G6D,110,  73, 144, 92,  93
    MOVE G6A, 90, 90, 155,  63, 112
    WAIT

    SPEED 보행속도
    GOSUB Leg_motor_mode2
    '왼발들기10
    MOVE G6A, 90, 97, 105, 102, 114
    MOVE G6D,111,  74, 146,  85,  94
    WAIT
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF
    ERX 4800,A, 안내장들고전진보행50_1
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '오른쪽기울기2
        MOVE G6D, 106,  73, 146,  85,  96		
        MOVE G6A,  88,  68, 152,  82, 106
        WAIT

        SPEED 3
        MOVE G6A,100,  73, 145,  85, 100, 100
        MOVE G6D,100,  73, 145,  85, 100, 100
        WAIT
        GOSUB Leg_motor_mode1
        ' GOSUB 자이로OFF
        GOTO RX_EXIT
    ENDIF


    GOTO 안내장들고전진보행50_1
    '************************************************
    '******************************************
제자리걸음:
    넘어진확인 = 0
    GOSUB Arm_motor_mode3
    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,2,3,3,3,2
    MOTORMODE G6D,2,3,3,3,2

    MOVE G6B,,35
    MOVE G6C,,35
    WAIT

제자리걸음_1:

    SPEED 4
    MOVE G6A,105,  76, 146,  93, 98, 100
    MOVE G6D,85,  73, 151,  90, 108, 100
    WAIT

    SPEED 12
    MOVE G6A,113,  76, 146,  93, 96, 100
    MOVE G6D,90,  100, 95,  120, 115, 100
    MOVE G6B,120
    MOVE G6C,80
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        RETURN
    ENDIF

    SPEED 10
    MOVE G6A,109,  76, 146,  93, 97, 100
    MOVE G6D,90,  76, 148,  92, 110, 100
    WAIT



    SPEED 4	
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100	
    WAIT

    ERX 4800,A, 제자리걸음_2
    IF A <> A_old THEN
        SPEED 5
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        RETURN
    ENDIF

제자리걸음_2:
    '***********************************
    SPEED 4
    MOVE G6D,105,  76, 146,  93, 98, 100
    MOVE G6A,85,  73, 151,  90, 108, 100
    WAIT	

    SPEED 12
    MOVE G6D,113,  76, 146,  93, 96, 100
    MOVE G6A,90,  100, 95,  120, 115, 100
    MOVE G6C,120
    MOVE G6B,80
    WAIT	



    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        RETURN
    ENDIF

    SPEED 10
    MOVE G6D,109,  76, 146,  93, 97, 100
    MOVE G6A,90,  76, 148,  92, 110, 100
    WAIT	

    SPEED 4		
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100	
    WAIT	

    ERX 4800,A, 제자리걸음_1
    IF A <> A_old THEN
        SPEED 5
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        RETURN
    ENDIF

    GOTO 제자리걸음_1


    RETURN
    '**********************************************	
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

집고오른쪽옆으로20:


    SPEED 12
    MOVE G6D, 93,  90, 120, 97, 104, 100
    MOVE G6A,103,  76, 145,  85, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 85, 100, 100
    MOVE G6A,90,  80, 140,  87, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  85, 100, 100
    MOVE G6A,98,  76, 145,  85, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOTO RX_EXIT
    '**********************************************

집고왼쪽옆으로20:


    SPEED 12
    MOVE G6A, 93,  90, 120, 97, 104, 100
    MOVE G6D,103,  76, 145,  85, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 85, 100, 100
    MOVE G6D,90,  80, 140,  87, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  85, 100, 100
    MOVE G6D,98,  76, 145,  85, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT

    '**********************************************

집고오른쪽옆으로70:
    GOSUB SOUND_Walk_Move
    SPEED 10
    MOVE G6D, 90,  90, 120, 92, 110, 100
    MOVE G6A,100,  76, 146,  85, 107, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  76, 147, 85, 100, 100
    MOVE G6A,83,  76, 140,  92, 115, 100
    WAIT

    SPEED 10
    MOVE G6D,98,  76, 146,  85, 100, 100
    MOVE G6A,98,  76, 146,  85, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOTO RX_EXIT
    '*************

집고왼쪽옆으로70:
    GOSUB SOUND_Walk_Move

    SPEED 10
    MOVE G6A, 90,  90, 120, 97, 110, 100	
    MOVE G6D,100,  76, 146,  85, 107, 100	
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 147, 85, 100, 100
    MOVE G6D,83,  76, 140,  92, 115, 100
    WAIT

    SPEED 10
    MOVE G6A,98,  76, 146,  85, 100, 100
    MOVE G6D,98,  76, 146,  85, 100, 100
    WAIT

    SPEED 15	
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOTO RX_EXIT
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

    '**********************************************
왼쪽턴10:
    GOSUB SOUND_Walk_Move
    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    GOTO RX_EXIT
    '**********************************************
오른쪽턴10:
    GOSUB SOUND_Walk_Move
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세

    GOTO RX_EXIT
    '**********************************************
    '**********************************************
왼쪽턴20:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
오른쪽턴20:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
왼쪽턴45:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '**********************************************
오른쪽턴45:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
왼쪽턴60:
    GOSUB SOUND_Walk_Move
    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOTO RX_EXIT

    '**********************************************
오른쪽턴60:
    GOSUB SOUND_Walk_Move
    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    GOSUB 기본자세
    GOTO RX_EXIT

    '************************************************
    '**********************************************
집고왼쪽턴10:
    GOSUB SOUND_Walk_Move
    SPEED 5
    MOVE G6A,97,  86, 145,  75, 103, 100
    MOVE G6D,97,  66, 145,  95, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  75, 101, 100
    MOVE G6D,94,  66, 145,  95, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT
    '**********************************************
집고오른쪽턴10:
    GOSUB SOUND_Walk_Move
    SPEED 5
    MOVE G6A,97,  66, 145,  95, 103, 100
    MOVE G6D,97,  86, 145,  75, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  95, 101, 100
    MOVE G6D,94,  86, 145,  75, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT
    '**********************************************
    '**********************************************
집고왼쪽턴20:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  96, 145,  65, 105, 100
    MOVE G6D,95,  56, 145,  105, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  65, 105, 100
    MOVE G6D,93,  56, 145,  105, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
집고오른쪽턴20:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  56, 145,  105, 105, 100
    MOVE G6D,95,  96, 145,  65, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  105, 105, 100
    MOVE G6D,93,  96, 145,  65, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
집고왼쪽턴45:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  55, 105, 100
    MOVE G6D,95,  46, 145,  115, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  55, 105, 100
    MOVE G6D,93,  46, 145,  115, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '**********************************************
집고오른쪽턴45:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  115, 105, 100
    MOVE G6D,95,  106, 145,  55, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  115, 105, 100
    MOVE G6D,93,  106, 145,  55, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
집고왼쪽턴60:
    GOSUB SOUND_Walk_Move
    SPEED 15
    MOVE G6A,95,  116, 145,  45, 105, 100
    MOVE G6D,95,  36, 145,  125, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  45, 105, 100
    MOVE G6D,90,  36, 145,  125, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT

    '**********************************************
집고오른쪽턴60:
    GOSUB SOUND_Walk_Move
    SPEED 15
    MOVE G6A,95,  36, 145,  125, 105, 100
    MOVE G6D,95,  116, 145,  45, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  125, 105, 100
    MOVE G6D,90,  116, 145,  45, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT

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
    MOVE G6A,70, 163,  28, 160, 135
    MOVE G6D,70, 163,  28, 160, 135
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
    MOVE G6A,  70, 165,  28, 162, 135
    MOVE G6D,  70, 165,  28, 162, 135
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    SPEED 6	
    MOVE G6A,  70, 145,  28, 142, 130
    MOVE G6D,  70, 145,  28, 142, 130
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    SPEED 10	
    MOVE G6A,  100, 145,  27, 142, 100
    MOVE G6D,  100, 145,  27, 142, 100
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







    '************************************************
    '************************************************
기어가기:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

    GOSUB GOSUB_RX_EXIT

    'GOTO 기어가기왼쪽턴_LOOP

기어가기_LOOP:


    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  25,  70
    MOVE G6C, 190,  50,  40
    WAIT
    ERX 4800, A, 기어가기_1
    IF A = 8 THEN GOTO 기어가기_1
    IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    GOTO 기어가다일어나기

기어가기_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  25,  70
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 175,  25,  70
    MOVE G6B, 190,  50,  40
    WAIT

    ERX 4800, A, 기어가기_2
    IF A = 8 THEN GOTO 기어가기_2
    IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    GOTO 기어가다일어나기

기어가기_2:
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 160,  25,  70
    MOVE G6B, 190,  25,  70
    WAIT

    GOTO 기어가기_LOOP


    '**********************************
기어가기왼쪽턴:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    SPEED 10
    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6C,175,  20, 80
    MOVE G6B,175,  20, 80
    WAIT

    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

기어가기왼쪽턴_LOOP:

    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6B,175,  70, 20
    MOVE G6C,175,  10, 75
    WAIT	


    ERX 4800, A, 기어가기왼쪽턴_1
    IF A = 8 THEN GOTO 기어가기_LOOP
    IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    IF A = 7 THEN GOTO 기어가기왼쪽턴_1
    GOTO 기어가다일어나기

기어가기왼쪽턴_1:
    MOVE G6A, 100, 155,  110, 100, 110
    MOVE G6D, 100, 155,  110, 100, 110
    MOVE G6B,175,  80, 30
    MOVE G6C,175,  30, 95
    WAIT		


    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6B,175,  15, 75
    MOVE G6C,175,  60, 20
    WAIT		

    ERX 4800, A, 기어가기왼쪽턴_2
    IF A = 8 THEN GOTO 기어가기_LOOP
    IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    IF A = 7 THEN GOTO 기어가기왼쪽턴_2
    GOTO 기어가다일어나기

기어가기왼쪽턴_2:
    MOVE G6A, 100, 155,  110, 100, 110
    MOVE G6D, 100, 155,  110, 100, 110
    MOVE G6B,175,  10, 75
    MOVE G6C,175,  10, 75
    WAIT	

    GOTO 기어가기왼쪽턴_LOOP



    '**********************************

    '**********************************
기어가기오른쪽턴:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    SPEED 10
    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6C,175,  20, 80
    MOVE G6B,175,  20, 80
    WAIT

    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

기어가기오른쪽턴_LOOP:

    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6C,175,  70, 20
    MOVE G6B,175,  10, 75
    WAIT	


    ERX 4800, A, 기어가기오른쪽턴_1
    IF A = 8 THEN GOTO 기어가기_LOOP
    IF A = 9 THEN GOTO 기어가기오른쪽턴_1
    IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP
    GOTO 기어가다일어나기

기어가기오른쪽턴_1:
    MOVE G6A, 100, 155,  110, 100, 110
    MOVE G6D, 100, 155,  110, 100, 110
    MOVE G6C,175,  80, 30
    MOVE G6B,175,  30, 95
    WAIT		


    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6C,175,  15, 75
    MOVE G6B,175,  60, 20
    WAIT		

    ERX 4800, A, 기어가기오른쪽턴_2
    IF A = 8 THEN GOTO 기어가기_LOOP
    IF A = 9 THEN GOTO 기어가기오른쪽턴_2
    IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP
    GOTO 기어가다일어나기

기어가기오른쪽턴_2:
    MOVE G6A, 100, 155,  110, 100, 110
    MOVE G6D, 100, 155,  110, 100, 110
    MOVE G6C,175,  10, 75
    MOVE G6B,175,  10, 75
    WAIT	

    GOTO 기어가기오른쪽턴_LOOP



    '**********************************

    GOTO RX_EXIT
    '**********************************	
기어가다일어나기:
    PTP SETON		
    PTP ALLON
    SPEED 15
    HIGHSPEED SETOFF

    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT

    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10

    GOSUB 기본자세

    GOTO RX_EXIT

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

    MOVE G6A,90, 130, 120,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT



    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
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
    MOVE G6B,105, 160, 190
    MOVE G6C,105, 168, 190
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
    MOVE G6B,105, 160, 190
    MOVE G6C,105, 168, 190
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

    GOSUB GOSUB_RX_EXIT

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

팔동작복사:
    GOSUB Arm_motor_mode3
    SPEED 10
    MOVE G6C,100,  70,  100
    WAIT

    MOTOROFF G6C	'오른팔 모터 풀기
    SPEED 15

    TEMPO 230
    MUSIC "cde"	

    DELAY 1000

팔동작복사_1:

    '오른팔 모터위치값 읽기
    S12 = MOTORIN(12)
    S13 = MOTORIN(13)
    S14 = MOTORIN(14)

    '왼쪽팔 모터값 적용하기
    SERVO 6,S12
    SERVO 7,S13
    SERVO 8,S14

    ''ERX 감지후 리모콘동작으로 전환
    ERX 4800,A,팔동작복사_1
    IF A = 26 THEN
        TEMPO 230
        MUSIC "cdefgab"

        GOSUB MOTOR_ON
        SPEED 5
        GOSUB 기본자세

        GOTO RX_EXIT
    ENDIF	


    GOTO 팔동작복사_1
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
연속댄스1: '
    댄스멈춤 = 0
    GOSUB SOUND_BGM10
    GOSUB 환호성

    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    DELAY 500

    GOSUB 오른발로앉고일어서기

    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    DELAY 500

    GOSUB 왼발로앉고일어서기

    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    DELAY 500

    GOSUB 샹송백댄서2
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    DELAY 500

    GOSUB 복고댄스
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    DELAY 500

    GOSUB 인사3
    GOSUB SOUND_STOP
    GOTO RX_EXIT


    '******************************************
연속댄스2: '80 sec
    댄스멈춤 = 0
    GOSUB SOUND_BGM7
    GOSUB 매트릭스피하기

    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 500

    GOSUB 숨쉬기운동

    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 500

    GOSUB 뽕뽕송댄스

    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    DELAY 500

    GOSUB 날개짓하며일어나기
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    DELAY 500

    GOSUB 비상
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    DELAY 500

    GOSUB 좌우뒤들기댄스
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 500

    GOSUB 인사2
    GOSUB SOUND_STOP
    GOTO RX_EXIT
    '******************************************
종합댄스1: ' sec
    댄스멈춤 = 0
    GOSUB SOUND_종합댄스곡

    GOSUB 인사3	

    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    GOSUB 패배액션2
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 샹송백댄서2
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 복고댄스
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 500

    '*********************
    GOSUB 숨쉬기운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 비행
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 뽕뽕송댄스
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 오른발로앉고일어서기
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 아리랑댄스
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 날개짓하며일어나기
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 매트릭스피하기
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 비상
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 200

    GOSUB 좌우뒤들기댄스
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 300


    GOSUB 물구나무서기
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 500

    GOSUB 인사2


    GOTO RX_EXIT
    '******************************************
종합댄스2:
    댄스멈춤 = 0
    GOSUB SOUND_MUSIC42

    GOSUB 샹송댄스
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 300
    GOSUB 안아주기
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 300
    GOSUB 샹송백댄서2
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 300
    GOSUB 패배액션1
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 300
    GOSUB 아리랑댄스
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 300
    GOSUB 비상
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 300
    GOSUB 주사위게임
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    DELAY 500
    GOSUB 인사3


    GOTO RX_EXIT
    '******************************************
종합댄스3: '
    GOSUB SOUND_BGM5
    GOSUB 샹송댄스
    GOSUB SOUND_STOP

    GOTO RX_EXIT
    '******************************************
종이컵잡기:
    GOSUB All_motor_mode3
    SPEED 8
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    MOVE G6B,190,  30,  80
    MOVE G6C,190,  30,  80
    WAIT

    SPEED 8
    MOVE G6A,100, 143,  28, 135, 190, 100
    MOVE G6D,100, 143,  28, 135, 190, 100
    MOVE G6B,190,  30,  80
    MOVE G6C,190,  30,  80
    WAIT


    DELAY 1000
    SPEED 8
    MOVE G6A,100, 143,  28, 90, 190, 100
    MOVE G6D,100, 143,  28, 90, 190, 100
    MOVE G6B,180,  30,  80
    MOVE G6C,180,  30,  80
    WAIT

    SPEED 8
    MOVE G6B,170,  20,  40
    MOVE G6C,170,  20,  40
    WAIT
    DELAY 500


    SPEED 8
    MOVE G6A,100, 143,  28, 135, 190, 100
    MOVE G6D,100, 143,  28, 135, 190, 100
    MOVE G6B,190,  20,  40
    MOVE G6C,190,  20,  40
    WAIT

    SPEED 6
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    WAIT


    RETURN

    '************************************************
물건집기:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  33, 188,  155, 100
    MOVE G6D,100,  33, 188,  155, 100
    MOVE G6B,185,  35,  80
    MOVE G6C,185,  35,  80
    WAIT

    '**** 잡는간격조절 ************
    MOVE G6B,185,  15,  60
    MOVE G6C,185,  15,  60
    WAIT

    SPEED 4
    MOVE G6A,100,  33, 170,  155, 100
    MOVE G6D,100,  33, 170,  155, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  60, 150,  115, 100
    MOVE G6D,100,  60, 150,  115, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOSUB All_motor_Reset
    물건집은상태 = 1
    RETURN
    '************************************************
    '************************************************
물건놓기:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  35, 170,  155, 100
    MOVE G6D,100,  35, 170,  155, 100
    WAIT

    DELAY 300

    MOVE G6B,185,  40,  80
    MOVE G6C,185,  40,  80
    WAIT

    SPEED 5
    MOVE G6A,100,  65, 150,  105, 100
    MOVE G6D,100,  65, 150,  105, 100
    MOVE G6B,140,  40,  80
    MOVE G6C,140,  40,  80
    WAIT


    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset
    물건집은상태 = 0
    RETURN
    '************************************************
    '******************************************
정면양손펀치:
    HIGHSPEED SETON
    SPEED 7
    MOVE G6A, 92, 100, 110, 100, 107
    MOVE G6D, 92, 100, 110, 100, 107
    MOVE G6B,185, 130,  15
    MOVE G6C,185, 130,  15
    WAIT

    SPEED 10
    MOVE G6B,185, 50,  15
    MOVE G6C,185, 50,  15
    WAIT

    SPEED 13
    FOR I = 0 TO 1
        MOVE G6B,185,  10, 80
        MOVE G6C,185, 80,  10
        WAIT
        DELAY 200
        MOVE G6B,185, 80,  10
        MOVE G6C,185,  10, 80
        WAIT
        DELAY 200

    NEXT I

    MOVE G6A, 92, 100, 113, 100, 107
    MOVE G6D, 92, 100, 113, 100, 107
    MOVE G6B,185, 130,  10
    MOVE G6C,185, 130,  10
    WAIT

    HIGHSPEED SETOFF
    SPEED 12
    MOVE G6A, 102, 100, 113, 100, 98
    MOVE G6D, 102, 100, 113, 100, 98
    MOVE G6B,100,  80,  60
    MOVE G6C,100,  80,  60
    WAIT

    GOSUB 기본자세

    GOTO RX_EXIT
    ''**********************************************

    '******************************************
정면올리기공격:
    HIGHSPEED SETON
    SPEED 7
    MOVE G6A,98,  70, 146,  103, 100
    MOVE G6D,98,  70, 146,  103, 100
    MOVE G6B,133, 30,  80
    MOVE G6C,133, 30,  80
    WAIT

    SPEED 10
    MOVE G6B,133, 15,  70
    MOVE G6C,133, 15,  70
    WAIT

    SPEED 13
    MOVE G6A,98,  77, 146,  73, 100
    MOVE G6D,98,  77, 146,  73, 100
    MOVE G6B,185, 15,  70
    MOVE G6C,185, 15,  70
    WAIT

    HIGHSPEED SETOFF
    DELAY 1000

    SPEED 12
    MOVE G6A,98,  70, 146,  103, 100
    MOVE G6D,98,  70, 146,  103, 100
    MOVE G6B,133, 30,  80
    MOVE G6C,133, 30,  80
    WAIT

    SPEED 10
    GOSUB 기본자세

    GOTO RX_EXIT
    ''**********************************************
    '******************************************
뒷면올리기공격:
    HIGHSPEED SETON
    SPEED 7
    MOVE G6A,98,  79, 146,  83, 100
    MOVE G6D,98,  79, 146,  83, 100
    MOVE G6B,80, 30,  80
    MOVE G6C,80, 30,  80
    WAIT

    SPEED 10
    MOVE G6B,80, 20,  70
    MOVE G6C,80, 20,  70
    WAIT

    SPEED 13
    MOVE G6A,98,  68, 146,  118, 100
    MOVE G6D,98,  68, 146,  118, 100
    MOVE G6B,15, 10,  70
    MOVE G6C,15, 10,  70
    WAIT

    HIGHSPEED SETOFF
    DELAY 1000

    SPEED 12
    MOVE G6A,98,  68, 146,  103, 100
    MOVE G6D,98,  68, 146,  103, 100
    MOVE G6B,80, 30,  80
    MOVE G6C,80, 30,  80
    WAIT

    SPEED 8
    GOSUB 기본자세

    GOTO RX_EXIT
    ''**********************************************
왼손정면공격:
    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,185,  80,  20
    MOVE G6C,50,  40,  80
    WAIT

    SPEED 10
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,185,  80,  20
    MOVE G6C,50,  40,  80
    WAIT
    GOSUB All_motor_Reset
    SPEED 12
    HIGHSPEED SETON

    MOVE G6A,95,  84, 105, 126,  105,
    MOVE G6D, 86, 110, 136,  69, 114,
    MOVE G6B, 189,  30,  80
    MOVE G6C,  50,  40,  80
    WAIT

    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 12
    MOVE G6A,93,  80, 130, 110,  105,
    MOVE G6D, 93, 80, 130,  110, 105,
    MOVE G6B, 100,  40,  80
    MOVE G6C, 100,  40,  80
    WAIT

    SPEED 6
    MOVE G6A,101,  80, 130, 110,  98,
    MOVE G6D, 101, 80, 130,  110, 98,
    MOVE G6B, 100,  40,  80
    MOVE G6C, 100,  40,  80
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOTO RX_EXIT
    ''**********************************************
오른손정면공격:
    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,108,  76, 146,  93,  92
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6B,50,  40,  80
    MOVE G6C,185,  80,  20
    WAIT

    SPEED 10
    MOVE G6A,112,  76, 146,  93, 98
    MOVE G6D, 85,  80, 140, 95, 114
    MOVE G6B,50,  40,  80
    MOVE G6C,185,  80,  20
    WAIT
    GOSUB All_motor_Reset
    SPEED 12
    HIGHSPEED SETON

    MOVE G6A, 86, 110, 136,  69, 114,
    MOVE G6D,95,  84, 105, 126,  105,
    MOVE G6B,  50,  40,  80
    MOVE G6C, 189,  30,  80
    WAIT

    DELAY 1000
    HIGHSPEED SETOFF
    SPEED 12
    MOVE G6A, 93, 80, 130,  110, 105,
    MOVE G6D,93,  80, 130, 110,  105,
    MOVE G6B, 100,  40,  80
    MOVE G6C, 100,  40,  80
    WAIT

    SPEED 6
    MOVE G6A, 101, 80, 130,  110, 98,
    MOVE G6D,101,  80, 130, 110,  98,
    MOVE G6B, 100,  40,  80
    MOVE G6C, 100,  40,  80
    WAIT
    SPEED 10
    GOSUB 기본자세
    GOTO RX_EXIT
    ''**********************************************
왼쪽옆공격:
    HIGHSPEED SETON
    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6D,108,  76, 146,  93,  92
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6C,100,  60,  90, , ,
    MOVE G6B,100,  170,  15, , ,
    WAIT

    GOSUB All_motor_Reset

    SPEED 8
    MOVE G6D,110,  76, 146,  93,  92
    MOVE G6A, 88,  85, 130,  100, 110
    MOVE G6C,100,  60,  90, , ,
    MOVE G6B,100,  170,  45, , ,
    WAIT

    SPEED 13
    MOVE G6D, 63, 76,  160, 85, 130	
    MOVE G6A, 88, 125,  70, 120, 115
    MOVE G6C,100,  70,  100
    MOVE G6B,100, 125, 108
    WAIT


    DELAY 1000
    HIGHSPEED SETOFF
    SPEED 15

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOTO RX_EXIT
    ''**********************************************
오른쪽옆공격:
    HIGHSPEED SETON
    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,108,  76, 146,  93,  92
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6B,100,  60,  90, , ,
    MOVE G6C,100,  170,  15, , ,
    WAIT

    GOSUB All_motor_Reset

    SPEED 8
    MOVE G6A,110,  76, 146,  93,  92
    MOVE G6D, 88,  85, 130,  100, 110
    MOVE G6B,100,  60,  90, , ,
    MOVE G6C,100,  170,  45, , ,
    WAIT

    SPEED 13
    MOVE G6A, 63, 76,  160, 85, 130	
    MOVE G6D, 88, 125,  70, 120, 115
    MOVE G6B,100,  70,  100
    MOVE G6C,100, 125, 108
    WAIT


    DELAY 1000
    HIGHSPEED SETOFF
    SPEED 15

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOTO RX_EXIT
    ''**********************************************
    '**********************************************
왼쪽옆뒤공격:

    HIGHSPEED SETON
    SPEED 12
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,15,  40,  80
    MOVE G6C,115,  40,  80
    WAIT


    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT

    SPEED 12
    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
오른쪽옆뒤공격:


    HIGHSPEED SETON
    SPEED 12
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,115,  40,  80
    MOVE G6C,15,  40,  80
    WAIT


    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 12
    GOSUB 기본자세
    GOTO RX_EXIT


    '************************************************
    '************************************************
가위:
    GOSUB SOUND_가위
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6A,100,  96, 145,  73, 100, 100
    MOVE G6D,100,  56, 145,  113, 100, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    DELAY 1000

    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset
    RETURN

    '************************************************
바위:
    GOSUB SOUND_바위
    GOSUB Leg_motor_mode2
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  60,  50
    MOVE G6C,100,  60,  50
    WAIT

    DELAY 1000

    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset

    RETURN

    '************************************************
보:
    GOSUB SOUND_보
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6A,91,  76, 145,  93, 108
    MOVE G6D,91,  76, 145,  93, 108
    MOVE G6B,100,  40,  90
    MOVE G6C,100,  40,  90
    WAIT

    DELAY 1000

    SPEED 5
    MOVE G6A,101,  76, 145,  93, 98
    MOVE G6D,101,  76, 145,  93, 98
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset
    RETURN


    '************************************************
참참참게임:
    B = RND
    B = B MOD 3

    IF B = 0 THEN
        GOSUB 참참참_왼쪽
    ELSEIF B = 1 THEN
        GOSUB 참참참_오른쪽
    ELSEIF B = 2 THEN
        GOSUB 참참참_정면
    ENDIF
    RETURN
    '***************************************
참참참_왼쪽:
    HIGHSPEED SETON
    SPEED 10
    MOVE G6B, , , , , , 150
    WAIT
    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15
    GOSUB 기본자세
    RETURN
    '***************************************
참참참_오른쪽:
    HIGHSPEED SETON
    SPEED 10
    MOVE G6B, , , , , , 50
    WAIT
    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15 	
    GOSUB 기본자세
    RETURN
    '***************************************
참참참_정면:
    HIGHSPEED SETON
    SPEED 10
    MOVE G6B, , , , , , 110
    WAIT
    MOVE G6B, , , , , , 90
    WAIT	
    MOVE G6B, , , , , , 100
    WAIT	
    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15 	
    GOSUB 기본자세
    RETURN
    '***************************************

청기백기자세:
    GOSUB All_motor_mode3
    SPEED 6
    MOVE G6A,100,  76, 145,  88, 100
    MOVE G6D,100,  76, 145,  88, 100
    MOVE G6B,135,  35,  80
    MOVE G6C,135,  35,  80
    WAIT

    RETURN
    '************************************************

청기왼손올려:
    GOSUB SOUND_청기올려
    SPEED 15
    MOVE G6B,165
    WAIT
    MOVE G6B,135
    WAIT
    RETURN
    '************************************************
청기왼손내려:
    GOSUB SOUND_청기내려
    SPEED 15
    MOVE G6B,105
    WAIT
    MOVE G6B,135
    WAIT
    RETURN
    '************************************************
백기오른손올려:
    GOSUB SOUND_백기올려
    SPEED 15
    MOVE G6C,165
    WAIT
    MOVE G6C,135
    WAIT
    RETURN
    '************************************************
백기오른손내려:
    GOSUB SOUND_백기내려
    SPEED 15
    MOVE G6C,105
    WAIT
    MOVE G6C,135
    WAIT

    RETURN
    '************************************************
주사위게임:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  30, 188,  155, 100
    MOVE G6D,100,  30, 188,  155, 100
    MOVE G6B,185,  30,  80
    MOVE G6C,185,  30,  80
    WAIT

    MOVE G6B,185,  15,  65
    MOVE G6C,185,  15,  65
    WAIT

    SPEED 4
    MOVE G6A,100,  30, 170,  155, 100
    MOVE G6D,100,  30, 170,  155, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  60, 150,  115, 100
    MOVE G6D,100,  60, 150,  115, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  74, 145,  85, 100
    MOVE G6D,100,  74, 145,  85, 100
    WAIT


    TEMP = RND
    TEMP = TEMP MOD 3

    IF TEMP = 0 THEN

        SPEED 4
        MOVE G6B,135,  13,  50
        MOVE G6C,188,  13,  50
        WAIT

        SPEED 15
        MOVE G6C,188,  60,  50
        MOVE G6B,165,  13,  50
        WAIT

    ELSEIF TEMP = 1 THEN

        SPEED 4
        MOVE G6C,135,  13,  50
        MOVE G6B,188,  13,  50
        WAIT

        SPEED 15
        MOVE G6B,188,  60,  50
        MOVE G6C,165,  13,  50
        WAIT

    ELSE

        SPEED 15
        MOVE G6B,188,  50,  65
        MOVE G6C,188,  50,  65
        WAIT

    ENDIF


    DELAY 1000

    SPEED 10
    MOVE G6B,140,  70,  80
    MOVE G6C,140,  70,  80
    WAIT


    SPEED 4
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset
    RETURN
    '************************************************
    '************************************************
컵던지기게임:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  30, 188,  155, 100
    MOVE G6D,100,  30, 188,  155, 100
    MOVE G6B,185,  30,  80
    MOVE G6C,185,  30,  80
    WAIT

    MOVE G6B,185,  15,  60
    MOVE G6C,185,  15,  60
    WAIT

    SPEED 4
    MOVE G6A,100,  30, 170,  155, 100
    MOVE G6D,100,  30, 170,  155, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  60, 150,  115, 100
    MOVE G6D,100,  60, 150,  115, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  74, 145,  85, 100
    MOVE G6D,100,  74, 145,  85, 100
    WAIT

    DELAY 500

    SPEED 10
    MOVE G6B,188,  50,  65
    MOVE G6C,188,  50,  65
    WAIT

    DELAY 1000

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT

    GOSUB All_motor_Reset
    RETURN
    '************************************************

    '************************************************
    '********************************************
    '********************************************

승부차기왼쪽:
    SPEED 10

    '*************
    MOVE G6A,90,  78, 155,  103, 100, 100
    MOVE G6D,90,  66, 140,  83, 100, 100
    WAIT

    DELAY 20	
    SPEED 15
    MOVE G6A,100,  76, 146,  93, 100, 100
    MOVE G6D,100,  76, 146,  93, 100, 100
    WAIT

    DELAY 200	
    '*************
    GOTO RX_EXIT

    '************************************************
    '************************************************

승부차기오른쪽:
    SPEED 10

    '*************
    MOVE G6D,90,  78, 155,  103, 100, 100
    MOVE G6A,90,  66, 140,  83, 100, 100
    WAIT

    DELAY 20	
    SPEED 15
    MOVE G6D,100,  76, 146,  93, 100, 100
    MOVE G6A,100,  76, 146,  93, 100, 100
    WAIT

    DELAY 200	
    '*************
    GOTO RX_EXIT
    '************************************************
    '************************************************
계단왼발오르기3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 110, 100, 114
    MOVE G6D,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6A, 90, 140, 35, 130, 114
    MOVE G6D,113,  73, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6A,  80, 40, 115, 160, 114,
    MOVE G6D,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6A, 105, 70, 100, 160, 100,
    MOVE G6D,80,  90, 165,  70, 100
    MOVE G6B,160,50
    MOVE G6C,160,40
    WAIT

    SPEED 6
    MOVE G6A, 113, 90, 80, 160,95,
    MOVE G6D,70,  95, 165,  65, 105
    MOVE G6B,180,50
    MOVE G6C,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,75,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6A, 114, 90, 110, 130,95,
    MOVE G6D,90,  95, 90,  145, 108
    MOVE G6B,140,50
    MOVE G6C,140,30
    WAIT

    SPEED 10
    MOVE G6A, 110, 90, 110, 130,95,
    MOVE G6D,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN
    '****************************************

계단오른발오르기3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,113,  73, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 40, 115, 160, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 70, 100, 160, 100,
    MOVE G6A,80,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 80, 160,95,
    MOVE G6A,70,  95, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,75,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6D, 114, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN
    '********************************************	

    '************************************************
계단왼발내리기3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,113,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 20, 150, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6A,100, 30, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN
    '****************************************
    '************************************************
계단오른발내리기3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 115, 105, 114
    MOVE G6A,113,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6D,  80, 30, 155, 150, 114,
    MOVE G6A,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6D,  80, 30, 175, 150, 114,
    MOVE G6A,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D,90, 20, 150, 150, 110
    MOVE G6A,110,  155, 35,  120,94
    MOVE G6C,100,50
    MOVE G6B,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6D,100, 30, 150, 150, 100
    MOVE G6A,100,  155, 70,  100,100
    MOVE G6C,140,50
    MOVE G6B,100,40
    WAIT

    SPEED 10
    MOVE G6D,114, 70, 130, 150, 94
    MOVE G6A,80,  125, 140,  85,114
    MOVE G6C,170,50
    MOVE G6B,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6D,114, 70, 130, 150, 94
    MOVE G6A,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6D,114, 75, 130, 120, 94
    MOVE G6A,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6D,112, 80, 130, 110, 94
    MOVE G6A,80,  75,130,  115,114
    MOVE G6C,130,50
    MOVE G6B,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN
    '************************************************
    '************************************************

    '************************************************
왼손옆으로올리기:

    SPEED 15
    MOVE G6B,,100
    WAIT

    GOSUB 기본자세
    RETURN
    '**********************************************
오른손옆으로올리기:
    SPEED 15
    MOVE G6C,,100
    WAIT

    GOSUB 기본자세
    RETURN
    '**********************************************
키퍼왼쪽막기:

    HIGHSPEED SETON
    SPEED 7
    MOVE G6D,65, 85,  120, 110, 90, 100
    MOVE G6A,110, 143,  28, 142, 130, 100
    MOVE G6B,185,  100,  80
    MOVE G6C,185,  100,  80
    WAIT

    DELAY 2000
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB 앉은자세
    SPEED 8
    GOSUB 기본자세


    RETURN
    '**********************************************
키퍼오른쪽막기:

    HIGHSPEED SETON
    SPEED 7
    MOVE G6A,65, 85,  120, 110, 90, 100
    MOVE G6D,110, 143,  28, 142, 130, 100
    MOVE G6B,185,  100,  80
    MOVE G6C,185,  100,  80
    WAIT

    DELAY 2000
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB 앉은자세
    SPEED 8
    GOSUB 기본자세

    RETURN
    '**********************************************
키퍼정면막기:

    HIGHSPEED SETON
    SPEED 7
    MOVE G6A,80, 143,  28, 142, 118, 100
    MOVE G6D,80, 143,  28, 142, 118, 100
    MOVE G6B,100,  60,  80, 100, 100, 100
    MOVE G6C,100,  60,  80, 100, 100, 100
    WAIT

    DELAY 2000
    HIGHSPEED SETOFF
    SPEED 8
    GOSUB 기본자세

    RETURN
    '**********************************************

    '**********************************************

드로윙오른쪽:
    GOSUB All_motor_mode3
    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100
    MOVE G6D,100,  76, 145,  95, 100
    MOVE G6B,100,  185,  110
    MOVE G6C,100,  185,  110
    WAIT

    GOSUB GOSUB_RX_EXIT
드로윙오른쪽_1:
    ERX 4800, A, 드로윙오른쪽_1
    '**** 잡는간격조절 ************
    SPEED 4
    MOVE G6B,,  ,  135
    MOVE G6C,,  ,  135
    WAIT

    DELAY 500
    GOSUB GOSUB_RX_EXIT	

드로윙오른쪽_2:
    ERX 4800, A, 드로윙오른쪽_2
    IF A = 26 THEN
        SPEED 10
        GOSUB 기본자세
        GOSUB All_motor_Reset	
        GOTO RX_EXIT
    ELSEIF A = 4 THEN
        GOTO 드로윙왼쪽_3
    ELSEIF A = 5 THEN
        GOTO 드로윙정면_3
    ELSEIF A = 6 THEN
        GOTO 드로윙오른쪽_3
    ENDIF
드로윙오른쪽_3:
    GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    WAIT

    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    WAIT


    SPEED 6
    MOVE G6A,100,  96, 125,  85, 100
    MOVE G6D,100,  96, 125,  85, 100
    MOVE G6B,135,  ,
    MOVE G6C,135,  ,
    WAIT

    GOSUB All_motor_Reset
    HIGHSPEED SETON

    SPEED 12
    MOVE G6A,100,  66, 145,  115, 100
    MOVE G6D,100,  66, 145,  115, 100
    MOVE G6B,75,  , 125
    MOVE G6C,75,  , 125
    WAIT	

    DELAY 800
    HIGHSPEED SETOFF

    GOSUB All_motor_mode3
    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN
    RETURN
    '**********************************************
드로윙왼쪽:
    GOSUB All_motor_mode3
    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100
    MOVE G6D,100,  76, 145,  95, 100
    MOVE G6B,100,  185,  110
    MOVE G6C,100,  185,  110
    WAIT

    GOSUB GOSUB_RX_EXIT
드로윙왼쪽_1:
    ERX 4800, A, 드로윙왼쪽_1
    '**** 잡는간격조절 ************
    SPEED 4
    MOVE G6B,,  ,  135
    MOVE G6C,,  ,  135
    WAIT

    DELAY 500
    GOSUB GOSUB_RX_EXIT	

드로윙왼쪽_2:
    ERX 4800, A, 드로윙왼쪽_2
    IF A = 26 THEN
        SPEED 10
        GOSUB 기본자세
        GOSUB All_motor_Reset	
        GOTO RX_EXIT
    ELSEIF A = 4 THEN
        GOTO 드로윙왼쪽_3
    ELSEIF A = 5 THEN
        GOTO 드로윙정면_3
    ELSEIF A = 6 THEN
        GOTO 드로윙오른쪽_3
    ENDIF
드로윙왼쪽_3:
    GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6A,100,  76, 145,  93, 100
    WAIT

    SPEED 8
    MOVE G6D,95,  46, 145,  123, 105, 100
    MOVE G6A,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 10
    MOVE G6D,93,  46, 145,  123, 105, 100
    MOVE G6A,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6A,100,  76, 145,  93, 100
    WAIT


    SPEED 6
    MOVE G6A,100,  96, 125,  85, 100
    MOVE G6D,100,  96, 125,  85, 100
    MOVE G6B,135,  ,
    MOVE G6C,135,  ,
    WAIT	
    GOSUB All_motor_Reset
    HIGHSPEED SETON

    SPEED 12
    MOVE G6A,100,  66, 145,  115, 100
    MOVE G6D,100,  66, 145,  115, 100
    MOVE G6B,75,  , 125
    MOVE G6C,75,  , 125
    WAIT	

    DELAY 800
    HIGHSPEED SETOFF

    GOSUB All_motor_mode3
    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN
    RETURN
    '**********************************************
드로윙정면:
    GOSUB All_motor_mode3
    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100
    MOVE G6D,100,  76, 145,  95, 100
    MOVE G6B,100,  185,  110
    MOVE G6C,100,  185,  110
    WAIT

    GOSUB GOSUB_RX_EXIT
드로윙정면_1:
    ERX 4800, A, 드로윙정면_1
    '**** 잡는간격조절 ************
    SPEED 4
    MOVE G6B,,  ,  135
    MOVE G6C,,  ,  135
    WAIT

    DELAY 500
    GOSUB GOSUB_RX_EXIT	

드로윙정면_2:
    ERX 4800, A, 드로윙정면_2
    IF A = 26 THEN
        SPEED 10
        GOSUB 기본자세
        GOSUB All_motor_Reset	
        GOTO RX_EXIT
    ELSEIF A = 4 THEN
        GOTO 드로윙왼쪽_3
    ELSEIF A = 5 THEN
        GOTO 드로윙정면_3
    ELSEIF A = 6 THEN
        GOTO 드로윙오른쪽_3
    ENDIF
드로윙정면_3:
    SPEED 5
    MOVE G6A,100,  96, 125,  85, 100
    MOVE G6D,100,  96, 125,  85, 100
    MOVE G6B,135,  ,
    MOVE G6C,135,  ,
    WAIT

    GOSUB All_motor_Reset
    HIGHSPEED SETON

    SPEED 12
    MOVE G6A,100,  66, 145,  115, 100
    MOVE G6D,100,  66, 145,  115, 100
    MOVE G6B,75,  , 125
    MOVE G6C,75,  , 125
    WAIT	

    DELAY 800
    HIGHSPEED SETOFF

    GOSUB All_motor_mode3
    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN
    '**********************************************
오른쪽으로슈팅:
    GOSUB Leg_motor_mode3
    SPEED 4
    '왼쪽기울기
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6A, 108,  76, 146,  93,  94
    MOVE G6C, 100,40
    MOVE G6B, 100,40
    WAIT

    GOSUB Leg_motor_mode1
    HIGHSPEED SETON
    SPEED 8
    '오른발들기
    MOVE G6D, 80, 95, 115, 105, 140
    MOVE G6A,113,  78, 146,  93,  94
    MOVE G6C, 100,60
    MOVE G6B, 100,60
    WAIT

    DELAY 100
    HIGHSPEED SETOFF
    GOSUB Leg_motor_mode3
    SPEED 8
    '왼쪽기울기2
    MOVE G6A, 106,  76, 146,  93,  96		
    MOVE G6D,  88,  71, 152,  91, 106
    MOVE G6B, 100,35
    MOVE G6C, 100,35
    WAIT	

    GOSUB Leg_motor_mode3
    SPEED 3
    GOSUB 기본자세
    GOSUB Leg_motor_mode1


    RETURN
    '**********************************************
왼쪽으로슈팅:
    GOSUB Leg_motor_mode3
    SPEED 4
    '왼쪽기울기
    MOVE G6A,  88,  71, 152,  91, 110
    MOVE G6D, 108,  76, 146,  93,  94
    MOVE G6B, 100,40
    MOVE G6C, 100,40
    WAIT

    GOSUB Leg_motor_mode1
    HIGHSPEED SETON

    SPEED 8
    MOVE G6A, 80, 95, 115, 105, 140
    MOVE G6D,113,  78, 146,  93,  94
    MOVE G6B, 100,60
    MOVE G6C, 100,60
    WAIT

    DELAY 100
    HIGHSPEED SETOFF
    GOSUB Leg_motor_mode3

    SPEED 8
    MOVE G6D, 106,  76, 146,  93,  96		
    MOVE G6A,  88,  71, 152,  91, 106
    MOVE G6B, 100,35
    MOVE G6C, 100,35
    WAIT	

    GOSUB Leg_motor_mode3
    SPEED 3
    GOSUB 기본자세
    GOSUB Leg_motor_mode1

    RETURN

    '**********************************************
뒤로슈팅:
    IF 보행순서 = 0 THEN
        '오른발
        GOSUB Leg_motor_mode2
        SPEED 4

        MOVE G6A,110,  77, 145,  93,  92, 100	
        MOVE G6D, 85,  71, 152,  91, 114, 100
        MOVE G6C,100,  40,  80, , , ,
        MOVE G6B,100,  40,  80, , , ,	
        WAIT

        SPEED 10
        MOVE G6A,114,  78, 147,  85,  95	
        MOVE G6D, 83,  85, 122,  100, 114
        WAIT


        HIGHSPEED SETON

        SPEED 15
        MOVE G6A,114,  75, 147,  110,  95	
        MOVE G6D, 83,  110, 122,  75, 114
        MOVE G6B,80
        MOVE G6C,120
        WAIT


        DELAY 100
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3

        SPEED 10
        MOVE G6A,114,  74, 147,  97,  95
        MOVE G6D, 83,  85, 122,  105, 114
        MOVE G6C,100,  40,  80, , , ,
        MOVE G6B,100,  40,  80, , , ,	
        WAIT	

        SPEED 8
        MOVE G6A,113,  76, 147,  95,  95	
        MOVE G6D, 80,  76, 142,  95, 114
        MOVE G6C,100,  40,  80, , , ,
        MOVE G6B,100,  40,  80, , , ,
        WAIT	

        SPEED 8
        MOVE G6A,110,  77, 147,  93,  93, 100	
        MOVE G6D, 80,  71, 154,  91, 114, 100
        WAIT


        SPEED 3
        GOSUB 기본자세	
        GOSUB Leg_motor_mode1
        보행순서 = 1
    ELSE
        '왼발
        GOSUB Leg_motor_mode2
        SPEED 4

        MOVE G6D,110,  77, 145,  93,  92, 100	
        MOVE G6A, 85,  71, 152,  91, 114, 100
        MOVE G6B,100,  40,  80, , , ,
        MOVE G6C,100,  40,  80, , , ,	
        WAIT

        SPEED 10
        MOVE G6D,114,  78, 147,  85,  95	
        MOVE G6A, 83,  85, 122,  100, 114
        WAIT


        HIGHSPEED SETON

        SPEED 15
        MOVE G6D,114,  75, 147,  110,  95	
        MOVE G6A, 83,  110, 122,  75, 114
        MOVE G6C,80
        MOVE G6B,120
        WAIT


        DELAY 100
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3

        SPEED 10
        MOVE G6D,114,  74, 147,  97,  95
        MOVE G6A, 83,  85, 122,  105, 114
        MOVE G6B,100,  40,  80, , , ,
        MOVE G6C,100,  40,  80, , , ,	
        WAIT	

        SPEED 8
        MOVE G6D,113,  76, 147,  95,  95	
        MOVE G6A, 80,  76, 142,  95, 114
        MOVE G6B,100,  40,  80, , , ,
        MOVE G6C,100,  40,  80, , , ,
        WAIT	

        SPEED 8
        MOVE G6D,110,  77, 147,  93,  93, 100	
        MOVE G6A, 80,  71, 154,  91, 114, 100
        WAIT


        SPEED 3
        GOSUB 기본자세	
        GOSUB Leg_motor_mode1
        보행순서 = 0
    ENDIF




    RETURN

    '************************************************
RND_MOTION:

    GOSUB All_motor_mode3

RND_MOTION_LOOP:
    'FOR J = 1 TO 반복횟수
    홍보모드방향지시여부 = 0



    SPEED 3
    TEMP = RND
    TEMP = TEMP MOD 80

    S11= 60 + TEMP
    SERVO 11,S11

    '***********
    TEMP = RND
    TEMP = TEMP MOD 30

    SPEED 1

    S6= 90 + TEMP
    TEMP = TEMP MOD 2
    IF TEMP = 0 THEN
        SERVO 6,S6
    ENDIF

    '***********	
    TEMP = RND
    TEMP = TEMP MOD 30

    S12= 90 + TEMP

    TEMP = TEMP MOD 2
    IF TEMP = 0 THEN
        SERVO 12,S12
    ENDIF


    '*********************************	
    FOR I = 1 TO 150
        DELAY 15' 195
        ERX 4800,A ,RND_MOTION_1
        IF A = 26 THEN	' ■
            GOSUB SOUND_STOP
            OUT 52,0
            SPEED 5
            GOSUB 기본자세
            GOSUB All_motor_Reset
            GOSUB 비프음
            RETURN
        ELSEIF A = 21 THEN ' △: 정면
            SPEED 6
            MOVE G6B,160,  25,  70, , ,100
            MOVE G6C,160,  25,  70
            WAIT
            SPEED 8
            MOVE G6B,160,  25,  80, , ,100
            MOVE G6C,160,  25,  80
            WAIT		
            I = 1
            홍보모드방향지시여부 = 1

        ELSEIF A = 15 THEN  ' A: 왼쪽앞
            SPEED 6
            MOVE G6B,160,  70,  70, , ,70
            MOVE G6C,160,  25,  70
            WAIT
            SPEED 8
            MOVE G6B,160,  50,  90, , ,55
            MOVE G6C,160,  15,  40
            WAIT
            I = 1
            홍보모드방향지시여부 = 1

        ELSEIF A = 30 THEN  ' ▷: 오른쪽
            SPEED 6
            MOVE G6C,175,  70,  70
            MOVE G6B,160,  25,  70, , ,140
            WAIT
            SPEED 10
            MOVE G6C,175,  90,  95
            MOVE G6B,175,  15,  20, , ,170
            WAIT
            I = 1
            홍보모드방향지시여부 = 1

        ELSEIF A = 28 THEN 	' ◁: 왼쪽
            SPEED 6
            MOVE G6B,175,  70,  70, , ,60
            MOVE G6C,160,  25,  70
            WAIT
            SPEED 10
            MOVE G6B,175,  90,  95
            MOVE G6C,175,  15,  20, , ,30
            WAIT
            I = 1
            홍보모드방향지시여부 = 1

        ELSEIF A = 20 THEN   ' B: 오른쪽앞
            SPEED 6
            MOVE G6C,160,  70,  70
            MOVE G6B,160,  25,  70, , ,130
            WAIT
            SPEED 8
            MOVE G6C,160,  50,  90
            MOVE G6B,160,  15,  40, , ,145
            WAIT
            I = 1
            홍보모드방향지시여부 = 1

        ELSEIF A = 1 THEN
            GOSUB SOUND_홍보1
        ELSEIF A = 2 THEN
            GOSUB SOUND_홍보2
        ELSEIF A = 3 THEN
            GOSUB SOUND_홍보3
        ELSEIF A = 4 THEN
            GOSUB SOUND_홍보4
        ELSEIF A = 5 THEN
            GOSUB SOUND_홍보5
        ELSEIF A = 6 THEN
            GOSUB SOUND_홍보6
        ELSEIF A = 7 THEN
            GOSUB SOUND_홍보7
        ELSEIF A = 8 THEN
            GOSUB SOUND_홍보8
        ELSEIF A = 9 THEN
            GOSUB SOUND_홍보9
        ENDIF

        GOSUB GOSUB_RX_EXIT


RND_MOTION_1:
        IF I < 10 THEN
            OUT 52,1
        ELSEIF I > 10 THEN
            OUT 52,0
        ENDIF
    NEXT I
    '***********

    IF 홍보모드방향지시여부 = 1 THEN
        SPEED 6
        MOVE G6B,130,  40,  80, , ,100
        MOVE G6C,130,  40,  80
        WAIT

        MOVE G6B,100,  30,  80, , ,100
        MOVE G6C,100,  30,  80
        WAIT
    ENDIF


    GOTO RND_MOTION_LOOP
    '***********************************
    SPEED 3
    GOSUB 기본자세
    GOSUB All_motor_Reset
    GOSUB 비프음

    RETURN

    '************************************************

    '**********************************************
국민체조시작:
    댄스멈춤 = 0

    GOSUB SOUND_국민체조곡
    GOSUB 국민체조_1	'시작

    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN

    GOSUB 국민체조_2	'다리운동

    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_3	'팔운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_4	'머리운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_5 	'가슴운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_6	'옆꾸리운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_7	'등배운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_8 	'몸통운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_9	'온몸운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_10   '뜀뛰기운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_11   '팔다리운동
    GOSUB DANCE_STOP
    IF 댄스멈춤 = 1 THEN GOTO STOP_MAIN
    GOSUB 국민체조_12	'숨고르기



    GOTO RX_EXIT
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
    IF A <> 26 THEN
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
    IF A <> 26 THEN
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
    IF A <> 26 THEN
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
    IF A <> 26 THEN
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
    IF A <> 26 THEN
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
    IF A <> 26 THEN
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
    IF A <> 26 THEN
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
    IF A <> 26 THEN
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
    IF A <> 26 THEN
        GOSUB 비프음
        GOTO 미안한자세_WAIT
    ENDIF

    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN

    '**********************************************

    '***************************************
CODE_EVENT_ALL_STOP:
    PRINT "EVENT_ALL_STOP !"
    PRINT "STOP !"
    SPEED 8
    MOVE G6B,, 40, 90, , , 100
    MOVE G6C,, 40, 90
    WAIT
    SPEED 4
    GOSUB 기본자세
    RETURN

    '**********************************************
    '**********************************************
    '**********************************************
MF소개1분9초:
    PRINT "VOLUME 200 !"

    PRINT "OPEN INFO.MRS !"
    IF info_index = 0 THEN	'KOREA
        PRINT "SOUND 0 !"
        '                     1  2  3   4   5   6   7   8   9  10  11  12  13  14  15
        PRINT "CODE_EVENT 101 1 65 105 165 215 295 370 446 519 575 589 597 606 645 689 !"

    ELSEIF info_index = 1 THEN	'CHIN
        PRINT "SOUND 1 !"
        '                     1  2  3   4   5   6   7   8   9  10  11  12  13  14
        PRINT "CODE_EVENT 101 1 65 105 146 215 310 370 446 519 575 589 597 606 670 !"

    ELSEIF info_index = 2 THEN 'JAPAN
        PRINT "SOUND 2 !"
        '                     1  2  3   4   5   6   7   8   9  10  11  12  13  14
        PRINT "CODE_EVENT 101 1 65 120 146 170 232 336 399 442 522 596 656 !"
    ELSEIF info_index = 3 OR info_index = 4 THEN 'English

        '                     1  2  3   4   5   6   7   8   9  10  11  12  13  14
        PRINT "CODE_EVENT 101 1 65 100 123 185 228 268 371 464 584 625 !" '658 !"
        PRINT "TRS !"'"TIMER_SET !"

        IF info_index = 3 THEN
            PRINT "SOUND 3 !"
        ENDIF
        IF info_index = 4 THEN
            PRINT "SOUND 4 !"
        ENDIF
    ENDIF

MF소개1분9초_LOOP:
	GOSUB 앞뒤기울기측정
    ERX 4800,A,MF소개1분9초_LOOP

    IF A >= 100 THEN
        A_OLD  = A
        A = A - 100
        ON A GOTO MF소개1분9초_LOOP,MF소개1분9초_1,MF소개1분9초_2,MF소개1분9초_3,MF소개1분9초_4,MF소개1분9초_5,MF소개1분9초_6,MF소개1분9초_7,MF소개1분9초_8,MF소개1분9초_9,MF소개1분9초_10,MF소개1분9초_11,MF소개1분9초_12,MF소개1분9초_13,MF소개1분9초_14
        GOTO MF소개1분9초_LOOP
    ELSE
        IF A = 26  THEN
            GOSUB CODE_EVENT_ALL_STOP
            GOSUB MR_SOUND_OPEN
            RETURN
        ELSEIF A = 11  THEN
            PRINT "UP 20 !"
        ELSEIF A = 12  THEN
            PRINT "DOWN 20 !"
        ENDIF
    ENDIF
    GOTO MF소개1분9초_LOOP


    '***************************************
MF소개1분9초_1:

    GOSUB 인사4
    GOSUB 여러분
    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_2:
    GOSUB 소개액션

    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_3:
    IF info_index = 0 THEN 'KOREA
        반복횟수 = 6
    ELSEIF info_index = 1 THEN 'CHIN
        반복횟수 = 4
    ELSEIF info_index = 2 THEN  'JAPAN
        반복횟수 = 2
    ELSEIF info_index = 3 OR info_index = 4   THEN  'English
        GOSUB 연극

        GOTO MF소개1분9초_LOOP
    ENDIF

    GOSUB 소개제자리걸음
    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_4:

    IF info_index = 0 THEN 'KOREA
        반복횟수 = 4
    ELSEIF info_index = 1 THEN 'CHIN
        반복횟수 = 4
    ELSEIF info_index = 2 THEN  'JAPAN
        반복횟수 = 2
    ELSEIF info_index = 3 OR info_index = 4   THEN  'English
        GOSUB 안내원
        DELAY 200
        GOSUB 댄서
        DELAY 200
        GOSUB 마스코드_E
        GOTO MF소개1분9초_LOOP

    ENDIF
    GOSUB 진동보행제자리
    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_5:
    IF info_index = 0 OR info_index = 1 THEN 'KOREA,'CHIN
        GOSUB 전기전자프로그램배움
    ELSEIF info_index = 2 THEN 'JAPAN
        GOSUB 일본17관절이용동작댄스
    ELSEIF info_index = 3 OR info_index = 4   THEN  'English
        반복횟수 = 2
        'DELAY 200
        GOSUB 제자리걸음
        GOSUB 진동보행제자리

    ENDIF
    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_6:
    IF info_index = 0 THEN 'KOREA
        GOSUB 여러분
        GOSUB 댄스액션
        DELAY 250
        GOSUB 올림픽허들
    ELSEIF info_index = 1 THEN 'CHIN
        GOSUB 올림픽허들
        DELAY 250
        GOSUB 댄스액션
    ELSEIF info_index = 2 THEN  'JAPAN
        GOSUB 다음은제메인보드입니다
    ELSEIF info_index = 3 OR info_index = 4   THEN  'English
        GOSUB 전기전자프로그램배움_E

    ENDIF

    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_7:
    IF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB 여러분
        GOSUB 올림픽허들
        DELAY 250
        GOSUB 댄스액션
        GOTO MF소개1분9초_LOOP
    ENDIF
    GOSUB 제가소개하는것처럼
    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_8:

    IF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB 제가소개하는것처럼_E
        GOSUB 어린이를가르키는

        GOTO MF소개1분9초_LOOP
        'GOSUB 마스코드_C
    ENDIF
    GOSUB 제가댄스

    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_9:
    IF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB 저는앞으로국어영어
        GOSUB 제가댄스

        GOTO MF소개1분9초_LOOP
    ENDIF
    GOSUB 저는앞으로국어영어
    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_10:
    IF info_index = 0 OR info_index = 1 THEN'KOREA,'CHIN
        GOSUB 연극
    ELSEIF info_index = 2 THEN 'JAPAN
        GOSUB 연극
        DELAY 300
        GOSUB 안내원
        DELAY 300
        GOSUB 댄서
        DELAY 300
        GOSUB 마스코드
    ELSEIF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB 나는많은목적여러장소
    ENDIF
    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_11:
    IF info_index = 0 OR info_index = 1 THEN'KOREA,'CHIN
        GOSUB 안내원

    ELSEIF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB 많은활동기대
        RETURN
    ENDIF
    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_12:
    IF info_index = 0 OR info_index = 1 THEN'KOREA,'CHIN
        GOSUB 댄서

    ELSEIF info_index = 2 THEN 'JAPAN
        GOSUB 많은활동기대
        GOSUB MR_SOUND_OPEN
        RETURN
    ENDIF
    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_13:
    IF info_index = 0 THEN 'KOREA
        GOSUB 마스코드
    ELSEIF info_index = 1 THEN 'CHIN
        GOSUB 마스코드_C
    ELSEIF info_index = 2 THEN  'JAPAN

    ENDIF

    GOTO MF소개1분9초_LOOP
    '*********
MF소개1분9초_14:
    IF info_index = 0 THEN 'KOREA
        GOSUB 많은활동기대
    ELSEIF info_index = 1 THEN 'CHIN
        GOSUB 많은활동기대_C
    ELSEIF info_index = 2 THEN  'JAPAN

    ENDIF

    GOSUB MR_SOUND_OPEN
    RETURN

    GOTO MF소개1분9초_LOOP
    '*********


    '***************************************
인사4:
    GOSUB All_motor_mode3

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  60,  80
    MOVE G6B,160,  35,  80
    WAIT

    SPEED 12
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

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,140,  40,  80
    WAIT

    SPEED 12
    GOSUB 기본자세

    RETURN
    '***************************************
여러분:
    GOSUB All_motor_mode3

    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,140,  30,  80
    MOVE G6C,140,  30,  80
    WAIT
    DELAY 400

    SPEED 3
    MOVE G6B,160,  90,  90, , ,60
    MOVE G6C,160,  90,  90
    WAIT

    DELAY 600
    SPEED 8
    GOSUB 기본자세
    RETURN


    '***************************************
댄스액션:
    GOSUB All_motor_mode3

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  55,  40
    MOVE G6C,100,  55,  40
    WAIT

    SPEED 6
    MOVE G6A,98, 88, 122, 105, 117
    MOVE G6D,101, 67, 162, 86, 83
    MOVE G6B,100,  60,  40
    MOVE G6C,100,  35,  50
    WAIT

    DELAY 100

    SPEED 8
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6C,100,  60,  40
    MOVE G6B,100,  35,  50
    WAIT
    RETURN
    '***************************************
소개액션:

    GOSUB 댄스액션

    DELAY 800

    SPEED 8
    MOVE G6A,98, 88, 122, 105, 117
    MOVE G6D,101, 67, 162, 86, 83
    MOVE G6B,100,  80,  15, , ,150
    MOVE G6C,100,  130,  100
    WAIT

    DELAY 1000

    '***************

    SPEED 12
    GOSUB 기본자세



    RETURN
    '*******************************************
    '******************************************
소개제자리걸음:
    넘어진확인 = 0
    '    GOSUB Arm_motor_mode3
    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,2,3,3,3,2
    MOTORMODE G6D,2,3,3,3,2

    MOVE G6B,,35
    MOVE G6C,,35
    WAIT
    I = 0
소개제자리걸음_1:

    SPEED 4
    MOVE G6A,105,  76, 146,  93, 98, 100
    MOVE G6D,90,  73, 151,  90, 108, 100
    WAIT

    SPEED 12
    MOVE G6A,113,  76, 146,  93, 98, 100
    MOVE G6D,85,  100, 95,  120, 112, 100
    MOVE G6B,120 , , , , ,90
    MOVE G6C,80
    WAIT

    'GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        RETURN
    ENDIF

    SPEED 10
    MOVE G6A,109,  76, 146,  93, 97, 100
    MOVE G6D,90,  76, 148,  92, 110, 100
    WAIT

    SPEED 4	
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100	
    WAIT

    I = I + 1
    'ERX 4800,A, 제자리걸음_2
    IF I >= 반복횟수 THEN
        SPEED 5
        GOSUB 기본자세
        RETURN
    ENDIF

소개제자리걸음_2:
    '***********************************
    SPEED 4
    MOVE G6D,105,  76, 146,  93, 98, 100
    MOVE G6A,90,  73, 151,  90, 108, 100
    WAIT	

    SPEED 12
    MOVE G6D,113,  76, 146,  93, 98, 100
    MOVE G6A,85,  100, 95,  120, 112, 100
    MOVE G6C,120
    MOVE G6B,80 , , , , ,110
    WAIT	

    ' GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        RETURN
    ENDIF

    SPEED 10
    MOVE G6D,109,  76, 146,  93, 97, 100
    MOVE G6A,90,  76, 148,  92, 110, 100
    WAIT	

    SPEED 4		
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100	
    WAIT	
    I = I + 1
    'ERX 4800,A, 제자리걸음_1
    IF I >= 반복횟수 THEN
        SPEED 5
        GOSUB 기본자세
        RETURN
    ENDIF

    GOTO 소개제자리걸음_1


    RETURN
    '**********************************************	
    '************************************************
진동보행제자리:
    MOTORMODE G6A,3,2,2,2,3
    MOTORMODE G6D,3,2,2,2,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    SPEED 10
    GOSUB 진동보행제자리_초기자세

    HIGHSPEED SETON
    SPEED 15
    MOVE G6A,95,  110, 87,  120, 100, 100
    MOVE G6D,103,  110, 87,  120, 100, 100
    MOVE G6B,100,  35,  80, , ,100
    MOVE G6C,100,  35,  80
    WAIT


    SPEED 12
    FOR I = 1 TO 반복횟수
        MOVE G6D,103,  110, 89,  120, 98, 100
        MOVE G6A,95,  120, 67,  125, 105, 100
        MOVE G6C,120
        MOVE G6B,80
        WAIT

        MOVE G6D,98,  110, 88,  120, 102, 100
        MOVE G6A,101,  110, 88,  120, 102, 100
        WAIT

        MOVE G6A,103,  110, 89,  120, 98, 100
        MOVE G6D,95,  120, 67,  125, 105, 100
        MOVE G6B,120
        MOVE G6C,80
        WAIT

        MOVE G6A,98,  110, 88,  120, 102, 100
        MOVE G6D,101,  110, 88,  120, 102, 100
        WAIT

    NEXT I


    SPEED 15
    GOSUB 진동보행제자리_초기자세
    DELAY 200
    HIGHSPEED SETOFF
    GOSUB Arm_motor_mode3
    SPEED 10
    GOSUB 기본자세
    RETURN
    '************************************************
진동보행제자리_초기자세:
    MOVE G6A,100,  110, 87,  120, 100, 100
    MOVE G6D,100,  110, 87,  120, 100, 100
    MOVE G6B,100,  35,  80, , ,100
    MOVE G6C,100,  35,  80
    WAIT
    RETURN
    '************************************************
전기전자프로그램배움:
    GOSUB 전기전자프로그램배움_1
    DELAY 1200

    GOSUB 전기전자프로그램배움_2
    DELAY 200


    SPEED 6
    FOR I = 1 TO 2
        MOVE G6A,100,  76, 145,  88, 100, 100
        MOVE G6D,100,  76, 145,  88, 100, 100
        MOVE G6C,190,  20,  80
        MOVE G6B,170,  20,  80, , ,100
        WAIT

        MOVE G6C,170,  20,  80
        MOVE G6B,190,  20,  80
        WAIT
    NEXT I

    GOSUB 전기전자프로그램배움_3

    RETURN
    '***************************************
전기전자프로그램배움_1:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    RETURN
    '***************************************
전기전자프로그램배움_2:
    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  85,  90, , ,70
    WAIT
    DELAY 200

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,160,  85,  90
    MOVE G6B,160,  85,  90, , ,130
    WAIT

    RETURN
    '***************************************
전기전자프로그램배움_3:
    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  50,  80, , ,130
    MOVE G6C,80,  170,  180
    WAIT
    DELAY 100

    SPEED 3
    MOVE G6B,100,  50,  80, , ,70
    MOVE G6C,80,  150,  190
    WAIT
    DELAY 100

    SPEED 10
    GOSUB 기본자세

    RETURN
    '***************************************
전기전자프로그램배움_E:
    GOSUB 전기전자프로그램배움_1
    DELAY 300
    GOSUB 전기전자프로그램배움_2
    GOSUB 전기전자프로그램배움_3
    RETURN
    '************************************************
일본17관절이용동작댄스:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 50

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  85,  90, , ,70
    WAIT
    DELAY 50

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,160,  85,  90
    MOVE G6B,160,  85,  90, , ,130
    WAIT
    DELAY 50


    SPEED 10
    FOR I = 1 TO 2
        MOVE G6A,100,  76, 145,  88, 100, 100
        MOVE G6D,100,  76, 145,  88, 100, 100
        MOVE G6C,190,  20,  80
        MOVE G6B,170,  20,  80, , ,100
        WAIT

        MOVE G6C,170,  20,  80
        MOVE G6B,190,  20,  80
        WAIT
    NEXT I

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  50,  80, , ,130
    MOVE G6C,80,  170,  180
    WAIT
    DELAY 50

    SPEED 8
    MOVE G6B,100,  50,  80, , ,70
    MOVE G6C,80,  150,  190
    WAIT

    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  55,  40
    MOVE G6C,100,  55,  40
    WAIT

    SPEED 6
    MOVE G6A,98, 88, 122, 105, 117
    MOVE G6D,101, 67, 162, 86, 83
    MOVE G6B,100,  60,  40
    MOVE G6C,100,  35,  50
    WAIT

    DELAY 50

    SPEED 8
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6C,100,  60,  40
    MOVE G6B,100,  35,  50
    WAIT
    RETURN

    '***************************************
다음은제메인보드입니다:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세

    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세2
    DELAY 700

    SPEED 12
    MOVE G6C,40,  150,  190
    MOVE G6B,40,  150,  190, , ,100
    WAIT
    DELAY 400

    SPEED 6
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,40,  170,  120
    MOVE G6B,40,  170,  120, , ,100
    WAIT

    DELAY 400

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,80,  160,  190
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 400
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 100
    SPEED 8
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  130,  120, , , 70
    WAIT

    DELAY 400
    SPEED 8
    MOVE G6C,160,  40,  25
    MOVE G6B,160,  40,  25, , ,100
    WAIT
    DELAY 200
    SPEED 4
    GOSUB 제가소개하는것처럼_초기자세2
    DELAY 200
    SPEED 6
    GOSUB 기본자세

    RETURN



    '***************************************
    '***************************************
올림픽허들:
    GOSUB All_motor_mode3


    SPEED 12
    MOVE G6A,100,  54, 145,  145, 100, 100
    MOVE G6D,100,  54, 145,  145, 100, 100
    MOVE G6B,50,  40,  90, , ,110
    MOVE G6C,190,  40,  90
    WAIT
    DELAY 100

    SPEED 15
    MOVE G6C,50,  40,  90
    MOVE G6B,190,  40,  90, , ,90
    WAIT
    DELAY 100

    SPEED 10
    GOSUB 기본자세
    RETURN

    '***************************************
제가소개하는것처럼:
    GOSUB All_motor_mode3
    SPEED 12
    GOSUB 제가소개하는것처럼_초기자세

    SPEED 10
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 700

    SPEED 8
    MOVE G6C,180,  25,  80
    MOVE G6B,180,  25,  80
    WAIT
    DELAY 400

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,80,  160,  190
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 400
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 100
    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세
    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 50
    SPEED 4
    GOSUB 제가소개하는것처럼_초기자세2
    DELAY 100
    SPEED 10
    GOSUB 기본자세

    RETURN
    '***************************************
    '***************************************
제가소개하는것처럼_E:
    GOSUB All_motor_mode3
    SPEED 12
    GOSUB 제가소개하는것처럼_초기자세

    SPEED 10
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 300

    SPEED 8
    MOVE G6C,180,  25,  80
    MOVE G6B,180,  25,  80
    WAIT
    DELAY 300

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,80,  160,  190
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 200
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 100
    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세
    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 50
    SPEED 6
    GOSUB 제가소개하는것처럼_초기자세2
    DELAY 100
    SPEED 10
    GOSUB 기본자세

    RETURN
    '***************************************
제가소개하는것처럼_초기자세:
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,160,  30,  80
    MOVE G6B,160,  30,  80
    WAIT
    RETURN

    '***************************************
제가소개하는것처럼_초기자세2:
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,160,  90,  90, , ,60
    MOVE G6C,160,  90,  90
    WAIT
    RETURN

    '***************************************
제가댄스:
    GOSUB All_motor_mode3
    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,160,  30,  80
    MOVE G6B,100,  30,  80, , , 120
    WAIT

    SPEED 10
    MOVE G6C,170,  20,  10
    MOVE G6B,100,  30,  80
    WAIT
    DELAY 100
    SPEED 12
    MOVE G6C,130,  30,  80
    WAIT
    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  55,  40
    MOVE G6C,100,  55,  40
    WAIT

    SPEED 10

    SERVO 11,70
    GOSUB 제가댄스_자세1

    GOSUB 제가댄스_자세2

    SERVO 11,130
    GOSUB 제가댄스_자세1

    GOSUB 제가댄스_자세2


    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  160,  150
    MOVE G6B,100,  160,  150, , , 120
    WAIT

    SPEED 12
    FOR I = 1 TO 2

        SERVO 11,80
        GOSUB 제가댄스_자세3


    NEXT I

    FOR I = 1 TO 2
        SERVO 11,120
        GOSUB 제가댄스_자세3

    NEXT I
    DELAY 100
    SPEED 15
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6C,80,  170,  180
    MOVE G6B,100,  120,  100, , ,150
    WAIT

    DELAY 600

    SPEED 10
    GOSUB 기본자세

    RETURN
    '***************************************
제가댄스_자세1:
    MOVE G6A,100,  110, 87,  120, 100, 100
    MOVE G6D,100,  110, 87,  120, 100, 100
    WAIT

    RETURN
    '***************************************
제가댄스_자세2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    RETURN
    '***************************************
제가댄스_자세3:
    MOVE G6C,100,  130,  130
    MOVE G6B,100,  130,  130
    WAIT

    MOVE G6C,100,  160,  150
    MOVE G6B,100,  160,  150
    WAIT

    RETURN
    '***************************************
저는앞으로국어영어:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 800

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  85,  90, , ,130
    WAIT
    DELAY 400

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,190,  85,  90
    MOVE G6B,190,  85,  90, , ,70
    WAIT
    DELAY 400

    SPEED 4
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    MOVE G6C,180,  20,  10
    MOVE G6B,190,  25,  25, , ,130
    WAIT

    RETURN

    '***************************************
어린이를가르키는:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 300

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  85,  90, , ,130
    WAIT
    DELAY 100

    SPEED 10
    MOVE G6A,100,  76, 160,  58, 100, 100
    MOVE G6D,100,  76, 160,  58, 100, 100
    MOVE G6C,190,  85,  90
    MOVE G6B,190,  85,  90, , ,70
    WAIT
    DELAY 100

    SPEED 8
    MOVE G6A,100,  76, 125,  125, 100, 100
    MOVE G6D,100,  76, 125,  125, 100, 100
    MOVE G6C,180,  20,  10
    MOVE G6B,190,  25,  25, , ,130
    WAIT

    RETURN

    '***************************************
연극:
    SPEED 15
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6C,60,  170,  180
    MOVE G6B,100,  60,  100, , ,150
    WAIT

    RETURN

안내원:
    HIGHSPEED SETON
    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,190,  95,  95, , ,70
    MOVE G6C,180,  15,  15
    WAIT
    HIGHSPEED SETOFF
    RETURN
댄서:
    SPEED 15
    MOVE G6A,98, 88, 122, 105, 117
    MOVE G6D,101, 67, 162, 86, 83
    MOVE G6B,100,  85,  20, , ,100
    MOVE G6C,100,  60,  30
    WAIT

    RETURN
    '***************************************
마스코드:
    SPEED 15
    GOSUB 마스코드_1

    DELAY 2000

    SPEED 10
    GOSUB 마스코드_2
    DELAY 500

    SPEED 4
    GOSUB 마스코드_3

    MOVE G6B,,  ,  , , ,70
    WAIT

    SPEED 12
    GOSUB 기본자세
    RETURN
    '***************************************
마스코드_1:
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6B,70,  160,  190, , ,50
    MOVE G6C,70,  160,  190
    WAIT
    RETURN
    '***************************************
마스코드_2:
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    MOVE G6B,180,  20,  10, , ,70
    MOVE G6C,190,  20,  20
    WAIT
    RETURN
    '***************************************
마스코드_3:
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    MOVE G6B,190,  90,  90, , ,130
    MOVE G6C,190,  90,  90
    WAIT
    RETURN
    '***************************************
마스코드_C:
    SPEED 15
    GOSUB 마스코드_1

    DELAY 1000

    SPEED 10
    GOSUB 마스코드_2
    DELAY 500

    SPEED 4
    GOSUB 마스코드_3

    DELAY 500
    MOVE G6B,,  ,  , , ,70
    WAIT
    DELAY 1000
    SPEED 12
    GOSUB 기본자세
    RETURN
    '***************************************
마스코드_E:
    SPEED 15
    GOSUB 마스코드_1

    DELAY 150

    SPEED 10
    GOSUB 마스코드_2
    DELAY 1500

    SPEED 5
    GOSUB 마스코드_3

    DELAY 100
    SPEED 8
    MOVE G6B,,  ,  , , ,70
    WAIT
    'DELAY 500
    SPEED 14
    GOSUB 기본자세
    RETURN
    '***************************************
나는많은목적여러장소:

    GOSUB All_motor_mode3
    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세

    SPEED 12
    GOSUB 제가소개하는것처럼_초기자세2
    DELAY 100

    SPEED 12
    MOVE G6C,40,  150,  190
    MOVE G6B,40,  150,  190, , ,100
    WAIT
    DELAY 100

    SPEED 6
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,40,  170,  120
    MOVE G6B,40,  170,  120, , ,100
    WAIT

    DELAY 100

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,80,  160,  190
    MOVE G6B,80,  160,  190, , , 130
    WAIT

    DELAY 100
    SPEED 10
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  130,  120, , , 70
    WAIT

    DELAY 100
    SPEED 8
    MOVE G6C,160,  40,  25
    MOVE G6B,160,  40,  25, , ,100
    WAIT
    SPEED 10
    GOSUB 제가소개하는것처럼_초기자세2


    RETURN

    '***************************************

많은활동기대:

    GOSUB 많은활동기대_1

    DELAY 500

    SPEED 5
    GOSUB 많은활동기대_2

    DELAY 1000

    GOSUB 많은활동기대_3

    RETURN
    '***************************************
많은활동기대_1:
    GOSUB All_motor_mode3
    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,140,  30,  80
    MOVE G6B,140,  30,  80, , ,100
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,140,  30,  30
    MOVE G6B,140,  30,  30, , ,130
    WAIT
    RETURN
    '***************************************
많은활동기대_2:
    MOVE G6A,100,  55, 145,  145, 100, 100
    MOVE G6D,100,  55, 145,  145, 100, 100
    MOVE G6C,150,  30,  25
    MOVE G6B,150,  30,  25,
    WAIT
    RETURN
    '***************************************
많은활동기대_3:
    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,140,  30,  30
    MOVE G6B,140,  30,  30, , ,100
    WAIT

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,120,  30,  80
    MOVE G6B,120,  30,  80, , ,100
    WAIT

    SPEED 6
    GOSUB 기본자세
    RETURN
    '***************************************
    '***************************************
많은활동기대_C:
    GOSUB 많은활동기대_1

    SPEED 6
    GOSUB 많은활동기대_2
    DELAY 1000

    GOSUB 많은활동기대_3

    RETURN



    '***************************************
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


    GOSUB 모터ONOFF_LED

    ERX 4800,A,MAIN
    A_old = A

    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************
    '*******************************************

KEY1:
    IF Action_mode  = 0 THEN '댄스모드
        info_index = 0	'KOREA
        GOSUB MF소개1분9초
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOSUB 인사1
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 가위
        ENDIF

    ELSEIF  Action_mode  = 3 THEN ' 축구모드

        IF 자세 = 0 THEN
            GOSUB 키퍼왼쪽막기
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB 계단왼발오르기3cm
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN
            GOSUB 비상자세
        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 자세 = 0 THEN

            GOSUB SOUND_홍보1
            GOSUB RND_MOTION
        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY2:
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            info_index = 1 ''CHIN
            GOSUB MF소개1분9초
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOSUB 인사2
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN	
            GOSUB 바위
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN	
            GOSUB 키퍼정면막기
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 자세 = 0 THEN
            IF 물건집은상태 = 0 THEN
                GOTO 전진종종걸음
            ELSE
                GOTO 집고달리기
            ENDIF
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN
            GOSUB 파이터자세
        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 AND 자세 = 0 THEN

            GOSUB SOUND_홍보2
            GOSUB RND_MOTION
        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY3:
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN	
            info_index = 2 'JAPAN
            GOSUB MF소개1분9초
        ENDIF

    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOSUB 덤벼액션
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 보
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOSUB 키퍼오른쪽막기
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB 계단오른발오르기3cm
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN
            GOSUB 옆찌르기자세
        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨

        IF 자세 = 0 THEN
            GOSUB SOUND_홍보3
            GOSUB RND_MOTION

        ENDIF
    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY4:
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            info_index = 3 'English
            GOSUB MF소개1분9초
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOSUB 승리세레모니1
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 청기왼손올려
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOSUB 드로윙왼쪽
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB 계단왼발내리기3cm
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN
            GOSUB 한발들기자세
        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB SOUND_홍보4
            GOSUB RND_MOTION
        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY5:
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            'GOSUB 복고댄스	'13초
            GOSUB 비상	'24초
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOSUB 승리세레모니2
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 참참참게임
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOSUB 드로윙정면
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB 주사위게임
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN
            GOSUB 공차기자세
        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB SOUND_홍보5
            GOSUB RND_MOTION
        ENDIF

    ENDIF
    GOTO RX_EXIT
    '*******************************************
KEY6:
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 샹송백댄서2	'11초
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOSUB 승리세레모니3
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 백기오른손올려
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOSUB 드로윙오른쪽
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB 계단오른발내리기3cm
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN
            GOSUB 비전자세
        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB SOUND_홍보6
            GOSUB RND_MOTION
        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY7:
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 숨쉬기운동	'6초
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOSUB 패배액션1
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 청기왼손내려
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 왼쪽턴10
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOTO 기어가기왼쪽턴
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN
            GOSUB 복고댄스자세
        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB SOUND_홍보7
            GOSUB RND_MOTION
        ENDIF
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY8:
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 좌우뒤들기댄스	'12초
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOSUB 안아주기
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 주사위게임
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 전진보행50
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOTO 기어가기
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN
            GOSUB 보행자세
        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB SOUND_홍보8
            GOSUB RND_MOTION
        ENDIF
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY9:

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 날개짓하며일어나기	'7초
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOSUB 패배액션2
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 백기오른손내려
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 오른쪽턴10
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOTO 기어가기오른쪽턴
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN
            GOSUB 미안한자세
        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB SOUND_홍보9
            GOSUB RND_MOTION
        ENDIF	

    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY10: '0

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 뽕뽕송댄스	'12초
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 정면양손펀치
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 컵던지기게임
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 전진종종걸음
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 자세 = 0 THEN
            IF 물건집은상태 = 0 THEN
                GOSUB  물건집기
            ELSE
                GOSUB 물건놓기
            ENDIF
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF  자세 = 0 THEN

        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY11: ' ▲

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOTO 전진보행50
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 전진달리기50
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 전진달리기50
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 전진달리기50
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 전진달리기50
            ELSE
                GOTO 전진앉아보행
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고달리기			
            ELSE
                GOTO 전진앉아보행
            ENDIF		
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF  자세 = 0 THEN
            IF 물건집은상태 = 2 THEN
                GOTO 안내장들고전진보행50
            ELSE
                GOTO 전진보행50
            ENDIF
        ENDIF

    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY12: ' ▼

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOTO 후진보행50
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 후진달리기40
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 후진달리기40
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 후진달리기40
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 후진달리기40
            ELSE
                GOTO 후진앉아보행
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고후진걸음
            ELSE
                GOTO 후진앉아보행
            ENDIF		
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF  자세 = 0 AND 물건집은상태 = 0 THEN
            GOTO 후진보행50
        ENDIF

    ENDIF



    GOTO RX_EXIT
    '*******************************************
KEY13: '▶

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 천천히오른쪽옆으로50
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 오른쪽옆으로70
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 오른쪽옆으로70
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 오른쪽옆으로70
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 오른쪽옆으로70	
            ELSE
                GOTO 앉아오른쪽옆으로
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고오른쪽옆으로70	
            ELSE
                GOTO 앉아오른쪽옆으로
            ENDIF		
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOSUB 천천히오른쪽옆으로50
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고오른쪽옆으로20
            ENDIF		
        ENDIF
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY14: ' ◀

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB  천천히왼쪽옆으로50
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 왼쪽옆으로70
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 왼쪽옆으로70
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 왼쪽옆으로70
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 왼쪽옆으로70	
            ELSE
                GOTO 앉아왼쪽옆으로
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고왼쪽옆으로70	
            ELSE
                GOTO 앉아왼쪽옆으로
            ENDIF		
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨

        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOSUB 천천히왼쪽옆으로50
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고왼쪽옆으로20
            ENDIF		
        ENDIF
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY15: ' A

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            PRINT "DATEPLAY !"
            DELAY 500
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 왼손정면공격
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 왼발공차기
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOSUB 왼발공차기
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB 왼발공차기
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 자세 = 0 THEN

        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY16: ' POWER
    PRINT "OPEN MRSOUND.mrs !"
    GOSUB MOTOR_OFF
    GOSUB GOSUB_RX_EXIT

KEY16_1:

    GOSUB 모터ONOFF_LED	

    ERX 4800,A,KEY16_1
    GOSUB SOUND_STOP
    '**** 액션모드변환 및 모터켜기 ****
    IF 모터ONOFF = 1 AND A <> 16 THEN
        GOSUB MOTOR_FAST_ON
        GOSUB All_motor_mode3
    ENDIF
    IF A = 16 THEN		'POWER 버튼:현재자세에서 모터 켜기
        IF 모터ONOFF = 1 THEN
            GOSUB MOTOR_ON
        ELSE
            GOSUB MOTOR_OFF
        ENDIF
    ELSEIF A = 27 OR A = 1 THEN	'D 버튼:댄스모드
        Action_mode  = 0
        GOSUB SOUND_댄스모드
        SPEED 10
        MOVE G6B,, 50, 90
        MOVE G6C,, 50, 90
        WAIT

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100, 70, 30, , , 100
        MOVE G6C,100, 70, 30
        WAIT
        'GOSUB 엔터테이먼트음
    ELSEIF A = 32 OR A = 2 THEN	'F 버튼:파이트모드
        Action_mode  = 1
        GOSUB SOUND_격투모드
        SPEED 10
        MOVE G6B,, 60, 90
        MOVE G6C,, 60, 90
        WAIT     	

        SPEED 8
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,188, 15, 20, , , 100
        MOVE G6C,188, 20, 90
        WAIT
        'GOSUB 파이트음
    ELSEIF A = 23 OR A = 3 THEN	'G 버튼:게임모드
        Action_mode  = 2
        GOSUB SOUND_게임모드
        SPEED 10
        MOVE G6B,, 60, 90
        MOVE G6C,, 60, 90
        WAIT     	

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,170, 20, 80, , , 100
        MOVE G6C,140, 20, 80
        WAIT
        'GOSUB 게임음
    ELSEIF A = 20 OR A = 4 THEN	'B 버튼:축구모드
        Action_mode  = 3
        GOSUB SOUND_축구모드
        SPEED 10
        MOVE G6B,, 60, 90
        MOVE G6C,, 60, 90
        WAIT     	

        SPEED 10
        MOVE G6A,93,  76, 145,  93, 105, 100
        MOVE G6D,105,  76, 145,  93, 96, 100
        MOVE G6B,70, 35, 80, , , 100
        MOVE G6C,140, 35, 80
        WAIT
        'GOSUB 축구게임음
    ELSEIF A = 18 OR A = 5 THEN	'E 버튼:장애물경주모드
        Action_mode  = 4
        GOSUB SOUND_장애물경주모드
        SPEED 10
        MOVE G6B,, 60, 90
        MOVE G6C,, 60, 90
        WAIT     	

        SPEED 6
        MOVE G6A,100,  71, 145,  113, 100, 100
        MOVE G6D,100,  71, 145,  113, 100, 100
        MOVE G6B,70, 25, 80, , , 100
        MOVE G6C,70, 25, 80
        WAIT
        'GOSUB 장애물게임음
    ELSEIF A = 17 OR A = 6 THEN ' C: 카메라모드
        Action_mode  = 5
        GOSUB SOUND_카메라모드
        SPEED 10
        MOVE G6B,100, 60, 90
        MOVE G6C,100, 60, 90
        WAIT     	

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,140, 30, 30, , , 80
        MOVE G6C,140, 30, 30
        WAIT
    ELSEIF A = 15 OR A = 7 THEN	'A 버튼: MF홍보맨
        Action_mode  = 6
        GOSUB SOUND_홍보모드
        SPEED 10
        MOVE G6B,, 55, 90
        MOVE G6C,, 55, 90
        WAIT     	

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,160, 70, 90, , , 60
        MOVE G6C,180, 30, 20
        WAIT
        'GOSUB 시작음

    ELSEIF A = 26 THEN	'■ 버튼:액션모드변경 종료
        GOSUB MOTOR_FAST_ON
        SPEED 5
        MOVE G6A,97,  76, 145,  93, 102, 100
        MOVE G6D,97,  76, 145,  93, 102, 100
        WAIT
        SPEED 8
        MOVE G6B,, 50, 90, , , 100
        MOVE G6C,, 50, 90
        WAIT
        GOSUB 기본자세
        'GOSUB 시작음

        GOSUB All_motor_Reset
        GOSUB SOUND_MODE_SELECT
        GOTO RX_EXIT


    ELSEIF A = 21 THEN 	' △버튼: 소리 켜기
        GOSUB SOUND_ALL_ON_MSG
    ELSEIF A = 31 THEN  ' ▽버튼: 소리 끄기
        GOSUB SOUND_ALL_OFF_MSG
    ELSEIF A = 30 THEN  ' ▷버튼: 볼륨업
        GOSUB SOUND_BGM2
        GOSUB SOUND_UP
        GOSUB 비프음
    ELSEIF A = 28 THEN  ' ◁버튼: 볼륨다운
        GOSUB SOUND_BGM2
        GOSUB SOUND_DOWN		
        GOSUB 비프음
    ELSE
        GOSUB 비프음
    ENDIF

    GOSUB GOSUB_RX_EXIT

    GOTO KEY16_1

    GOTO RX_EXIT

    '*******************************************
KEY17: ' C

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOTO 연속댄스1
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 왼쪽옆뒤공격
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 승부차기왼쪽
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOSUB 왼쪽으로슈팅
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOTO 승부차기왼쪽
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 AND 자세 = 0 THEN

        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY18: ' E
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOTO 종합댄스1

        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 왼쪽옆으로20
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 왼손옆으로올리기
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 승부차기왼쪽
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        GOSUB 뒤로일어나기
        GOTO RX_EXIT
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 AND 자세 = 0 THEN

        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************


KEY19: ' P2

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOTO 오른쪽턴45
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 오른쪽턴60
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 오른쪽턴45
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 오른쪽턴45
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 오른쪽턴45	
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고오른쪽턴45		
            ENDIF		
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 오른쪽턴20	
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고오른쪽턴20		
            ENDIF		
        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY20: ' B	

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            PRINT "TIMEPLAY !"
            DELAY 500
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 오른손정면공격
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN

            GOSUB 오른발공차기
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOSUB 오른발공차기
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOSUB 오른발공차기
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 자세 = 0 THEN

        ENDIF
    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY21: ' △

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 앞으로덤블링
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 정면올리기공격
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 전진달리기30
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 전진종종걸음
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            GOSUB 앞으로덤블링
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF  자세 = 0 THEN

        ENDIF
    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY22: ' *	

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN

            GOSUB 물구나무서기
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 왼쪽턴20
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 왼쪽턴10
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 왼쪽턴20
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 왼쪽턴20	
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고왼쪽턴20
            ENDIF		
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 자세 = 0 THEN
            IF 물건집은상태 = 0 THEN
                GOSUB 안내장들기
            ENDIF
        ENDIF

    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY23: ' G
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOTO 국민체조시작'종합댄스3
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 오른쪽옆으로20
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOSUB 오른손옆으로올리기
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 승부차기오른쪽	
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        GOSUB 앞으로일어나기
        GOTO RX_EXIT

    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF  자세 = 0 THEN

        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY24: ' #

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOTO 팔동작복사
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 오른쪽턴20
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        GOTO 오른쪽턴10
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        GOTO 오른쪽턴20
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 오른쪽턴20	
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고오른쪽턴20	
            ENDIF		
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF  자세 = 0 THEN
            IF 물건집은상태 <> 0 THEN
                GOSUB 안내장전달
            ENDIF
        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY25: ' P1

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOTO 왼쪽턴45
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 왼쪽턴60
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 왼쪽턴45
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 왼쪽턴45
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 왼쪽턴45	
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고왼쪽턴45
            ENDIF		
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 왼쪽턴20	
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고왼쪽턴20
            ENDIF		
        ENDIF

    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY26: ' ■
    GOSUB SOUND_STOP
    IF 자세 = 1 THEN GOTO RX_EXIT

    IF Action_mode  = 4 THEN
        IF 물건집은상태 = 0 THEN
            SPEED 5
            GOSUB 기본자세

        ELSE
            GOSUB Arm_motor_mode3
            SPEED 10
            MOVE G6B, , 60
            MOVE G6C, , 60
            WAIT	
            SPEED 8
            GOSUB 기본자세	
        ENDIF
        GOSUB All_motor_Reset
        GOTO RX_EXIT
    ENDIF

    S7 = MOTORIN(7)
    S8 = MOTORIN(8)
    S13 = MOTORIN(13)
    S14 = MOTORIN(14)

    IF S7 < 25 OR S8 < 40 THEN
        SPEED 4
        MOVE G6B,,  50,  100
        MOVE G6C,,  50,  100
        WAIT
    ELSEIF S13 < 25 OR S14 < 40 THEN
        SPEED 4
        MOVE G6B,,  50,  100
        MOVE G6C,,  50,  100
        WAIT	
    ENDIF

    SPEED 5
    GOSUB 기본자세	

    GOTO RX_EXIT
    '*******************************************
KEY27: ' D

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOTO 연속댄스2
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 오른쪽옆뒤공격
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 승부차기오른쪽
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOSUB 오른쪽으로슈팅
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 자세 = 0 THEN
            GOTO 승부차기오른쪽
        ENDIF
    ELSEIF  Action_mode  = 5 THEN ' 카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN ' MF홍보맨
        IF 자세 = 0 THEN

        ENDIF

    ENDIF


    GOTO RX_EXIT
    '*******************************************
KEY28: ' ◁


    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 왼쪽덤블링
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 왼쪽옆공격
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 왼쪽옆으로20
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 왼쪽옆으로20
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 왼쪽옆으로20
            ELSE
                GOTO 앉아왼쪽옆으로
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고왼쪽옆으로20
            ELSE
                GOTO 앉아왼쪽옆으로
            ENDIF		

        ENDIF
    ELSEIF  Action_mode  = 5 THEN '카메라모드
        IF 자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN 'MF홍보맨
        IF 자세 = 0 THEN

        ENDIF
    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY29: ' □

    IF Action_mode  = 0 THEN
        GOSUB SOUND_BGM1
        GOSUB 제자리걸음
        GOSUB SOUND_STOP
        GOTO RX_EXIT
    ENDIF

    IF Action_mode  = 4 THEN
        IF 자세 = 0 THEN
            IF  물건집은상태 = 0 THEN
                GOSUB Leg_motor_mode3

                SPEED 10
                MOVE G6A,100, 140,  37, 140, 100, 100
                MOVE G6D,100, 140,  37, 140, 100, 100
                WAIT

                SPEED 3
                GOSUB 앉은자세	
            ELSE
                GOSUB Leg_motor_mode3

                SPEED 10
                MOVE G6A,100, 140,  37, 140, 100, 100
                MOVE G6D,100, 140,  37, 140, 100, 100
                WAIT

                SPEED 3
                MOVE G6A,100, 140,  28, 142, 100, 100
                MOVE G6D,100, 140,  28, 142, 100, 100
                WAIT
                자세 = 1		
            ENDIF

        ELSE

            IF  물건집은상태 = 0 THEN
                GOSUB Leg_motor_mode2
                SPEED 6
                MOVE G6A,100, 140,  37, 140, 100, 100
                MOVE G6D,100, 140,  37, 140, 100, 100
                WAIT

                SPEED 10
                GOSUB 기본자세
                GOSUB Leg_motor_mode1
            ELSE
                GOSUB Leg_motor_mode2
                SPEED 6
                MOVE G6A,100, 140,  37, 140, 100, 100
                MOVE G6D,100, 140,  37, 140, 100, 100
                WAIT

                SPEED 10
                MOVE G6A,100,  76, 145,  85, 100
                MOVE G6D,100,  76, 145,  85, 100
                WAIT
                자세 = 0
                GOSUB Leg_motor_mode1	
            ENDIF
        ENDIF	
        GOTO RX_EXIT
    ENDIF


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

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 오른쪽덤블링
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 오른쪽옆공격
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 오른쪽옆으로20
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 오른쪽옆으로20
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            IF 자세 = 0 THEN
                GOTO 오른쪽옆으로20
            ELSE
                GOTO 앉아오른쪽옆으로
            ENDIF
        ELSE
            IF 자세 = 0 THEN
                GOTO 집고오른쪽옆으로20
            ELSE
                GOTO 앉아오른쪽옆으로
            ENDIF		
        ENDIF
    ELSEIF  Action_mode  = 5 THEN '카메라모드
        IF  자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN 'MF홍보맨
        IF 자세 = 0 THEN

        ENDIF
    ENDIF

    GOTO RX_EXIT
    '*******************************************
KEY31: ' ▽
    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 뒤로덤블링
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 뒷면올리기공격
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 기어가기
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOTO 후진종종걸음
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 THEN
            GOSUB 뒤로덤블링
        ENDIF
    ELSEIF  Action_mode  = 5 THEN '카메라모드
        IF  자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN 'MF홍보맨
        IF 자세 = 0 THEN

        ENDIF
    ENDIF

    GOTO RX_EXIT
    '*******************************************

KEY32: ' F

    IF Action_mode  = 0 THEN '댄스모드
        IF 자세 = 0 THEN
            GOSUB 종합댄스2
        ENDIF
    ELSEIF Action_mode  = 1 THEN '파이트모드
        IF 자세 = 0 THEN
            GOTO 후진종종걸음
        ENDIF
    ELSEIF Action_mode  = 2 THEN '게임모드
        IF 자세 = 0 THEN
            GOTO 후진종종걸음
        ENDIF
    ELSEIF  Action_mode  = 3 THEN ' 축구모드
        IF 자세 = 0 THEN
            GOSUB 뒤로슈팅
        ENDIF
    ELSEIF  Action_mode  = 4 THEN ' 장애물경주모드
        IF 물건집은상태 = 0 AND 자세 = 0 THEN
            GOTO 후진종종걸음
        ENDIF
        GOTO RX_EXIT
    ELSEIF  Action_mode  = 5 THEN '카메라모드
        IF  자세 = 0 THEN

        ENDIF
    ELSEIF  Action_mode  = 6 THEN 'MF홍보맨
        IF 자세 = 0 THEN

        ENDIF
    ENDIF

    GOTO RX_EXIT
    '*******************************************











