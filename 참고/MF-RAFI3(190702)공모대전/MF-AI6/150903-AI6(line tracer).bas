
' CTS Function
'
CONST returnXY = 0				' return color object position by HEX 0xXY
CONST returnArea = 1			' return color object area size
CONST returnXPos = 2			' return color object X position
CONST returnYPos = 3			' return color object Y position
CONST returnXLength = 4			' return color object X size
CONST returnYLength = 5			' return color object Y size
CONST returnPos = 6 			' return color object position *
CONST returnLastPos = 7 		' return color object last position *
CONST returnNum = 8 			' return object count
CONST returnAllNum = 9 			' return all color object count


CONST returnDRC_XPos = 1			' return Face object X position
CONST returnDRC_YPos = 2			' return Face object Y position



'*********************************************

CONST Color_Find_P = 15
CONST Face_Find_P = 35

'*********************************************
'* area code
' 1  2  3
' 4  5  6
' 7  8  9


DIM A AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM i AS BYTE
DIM J AS BYTE
DIM A_OLD AS BYTE
DIM Tilt_F AS BYTE
DIM Tilt_S AS BYTE
DIM pose AS BYTE
DIM thing_chach_pose AS BYTE
DIM CTS_MODE AS BYTE
DIM rxCommand AS BYTE
DIM rxData AS BYTE
DIM rxRemain AS BYTE
DIM ColorCode AS BYTE
DIM ColorComm AS BYTE



DIM X_Pos320 AS BYTE	'1 ~ 255
DIM Y_Pos240 AS BYTE	'1 ~ 240
DIM X_Pos320_OLD AS BYTE	'1 ~ 255
DIM Y_Pos240_OLD AS BYTE	'1 ~ 240
DIM X_Angle AS BYTE		'10 ~ 190
DIM Y_Angle AS BYTE		'10 ~ 130
DIM cal_x AS BYTE
DIM cal_y AS BYTE

DIM count AS BYTE
DIM X_Pos15 AS BYTE		'1 ~ 15
DIM Y_Pos12 AS BYTE		'1 ~ 12
DIM Color_MinArea AS BYTE

DIM Find_Direction AS BYTE

DIM X_Length AS BYTE
DIM Y_Length AS BYTE
DIM Face_Length AS BYTE
DIM Divide_9_Location AS BYTE
DIM Divide_9_Forgetten AS BYTE
DIM Number_of_Objecs AS BYTE

DIM Y_Angle_MAX AS BYTE
DIM Y_Angle_MID AS BYTE
DIM Y_Angle_MIN AS BYTE
DIM Find_speed AS BYTE
DIM Look_speed AS BYTE
DIM Find_delay_time AS BYTE

DIM Face_Find_speed AS BYTE
DIM Face_Search_delay_time AS BYTE

DIM zyroONOFF AS BYTE

DIM walk_number AS BYTE
DIM ball_front AS BYTE
DIM fall_check AS BYTE

DIM SOUND_BUSY AS BYTE
'******** MF-AI6 ROBOT MOTOR Init Setting *******
DIR G6A,1,0,0,1,0,0
DIR G6B,1,1,1,1,1,1
DIR G6C,0,0,0,0,1,0
DIR G6D,0,1,1,0,1,0


'**** tilt_port *****

CONST FB_tilt_AD_port = 0
CONST LR_tilt_AD_port = 1

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

'************************************************

GOSUB MOTOR_ON
GOSUB All_motor_mode3

SPEED 5
'GOSUB power_first_pose
GOSUB standard_pose


'rxCommand = 30


X_Angle = MOTORIN(11)
Y_Angle = MOTORIN(16)

SERVO 11, 100
SERVO 16, 55

'************************************************
PRINT "VOLUME 150 !"
GOSUB SOUND_HELLO_miniROBOT_ROBONOVA_2
GOSUB SOUND_PLAY_CHK
DELAY 1000
GOSUB SOUND_cameramode
GOSUB SOUND_PLAY_CHK
'************************************************
'************************************************

GOSUB GOSUB_RX_EXIT

GOSUB CTS_START_WAIT
GOSUB CTS_Setting_init

'********* CTS Setting *************************
GOSUB GOSUB_RX_EXIT

GOSUB HEAD_UART_ENABLE
GOSUB Head_Rx_Board_rate_115200
GOSUB Head_IR_On

GOSUB zyroINIT
GOSUB zyroMid
GOSUB zyroON


GOSUB GOSUB_RX_EXIT



DIM Infrared_Distance_Variable AS BYTE
DIM Infrared_Distance AS BYTE

'*************************************
'*************************************
'***** Setting Constant,Variable*****
'*************************************
DIM turn_delay AS INTEGER

turn_delay = 300

CONST Head_Bowed_Variable = 55
CONST CTS_Curve_short_walk_speed = 9

CONST Right_Curve_walk = 78  	'Center = 128
CONST Left_Curve_walk = 188		'Center = 128
CONST Right_Curve_walk_MAX = 48 'Center = 128
CONST Left_Curve_walk_MAX = 208	'Center = 128

ColorCode = 30'
'*********************************************
' Infrared_Distance = 60 ' About 20cm
Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************


SERVO 11, 100
SERVO 16, Head_Bowed_Variable

GOTO Remocon_Start_LOOP


