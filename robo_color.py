# -*- coding: utf-8 -*-

import numpy as np
import cv2

# 색상 상수
UNDEF = 0
BLACK = 1
WHITE = 2
GRAY = 3
RED = 4
GREEN = 5
BLUE = 6
YELLOW = 7

DETECTABLE_COLORS = [ BLACK, WHITE, GRAY, RED, GREEN, BLUE, YELLOW ]

# ******************************************************************
# ******************************************************************
# ******************************************************************



# ******************************************************************
def nothing(x):
    pass
#-----------------------------------------------
def toString(colorRef):
    # 상수로 주어진 색상 정보를 문자열로 변경하여 반환.
    if   colorRef is UNDEF:     return 'undefined'
    elif colorRef is BLACK:     return 'black'
    elif colorRef is GRAY:      return 'gray'
    elif colorRef is WHITE:     return 'white'
    elif colorRef is RED:       return 'red'
    elif colorRef is GREEN:     return 'green'
    elif colorRef is BLUE:      return 'blue'
    elif colorRef is YELLOW:    return 'yellow'
    else:                       return None
#-----------------------------------------------
def toRef(string):
    # 문자열로 주어진 색상 정보를 상수로 변경하여 반환.
    if   string == 'undefined': return UNDEF
    elif string == 'black':     return BLACK
    elif string == 'gray':      return GRAY
    elif string == 'white':     return WHITE
    elif string == 'red':       return RED
    elif string == 'green':     return GREEN
    elif string == 'blue':      return BLUE
    elif string == 'yellow':    return YELLOW
    else:                       return None
#-----------------------------------------------
def toRGB(colorRef):
    # 잡탕 유틸리티 함수 : colorRef에 해당하는 색을 BGR로 반환.
    # --> 선 그리기에 사용하자.
    if   colorRef is BLACK:     return ( 42, 42, 42) # (0, 0, 0) 으로 해두니 검출 여부조차 알 수 없음...
    elif colorRef is GRAY:      return (128,128,128)
    elif colorRef is WHITE:     return (255,255,255)
    elif colorRef is RED:       return (  0,  0,255)
    elif colorRef is GREEN:     return (  0,255,  0)
    elif colorRef is BLUE:      return (255,  0,  0)
    elif colorRef is YELLOW:    return (  0,255,255)
    else:                       return (  0,  0,255) # Default is RED
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
def colorRangeHSV(colorRef):
    # colorRef에 해당하는 색상을 탐지하기 위한 HSV의 범위를 반환.
    #   [ ( lowerb ), ( upperb ) ] of HSV
    TH1 = 100
    if   colorRef is BLACK:     return [(  0,  0,  0), (255, 80, 80)]
    elif colorRef is GRAY:      return [(  0,  0, 80), (255, 80,192)]
    elif colorRef is WHITE:     return [(  0,  0,192), (255, 80,255)]

    elif colorRef is YELLOW:    return [( 20,TH1,  0), ( 35,255,255)]
    elif colorRef is GREEN:     return [( 50,TH1,  0), ( 80,255,255)]
    elif colorRef is BLUE:      return [(100,TH1,  0), (120,255,255)]
    # elif colorRef is RED:       return [(170,TH1,  0), (180,255,255)] # UNSTABLE, use YUV not HSV.
    else:                       return None
#-----------------------------------------------
def colorRangeYUV(colorRef):
    # colorRef에 해당하는 색상을 탐지하기 위한 YUV의 범위를 반환.
    if   colorRef is RED:       return [(  0,107,158), (255,127,214)]
    else:                       return None
#-----------------------------------------------
def colorMask(frame, colorRef, useFilter=True):
    # BGR 이미지로부터 colorRef에 해당하는 색을 검출하여 마스크이미지를 반환.
    if type(colorRef) is type(''):
        colorRef = toRef(colorRef)
    
    if not colorRef in DETECTABLE_COLORS:
        print('Undetectable color', colorRef)
        return np.zeros(frame.shape)

    lowerb, upperb = None, None

    if useFilter:
        frame = cv2.GaussianBlur(frame, (5,5), 1)
    # ----
    if colorRef is RED:
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2YUV)
        lowerb, upperb = colorRangeYUV(colorRef)
    else:
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        lowerb, upperb = colorRangeHSV(colorRef)
    
    mask = cv2.inRange(frame, lowerb, upperb)
    # ----
    if useFilter:
        mask = cv2.erode(mask, (3,3), iterations=2)
        mask = cv2.dilate(mask, (3,3), iterations=2)

    # 그냥 넣어본 기능 (마스크에 색 입히기)
    canvas = np.zeros(frame.shape, dtype=np.uint8)
    color = toRGB(colorRef)
    canvas[:,:] = color
    mask = cv2.bitwise_and(canvas, canvas, mask=mask)

    return mask
#-----------------------------------------------
trackBar_winname = None
trackBar_varnames = [
    'max_0', 'min_0',
    'max_1', 'min_1',
    'max_2', 'min_2']

def trackBar_init(winname='trackBars'):
    global trackBar_winname
    global trackBar_varnames

    trackBar_winname = winname
    cv2.namedWindow(trackBar_winname)

    for name in trackBar_varnames:
        cv2.createTrackbar(name, trackBar_winname, 0, 255, nothing)

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
                


