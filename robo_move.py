# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_serial as serial
import robo_color as color
import time

#-----------------------------------------------
def runtime():
    ms = int(cv2.getTickCount() / cv2.getTickFrequency() * 1000)
    return "%6d:%02d"%(ms//1000, ms//10%100)
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
    
    if not obj['yellow']:
        status = 'LINE MISSING'
        print(runtime(), '%-20s'%status, end="\r")

    # if yellow
    elif obj['red'] and obj['black']:
        status = 'BRIDGE'
        print(runtime(), '%-20s'%status, end="\r")
    
    elif obj['red'] and not obj['black']:
        status = 'DRILL-CAN'
        print(runtime(), '%-20s'%status, end="\r")

    elif obj['green'] and obj['blue']:
        status = 'SORT-PACK'
        print(runtime(), '%-20s'%status, end="\r")

    elif obj['green'] and not obj['blue']:
        status = 'DRILL-PACK'
        print(runtime(), '%-20s'%status, end="\r")
    
    else:
        status = 'WALKING'
        print(runtime(), '%-20s'%status, end="\r")


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


    