'*************************************
'*************************************
'*************************************
Remocon_Start_LOOP:


    GOSUB CTSColorFind_MinArea

    IF Color_MinArea >  2 THEN
        GOSUB Head_IR_LED_ON
        GOSUB GOSUB_RX_EXIT
        DELAY 50
    ELSE
        GOSUB Head_IR_LED_OFF
        GOSUB GOSUB_RX_EXIT
        DELAY 50
    ENDIF


    ERX 115200, A ,Remocon_Start_LOOP
    IF A = 11 THEN
        TEMPO 200
        MUSIC "f"
        GOSUB Head_IR_OFF
        GOSUB GOSUB_RX_EXIT
        GOTO CTS_Curve_short_walk
    ELSEIF A = 26 THEN
        MUSIC "c"
    ENDIF
    GOSUB GOSUB_RX_EXIT



    GOTO Remocon_Start_LOOP
    '*************************************

    '************************************************
    'RX_EXIT:
    '
    '    ERX 115200, A, MAIN
    '
    '    GOTO RX_EXIT
    '************************************************
    '************************************************
    '************************************************
    '************************************************
Infrared_Measurement:

    Infrared_Distance_Variable = AD(5)

    IF Infrared_Distance_Variable > 40 THEN '40 = Infrared_Distance = 35cm
        MUSIC "C"
    ELSE	
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    DELAY 20
    GOTO Infrared_Measurement


    '*************************************
    '************************************************
    '************************************************
    '************************************************
    '************************************************
    '************************************************
SOUND_cameramode:
    PRINT "SOUND 7!"
    RETURN
    '************************************************
SOUND_PLAY_CHK:
    DELAY 60
    SOUND_BUSY = IN(46)
    IF SOUND_BUSY = 1 THEN GOTO SOUND_PLAY_CHK
    DELAY 50

    RETURN

    '************************************************
SOUND_HELLO_miniROBOT_ROBONOVA_2: '
    PRINT "SOUND 0!"
    RETURN
    '************************************************
GOSUB_RX_EXIT:

    ERX 115200, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN


    '************************************************
All_motor_mode1:

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
    MOTORMODE G6C,3,3,3, ,3

    RETURN
    '************************************************
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
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
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

    GOSUB start_music

    RETURN
    '************************************************
standard_pose:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, , ,
    MOVE G6C,100,  30,  80, , Head_Bowed_Variable
    WAIT

    pose = 0
    thing_chach_pose = 0
    RETURN
    '******************************************	
    '************************************************
standard_pose2:

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, , ,
    MOVE G6C,100,  30,  80, , Head_Bowed_Variable
    WAIT
    pose = 0
    thing_chach_pose = 0
    RETURN
    '******************************************	
power_first_pose:
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,100,  45,  90, 100, 100,
    MOVE G6C,100,  45,  90, 100,  , 100
    WAIT
    pose = 0
    RETURN
    '************************************************
safety_pose:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, , ,
    MOVE G6C,100,  30,  80, ,  ,
    WAIT
    pose = 0

    RETURN
    '******************************************	
    '************************************************
chack_standard_pose:

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    pose = 0
    thing_chach_pose = 1
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
Head_standard_pose:
    X_Angle = 100
    Y_Angle = 75
    SERVO 11,X_Angle
    SERVO 16,Y_Angle

    RETURN
    '************************************************
Head_Center:
    MOVE G6B, ,  , , , ,100
    WAIT
    RETURN
    '************************************************
    '******* buzzer ***********************
    '************************************************


start_music:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
end_buzzer:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
entertainment_sound:
    TEMPO 220
    MUSIC "O28B>4D8C4E<8B>4D<8B>4G<8E>4C"
    RETURN
    '************************************************
game_sound:
    TEMPO 210
    MUSIC "O23C5G3#F5G3A5G"
    RETURN
    '************************************************
fight_sound:
    TEMPO 210
    MUSIC "O15A>C<A>3D"
    RETURN
    '************************************************
warning_sound:
    TEMPO 180
    MUSIC "O13A"
    DELAY 300

    RETURN
    '************************************************
buzzer_sound:
    TEMPO 180
    MUSIC "A"
    DELAY 300

    RETURN
    '************************************************
siren_sound:
    TEMPO 180
    MUSIC "O22FC"
    DELAY 10
    RETURN
    '************************************************

footballgame_sound:
    TEMPO 180
    MUSIC "O28A#GABA"
    RETURN
    '************************************************

steeplechase_racesmode_sound:
    TEMPO 200
    MUSIC "O37C<C#BCA"
    RETURN
    '************************************************
    '*********************************************
    '*********************************************
    '******* CTS communication function *********
    '*********************************************
    '*********************************************
    '*********************************************

    '*********************************************
CTS_MODE_Query: ''Return CTS_MODE = 0 ~ 5

    rxRemain = 0
    CTS_MODE = 10 'NON
    '0 = SmartPhone Control  '(Android apps)
    '1 = SmartPhone Face tacking    '(Android apps)
    '2 = CTS - SETTING       '(Windows program, CTS Studio)
    '3 = CTS - Debug	     '(CTS Studio /Android apps)
    '4 = CTS - RealTime      '(CTS Studio /Android apps)
    '5 = CTS - Color tacking '(Local Color tacking)


    ETX 115200,250 'CTS_MODE_Query

CTS_MODE_Query_RX:

    IF rxRemain > 30 THEN
        CTS_MODE = 10
        GOSUB GOSUB_RX_EXIT
        RETURN
    ENDIF
    rxRemain = rxRemain + 1
    ERX 115200,CTS_MODE,CTS_MODE_Query_RX
    IF CTS_MODE > 5 THEN
        CTS_MODE = 10 'NON
    ENDIF
    GOSUB GOSUB_RX_EXIT
    RETURN


    '************************************************
