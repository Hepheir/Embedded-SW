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
def _scan():
    line = sys.stdin.readline()
    sys.stdin.flush()
    sys.stdin.flush()
    return line
# -----------------------------------------------
def runtime_str():
    # 현재 실행시간 출력 : sec:ms (문자열 최소길이 7)
    total_ms = int(cv2.getTickCount() / cv2.getTickFrequency() * 1000)
    cs = (total_ms // 10) % 100
    s = (total_ms // 1000) % 60
    m = total_ms // 60000
    return '%d:%02d:%02d'%(m,s,cs)
# -----------------------------------------------
def _cvtColor(src, code):
    # 라즈베리파이에서는 YUV가 YVU순서로 되어있는 오류 보정
    ret = cv2.cvtColor(src, code)
    if isRasp() and code is cv2.COLOR_BGR2YUV:
        ret[:,:,1:] = ret[:,:,2:0:-1]
    return ret
# -----------------------------------------------
def waitKey(delay):
    key = cv2.waitKey(delay)
    return key & 0xFF if (key != -1) else False
# -----------------------------------------------
def showAllColorMasks(frame, color_masks, winname='masks'):
    LINE_THICKNESS = 2
    SCALER = 0.25 # 이미지 축소/확대 비율
    GAMMA = 32
    # --------
    height, width = frame.shape[:2]
    colors = len(color.DETECTABLE_COLORS)
    resolution = (int(width * colors * SCALER), int(height * SCALER) )
    # --------
    def _(color_name):
        mask_gray, ref = (color_masks[color_name], color.getRef(color_name))
        mask_bgr = cv2.cvtColor(mask_gray, cv2.COLOR_GRAY2BGR)
        selected_color_bgr = ref['bgr']

        # RETR_EXTERNAL : 외곽선만 구함 --> 처리속도 효율 향상 / APPROX_SIMPLE : 근사화 --> 데이터 량 줄임, 속도 향상
        contours = cv2.findContours(mask_gray, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
        if contours:
            max_cont = max(contours, key=cv2.contourArea)
            x,y,w,h = cv2.boundingRect(max_cont)

            # mask는 GRAY_SCALE 이므로, 컬러를 입히려면 BGR로 convert 해주어야함.
            cv2.rectangle(mask_bgr, (x,y), (x+w,y+h), selected_color_bgr, int(LINE_THICKNESS/SCALER))
        mask_bgr = cv2.addWeighted(frame, 0.3, mask_bgr, 0.7, GAMMA)
        mask_bgr[:,int(-1/SCALER):] = (255,255,255) # 각 마스크별 경계선
        return mask_bgr

    stacked_masks = np.hstack( tuple([_(color_name) for color_name in color_masks]) )
    resized = cv2.resize(stacked_masks, resolution)
    cv2.imshow('stacked masks', resized)
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
def remoteCtrl(key):
    macro = {
        ' ' : move.STOP_MOTION.STABLE,
        'x' : move.STOP_MOTION.LOWER,
        
        'w' : move.LOOP_MOTION.WALK_FORWARD,
        's' : move.LOOP_MOTION.WALK_BACKWARD,
        'a' : move.LOOP_MOTION.TURN_LEFT,
        'd' : move.LOOP_MOTION.TURN_RIGHT,

        'r' : move.HEAD.YAW_CENTER,
        'q' : move.HEAD.YAW_LEFT_90,
        'e' : move.HEAD.YAW_RIGHT_90,

        'z' : move.HEAD.PITCH_LOWER_45,
        'c' : move.HEAD.PITCH_LOWER_90,

        '1' : 1, '2' : 2, '3' : 3,
        '4' : 4, '5' : 5, '6' : 6,
        '7' : 7, '8' : 8, '9' : 9,
        '0' : 0
    }
    for c in macro:
        if key is ord(c):
            move.do(macro[c])
            return macro[c]
    return -1
# -----------------------------------------------
if __name__ == "__main__":
    record()