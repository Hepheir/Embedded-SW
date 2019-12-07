# -*- coding: utf-8 -*-

import numpy as np
import cv2

import sys

import robo_color as color
import robo_move as move
# 디버그용으로 임시로 쓰고 말 것들

DEBUG_MODE = False

# -----------------------------------------------
def python_version():
    return (sys.hexversion & 0xFF000000) // 0x1000000
# -----------------------------------------------
def isRasp():
    return python_version() < 3
# -----------------------------------------------
def _print(string):
    sys.stdout.write(string)
    sys.stdout.flush()
# -----------------------------------------------
def _cvtColor(src, code):
    ret = cv2.cvtColor(src, code)
    if isRasp() and code is cv2.COLOR_BGR2YUV:
        ret[:,:,1:] = ret[:,:,2:0:-1]
    return ret
# -----------------------------------------------
def showAllColorMasks(frame,color_masks):
    height, width = frame.shape[:2]
    colors = len(color.DETECTABLE_COLORS)
    line_thick = 2
    scaler = 0.5 # 이미지 축소/확대 비율
    gamma = 72

    detected = np.zeros((height, width * colors, 3), dtype=np.uint8)

    i = 0
    for color_name in color_masks:
        mask = color_masks[color_name].copy()
        ref = color.getRef(color_name)
        color_bgr = ref['rgb'][::-1] # [::-1], RGB 를 역순으로 --> BGR

        # RETR_EXTERNAL : 외곽선만 구함 --> 처리속도 효율 향상 / APPROX_SIMPLE : 근사화 --> 데이터 량 줄임, 속도 향상
        contours = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]

        mask = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR)
        color_mask = cv2.addWeighted(mask, .7, frame, .3, gamma)

        if contours:
            max_cont = max(contours, key=cv2.contourArea)
            x,y,w,h = cv2.boundingRect(max_cont)

            # mask는 GRAY_SCALE 이므로, 컬러를 입히려면 BGR로 convert 해주어야함.
            cv2.rectangle(color_mask, (x,y), (x+w,y+h), color_bgr, int(line_thick/scaler))

        stX = width * i # StartX : 이미지 붙여넣을 위치 (x좌표)
        detected[:, stX:(stX+width)] = color_mask # 마스크 붙여넣기
        detected[:, (stX+width-1)] = (255,255,255) # 각 마스크별 흰색 두께 1의 경계선
        
        i += 1
    cv2.imshow('masks', cv2.resize(detected, ( int(width*colors*scaler), int(height*scaler))))
# -----------------------------------------------
def record():
    # find the webcam
    cap = cv2.VideoCapture(0)
    # video recorder
    w = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
    h = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
    fourcc = cv2.VideoWriter_fourcc(*'MJPG')
    out = cv2.VideoWriter('output.avi',fourcc, 15.0, (int(w),int(h)))
    # record video
    while (cap.isOpened()):
        if ord(' ') == (cv2.waitKey(1) & 0xFF):
            break
        ret, frame = cap.read() 
        if not ret:
            break
        out.write(frame)
        cv2.imshow('Video Stream', frame)

    cap.release()
    cv2.destroyAllWindows()
# -----------------------------------------------
def runtime():
    ms = int(cv2.getTickCount() / cv2.getTickFrequency() * 1000)
    return "%7d:%02d"%(ms//1000, ms//10%100)
# -----------------------------------------------
def waitKey(delay):
    key = cv2.waitKey(delay) & 0xFF
    if key == -1:
        _print('[ ] ')
    else:
        _print('[%c] ' % chr(key))
    return key
# -----------------------------------------------
def remoteCtrl(key):
    if key is ord('w'):
        move.do(move.act.FORWARD_WALK)
    elif key is ord('a'):
        move.do(move.act.TURN_LEFT)
    elif key is ord('s'):
        move.do(move.act.BACKWARD_WALK)
    elif key is ord('d'):
        move.do(move.act.TURN_RIGHT)
    else:
        move.do(move.act.STABLE)
# -----------------------------------------------
if __name__ == "__main__":
    record()