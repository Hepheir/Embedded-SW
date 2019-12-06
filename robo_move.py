# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_serial as serial
import robo_color as color
import time

LINE_MISSING = 'LINE MISSING'
WALKING = 'WALKING'

BRIDGE = 'BRIDGE'

DRILL_CAN = 'DRILL-CAN'
DRILL_PACK = 'DRILL-PACK'
#-----------------------------------------------
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
#-----------------------------------------------
def centerOfBox(box):
    x,y,w,h = box
    cx, cy = (x + w//2, y + h//2)
    return (cx,cy)
#-----------------------------------------------
def context(color_masks):
    obj = {}
    for c in color_masks:
        obj[c] = objTrace(color_masks[c])
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

#-----------------------------------------------
def walking():
    pass

def walking_green():
    pass


def findGreenObj(green_mask):
    # 초록 장애물을 발견하는 동작
    boxes = objTrace(green_mask)

def findBlueZone(blue_mask):
    pass


    