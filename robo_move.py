# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_color as color

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
i = 0
def context(color_masks):
    global i
    obj = {}
    for c in color_masks:
        obj[c] = objTrace(color_masks[c])

        for x,y,w,h in obj[c]:
            cv2.rectangle(color_masks[c], (x,y), (x+w, y+h), (255,255,255), 1)
    
    if not obj['yellow']:
        i += 1
        print(i, 'LINE MISSING')

    elif obj['black'] and obj['red']:
        i += 1
        print(i, 'BRIDGE')
    
    elif obj['red'] and not obj['black']:
        i += 1
        print(i, 'DRILL_2')

    elif obj['green'] and obj['blue']:
        i += 1
        print(i, 'DRILL_1')
    
    else:
        i += 1
        print(i, 'WALKING')


def walking():
    pass

def walking_green():
    pass


def findGreenObj(green_mask):
    # 초록 장애물을 발견하는 동작
    boxes = objTrace(green_mask)

def findBlueZone(blue_mask):
    pass


    