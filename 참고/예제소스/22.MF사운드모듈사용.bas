
'****************************************
'***** 메탈파이터 기초 프로그램 *******
'****************************************

'******* 변수선언 ***********************
DIM A AS BYTE
DIM A_OLD AS BYTE
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

GOSUB MOTOR_ON
GOSUB SOUND_VOLUME_30

'***** 메인 반복루틴 **************
MAIN:

    ERX 4800,A,MAIN
    A_OLD = A

    IF A = 1 THEN
        GOSUB SOUND_가위
    ELSEIF A = 2 THEN
        GOSUB SOUND_바위
    ELSEIF A = 3 THEN
        GOSUB SOUND_보
    ELSEIF A = 4 THEN
        GOSUB SOUND_BGM1
    ELSEIF A = 5 THEN
        GOSUB SOUND_BGM2
    ELSEIF A = 6 THEN
        GOSUB SOUND_BGM7
    ELSEIF A = 7 THEN
        GOSUB SOUND_BGM10
    ELSEIF A = 8 THEN
        GOSUB SOUND_로보링크주제곡
    ELSEIF A = 9 THEN
        GOSUB SOUND_국민체조곡
    ELSEIF A = 10 THEN
        GOSUB SOUND_안녕하세요미니로봇에서개발된메탈파이터입니다
    ELSEIF A = 21 THEN 	' △버튼: 소리 켜기
        GOSUB SOUND_ALL_ON_MSG
    ELSEIF A = 31 THEN  ' ▽버튼: 소리 끄기
        GOSUB SOUND_ALL_OFF_MSG
    ELSEIF A = 30 THEN  ' ▷버튼: 볼륨업
        GOSUB SOUND_UP
        GOSUB 비프음
    ELSEIF A = 28 THEN  ' ◁버튼: 볼륨다운
        GOSUB SOUND_DOWN		
        GOSUB 비프음
    ELSEIF A = 26 THEN	' ■버튼:소리멈춤
        GOSUB SOUND_STOP
    ELSE

        GOSUB 비프음

    ENDIF




    GOTO MAIN

    '***************************************
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
    '******* 사운드모듈관련 **************
    '*************************************
비프음:
    TEMPO 230
    MUSIC "A"
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
