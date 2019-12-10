# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_color as color
import robo_camera as cam
import robo_serial as serial
import robo_debug as debug

import time

class STATUS:
    LINE_MISSING = 'LINE MISSING'
    WALKING = 'WALKING'

    BRIDGE = 'BRIDGE'

    DRILL_CAN = 'DRILL-CAN'
    DRILL_PACK = 'DRILL-PACK'
# -----------------------------------------------
class STOP_MOTION:
    STABLE  = 10
    STAND   = 11
    LOWER   = 12
    LIMBO   = 13

class LOOP_MOTION:
    WALK_FORWARD = 32
    WALK_BACKWARD = 33
    WALK_LEFT = 34
    WALK_RIGHT = 35

    LOWER_FORWARD = 36
    LOWER_BACKWARD = 37
    LOWER_LEFT = 38
    LOWER_RIGHT = 39

    TURN_LEFT = 40
    TURN_RIGHT = 41

    TURN_LOWER_LEFT = 42
    TURN_LOWER_RIGHT = 43

class STEP:
    FORWARD = 64
    BACKWARD = 65
    LEFT = 66
    RIGHT = 67

    LOWER_FORWARD = 68
    LOWER_BACKWARD = 69
    LOWER_LEFT = 70
    LOWER_RIGHT = 71

    TURN_LEFT = 72
    TURN_RIGHT = 73

    TURN_LOWER_LEFT = 74
    TURN_LOWER_RIGHT = 75

class HEAD:
    # 좌우
    YAW_CENTER = 96
    YAW_LEFT_90 = 97
    YAW_RIGHT_90 = 98
    YAW_LEFT_45 = 99
    YAW_RIGHT_45 = 100
    
    # 상하
    PITCH_CENTER = 101
    PITCH_LOWER_45 = 102
    PITCH_LOWER_90 = 103

class ARM:
    DOWN = 112
    MID = 113
    UP = 114

class MACRO:
    SHUTTER = 128
    OPEN_DOOR = 129
    
class SENSOR:
    DISTANCE = None # 적외선 센서 거리측정
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
def context(cmask):
    # 현재 로봇이 처한 상황을 파악
    if not findLine(cmask):
        return STOP_MOTION.STABLE # return to line
    
    if endOfLine(cmask):
        return STOP_MOTION.STAND # end of line
    
    if not findObstacles(cmask):
        return dirCalibration(cmask) # Running | Walking

    return STOP_MOTION.LOWER # undefined
    # --------
    # --------

# -----------------------------------------------
def findLine(cmask):
    y_msk = cmask['yellow']
    conts = objContTrace(y_msk)
    return len(conts) > 0
# --------
def endOfLine(cmask):
    y_msk = cmask['yellow']
    roi = y_msk[:cam.HEIGHT//3,:]
    conts = objContTrace(roi)
    return len(conts) == 0
# --------
def findObstacles(cmask):
    g_msk = cmask['green'][cam.HEIGHT*2//3:,:]
    r_msk = cmask['red'][cam.HEIGHT*2//3:,:]
    conts = objContTrace(g_msk) + objContTrace(r_msk)
    return len(conts) > 0
# -----------------------------------------------
def dirCalibration(cmask):
    y_msk = cmask['yellow'][cam.HEIGHT//2:,:]

    # Line direction
    line_probs = objContTrace(y_msk)
    if not line_probs:
        return False

    line = max(line_probs, key=cv2.contourArea)

    vx,vy,x,y = cv2.fitLine(line, cv2.DIST_L2,0,0.01,0.01)

    dx = vx*(vy/abs(vy))

    if abs(dx) > 0.2:
        if dx > 0:
            return STEP.TURN_LEFT
        else:
            return STEP.TURN_RIGHT
    else:
        return LOOP_MOTION.WALK_FORWARD


def walking():
    pass

def walking_green():
    pass


def findGreenObj(green_mask):
    # 초록 장애물을 발견하는 동작
    boxes = objTrace(green_mask)

def findBlueZone(blue_mask):
    pass


    