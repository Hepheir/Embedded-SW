# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_color as color
import robo_camera as cam
import robo_serial as serial
import robo_debug as debug

import time
import math

class Action():
    def __init__(self, serial_code, act_name):
        self.code = serial_code
        self.name = act_name

class STATUS:
    LINE_MISSING = 'LINE MISSING'
    WALKING = 'WALKING'

    BRIDGE = 'BRIDGE'

    DRILL_CAN = 'DRILL-CAN'
    DRILL_PACK = 'DRILL-PACK'
# -----------------------------------------------
class STOP_MOTION:
    STABLE  = Action(10, 'STABLE')
    STAND   = Action(11, 'STAND')
    LOWER   = Action(12, 'LOWER')
    LIMBO   = Action(13, 'LIMBO')

class LOOP_MOTION:
    WALK_FORWARD    = Action(32, 'WALK_FORWARD')
    WALK_BACKWARD   = Action(33, 'WALK_BACKWARD')
    WALK_LEFT       = Action(34, 'WALK_LEFT')
    WALK_RIGHT      = Action(35, 'WALK_RIGHT')

    LOWER_FORWARD   = Action(36, '')
    LOWER_BACKWARD  = Action(37, '')
    LOWER_LEFT      = Action(38, '')
    LOWER_RIGHT     = Action(39, '')

    TURN_LEFT       = Action(40, '')
    TURN_RIGHT      = Action(41, '')

    TURN_LOWER_LEFT     = Action(42, '')
    TURN_LOWER_RIGHT    = Action(43, '')

    RUN_FORWARD = Action(44, 'RUN_FORWARD')

class STEP:
    FORWARD     = Action(64, '')
    BACKWARD    = Action(65, '')
    LEFT        = Action(66, 'LEFT')
    RIGHT       = Action(67, 'RIGHT')
    TURN_LEFT   = Action(72, 'TURN_LEFT')
    TURN_RIGHT  = Action(73, 'TURN_RIGHT')

    TURN_LEFT_WIDE   = Action(74, 'TURN_LEFT_WIDE')
    TURN_RIGHT_WIDE  = Action(75, 'TURN_RIGHT_WIDE')

    LOWER_FORWARD   = Action(68, '')
    LOWER_BACKWARD  = Action(69, '')
    LOWER_LEFT      = Action(70, '')
    LOWER_RIGHT     = Action(71, '')
    LOWER_TURN_LEFT     = Action(80, '')
    LOWER_TURN_RIGHT    = Action(81, '')

class HEAD:
    # 좌우
    YAW_CENTER      = Action(96, 'YAW_CENTER')
    YAW_LEFT_90     = Action(97, 'YAW_LEFT_90')
    YAW_RIGHT_90    = Action(98, 'YAW_RIGHT_90')
    YAW_LEFT_45     = Action(99, '')
    YAW_RIGHT_45    = Action(100, '')
    
    # 상하
    PITCH_CENTER    = Action(101, 'PITCH_CENTER')
    PITCH_LOWER_45  = Action(102, 'PITCH_LOWER_45')
    PITCH_LOWER_90  = Action(103, 'PITCH_LOWER_90')

class ARM:
    DOWN    = Action(112, '')
    MID     = Action(113, '')
    UP      = Action(114, '')

class MACRO:
    SHUTTER     = Action(128, 'SHUTTER')
    OPEN_DOOR   = Action(129, 'OPEN_DOOR')
    
class SENSOR:
    DISTANCE = None # 적외선 센서 거리측정

NO_ACTION = Action(None, None)
ERROR     = Action(STOP_MOTION.STAND.code, 'ERROR')

# -----------------------------------------------
def get(sensor):
    serial.TX_data(sensor)
    return serial.RX_data
# -----------------------------------------------
def objContTrace(mask, minObjSize=50):
    contours = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
    if not contours:
        return []
    return list(filter(lambda c: cv2.contourArea(c) > minObjSize, contours))
# -----------------------------------------------
def center_of_contour(contour):
	# compute the center of the contour
    M = cv2.moments(contour)
    cx = int(M["m10"] / M["m00"])
    cy = int(M["m01"] / M["m00"])
    return (cx, cy)
# -----------------------------------------------
def detectVertLine(mask, erodity=20):
    mask = cv2.erode(mask, cv2.getStructuringElement(cv2.MORPH_RECT, (1, erodity)))
    mask = cv2.dilate(mask, cv2.getStructuringElement(cv2.MORPH_RECT, (1, erodity)))
    return mask