CTS_START_WAIT:
    '0 = SmartPhone Control  '(Android apps)
    '1 = SmartPhone Face tacking    '(Android apps)
    '2 = CTS - SETTING       '(Windows program, CTS Studio)
    '3 = CTS - Debug	     '(CTS Studio /Android apps)
    '4 = CTS - RealTime      '(CTS Studio /Android apps)
    '5 = CTS - Color tacking '(Local Color tacking)


    GOSUB CTS_MODE_Query
    'CTS MODE = 5 or RealTime MODE=4 = Start
    IF CTS_MODE = 5 OR CTS_MODE = 4 THEN
        MUSIC "C"
        GOSUB GOSUB_RX_EXIT
        RETURN
    ENDIF
    DELAY 500
    MUSIC "C"
    GOTO CTS_START_WAIT
    '************************************************
SmartPhone_START_WAIT:
    '0 = SmartPhone Control  '(Android apps)
    '1 = SmartPhone Face tacking    '(Android apps)
    '2 = CTS - SETTING       '(Windows program, CTS Studio)
    '3 = CTS - Debug	     '(CTS Studio /Android apps)
    '4 = CTS - RealTime      '(CTS Studio /Android apps)
    '5 = CTS - Color tacking '(Local Color tacking)

    GOSUB CTS_MODE_Query
    IF CTS_MODE = 0 THEN
        MUSIC "C"
        GOSUB GOSUB_RX_EXIT
        RETURN
    ENDIF
    DELAY 300

    GOTO SmartPhone_START_WAIT
    '************************************************

    '************************************************
CTS_SmartPhone_START_WAIT:
    '0 = SmartPhone Control  '(Android apps)
    '1 = SmartPhone Face tacking    '(Android apps)
    '2 = CTS - SETTING       '(Windows program, CTS Studio)
    '3 = CTS - Debug	     '(CTS Studio /Android apps)
    '4 = CTS - RealTime      '(CTS Studio /Android apps)
    '5 = CTS - Color tacking '(Local Color tacking)


    GOSUB CTS_MODE_Query
    'CTS MODE = 5 or RealTime MODE=4 = Start
    IF CTS_MODE = 0 THEN
        MUSIC "C"
        GOSUB GOSUB_RX_EXIT
        RETURN
    ELSEIF CTS_MODE = 5 OR CTS_MODE = 4 THEN
        MUSIC "C"
        GOSUB GOSUB_RX_EXIT
        RETURN
    ENDIF
    DELAY 500
    MUSIC "C"
    GOTO CTS_SmartPhone_START_WAIT
    '************************************************
    '*********************************************
CTS_Setting_init:

    Y_Angle_MAX = 70			'Default = 70
    Y_Angle_MID = 55			'Default = 55
    Y_Angle_MIN = 40			'Default = 40
    Find_speed = 14				'Default = 12 (10~15)
    Look_speed = 15				'Default = 15 (10~15)
    'Find_delay_time = 30  	    'Default = 20 (10~100)

    '********* Serch Time Auto cal *************************
    Find_delay_time = 20 - Find_speed
    Find_delay_time = Find_delay_time * Find_delay_time

    RETURN
    '********* Face Setting *************************
Face_Setting_init:

    Y_Angle_MAX = 100			'Default = 100
    Y_Angle_Min = 95			'Default = 95
    Face_Find_speed = 8  	    'Default = 8
    Face_Search_delay_time = 90	'Default = 90

    RETURN
    '*********************************************
CTS_Light_OFF: '

    rxCommand = 251
    GOSUB readCommandData

    RETURN

    '*********************************************
CTS_Light_ON: '

    rxCommand = 252
    GOSUB readCommandData

    RETURN

    '*********************************************


CTSColorFind_X15Y12: 'Return: X_Pos15 = 1~15,  Y_Pos12 = 1~12, NON = 0

    rxCommand = 100 + ColorCode
    GOSUB readCommandData

    X_Pos15 = rxData >> 4
    rxData = rxData << 4
    Y_Pos12 = rxData >> 4

    RETURN

    '*********************************************

CTSColorFind_MinArea: 'Return: Color_MinArea = 1~255, NON = 0

    rxCommand = 101 + ColorCode
    GOSUB readCommandData

    Color_MinArea = rxData

    RETURN

    '*********************************************
CTSColorFind_X320: 'Return: X_Pos320 = 1 ~ 255, NON = 0

    rxCommand = 102 + ColorCode
    GOSUB readCommandData
    X_Pos320 = rxData
    RETURN
    '*********************************************
CTSColorFind_Y240: 'Return: Y_Pos240 = 1 ~ 240, NON = 0

    rxCommand = 103 + ColorCode
    GOSUB readCommandData
    Y_Pos240 = rxData
    RETURN
    '*********************************************
CTSColorFind_X_Length: 'Return: X_Length = 1~255 , NON = 0

    rxCommand = 104 + ColorCode
    GOSUB readCommandData

    X_Length = rxData

    RETURN
    '*********************************************
CTSColorFind_Y_Length: 'Return: X_Length = 1~240 , NON = 0

    rxCommand = 105 + ColorCode
    GOSUB readCommandData

    Y_Length = rxData

    RETURN
    '*********************************************
CTSColorFind_Divide_9_Location: 'Return: Divide_9_Location = 1~9 , NON = 0

    rxCommand = 106 + ColorCode
    GOSUB readCommandData

    Divide_9_Location = rxData

    RETURN
    '*********************************************
CTSColorFind_Divide_9_Forgetten: 'Return: Divide_9_Forgetten = 1~9 , NON = 0

    rxCommand = 107 + ColorCode
    GOSUB readCommandData

    Divide_9_Forgetten = rxData

    RETURN

    '*********************************************
CTSColorFind_Number_of_Objecs: 'Return: 1~  , NON = 0

    rxCommand = 108 + ColorCode
    GOSUB readCommandData

    Number_of_Objecs = rxData

    RETURN
    '*********************************************
    '*********************************************

readCommandData:
    ETX 115200,rxCommand
readRX:
    rxRemain = 0
