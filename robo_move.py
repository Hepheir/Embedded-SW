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
    HAND_SHUTTER            = 1  # 손셔터
    FORWARD_WALK            = 2  # 전진종종걸음
    RIGHT_HAND_OPEN_DOOR    = 3  # 오른손 들고 문열기
    TURN_LEFT_3             = 4  # 왼쪽 턴 3
    FORWARD_RUN             = 5  # 전진 달리기 50
    TURN_RIGHT_3            = 6  # 오른쪽 턴 3
    SIT_1                   = 7  # 앉은자세 1
    FORWARD_WALK_1          = 8  # 전진종종걸음 1 (팔 안움직이고 걷기)
    FORWARD_WALK_2          = 9  # 전진종종걸음 2 (팔 안움직이고 앉아서 걷기)
    GRAB_OBJECT             = 10 # 우유곽 잡기
    FREE_OBJECT             = 15 # 우유곽 놓기
    CLEAR_CAN               = 18 # 캔 날리기
    BACKWARD_WALK           = 29 # 연속 후진
# -----------------------------------------------
def do(action):
    for _ in range(16):
        serial.TX_data(action)
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


    