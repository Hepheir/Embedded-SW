# -*- coding: utf-8 -*-

import numpy as np
import cv2

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
        print(runtime(), 'LINE MISSING', end="\r")

    elif obj['black'] and obj['red']:
        print(runtime(), 'BRIDGE      ', end="\r")
    
    elif obj['red'] and not obj['black']:
        print(runtime(), 'DRILL_2     ', end="\r")

    elif obj['green'] and obj['blue']:
        print(runtime(), 'DRILL_1     ', end="\r")
    
    else:
        print(runtime(), 'WALKING     ', end="\r")


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


    