readRXremain:
    IF rxRemain > 4 THEN
        rxRemain = 0
        GOSUB GOSUB_RX_EXIT
        RETURN
    ENDIF
    rxRemain = rxRemain + 1
    DELAY 2

    ERX 115200,rxData,readRXremain
    GOSUB GOSUB_RX_EXIT
    RETURN
    '*********************************************
    '*********************************************
LookColor_XY_MOVE:
    HIGHSPEED SETOFF
    SPEED Look_speed
    count = 0

LookColor_XY_MOVE_Loop:


    GOSUB CTSColorFind_X320

    IF X_Pos320 > 1 THEN
        count = 0
        IF X_Pos320 > 133 THEN
            cal_x = X_Pos320 - 128
            cal_x = cal_x / Color_Find_P
            X_Angle = X_Angle + cal_x


        ELSEIF X_Pos320 < 123 THEN
            cal_x = 128 - X_Pos320
            cal_x = cal_x / Color_Find_P
            X_Angle = X_Angle - cal_x

        ENDIF

    ELSE
        X_Pos320 = 0
        Y_Pos240 = 0
        count = count + 1
        IF count > 20 THEN

            RETURN
        ENDIF
    ENDIF

    GOSUB CTSColorFind_Y240

    IF Y_Pos240 > 1 THEN
        count = 0
        IF Y_Pos240 > 125 THEN
            cal_y = Y_Pos240 - 120
            cal_y = cal_y / Color_Find_P
            Y_Angle = Y_Angle - cal_y

        ELSEIF Y_Pos240 < 115 THEN
            cal_y = 120 - Y_Pos240
            cal_y = cal_y / Color_Find_P
            Y_Angle = Y_Angle + cal_y
        ENDIF

    ELSE
        X_Pos320 = 0
        Y_Pos240 = 0
        count = count + 1
        IF count > 20 THEN

            RETURN

        ENDIF
    ENDIF


    IF count = 1 THEN
        X_Pos320 = 0
        Y_Pos240 = 0
        CONST Forgetten_p  = 20
        GOSUB CTSColorFind_Divide_9_Forgetten

        IF Divide_9_Forgetten = 1 THEN
            X_Angle = X_Angle - Forgetten_p
            Y_Angle = Y_Angle + Forgetten_p
        ELSEIF Divide_9_Forgetten = 2 OR  Divide_9_Forgetten = 5 THEN
            Y_Angle = Y_Angle + Forgetten_p
        ELSEIF Divide_9_Forgetten = 3 THEN
            X_Angle = X_Angle + Forgetten_p
            Y_Angle = Y_Angle + Forgetten_p
        ELSEIF Divide_9_Forgetten = 4 THEN
            X_Angle = X_Angle - Forgetten_p
        ELSEIF Divide_9_Forgetten = 6  THEN
            X_Angle = X_Angle + Forgetten_p

        ELSEIF Divide_9_Forgetten = 7 THEN
            X_Angle = X_Angle - Forgetten_p
            Y_Angle = Y_Angle - Forgetten_p
        ELSEIF Divide_9_Forgetten = 8 THEN
            Y_Angle = Y_Angle - Forgetten_p
        ELSEIF Divide_9_Forgetten = 9 THEN
            X_Angle = X_Angle + Forgetten_p
            Y_Angle = Y_Angle - Forgetten_p
        ENDIF
    ENDIF

    SERVO 11,X_Angle
    SERVO 16,Y_Angle

    IF cal_x < Color_Find_P AND cal_y < Color_Find_P THEN
        RETURN
    ENDIF


    GOTO LookColor_XY_MOVE_Loop

    '*********************************************
FindColor_XY_MOVE:
    HIGHSPEED SETOFF
    SPEED Find_speed
    X_Angle = 10
    Y_Angle = Y_Angle_Min
    count = 0
    Find_Direction = 0
FindColor_XY_MOVELoop:

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        RETURN
    ENDIF

    GOSUB CTSColorFind_X320

    IF X_Pos320 > 1 THEN

        IF X_Pos320 > 133 THEN
            cal_x = X_Pos320 - 128
            cal_x = cal_x / Color_Find_P
            X_Angle = X_Angle + cal_x
        ELSEIF X_Pos320 < 123 THEN
            cal_x = 128 - X_Pos320
            cal_x = cal_x / Color_Find_P
            X_Angle = X_Angle - cal_x
            IF X_Angle < 10 THEN
                X_Angle = 10
            ENDIF
        ENDIF

        GOSUB CTSColorFind_Y240

        IF Y_Pos240 > 1 THEN

            IF Y_Pos240 > 125 THEN
                cal_y = Y_Pos240 - 120
                cal_y = cal_y / Color_Find_P
                Y_Angle = Y_Angle - cal_y
            ELSEIF Y_Pos240 < 115 THEN
                cal_y = 120 - Y_Pos240
                cal_y = cal_y / Color_Find_P
                Y_Angle = Y_Angle + cal_y
            ENDIF

        ENDIF

        count = count + 1
        IF count > 3 THEN
            OUT 52, 1
            RETURN
        ENDIF
    ELSE

        count = 0
        IF Find_Direction = 0 THEN
            IF Y_Angle = Y_Angle_MAX  THEN
                X_Angle = X_Angle + 10
                IF X_Angle >= 190 THEN
                    Y_Angle = Y_Angle_MID
                    Find_Direction = 1
                ENDIF
            ELSEIF Y_Angle = Y_Angle_MID  THEN
                X_Angle = X_Angle - 10
                IF X_Angle <= 10 THEN
                    Y_Angle = Y_Angle_MAX
                ENDIF
            ELSE
                X_Angle = X_Angle + 10
                IF X_Angle >= 190 THEN
                    Y_Angle = Y_Angle_MID
                ENDIF
            ENDIF

        ELSE
            IF Y_Angle = Y_Angle_MID  THEN
                X_Angle = X_Angle - 10
                IF X_Angle <= 10 THEN
                    Y_Angle = Y_Angle_MIN
                    Find_Direction = 0
                ENDIF
            ELSE
                Find_Direction = 0
            ENDIF
        ENDIF
    ENDIF



    SERVO 11,X_Angle
    SERVO 16,Y_Angle

    IF X_Angle = 10 OR X_Angle = 190 THEN
        DELAY 100
        '**********
        GOSUB CTS_MODE_Query
        IF CTS_MODE = 4 OR  CTS_MODE = 5   THEN

        ELSE
            Y_Angle = 70
            X_Angle = 100
            SERVO 11,X_Angle
            SERVO 16,Y_Angle
            RETURN
        ENDIF
        '*************
    ENDIF
    DELAY Find_delay_time



    GOTO FindColor_XY_MOVELoop


    '*********************************************


    '*********************************************
