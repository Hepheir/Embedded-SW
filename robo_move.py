# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_color as color
import robo_camera as cam
import robo_serial as serial

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
def do(action):
    serial.TX_data(action)
# -----------------------------------------------
def get(sensor):
    serial.TX_data(sensor)
    return serial.RX_data
# -----------------------------------------------
def objTrace(mask, minObjSize=50):
    retval = []
    contours = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
    if not contours:
        return retval
    for cont in contours:
        area = cv2.contourArea(cont)
        if (area < minObjSize):
            continue
        box = cv2.boundingRect(cont)
        retval.append(box)
    return retval
# -----------------------------------------------
def centerOfBox(box):
    x,y,w,h = box
    cx, cy = (x + w//2, y + h//2)
    return (cx,cy)
# -----------------------------------------------
def context(color_masks):
    obj = {}
    for c in color_masks:
        # 프레임의 세로 3분할
        c1b3_color_mask = color_masks[c][cam.HEIGHT*2//3:,:]

        # 3분할 된 마스크 가장 아래꺼에서 '특정 크기 이상의 물체'의 '바운딩박스' 구하기
        obj[c] = objTrace(c1b3_color_mask)
    # --------
    if not obj['yellow']:
        # 라인 찾기
        return STATUS.LINE_MISSING
    # --------
    elif obj['red'] and obj['black']:
        # 다리 건너기
        return STATUS.BRIDGE
    # --------
    elif obj['red'] and not obj['black']:
        # 코카콜라 캔 치우기
        return STATUS.DRILL_CAN
    # --------
    elif obj['green'] and obj['blue']:
        # 우유곽 파란선 안으로 옮기기
        return STATUS.DRILL_PACK
    # --------
    elif obj['green'] and not obj['blue']:
        # 우유곽 치우기
        return STATUS.DRILL_PACK
    # --------
    else:
        # 걷기
        return STATUS.WALKING
    # --------

# -----------------------------------------------
def walking():
    pass

def walking_green():
    pass


def findGreenObj(green_mask):
    # 초록 장애물을 발견하는 동작
    boxes = objTrace(green_mask)

def findBlueZone(blue_mask):
    pass


    