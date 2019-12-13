# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_color as color
import robo_camera as cam
import robo_serial as serial
import robo_debug as debug

import time
import math

class STATUS:
    LINE_MISSING = 'LINE MISSING'
    WALKING = 'WALKING'

    BRIDGE = 'BRIDGE'

    DRILL_CAN = 'DRILL-CAN'
    DRILL_PACK = 'DRILL-PACK'
# -----------------------------------------------
class STOP_MOTION:
    STABLE  = (10, 'STABLE')
    STAND   = (11, 'STAND')
    LOWER   = (12, 'LOWER')
    LIMBO   = (13, 'LIMBO')

class LOOP_MOTION:
    WALK_FORWARD = (32, 'WALK_FORWARD')
    WALK_BACKWARD = (33, 'WALK_BACKWARD')
    WALK_LEFT = (34, 'WALK_LEFT')
    WALK_RIGHT = (35, 'WALK_RIGHT')

    LOWER_FORWARD = (36, '')
    LOWER_BACKWARD = (37, '')
    LOWER_LEFT = (38, '')
    LOWER_RIGHT = (39, '')

    TURN_LEFT = (40, '')
    TURN_RIGHT = (41, '')

    TURN_LOWER_LEFT = (42, '')
    TURN_LOWER_RIGHT = (43, '')

class STEP:
    FORWARD = (64, '')
    BACKWARD = (65, '')
    LEFT = (66, 'LEFT')
    RIGHT = (67, 'RIGHT')

    LOWER_FORWARD = (68, '')
    LOWER_BACKWARD = (69, '')
    LOWER_LEFT = (70, '')
    LOWER_RIGHT = (71, '')

    TURN_LEFT = (72, 'TURN_LEFT')
    TURN_RIGHT = (73, 'TURN_RIGHT')

    TURN_LOWER_LEFT = (74, '')
    TURN_LOWER_RIGHT = (75, '')

class HEAD:
    # 좌우
    YAW_CENTER = (96, '')
    YAW_LEFT_90 = (97, '')
    YAW_RIGHT_90 = (98, '')
    YAW_LEFT_45 = (99, '')
    YAW_RIGHT_45 = (100, '')
    
    # 상하
    PITCH_CENTER = (101, '')
    PITCH_LOWER_45 = (102, 'PITCH_LOWER_45')
    PITCH_LOWER_90 = (103, 'PITCH_LOWER_90')

class ARM:
    DOWN = (112, '')
    MID = (113, '')
    UP = (114, '')

class MACRO:
    SHUTTER = (128, '')
    OPEN_DOOR = (129, '')

    TEMP = (1, '')
    
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
            return STEP.TURN_LEFT

        elif isDoor():
            return MACRO.OPEN_DOOR

        elif isShutter():
            return MACRO.SHUTTER

        elif isLimbo():
            return STOP_MOTION.LIMBO

        else:
            return STOP_MOTION.LOWER

    elif isObject():
        return STOP_MOTION.STAND

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
    roi = mskv[:cam.HEIGHT//2,:]
    conts = objContTrace(roi)
    return len(conts) == 0
# --------
def isCurve(mask):
    mskh = detectHoriLine(mask)
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
        return False

    line = max(line_probs, key=cv2.contourArea)
    vx,vy,x,y = cv2.fitLine(line, cv2.DIST_L2,0,0.01,0.01)

    if vy == 0:
        return False

    top_x = vx/vy * ( - y) + x
    bot_x = vx/vy * ((cam.HEIGHT + bottom_y_ext) - y) + x

    dx = (top_x - bot_x) / cam.WIDTH * 100
    bx = (bot_x - cam.CENTER[0]) / cam.CENTER[0] * 100

    if abs(bx) + abs(dx) > 1000:
        return False

    # 위치 보정
    if abs(bx) > ltr_shift_sen:
        return STEP.RIGHT if bx > 0 else STEP.LEFT

    # 회전각 보정
    if abs(dx) > ltr_turn_sen:
        return STEP.TURN_RIGHT if dx > 0 else STEP.TURN_LEFT
        

    # 문제가 없으면 전진
    return LOOP_MOTION.WALK_FORWARD   