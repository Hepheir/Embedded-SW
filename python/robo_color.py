# -*- coding: utf-8 -*-

import numpy as np
import cv2

import json

import robo_debug as debug


# 색상 상수
UNDEF   = 'undefined'
BLACK   = 'black'
WHITE   = 'white'
GRAY    = 'gray'
RED     = 'red'
GREEN   = 'green'
BLUE    = 'blue'
YELLOW  = 'yellow'

# 우선순위 순서로 정렬해야 함 (중요한 색상이 앞으로)
COLOR_REFERENCES = []
DETECTABLE_COLORS = []

MIN, MAX = 0, 255

# ******************************************************************
# ******************************************************************
# ******************************************************************

def nothing(x):
    pass
#-----------------------------------------------
def init(filename="data_color.json"):
    global COLOR_REFERENCES
    global DETECTABLE_COLORS

    print('"robo_color.py" initialized')

    with open(filename, 'r') as file:
        references = json.load(file)['references']
        # 리스트 --> 튜플로 변경
        for ref in references:
            new_ref = {}
            for key in ref:
                # 유니코드 디코딩
                new_key = str(key)
                # 자료형을 알맞게 변환하는 과정
                if type(ref[key]) is type([]):
                    new_ref[new_key] = tuple(ref[key])
                elif type(ref[key]) is type(u''):
                    new_ref[new_key] = str(ref[key])
                else:
                    new_ref[new_key] = ref[key]
                # 새로운 bgr 속성도 추가
                if new_key == 'rgb': 
                    new_ref['bgr'] = tuple(ref[key][::-1])
            
            COLOR_REFERENCES.append(new_ref)
    
    for ref in COLOR_REFERENCES:
        if ref['detectable']:
            DETECTABLE_COLORS.append(ref)
    
    for i in range(len(DETECTABLE_COLORS)-1):
        for j in range(i, len(DETECTABLE_COLORS)-1):
            if DETECTABLE_COLORS[j]['importance'] < DETECTABLE_COLORS[j+1]['importance']:
                temp = DETECTABLE_COLORS[i]
                DETECTABLE_COLORS[i] = DETECTABLE_COLORS[j+1]
                DETECTABLE_COLORS[j+1] = temp

    print('    Data loaded from', filename)
    print('    Detectable colors :', [ref['color_name'] for ref in DETECTABLE_COLORS])
#-----------------------------------------------
def pickColor(frame):
    # 입력된 이미지에 있는 모든 픽셀 값들의 평균을 반환.
    # (예: RGB의 경우 R평균, G평균, B평균을 각각 따로 계산하여 반환)
    channels = cv2.split(frame)
    return np.array([int(ch.mean()) for ch in channels])
#-----------------------------------------------
def pixColorRefHSV(hsv_pixel):
    # HSV형식으로 입력된 한 픽셀의 색상을 반환.
    h,s,v = hsv_pixel
    # - 무채색
    if s < 80:
        if            v <  80:  return BLACK
        elif          v < 192:  return GRAY
        elif    192 < v:        return WHITE
    # - 채색
    elif 100 < s:
        if       20 < h <  35:  return YELLOW
        elif     50 < h <  80:  return GREEN
        elif    100 < h < 120:  return BLUE
        elif    170 < h < 180:  return RED
    # - 그 외
    return UNDEF
#-----------------------------------------------
# ******************************************************************
# ******************************************************************
# ******************************************************************
def getRef(color):
    for ref in COLOR_REFERENCES:
        if ref['color_name'] == color:
            return ref
    return None
#-----------------------------------------------
def colorMaskAll(frame, useFilter=True,imshow=False):
    # BGR 이미지로부터 colorRef에 해당하는 색을 검출하여 마스크이미지를 반환.
    # 주어진 프레임으로부터 검출할 수 있는 모든 색상을 검출
    # 반환 값은 Dict 형식으로, { "색상1" : 마스크1, "색상2" : 마스크2, ... } 형식
    frame = frame.copy()

    if useFilter:
        frame = cv2.GaussianBlur(frame, (3,3), 1)
    
    hsv = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV)
    yuv = debug._cvtColor(frame,cv2.COLOR_BGR2YUV)

    retval = {}

    for i in range(len(DETECTABLE_COLORS)):
        ref = DETECTABLE_COLORS[i]
        
        hsv_mask = cv2.inRange(hsv, ref['hsv_lower'], ref['hsv_upper'])
        yuv_mask = cv2.inRange(yuv, ref['yuv_lower'], ref['yuv_upper'])

        mask = cv2.bitwise_and(hsv_mask, yuv_mask)

        # cv2.imshow('raw %s' % ref['color_name'], cv2.addWeighted(frame, 0.3, cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR), 0.7, 0))

        # 중복 제거
        for color in retval:
            clm = cv2.bitwise_not(retval[color]) # mask for clear
            mask = cv2.bitwise_and(mask, clm)

        if useFilter:
            mask = cv2.erode(mask, (3,3), iterations=1)
            mask = cv2.dilate(mask, (3,3), iterations=1)

        retval[ref['color_name']] = mask

    if imshow:
        debug.showAllColorMasks(frame, retval)

    return retval
# ******************************************************************
# ******************************************************************
# ******************************************************************

trackBar_winname = None
trackBar_varnames = [
    'max_0', 'min_0',
    'max_1', 'min_1',
    'max_2', 'min_2']
#--------
def trackBar_init(winname='trackBars'):
    global trackBar_winname
    global trackBar_varnames

    trackBar_winname = winname
    cv2.namedWindow(trackBar_winname)

    for name in trackBar_varnames:
        cv2.createTrackbar(name, trackBar_winname, MIN, MAX, nothing)
#--------
def trackBar_update(frame):
    global trackBar_winname
    global trackBar_varnames

    values = [cv2.getTrackbarPos(name, trackBar_winname) for name in trackBar_varnames]
    max0, min0, max1, min1, max2, min2 = values

    lowerb = (min0, min1, min2)
    upperb = (max0, max1, max2)

    mask = cv2.inRange(frame, lowerb, upperb)
    cv2.imshow(trackBar_winname, mask)
#-----------------------------------------------
if __name__ == '__main__':
    init()