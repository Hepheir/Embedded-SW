# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math


# CUSTOM =================================================

class HSV():
    def __init__(self,h,s,v):
        self.h = h
        self.s = s
        self.v = v

STATUS = {
    'debug' : -1,
    'stop' : 0,
    'line tracing' : 1 # line tracing
}

# bandwidth : lower, upper hsv를 파악하는데 사용.
COLOR_REF = {
    'line' : {
        'hsv' : HSV(66,21,242),
        'bandwidth' : HSV(32,32,32),
        'minArea' : 40
    },
    'yellow' : {
        'hsv' : HSV(201,153,172),
        'bandwidth' : HSV(102,82,166),
        'minArea' : 50
    },
    'red' : {
        'hsv' : HSV(32,170,123),
        'bandwidth' : HSV(66,60,56),
        'minArea' : 50
    },
    'blue' : {
        'hsv' : HSV(85,80,108),
        'bandwidth' : HSV(52,60,96),
        'minArea' : 10
    }
}
HIGHLIGHT = {
    'color' : (0,0,255),
    'thickness' : 2
}
VIEW_SIZE = { 'width' : None, 'height' : None }
BPS = 4800


WINNAME = {
    'main' : 'main',
    'mask' : 'masking'
}
KEY = {
    'esc' : 27,
    'spacebar' : ord(' ')
}

# ============================================================

serial_use = False
serial_port =  None

system_pause = False

#-----------------------------------------------
def nothing(x):
    pass
#-----------------------------------------------
def create_blank(width, height):
    image = np.zeros((height, width, 3), dtype=np.uint8)
    return image
#-----------------------------------------------

# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************

if __name__ == '__main__':
    # -------- User Setting --------
    BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200
    
    # -------- Camera Load --------
    camera = cv2.VideoCapture(0)
    time.sleep(0.5)

    # -------- Serial Setting --------
    serial_use = False # DEBUG

    if serial_use: #? Serial 통신 활성화 시, 미리 버퍼를 클리어
       serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
       serial_port.flush() # serial cls

    # -------- Screen Setting --------
    _,frame = camera.read()
    VIEW_SIZE['height'], VIEW_SIZE['width'] = frame.shape[:2]

    cv2.namedWindow(WINNAME['main'])

    # -------- Debug Preset --------
    current_status = STATUS['line tracing']

    # -------- Main Loop Start --------
    while True:
        # -------- Toggle System pause --------
        key = cv2.waitKey(1) # 0xFF 와 AND 연산
        if key is KEY['esc']:
            break
        elif key is KEY['spacebar']:
            system_pause = not system_pause

        if system_pause:
            continue

        # -------- Grab frames --------
        next_frame, current_frame = camera.read()
        if not next_frame:
            break # no more frames to read : EOF

        # -------- Check Context --------
        # TODO : 현재 상황 파악 하는 부분
        # current_status = ?

        # -------- Action :: Debug --------
        if current_status == STATUS['debug']:
            pass # TODO : 디버그 모드 (여유가 되면)

        # -------- Action :: Line Tracing --------
        elif current_status == STATUS['line tracing']:
            print(VIEW_SIZE)
            #roi = current_frame[] # Region of Interest : 관심영역
            pass # TODO : 라인트레이싱 (급함, 우선순위 1)
        
        cv2.imshow(WINNAME['main'], current_frame)


    # cleanup the camera and close any open windows
    if serial_use:
       serial_port.close()
    camera.release()
    cv2.destroyAllWindows()