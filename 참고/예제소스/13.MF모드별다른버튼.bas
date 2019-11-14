
'****************************************
'***** 메탈파이터 기초 프로그램 *******
'****************************************

'******* 변수선언 ***********************
DIM A AS BYTE
DIM A_old AS BYTE
DIM X AS BYTE
DIM Y AS BYTE
DIM 보행순서 AS BYTE
DIM Action_mode AS BYTE
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

'*******모터방향설정*********************
DIR G6A,1,0,0,1,0,0	'왼쪽다리:모터0~5번
DIR G6D,0,1,1,0,1,0	'오른쪽다리:모터18~23번
DIR G6B,1,1,1,1,1,1	'왼쪽팔:모터6~11번
DIR G6C,0,0,0,0,0,0	'오른쪽팔:모터12~17번


'*******모터동시제어설정****************
PTP SETON '단위그룹별 점대점동작 설정
PTP ALLON'전체모터 점대점 동작 설정

'*******모터위치값피드백****************
GOSUB MOTOR_GET

'*******모터사용설정********************
GOSUB MOTOR_ON

'*******피에조소리내기******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"
'***** 초기자세로 **********************
SPEED 5
GOSUB 기본자세

Action_mode = 0

'***** 메인 반복루틴 **************
MAIN:

    ERX 4800,A,MAIN
    A_old = A

    IF A = 16 THEN
        GOSUB SOUND_MODE_SELECT
        GOTO 모드변환
    ELSEIF A = 1 THEN
        SPEED 10
        IF Action_mode = 0 THEN			
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
        ELSEIF Action_mode = 1 THEN		
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
        ELSEIF Action_mode = 2 THEN		
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
        ELSEIF Action_mode = 3 THEN		
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
        ELSEIF Action_mode = 4 THEN		
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
        ELSEIF Action_mode = 5 THEN		
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
        ELSEIF Action_mode = 6 THEN		
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
        ENDIF
    ELSE
        MUSIC "F"    	
    ENDIF


    GOTO MAIN
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
모드변환:

    ERX 4800,A,모드변환


    IF A = 27 THEN	'D 버튼:댄스모드
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

    ELSEIF A = 32 THEN	'F 버튼:파이트모드
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

    ELSEIF A = 23 THEN	'G 버튼:게임모드
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

    ELSEIF A = 20 THEN	'B 버튼:축구모드
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

    ELSEIF A = 18 THEN	'E 버튼:장애물경주모드
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

    ELSEIF A = 17 THEN ' C: 카메라모드
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
    ELSEIF A = 15 THEN	'A 버튼: MF홍보맨
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

    ELSEIF A = 26 THEN	'■ 버튼:액션모드변경 종료
        SPEED 5
        MOVE G6A,97,  76, 145,  93, 102, 100
        MOVE G6D,97,  76, 145,  93, 102, 100
        WAIT
        SPEED 8
        MOVE G6B,, 50, 90, , , 100
        MOVE G6C,, 50, 90
        WAIT
        GOSUB 기본자세

        GOSUB All_motor_Reset
        GOTO RX_EXIT

    ELSE
        MUSIC "C"
    ENDIF

    GOSUB GOSUB_RX_EXIT

    GOTO 모드변환
    '*************************************
GOSUB_RX_EXIT: '수신값을 버리는루틴

    ERX 4800, A, GOSUB_RX_EXIT2
    GOTO GOSUB_RX_EXIT
GOSUB_RX_EXIT2:
    RETURN
'*************************************
RX_EXIT: '수신값을 버리는루틴	

    ERX 4800, A, MAIN

    GOTO RX_EXIT
    '*************************************
MOTOR_ON: '전포트서보모터사용설정
    MOTOR G24
    RETURN
    '***********************************
MOTOR_OFF: '전포트서보모터설정해제
    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    RETURN
    '***********************************
MOTOR_GET: '위치값피드백
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '*******기본자세관련*****************

기본자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    RETURN
    '*************************************	
All_motor_Reset:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1
    RETURN
    '*************************************
All_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2
    RETURN
    '*************************************
All_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3
    RETURN
    '*************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '*************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN
    '*************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '*************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '*************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '*************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1
    RETURN
    '*************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2
    MOTORMODE G6C,2,2,2
    RETURN
    '*************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3
    MOTORMODE G6C,3,3,3
    RETURN
    '*************************************
