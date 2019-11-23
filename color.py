# -*- coding: utf-8 -*-

import numpy as np
import cv2

UNDEF = 0
BLACK = 1
WHITE = 2
GRAY = 3
RED = 4
GREEN = 5
BLUE = 6
YELLOW = 7

# ******************************************************************
# ******************************************************************
# ******************************************************************



# ******************************************************************

def nothing(x):
    pass

def pickColor(frame):
    channels = cv2.split(frame)
    return np.array([int(ch.mean()) for ch in channels])

def pixColorRef(hsv_pixel):
    h,s,v = hsv_pixel
    # 무채색
    if s < 80:
        if            v <  80:  return BLACK
        elif          v < 192:  return GRAY
        elif    192 < v:        return WHITE
    # 채색
    elif 100 < s:
        if       20 < h <  35:  return YELLOW
        elif     50 < h <  80:  return GREEN
        elif    100 < h < 120:  return BLUE
        elif    170 < h < 180:  return RED
    # 그 외
    return UNDEF

def colorRange(colorRef):
    # lowerb, upperb of HSV
    TH1 = 100
    if   colorRef is BLACK:     return [(  0,  0,  0), (255, 80, 80)]
    elif colorRef is GRAY:      return [(  0,  0, 80), (255, 80,192)]
    elif colorRef is WHITE:     return [(  0,  0,192), (255, 80,255)]

    elif colorRef is YELLOW:    return [( 20,TH1,  0), ( 35,255,255)]
    elif colorRef is GREEN:     return [( 50,TH1,  0), ( 80,255,255)]
    elif colorRef is BLUE:      return [(100,TH1,  0), (120,255,255)]
    elif colorRef is RED:       return [(170,TH1,  0), (180,255,255)]
    else:                       return None

def toString(colorRef):
    if   colorRef is UNDEF:     return 'undefined'
    elif colorRef is BLACK:     return 'black'
    elif colorRef is GRAY:      return 'gray'
    elif colorRef is WHITE:     return 'white'
    elif colorRef is RED:       return 'red'
    elif colorRef is GREEN:     return 'green'
    elif colorRef is BLUE:      return 'blue'
    elif colorRef is YELLOW:    return 'yellow'
    else:                       return None

def colorMask(frame, colorRef, useFilter=True):
    lowerb, upperb = colorRange(colorRef)

    if useFilter:
        frame = cv2.GaussianBlur(frame, (5,5), 1)

    mask = cv2.inRange(frame, lowerb, upperb)

    if useFilter:
        mask = cv2.erode(mask, (3,3), iterations=2)
        mask = cv2.dilate(mask, (3,3), iterations=2)
    return mask


# def getMask(src, color=REF['YELLOW'], color_space='hsv'):
#     global hsv_ub, hsv_lb
#     hsv = cv2.cvtColor(src, cv2.COLOR_BGR2HSV)

#     mask = cv2.inRange(hsv, hsv_lb[color], hsv_ub[color])
#     mask = cv2.erode(mask, (3,3), iterations=1)
#     mask = cv2.dilate(mask, (3,3), iterations=1)
#     return mask


# def debugMode(video, resolution):
#     frame = None
#     upperb = None
#     lowerb = None

#     winname = 'DEBUG'
#     cv2.namedWindow(winname)
#     cv2.createTrackbar('H_ub', winname, hsv_ub[0,0], 255, nothing)
#     cv2.createTrackbar('H_lb', winname, hsv_lb[0,0], 255, nothing)

#     cv2.createTrackbar('S_ub', winname, hsv_ub[0,1], 255, nothing)
#     cv2.createTrackbar('S_lb', winname, hsv_lb[0,1], 255, nothing)

#     cv2.createTrackbar('V_ub', winname, hsv_ub[0,2], 255, nothing)
#     cv2.createTrackbar('V_lb', winname, hsv_lb[0,2], 255, nothing)

#     while True:
#         key = cv2.waitKey(1)
#         if (key == ord(' ')):
#             break

#         grab, now = video.read()
#         if not grab: break
#         else:
#             frame = cv2.resize(now, resolution)
#             cv2.imshow('CAM', frame)

#         upperb = np.array([cv2.getTrackbarPos('H_ub', winname), cv2.getTrackbarPos('S_ub', winname), cv2.getTrackbarPos('V_ub', winname)])
#         lowerb = np.array([cv2.getTrackbarPos('H_lb', winname), cv2.getTrackbarPos('S_lb', winname), cv2.getTrackbarPos('V_lb', winname)])
            
#         hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
#         mask = cv2.inRange(hsv, lowerb, upperb)
#         mask = cv2.erode(mask, (3,3), iterations=2)
#         mask = cv2.dilate(mask, (3,3), iterations=2)


#         cv2.imshow('CAM', frame)
#         cv2.imshow('MASK', mask)
#         cv2.namedWindow(winname)





# def huePick(frame, rectColor):

#     r = 6
#     x1,y1 = (cx-r, cy-r)
#     x2,y2 = (cx+r, cy+r)

#     cv2.rectangle(frame, (x1,y1), (x2,y2), rectColor, 1)
#     cut_hsv = cv2.cvtColor(frame[x1:x2,y1:y2], cv2.COLOR_BGR2HSV)
#     h = int(cut_hsv[:,:,0].mean())
#     return h

# def colorSetAuto(frame):
#     fh,fw = frame.shape[:2]
#     cy, cx = (fh//2, fw//2)
    
#     r = 6 # 사각형 반지름 : (가로-1)/2
#     gap = 3*r # 사각형 간격
#     rects = [
#         {
#             'ref' : REF['YELLOW'],
#             'box_color' : (0, 255, 255), # BGR
#             'p1' : (cx-(3*r+1)-gap, cy-r),
#             'p2' : (cx-(r)    -gap, cy+r)
#         },
#         {
#             'ref' : REF['BLUE'],
#             'box_color' : (255, 0, 0), # BGR
#             'p1' : (cx-r, cy-r),
#             'p2' : (cx+r, cy+r)
#         },
#         {
#             'ref' : REF['RED'],
#             'box_color' : (0, 0, 255), # BGR
#             'p1' : (cx+(r)    +gap, cy-r),
#             'p2' : (cx+(3*r+1)+gap, cy+r)
#         }]

#     update_mode = cv2.waitKey(1) is ord(' ')

#     for rect in rects:
#         if update_mode:
#             x1,y1 = rect['p1']
#             x2,y2 = rect['p2']
#             ref = rect['ref']

#             cut_h = cv2.cvtColor(frame[x1:x2,y1:y2], cv2.COLOR_BGR2HSV)[:,:,0]
#             new_color = int(cut_h.mean())

#             hsv_ub[ref,0] = new_color + 8
#             hsv_lb[ref,0] = new_color - 8

#             print('new color set', rect['ref'], new_color)

#         cv2.rectangle(frame, rect['p1'], rect['p2'], rect['box_color'], 2)

#     return frame
    