CTSColorFind: 'Return rxData

    rxCommand = 100 + ColorComm + ColorCode
    GOSUB readCommandData

    RETURN

    '*********************************************
    '******** DRC *************************************
    '*********************************************


    '*********************************************
SmartPhone_Face_Find: 'Return rxData

    rxCommand = 200 + ColorComm
    GOSUB readCommandData

    RETURN

    '*********************************************
SmartPhone_Face_Find_X15Y12: 'Return: X_Pos15 = 1~15,  Y_Pos12 = 1~12, NON = 0

    rxCommand = 200
    GOSUB readCommandData

    X_Pos15 = rxData >> 4
    rxData = rxData << 4
    Y_Pos12 = rxData >> 4

    RETURN
    '*********************************************
SmartPhone_Face_Find_X320: 'Return: X_Pos320 = 1 ~ 255, NON = 0

    rxCommand = 201
    GOSUB readCommandData
    X_Pos320 = rxData

    RETURN
    '*********************************************
SmartPhone_Face_Find_Y240: 'Return: Y_Pos240 = 1 ~ 240, NON = 0

    rxCommand = 202
    GOSUB readCommandData
    Y_Pos240 = rxData
    RETURN
    '*********************************************
SmartPhone_Face_Length: 'Return: Face_Length = 1 ~ 240, NON = 0

    rxCommand = 203
    GOSUB readCommandData
    Face_Length = rxData
    RETURN
    '*********************************************
SmartPhone_Face_9_Forgetten: 'Return: Divide_9_Forgetten =1~9 , NON = 0

    rxCommand = 204
    GOSUB readCommandData

    Divide_9_Forgetten = rxData

    RETURN

    '*********************************************
SmartPhone_Face_9_Location: 'Return: Divide_9_Location = 1~9 , NON = 0

    rxCommand = 205
    GOSUB readCommandData

    Divide_9_Location = rxData

    RETURN

    '*********************************************
    '*********************************************
    '*********************************************

    '*********************************************
    '*********************************************
Look_Face_XY_MOVE:
    HIGHSPEED SETOFF
    SPEED Face_Find_speed
    count = 0

Look_Face_XY_MOVE_Loop:

    GOSUB SmartPhone_Face_Find_X320


    IF X_Pos320 > 1 THEN
        count = 0
        IF X_Angle < 190 THEN
            IF X_Pos320 > 125 THEN
                cal_x = X_Pos320 - 120
                cal_x = cal_x / Face_Find_P
                X_Angle = X_Angle + cal_x
            ENDIF
        ENDIF
        IF X_Angle > 10 THEN
            IF X_Pos320 < 115 THEN
                cal_x = 120 - X_Pos320
                cal_x = cal_x / Face_Find_P
                X_Angle = X_Angle - cal_x
            ENDIF
        ENDIF
    ELSE
        count = count + 1
        IF count > 50 THEN
            RETURN
        ENDIF
    ENDIF

    GOSUB SmartPhone_Face_Find_Y240

    IF Y_Pos240 > 1 THEN
        IF Y_Angle > 20 THEN
            IF Y_Pos240 > 125 THEN
                cal_y = Y_Pos240 - 120
                cal_y = cal_y / Face_Find_P
                Y_Angle = Y_Angle - cal_y
            ENDIF
        ENDIF
        IF Y_Angle < 120 THEN
            IF Y_Pos240 < 115 THEN
                cal_y = 120 - Y_Pos240
                cal_y = cal_y / Face_Find_P
                Y_Angle = Y_Angle + cal_y
            ENDIF
        ENDIF
    ENDIF


    SERVO 11,X_Angle
    SERVO 16,Y_Angle

    GOTO Look_Face_XY_MOVE_Loop

    '*********************************************
Find_Face_XY_MOVE:
    HIGHSPEED SETOFF
    SPEED Face_Find_speed
    X_Angle = 10
    Y_Angle = Y_Angle_MAX
    count = 0

