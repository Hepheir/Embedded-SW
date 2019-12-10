# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_color as color
import robo_camera as cam
import robo_serial as serial

# line_angle = 0 # @ context

class STATUS:
    LINE_MISSING = 'LINE MISSING'
    WALKING = 'WALKING'

    BRIDGE = 'BRIDGE'

    DRILL_CAN = 'DRILL-CAN'
    DRILL_PACK = 'DRILL-PACK'
# -----------------------------------------------
class STOP_MOTION:
    STABLE  = 10
    STAND   = 11
    LOWER   = 12
    LIMBO   = 13

class LOOP_MOTION:
    WALK_FORWARD = 32
    WALK_BACKWARD = 33
    WALK_LEFT = 34
    WALK_RIGHT = 35

    LOWER_FORWARD = 36
    LOWER_BACKWARD = 37
    LOWER_LEFT = 38
    LOWER_RIGHT = 39

    TURN_LEFT = 40
    TURN_RIGHT = 41

    TURN_LOWER_LEFT = 42
    TURN_LOWER_RIGHT = 43

class STEP:
    FORWARD = 64
    BACKWARD = 65
    LEFT = 66
    RIGHT = 67

    LOWER_FORWARD = 68
    LOWER_BACKWARD = 69
    LOWER_LEFT = 70
    LOWER_RIGHT = 71

    TURN_LEFT = 72
    TURN_RIGHT = 73

    TURN_LOWER_LEFT = 74
    TURN_LOWER_RIGHT = 75

class HEAD:
    # 좌우
    YAW_CENTER = 96
    YAW_LEFT_90 = 97
    YAW_RIGHT_90 = 98
    YAW_LEFT_45 = 99
    YAW_RIGHT_45 = 100
    
    # 상하
    PITCH_CENTER = 101
    PITCH_LOWER_45 = 102
    PITCH_LOWER_90 = 103

class ARM:
    DOWN = 112
    MID = 113
    UP = 114

class MACRO:
    SHUTTER = 128
    OPEN_DOOR = 129
    
class SENSOR:
    DISTANCE = None # 적외선 센서 거리측정
# -----------------------------------------------
def do(action):
    serial.TX_data(action)
# -----------------------------------------------
def get(sensor):
    serial.TX_data(sensor)
    return serial.RX_data
# -----------------------------------------------
def objTrace(mask, minObjSize=50):
    contours = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
    if not contours:
        return []
    return list(filter(lambda c: cv2.contourArea(c) > minObjSize, contours))
# -----------------------------------------------
def center_of_contour(contour):
	# compute the center of the contour
    M = cv2.moments(contour)
    cx = int(M["m10"] / M["m00"])
    cy = int(M["m01"] / M["m00"])
    return (cx, cy)
# -----------------------------------------------
def context(frame):
    # 현재 로봇이 처한 상황을 파악
    # --------
    obj = {}
    # 프레임의 세로 3분할
    cmask = color.colorMaskAll(frame)
    return str(onLine(frame, cmask))

    c1b3_frame = frame[cam.HEIGHT*2//3:,:]
    c1b3_colorMasks = color.colorMaskAll(c1b3_frame, imshow=True)
    for c in c1b3_colorMasks:
        mask = c1b3_colorMasks[c]
        # 3분할 된 마스크 가장 아래꺼에서 '특정 크기 이상의 물체'의 '윤곽선' 구하기
        obj[c] = objTrace(mask)
    # --------
    if not obj['yellow']:
        # 라인 찾기
        return STATUS.LINE_MISSING
    # --------
    elif obj['red'] and obj['black']:
        # 다리 건너기
        return STATUS.BRIDGE
    # --------
    elif obj['red'] and not obj['black']:
        # 코카콜라 캔 치우기
        return STATUS.DRILL_CAN
    # --------
    elif obj['green'] and obj['blue']:
        # 우유곽 파란선 안으로 옮기기
        return STATUS.DRILL_PACK
    # --------
    elif obj['green'] and not obj['blue']:
        # 우유곽 치우기
        return STATUS.DRILL_PACK
    # --------
    else:
        # 라인트레이싱
        line = max(obj['yellow'], key=cv2.contourArea)

        line_rect = cv2.minAreaRect(line)
        [vx,vy,x,y] = cv2.fitLine(line, cv2.DIST_L2,0,0.01,0.01)

        line_center = center_of_contour(line)
        line_box = np.int0( cv2.boxPoints(line_rect) )
        line_color = color.getRef('yellow')['bgr']
        line_thickness = 2

        cv2.line(frame, (x,y), (x+vx, y+vy), line_color, line_thickness)
        # cv2.circle(c1b3_frame, line_center, 2, line_color, -1)
        cv2.drawContours(c1b3_frame, [line_box], -1 , line_color, line_thickness)

        # 서브루틴 :
        
        return STATUS.WALKING
    # --------

# -----------------------------------------------
def onLine(frame, cmask):
    roi_frame = frame[cam.HEIGHT*2//3:,:]
    roi_cmask = cmask['yellow'][cam.HEIGHT*2//3:,:]

    # Line direction
    line_obj = max(objTrace(roi_cmask), key=cv2.contourArea)
    vx,vy,x,y = cv2.fitLine(line_obj, cv2.DIST_L2,0,0.01,0.01)
    dx = vx*(vy/abs(vy))

    return dx

    roi_c_l = cmask[:,                : cam.WIDTH//3   ]
    roi_c_c = cmask[:, cam.WIDTH//3   : cam.WIDTH*2//3 ]
    roi_c_r = cmask[:, cam.WIDTH*2//3 :               ]
    
    roi_obj = [ objTrace(roic) for roic in [roi_c_l, roi_c_c, roi_c_r] ]

    if roi_obj[0]:
        return -1
    elif roi_obj[1]:
        return 0
    elif roi_obj[2]:
        return 1
    else:
        return None

def walking():
    pass

def walking_green():
    pass


def findGreenObj(green_mask):
    # 초록 장애물을 발견하는 동작
    boxes = objTrace(green_mask)

def findBlueZone(blue_mask):
    pass


    