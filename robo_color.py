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

# 우선순위 순서로 정렬해야 함 (중요한 색상이 앞으로)
DETECTABLE_COLORS = [ YELLOW, GREEN, RED, BLUE, WHITE, BLACK, GRAY ]

MIN, MAX = 0, 255

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
    elif colorRef is WHITE:     return (MAX,MAX,MAX)
    elif colorRef is RED:       return (MIN,MIN,MAX)
    elif colorRef is GREEN:     return (MIN,MAX,MIN)
    elif colorRef is BLUE:      return (MAX,MIN,MIN)
    elif colorRef is YELLOW:    return (MIN,MAX,MAX)
    else:                       return (MIN,MIN,MAX) # Default is RED
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
    ____________BYPASS____________ =   [(MIN,MIN,MIN), (MAX,MAX,MAX)] # 이 컬러공간에서는 검출하는데 큰 영향이 없을 경우.
    ___________NO_COLOR___________ =   [(MIN,MIN,MIN), (MAX, 92,MAX)] # 이 컬러공간에서는 무채색만 분리하는 경우.
    __________COLOR_PASS__________ =   [(MIN, 72,MIN), (MAX,MAX,MAX)] # 이 컬러공간에서는 채색만 분리하는 경우.

                                       
    if   colorRef is BLACK:     return ___________NO_COLOR___________
    elif colorRef is GRAY:      return [(MIN,MIN, 72), (MAX, 81,211)]
    elif colorRef is WHITE:     return ___________NO_COLOR___________

    elif colorRef is YELLOW:    return [( 20, 40,MIN), ( 35,MAX,MAX)]
    elif colorRef is GREEN:     return __________COLOR_PASS__________ # [( 40, 40,MIN), (100,MAX,MAX)]
    elif colorRef is BLUE:      return __________COLOR_PASS__________ # [(100, 40,MIN), (120,MAX,MAX)]
    elif colorRef is RED:       return __________COLOR_PASS__________ # [(170,TH1,MIN), (180,MAX,MAX)] # UNSTABLE, use YUV not HSV.
    
    else:                       return ____________BYPASS____________
#-----------------------------------------------
def colorRangeYUV(colorRef):
    # colorRef에 해당하는 색상을 탐지하기 위한 YUV의 범위를 반환.
    ____________BYPASS____________ =   [(MIN,MIN,MIN), (MAX,MAX,MAX)] # 이 컬러공간에서는 검출하는데 큰 영향이 없을 경우.

    if   colorRef is BLACK:     return [(MIN,MIN,MIN), ( 64,MAX,MAX)]
    elif colorRef is GRAY:      return [( 64,MIN,MIN), (200,MAX,MAX)]
    elif colorRef is WHITE:     return [(200,MIN,MIN), (MAX,MAX,MAX)]

    elif colorRef is YELLOW:    return [( 32,MIN,148), (200,100,240)]
    elif colorRef is GREEN:     return [( 32,MIN,MIN), (200,128,128)]
    elif colorRef is BLUE:      return [( 32,148,MIN), (200,MAX,148)]
    elif colorRef is RED:       return [( 32,MIN,148), (200,148,MAX)]

    else:                       return ____________BYPASS____________

# ******************************************************************
# ******************************************************************
# ******************************************************************

def colorMask(frame, colorRef, useFilter=True):
    # BGR 이미지로부터 colorRef에 해당하는 색을 검출하여 마스크이미지를 반환.
    if type(colorRef) is type(''):
        colorRef = toRef(colorRef)
    
    if not colorRef in DETECTABLE_COLORS:
        print('Undetectable color', colorRef)
        return np.zeros(frame.shape)

    if useFilter:
        frame = cv2.GaussianBlur(frame, (3,3), 1)
    # ----
    hsv_lowb, hsv_uppb = colorRangeHSV(colorRef)
    yuv_lowb, yuv_uppb = colorRangeYUV(colorRef)
    
    hsv_mask = cv2.inRange(cv2.cvtColor(frame,cv2.COLOR_BGR2HSV), hsv_lowb, hsv_uppb)
    yuv_mask = cv2.inRange(cv2.cvtColor(frame,cv2.COLOR_BGR2YUV), yuv_lowb, yuv_uppb) 

    mask = cv2.bitwise_and(hsv_mask, yuv_mask)
    # ----
    if useFilter:
        mask = cv2.erode(mask, (3,3), iterations=1)
        mask = cv2.dilate(mask, (3,3), iterations=1)

    return mask
#-----------------------------------------------
def colorMaskAll(frame, useFilter=True):
    # BGR 이미지로부터 colorRef에 해당하는 색을 검출하여 마스크이미지를 반환.
    if useFilter:
        frame = cv2.GaussianBlur(frame, (3,3), 1)
    
    hsv = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV)
    yuv = cv2.cvtColor(frame,cv2.COLOR_BGR2YUV)

    retval = []

    for i in range(len(DETECTABLE_COLORS)):
        cref = DETECTABLE_COLORS[i]

        hsv_lowb, hsv_uppb = colorRangeHSV(cref)
        hsv_mask = cv2.inRange(hsv, hsv_lowb, hsv_uppb)

        yuv_lowb, yuv_uppb = colorRangeYUV(cref)
        yuv_mask = cv2.inRange(yuv, yuv_lowb, yuv_uppb) 

        mask = cv2.bitwise_and(hsv_mask, yuv_mask)
        
        # 중복 제거
        for r, m in retval:
            nm = cv2.bitwise_not(m)
            mask = cv2.bitwise_and(mask, nm)

        if useFilter:
            mask = cv2.erode(mask, (3,3), iterations=1)
            mask = cv2.dilate(mask, (3,3), iterations=1)

        retval.append((cref, mask))
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