Find_Face_XY_MOVE_Loop:

    GOSUB SmartPhone_Face_Find_X320



    IF X_Pos320 > 1 THEN

        IF X_Angle < 190 THEN
            IF X_Pos320 > 125 THEN
                cal_x = X_Pos320 - 120
                cal_x = cal_x / 30
                X_Angle = X_Angle + cal_x
            ENDIF
        ENDIF
        IF X_Angle > 90 THEN
            IF X_Pos320 < 115 THEN
                cal_x = 120 - X_Pos320
                cal_x = cal_x / 30
                X_Angle = X_Angle - cal_x
            ENDIF
        ENDIF

        count = count + 1
        IF count > 1 THEN
            RETURN

        ENDIF

    ELSE
        IF Y_Angle = Y_Angle_MAX  THEN
            X_Angle = X_Angle + 10
            IF X_Angle > 190 THEN
                Y_Angle = Y_Angle_Min
            ENDIF
        ELSE
            X_Angle = X_Angle - 10
            IF X_Angle < 10 THEN

                GOTO Find_Face_XY_MOVE
            ENDIF
        ENDIF

    ENDIF


    SERVO 11,X_Angle
    SERVO 16,Y_Angle
    DELAY Face_Search_delay_time


    GOTO Find_Face_XY_MOVE_Loop




    '*******************************************
    '*******************************************
    'HeadIR Recver Module
    '*******************************************
    '*******************************************
    DIM SWETX AS BYTE 'H HeadIRModule
    DIM HeadIRRx AS BYTE 'H HeadIRModule
    DIM HeadIRValue AS BYTE 'H HeadIRModule
    DIM HeadIROrder AS BYTE '
    DIM HeadIR_RX_BPS AS BYTE '
    '*******************************************

Head_SW_ETX:
    DELAY 1
    OUT 52, 0
    OUT 52, SWETX.0
    OUT 52, SWETX.1
    OUT 52, SWETX.2
    OUT 52, SWETX.3
    OUT 52, SWETX.4
    OUT 52, SWETX.5
    OUT 52, SWETX.6
    OUT 52, SWETX.7
    OUT 52, 1
    DELAY 1

    RETURN

    '*******************************************

HEAD_UART_ENABLE:
    GOSUB GOSUB_RX_EXIT
    OUT 52, 1
    DELAY 1
    HeadIRValue = 0

UARTENABLE_T:
    SWETX=255
    GOSUB Head_SW_ETX

    IF HeadIRValue > 50 THEN
        RETURN
    ELSE
        HeadIRValue = HeadIRValue + 1
    ENDIF

    ERX 115200, HeadIRRx, UARTENABLE_T

    IF HeadIRRx = 170 THEN

    ELSE
        GOTO UARTENABLE_T
    ENDIF

    RETURN

    '*******************************************
Head_IR_OFF:
    HeadIROrder = 255

    SWETX=255
    GOSUB Head_SW_ETX
    SWETX=14
    GOSUB Head_SW_ETX
    SWETX=HeadIROrder
    GOSUB Head_SW_ETX
    DELAY 1
    GOSUB GOSUB_RX_EXIT
    RETURN

    '*******************************************
Head_IR_On:
    HeadIROrder = 0

    SWETX=255
    GOSUB Head_SW_ETX
    SWETX=14
    GOSUB Head_SW_ETX
    SWETX=HeadIROrder
    GOSUB Head_SW_ETX
    DELAY 1
    GOSUB GOSUB_RX_EXIT
    RETURN
    '*******************************************
Head_IR_LED_ON:

    HeadIROrder = 1

    SWETX=255
    GOSUB Head_SW_ETX
    SWETX=20
    GOSUB Head_SW_ETX
    SWETX=HeadIROrder
    GOSUB Head_SW_ETX
    DELAY 1
    GOSUB GOSUB_RX_EXIT
    RETURN


    '*******************************************
Head_IR_LED_OFF:

    HeadIROrder = 0

    SWETX=255
    GOSUB Head_SW_ETX
    SWETX=20
    GOSUB Head_SW_ETX
    SWETX=HeadIROrder
    GOSUB Head_SW_ETX
    DELAY 1
    GOSUB GOSUB_RX_EXIT
    RETURN

    '*******************************************
Head_COMMAND_OFF:

    HeadIROrder = 255

    SWETX=255
    GOSUB Head_SW_ETX
    SWETX=13
    GOSUB Head_SW_ETX
    SWETX=HeadIROrder
    GOSUB Head_SW_ETX
    DELAY 10
    GOSUB GOSUB_RX_EXIT
    OUT 52,0

    RETURN
    '*******************************************
Head_COMMAND_DOWN: 'HEAD_UART_ENABLE 명령어 다시 실행하면 통신가능

    HeadIROrder = 254

    SWETX=255
    GOSUB Head_SW_ETX
    SWETX=13
    GOSUB Head_SW_ETX
    SWETX=HeadIROrder
    GOSUB Head_SW_ETX
    DELAY 10
    GOSUB GOSUB_RX_EXIT
    OUT 52,0

    RETURN
    '*******************************************
    '*******************************************
    '******************************
Head_Rx_Board_rate_change: 'HEAD_UART_ENABLE 명령어 다시 실행하면 통신가능

    'HeadIR_RX_BPS = 0 	'4800 bps
    'HeadIR_RX_BPS = 1 	'9600 bps
    'HeadIR_RX_BPS = 2 	'19200 bps
    'HeadIR_RX_BPS = 3 	'38400 bps
    'HeadIR_RX_BPS = 4 	'57600 bps
    'HeadIR_RX_BPS = 5 	'115200 bps
    '
    SWETX=255
    GOSUB Head_SW_ETX
    SWETX=10
    GOSUB Head_SW_ETX
    SWETX=HeadIR_RX_BPS
    GOSUB Head_SW_ETX
    DELAY 2
    GOSUB GOSUB_RX_EXIT
    RETURN
    '******************************
    '******************************
Head_Rx_Board_rate_115200: 'HEAD_UART_ENABLE 명령어 다시 실행하면 통신가능

    ' HeadIR_RX_BPS = 0 	'4800 bps
    'HeadIR_RX_BPS = 1 	'9600 bps
    'HeadIR_RX_BPS = 2 	'19200 bps
    'HeadIR_RX_BPS = 3 	'38400 bps
    'HeadIR_RX_BPS = 4 	'57600 bps
    HeadIR_RX_BPS = 5 '115200 bps
    '
    SWETX=255
    GOSUB Head_SW_ETX
    SWETX=10
    GOSUB Head_SW_ETX
    SWETX=HeadIR_RX_BPS
    GOSUB Head_SW_ETX
    DELAY 2
    GOSUB GOSUB_RX_EXIT
    RETURN
    '******************************


    '***********************************************
    '**** zyro ****
    '***********************************************

