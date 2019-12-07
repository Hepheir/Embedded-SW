# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_color as color
import robo_camera as cam
import robo_serial as serial

LINE_MISSING = 'LINE MISSING'
WALKING = 'WALKING'

BRIDGE = 'BRIDGE'

DRILL_CAN = 'DRILL-CAN'
DRILL_PACK = 'DRILL-PACK'
# -----------------------------------------------
class act:
    STABLE                          = 1 # 안정화 자세

    WALK_FORWARD_CONTINUOUS         = 2 # 전진종종걸음
    WALK_BACKWARD_CONTINUOUS        = 12 # 연속 후진

    WALK_LOWER_FORWARD_CONTINUOUS   = 3 # 전진종종걸음 - 쭈구려가기

    TURN_LEFT                       = 6 # 왼쪽 턴 20
    TURN_RIGHT                      = 7 # 오른쪽 턴 20

    HEAD_CENTER                     = 13 # 머리 중앙
    HEAD_RIGHT                      = 14 # 머리 오른쪽 90도
    HEAD_LEFT                       = 15 # 머리 왼쪽 90도

    
    
class sensor:
    DISTANCE                = None # 적외선 센서 거리측정
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
        return LINE_MISSING
    # --------
    elif obj['red'] and obj['black']:
        # 다리 건너기
        return BRIDGE
    # --------
    elif obj['red'] and not obj['black']:
        # 코카콜라 캔 치우기
        return DRILL_CAN
    # --------
    elif obj['green'] and obj['blue']:
        # 우유곽 파란선 안으로 옮기기
        return DRILL_PACK
    # --------
    elif obj['green'] and not obj['blue']:
        # 우유곽 치우기
        return DRILL_PACK
    # --------
    else:
        # 걷기
        return WALKING
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


    