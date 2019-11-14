

'******** METAL FIGHTER STANDARD PROGRAM ********

DIM I AS BYTE
DIM J AS BYTE
DIM pose AS BYTE
DIM Action_mode AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM walk_speed AS BYTE
DIM left_right_speed AS BYTE
DIM left_right_speed2 AS BYTE
DIM walk_order AS BYTE
DIM volt_now AS BYTE
DIM inversion_check AS BYTE
DIM motor_ONOFF AS BYTE
DIM zyro_ONOFF AS BYTE
DIM tilt_front_back AS INTEGER
DIM tilt_left_right AS INTEGER
DIM DELAY_TIME AS BYTE
DIM DELAY_TIME2 AS BYTE
DIM TEMP AS BYTE
DIM thing_catch_state AS BYTE
DIM tilt_count AS BYTE
DIM fall_check AS BYTE

DIM replay_number AS BYTE
DIM tilt_measurement_check AS BYTE
DIM public_way_check AS BYTE


DIM S6 AS BYTE
DIM S7 AS BYTE
DIM S8 AS BYTE

DIM S11 AS BYTE
DIM S12 AS BYTE
DIM S13 AS BYTE
DIM S14 AS BYTE

DIM GYRO_ONOFF AS BYTE

'**** tilt sensor port

CONST front_back_tilt_AD_port = 2
CONST left_right_tilt_AD_port = 3



'**** OLD tilt Sensors *****
'CONST tilt_time_check = 10  
'CONST min = 100			
'CONST max = 160			
'CONST COUNT_MAX = 30

'**** 2012 NEW tilt Sensors *****
CONST tilt_time_check = 5  
CONST min = 61			
CONST max = 107			
CONST COUNT_MAX = 20
'*******************


CONST low_volt = 103	'6V

PTP SETON 				
PTP ALLON				

DIR G6A,1,0,0,1,0,0		'motor_0~5
DIR G6B,1,1,1,1,1,1		'motor_6~11
DIR G6C,0,0,0,0,0,0		'motor_12~17
DIR G6D,0,1,1,0,1,0		'motor_18~23


'***** beginning announcement *********************************
motor_ONOFF = 0
walk_order = 0
inversion_check = 0
tilt_count = 0
fall_check = 0
tilt_measurement_check = 1
public_way_check = 0
thing_catch_state = 0
'****Action_mode(beginning action mode)******************
Action_mode = 0	    'D(CODE 27):dance mode
'Action_mode = 1	'F(CODE 32):fight mode
'Action_mode = 2	'G(CODE 23):game mode
'Action_mode = 3	'B(CODE 20):soccer mode
'Action_mode = 4	'E(CODE 18):hurdle mode
'Action_mode = 5	'C(CODE 17):camera mode

'*** GYRO Setting  ***********************************
GOSUB GYRO_INIT
GOSUB GYRO_MID

'**** beginning position *****************************

OUT 52,0
GOSUB MOTOR_ON

OUT 52,0

SPEED 5
GOSUB power_beginning_pose
GOSUB standard_pose

GOSUB GYRO_ON

GOTO MAIN
'************************************************

MAIN:

    ERX 4800,A,MAIN

    A_old = A

    IF A = 1 THEN
        GOSUB All_motor_Reset
    ELSEIF A = 2 THEN
        GOSUB All_motor_mode2
    ELSEIF A = 3 THEN
        GOSUB All_motor_mode3
    ELSEIF A = 4 THEN
        GOSUB GYRO_MIN
    ELSEIF A = 5 THEN
        GOSUB GYRO_MID
    ELSEIF A = 6 THEN
        GOSUB GYRO_MAX
    ELSEIF A = 16 THEN	' POWER BUTTON
        IF GYRO_ONOFF = 1 THEN
            GOSUB GYRO_OFF
        ELSE
            GOSUB GYRO_ON
        ENDIF

    ELSEIF A = 29 THEN	' бр
        IF pose = 0 THEN
            GOSUB Leg_motor_mode3
            SPEED 10
            MOVE G6A,100, 140,  37, 140, 100, 100
            MOVE G6D,100, 140,  37, 140, 100, 100
            WAIT
            SPEED 3
            GOSUB sit_pose	
            ' IF  GYRO_ONOFF = 1 THEN GOSUB GYRO_OFF
        ELSE
            GOSUB Leg_motor_mode2
            SPEED 6
            MOVE G6A,100, 140,  37, 140, 100, 100
            MOVE G6D,100, 140,  37, 140, 100, 100
            WAIT

            SPEED 10
            GOSUB standard_pose
        ENDIF
    ENDIF

    GOSUB beep_music
    GOSUB GOSUB_RX_EXIT

    GOTO MAIN

    '***********************************************

GYRO_INIT:
    GYRODIR G6A, 0, 0, 0, 0, 1
    GYRODIR G6D, 1, 0, 0, 0, 0

    RETURN
    '***********************************************
GYRO_MAX:

    GYROSENSE G6A,255,255,255,255
    GYROSENSE G6D,255,255,255,255

    RETURN
    '***********************************************
GYRO_MID:
    GYROSENSE G6A,255,100,100,100
    GYROSENSE G6D,255,100,100,100,
    RETURN
    '***********************************************
    '***********************************************
GYRO_MIN:
    GYROSENSE G6A,50,50,50,50
    GYROSENSE G6D,50,50,50,50
    RETURN
    '***********************************************
GYRO_ST:
    GYROSENSE G6A,100,30,30,30,
    GYROSENSE G6D,100,30,30,30,
    RETURN

    '***********************************************
GYRO_ON:
    GYROSET G6A, 2, 1, 1, 1,
    GYROSET G6D, 2, 1, 1, 1,
    GYRO_ONOFF = 1
    RETURN
    '***********************************************
GYRO_OFF:
    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0
    GYRO_ONOFF = 0
    RETURN
    '************************************************


MOTOR_FAST_ON:

    MOTOR G6B
    MOTOR G6C
    MOTOR G6A
    MOTOR G6D

    motor_ONOFF = 0
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

    motor_ONOFF = 0
    GOSUB start_music			
    RETURN

    '************************************************
    'all port moter use
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    motor_ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB end_sound	
    RETURN
    '************************************************
    'position_feedback
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
    '******* standard_pose *****************************
    '************************************************
power_beginning_pose:
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,100,  45,  90, 100, 100, 100
    MOVE G6C,100,  45,  90, 100, 100, 100
    WAIT
    pose = 0
    RETURN
    '************************************************
stabilization_pose:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    pose = 0

    RETURN
    '************************************************
standard_pose:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    pose = 0
    thing_catch_state = 0
    RETURN
    '************************************************	
stand_up_pose:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    pose = 2
    RETURN
    '************************************************
sit_pose:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    pose = 1

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
    '******* piezo sond *****************************
    '************************************************


start_music:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
end_sound:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
entertainment_music:
    TEMPO 220
    MUSIC "O28B>4D8C4E<8B>4D<8B>4G<8E>4C"
    RETURN
    '************************************************
game_music:
    TEMPO 210
    MUSIC "O23C5G3#F5G3A5G"
    RETURN
    '************************************************
fight_music:
    TEMPO 210
    MUSIC "O15A>C<A>3D"
    RETURN
    '************************************************
caution_music:
    TEMPO 180
    MUSIC "O13A"
    DELAY 300

    RETURN
    '************************************************
beep_music:
    TEMPO 180
    MUSIC "A"
    DELAY 300

    RETURN
    '*******************************************