zyroINIT:
    GYRODIR G6A, 0, 0, 1, 0,1
    GYRODIR G6D, 1, 0, 1, 0,0

    RETURN
    '***********************************************
zyroMAX:

    GYROSENSE G6A,255 , 255,50,255,255
    GYROSENSE G6D,255 , 255,50,255,255

    RETURN
    '***********************************************
zyroMID:

    GYROSENSE G6A, 255, 150,30,150,100
    GYROSENSE G6D, 255, 150,30,150,100

    RETURN
    '***********************************************
    '***********************************************
zyroMIN:

    GYROSENSE G6A, 150, 50,10,50,50
    GYROSENSE G6D, 150, 50,10,50,50

    RETURN
    '***********************************************
zyroON:


    GYROSET G6A, 4, 3, 3, 3,
    GYROSET G6D, 4, 3, 3, 3,

    zyroONOFF = 1
    RETURN
    '***********************************************
zyroOFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0

    zyroONOFF = 0
    RETURN

    '************************************************


    '**********************************************
    '************************************************

    '    '************************************************
back_standup:
    GOSUB zyroOFF
    HIGHSPEED SETOFF
    GOSUB All_motor_mode1

    SPEED 15
    'GOSUB standard_pose

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
    GOSUB standard_pose

    fall_check = 1
    GOSUB zyroON
    RETURN


    '**********************************************
front_standup:
    HIGHSPEED SETOFF
    GOSUB zyroOFF
    GOSUB All_motor_mode1

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
    GOSUB standard_pose
    fall_check = 1

    GOSUB zyroON
    RETURN

    '******************************************
    '******************************************
    '************************************************
FB_tilt_check:

    FOR i = 0 TO COUNT_MAX
        Tilt_F = AD(FB_tilt_AD_port)	'
        IF Tilt_F > 250 OR Tilt_F < 5 THEN RETURN
        IF Tilt_F > MIN AND Tilt_F < MAX THEN RETURN
        DELAY tilt_time_check
    NEXT i

    IF Tilt_F < MIN THEN GOSUB tilt_front
    IF Tilt_F > MAX THEN GOSUB tilt_back

    GOSUB GOSUB_RX_EXIT

    RETURN
    '**************************************************
tilt_front:
    Tilt_F = AD(FB_tilt_AD_port)
    IF Tilt_F < MIN THEN  GOSUB back_standup
    RETURN

tilt_back:
    Tilt_F = AD(FB_tilt_AD_port)

    IF Tilt_F > MAX THEN GOSUB front_standup
    RETURN
    '**************************************************
Side_tilt_check:
    FOR i = 0 TO COUNT_MAX
        Tilt_S = AD(LR_tilt_AD_port)	'
        IF Tilt_S > 250 OR Tilt_S < 5 THEN RETURN
        IF Tilt_S > MIN AND Tilt_S < MAX THEN RETURN
        DELAY tilt_time_check
    NEXT i

    IF Tilt_S < MIN OR Tilt_S > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB standard_pose	
        RETURN

    ENDIF
    RETURN
    '**************************************************

    ''*************************************



    '**********************************************
left_turn10:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

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
    MOVE G6B,100,  30,  80, , ,
    MOVE G6C,100,  30,  80
    WAIT
    'X_Angle = X_Angle + 5
    'GOSUB GO_SERVO_X11
    GOSUB standard_pose2

    RETURN
    '**********************************************
right_turn10:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

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

    'X_Angle = X_Angle - 5
    'GOSUB GO_SERVO_X11
    GOSUB standard_pose2

    RETURN
    '**********************************************
    '**********************************************
left_turn20:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

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

    ' X_Angle = X_Angle + 10
    'GOSUB GO_SERVO_X11
    GOSUB standard_pose2

    RETURN
    '**********************************************
right_turn20:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

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

    'X_Angle = X_Angle - 10
    'GOSUB GO_SERVO_X11
    GOSUB standard_pose2

    RETURN
    '**********************************************
left_turn45:
    HIGHSPEED SETOFF

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
    'X_Angle = X_Angle + 35
    'GOSUB GO_SERVO_X11
    GOSUB standard_pose2

    RETURN

    '**********************************************
right_turn45:

    HIGHSPEED SETOFF

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
    ' X_Angle = X_Angle - 35
    'GOSUB GO_SERVO_X11
    GOSUB standard_pose2

    RETURN
    '**********************************************
left_turn60:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    'X_Angle = X_Angle + 50
    'GOSUB GO_SERVO_X11
    GOSUB standard_pose2

    RETURN

    '**********************************************
right_turn60:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100

    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    'X_Angle = X_Angle - 50
    'GOSUB GO_SERVO_X11
    GOSUB standard_pose2

    RETURN

    '*************************************
    '*************************************
    '*************************************
Line_Search:
    CONST Head_speed = 10
    fall_check = 0
    HIGHSPEED SETOFF

    SPEED Head_speed


    IF X_Pos320_OLD < 50 THEN
        GOTO Line_Search_Right
    ELSEIF X_Pos320_OLD > 200 THEN
        GOTO Line_Search_Left
    ENDIF

Line_Search_Loop:
    GOSUB Head_Center
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO Line_Search
    ENDIF

    GOSUB CTSColorFind_X320
    IF X_Pos320 > 1 THEN
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    '***************