# -----------------------------------------------
def detectHoriLine(mask, erodity=20):
    mask = cv2.erode(mask, cv2.getStructuringElement(cv2.MORPH_RECT, (erodity,1)))
    mask = cv2.dilate(mask, cv2.getStructuringElement(cv2.MORPH_RECT, (erodity,1)))
    return mask
# -----------------------------------------------
def context(cmask):
    # 현재 로봇이 처한 상황을 파악
    if not stadingOnLine(cmask['yellow']):
        return STOP_MOTION.LOWER # return to line
    
    # 만약 선이 끊겨있다면..
    if isEndOfLine(cmask['yellow']):
        if isCurve(cmask['yellow']):
            return STEP.TURN_LEFT_WIDE

        elif isDoor():
            return MACRO.OPEN_DOOR

        elif isShutter():
            return MACRO.SHUTTER

        elif isLimbo():
            return STOP_MOTION.LIMBO

        else:
            return ERROR

    elif isObject():
        return STOP_MOTION.STAND

    elif isBridge(cmasks):
        return dirCalibration_Lower(cmask['yellow'])

    else:
        return dirCalibration(cmask['yellow']) # undefined
    # --------

# -----------------------------------------------
def stadingOnLine(mask):
    conts = objContTrace(mask)
    return len(conts) > 0
# --------
def isEndOfLine(mask):
    mskv = detectVertLine(mask)
    roi = mskv[:cam.HEIGHT//3,:]
    conts = objContTrace(roi)
    return len(conts) == 0
# --------
def isCurve(mask):
    mskh = detectHoriLine(mask)
    conts = objContTrace(mskh)
    return len(conts) > 0

# --------
def isDoor():
    pass
# --------
def isShutter():
    pass
# --------
def isLimbo():
    pass
# --------
def isObject():
    pass
# --------
def isBridge(cmasks):
    red = cmasks['red']
    black = cmasks['black']
    isR, isB = [len(objContTrace(m)) > 0 for m in [red,black]]
    return isR and isB
# --------
def findObstacles(cmask):
    g_msk = cmask['green'][cam.HEIGHT*2//3:,:]
    r_msk = cmask['red'][cam.HEIGHT*2//3:,:]
    conts = objContTrace(g_msk) + objContTrace(r_msk)
    return len(conts) > 0
# -----------------------------------------------
def dirCalibration(mask):
    ltr_turn_sen    = 24
    ltr_shift_sen   = 24
    # v 로봇 카메라가 표시할 수 있는 최하단으로 부터, 가상으로 화면을 확장 시켰다고 가정시, 추정되는 로봇으로 부터 땅에 내린 수선의 발 위치
    bottom_y_ext    = cam.CENTER[1] * 2/3
    
    mskv = detectVertLine(mask)
    line_probs = objContTrace(mskv)
    if not line_probs:
        return NO_ACTION

    line = max(line_probs, key=cv2.contourArea)
    vx,vy,x,y = cv2.fitLine(line, cv2.DIST_L2,0,0.01,0.01)

    if vy == 0:
        return NO_ACTION

    top_x = vx/vy * ( - y) + x
    bot_x = vx/vy * ((cam.HEIGHT + bottom_y_ext) - y) + x

    dx = (top_x - bot_x) / cam.WIDTH * 100
    bx = (bot_x - cam.CENTER[0]) / cam.CENTER[0] * 100

    if abs(bx) + abs(dx) > 1000:
        return NO_ACTION

    # 위치 보정
    if abs(bx) > ltr_shift_sen:
        return STEP.RIGHT if bx > 0 else STEP.LEFT

    # 회전각 보정
    if abs(dx) > ltr_turn_sen:
        return STEP.TURN_RIGHT if dx > 0 else STEP.TURN_LEFT
        

    # 문제가 없으면 전진
    return LOOP_MOTION.WALK_FORWARD

def dirCalibration_Lower(mask):
    res = dirCalibration(mask)

    mapping = [
        (LOOP_MOTION.WALK_FORWARD, LOOP_MOTION.LOWER_FORWARD),

        (STEP.TURN_LEFT,    STEP.LOWER_TURN_LEFT),
        (STEP.TURN_RIGHT,   STEP.LOWER_TURN_RIGHT),

        # (STEP.LEFT,     STEP.LOWER_LEFT),
        # (STEP.RIGHT,    STEP.LOWER_RIGHT)

        (STEP.LEFT,     LOOP_MOTION.LOWER_FORWARD),
        (STEP.RIGHT,    LOOP_MOTION.LOWER_FORWARD)
    ]

    for old, new in mapping:
        if res is old:
            return new
    return res
