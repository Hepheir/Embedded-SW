
'****************************************
'***** 메탈파이터 기초 프로그램 *******
'****************************************

'******* 변수선언 ***********************
DIM A AS BYTE
DIM 자세 AS BYTE

DIM S12 AS BYTE		
DIM S13 AS BYTE
DIM S14 AS BYTE

'*******모터방향설정*********************
DIR G6A,1,0,0,1,0,0	'왼쪽다리:모터0~5번
DIR G6D,0,1,1,0,1,0	'오른쪽다리:모터18~23번
DIR G6B,1,1,1,1,1,1	'왼쪽팔:모터6~11번
DIR G6C,0,0,0,0,0,0	'오른쪽팔:모터12~17번


'*******모터동시제어설정****************
PTP SETON 		'단위그룹별 점대점동작 설정
PTP ALLON		'전체모터 점대점 동작 설정

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
OUT 52,0

자세 = 0

'***** 메인 반복루틴 **************
MAIN:

    ERX 4800,A,MAIN
	IF A = 1 THEN
		GOSUB 팔동작복사
	ELSE
		 MUSIC "F"
	ENDIF
 
    GOTO MAIN
'***************************************
    
팔동작복사:
        SPEED 10
        MOVE G6C,100,  70,  100
        WAIT

        MOTOROFF G6C	'오른팔 모터 풀기
        SPEED 15

        TEMPO 230
        MUSIC "cde"	

        DELAY 500

팔동작복사_1:

        '오른팔 모터위치값 읽기
        S12 = MOTORIN(12)
        S13 = MOTORIN(13)
        S14 = MOTORIN(14)

        '왼쪽팔 모터값 적용하기
        SERVO 6,S12
        SERVO 7,S13
        SERVO 8,S14

        'ERX 감지후 리모콘동작으로 전환
        ERX 4800,A,팔동작복사_1
        IF A = 26 THEN	'■ 버튼
            TEMPO 230
            MUSIC "cdefgab"
			
			GOSUB MOTOR_GET
			
            GOSUB MOTOR_ON
            SPEED 5
            GOSUB 기본자세
            GOTO MAIN
        ELSE
            MUSIC "F"
        ENDIF


    GOTO 팔동작복사_1
    '************************************
    '************************************
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
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    RETURN
    '**************************************
앉은자세:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    RETURN
    '***************************************