Line_Search_Left:
    SPEED Head_speed
    MOVE G6B, , , , , ,45
    WAIT
    DELAY turn_delay



    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO Line_Search
    ENDIF



    GOSUB CTSColorFind_X320
    IF X_Pos320 > 1 THEN
        GOSUB left_turn45
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    '***************
    SPEED Head_speed
    MOVE G6B, , , , , ,10
    WAIT
    DELAY turn_delay


    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO Line_Search
    ENDIF


    GOSUB CTSColorFind_X320
    IF X_Pos320 > 1 THEN
        GOSUB left_turn45
        GOSUB left_turn45
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    '***************
    SPEED Head_speed
    MOVE G6B, , , , , , 100
    WAIT
    DELAY turn_delay


    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO Line_Search
    ENDIF


    GOSUB CTSColorFind_X320
    IF X_Pos320 > 1 THEN
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    '***************

    DELAY turn_delay

Line_Search_Right:

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO Line_Search
    ENDIF


    SPEED Head_speed
    MOVE G6B, , , , , ,145
    WAIT
    DELAY turn_delay

    GOSUB CTSColorFind_X320
    IF X_Pos320 > 1 THEN
        GOSUB right_turn45
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    SPEED Head_speed
    MOVE G6B, , , , , , 180
    WAIT
    DELAY turn_delay


    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO Line_Search
    ENDIF


    GOSUB CTSColorFind_X320
    IF X_Pos320 > 1 THEN
        GOSUB right_turn45
        GOSUB right_turn45
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    DELAY turn_delay



    GOTO Line_Search_Loop

    '*************************************

    '*************************************
    '*************************************
    '*************************************
    '*************************************
    '*************************************
    '*************************************

    '*************************************



    '******************************************
    '************************************************
    '****** 보행 관련********************************
    '************************************************
    '******************************************
CTS_Curve_short_walk:
    fall_check = 0
    GOSUB All_motor_mode3
    GOSUB CTSColorFind_X320
    IF X_Pos320 = 0 THEN GOTO Line_Search


    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON


    IF walk_number = 0 THEN
        walk_number = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO CTS_Curve_short_walk_1
    ELSE
        walk_number = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO CTS_Curve_short_walk_4
    ENDIF


    '**********************

CTS_Curve_short_walk_1:
    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    'CTS_Curve_short_walk_2:


CTS_Curve_short_walk_3:
    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO Line_Search
    ENDIF


    Infrared_Distance_Variable = AD(5)
    IF Infrared_Distance_Variable > 40 THEN '40 = Infrared_Distance = 35cm
        GOSUB CTS_Curve_short_walk_6_STOP
        GOTO Infrared_Measurement
    ENDIF


    GOSUB CTSColorFind_X320
    IF X_Pos320 = 0 THEN
        GOSUB CTS_Curve_short_walk_3_STOP
        GOTO Line_Search
    ELSEIF X_Pos320 > Left_Curve_walk_MAX  THEN 	'right_turn
        X_Pos320_OLD = X_Pos320	
        GOSUB CTS_Curve_short_walk_3_STOP
        GOSUB right_turn20
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ELSEIF X_Pos320 < Right_Curve_walk_MAX  THEN	'left_turn
        X_Pos320_OLD = X_Pos320	
        GOSUB CTS_Curve_short_walk_3_STOP
        GOSUB left_turn20
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ELSEIF X_Pos320 > Left_Curve_walk  THEN 	'오른쪽곡선
        X_Pos320_OLD = X_Pos320	
        HIGHSPEED SETOFF
        SPEED 7
        MOVE G6D,103,   71, 140, 105,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO CTS_Curve_short_walk_1
    ELSEIF X_Pos320 < Right_Curve_walk  THEN	'왼쪽
        X_Pos320_OLD = X_Pos320	


    ENDIF


    '*********************************

CTS_Curve_short_walk_4:
    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


    'CTS_Curve_short_walk_5:


CTS_Curve_short_walk_6:
    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT


    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO Line_Search
    ENDIF


    Infrared_Distance_Variable = AD(5)
    IF Infrared_Distance_Variable > 40 THEN '40 = Infrared_Distance = 35cm
        GOSUB CTS_Curve_short_walk_6_STOP
        GOTO Infrared_Measurement
    ENDIF


    GOSUB CTSColorFind_X320
    IF X_Pos320 = 0 THEN
        GOSUB CTS_Curve_short_walk_6_STOP
        GOTO Line_Search

    ELSEIF X_Pos320 > Left_Curve_walk_MAX THEN'오른쪽턴
        X_Pos320_OLD = X_Pos320	
        GOSUB CTS_Curve_short_walk_6_STOP
        GOSUB right_turn20
        DELAY turn_delay
        GOTO CTS_Curve_short_walk

    ELSEIF X_Pos320 < Right_Curve_walk_MAX THEN'왼쪽턴
        X_Pos320_OLD = X_Pos320	
        GOSUB CTS_Curve_short_walk_6_STOP
        GOSUB left_turn20
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ELSEIF X_Pos320 > Left_Curve_walk THEN'오른쪽곡선
        X_Pos320_OLD = X_Pos320	

    ELSEIF X_Pos320 < Right_Curve_walk THEN'왼쪽곡선
        X_Pos320_OLD = X_Pos320	
        HIGHSPEED SETOFF
        SPEED 7
        MOVE G6A,103,   71, 140, 105,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO CTS_Curve_short_walk_4


    ENDIF



    GOTO CTS_Curve_short_walk_1
    '******************************************
    '******************************************
    '*********************************
CTS_Curve_short_walk_3_STOP:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB safety_pose
    SPEED 10
    GOSUB standard_pose2
    RETURN
    '******************************************
CTS_Curve_short_walk_6_STOP:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB safety_pose
    SPEED 10
    GOSUB standard_pose2
    RETURN	
    '******************************************
    '*********************************
