# -*- coding: utf-8 -*-

import platform
import numpy as np
import argparse
import cv2
import serial
import time
import sys
from threading import Thread

import math


X_255_point = 0
Y_255_point = 0
X_Size = 0
Y_Size = 0
Area = 0
Angle = 0
#-----------------------------------------------
Top_name = 'mini CTS5 setting' # 송출된 화면 창의 이름
hsv_Lower = 0
hsv_Upper = 0

hsv_Lower0 = 0
hsv_Upper0 = 0

hsv_Lower1 = 0
hsv_Upper1 = 0


# CUSTOM =================================================

class HSV_Values():
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
        'hsv' : HSV_Values(66,21,242),
        'bandwidth' : HSV_Values(32,32,32),
        'minArea' : 40
    },
    'yellow' : {
        'hsv' : { 'h' : 201, 's' : 153 , 'v' : 172 },
        'bandwidth' : { 'h' : 102, 's' : 82 , 'v' : 166 },
        'minArea' : 50
    },
    'red' : {
        'hsv' : { 'h' : 32, 's' : 170 , 'v' : 123 },
        'bandwidth' : { 'h' : 66, 's' : 60 , 'v' : 56 },
        'minArea' : 50
    },
    'blue' : {
        'hsv' : { 'h' : 85, 's' : 80 , 'v' : 108 },
        'bandwidth' : { 'h' : 52, 's' : 60 , 'v' : 96 },
        'minArea' : 10
    }
}
HIGHLIGHT = {
    'color' : (0,0,255),
    'thickness' : 2
}
VIEW_SIZE = { 'width' : 320, 'height' : 240 }
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


Serial_error_count = 0
Read_RX =  0

threading_Time = 5/1000.

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
    #-------------------------------------
    #---- user Setting -------------------
    #-------------------------------------
    W_View_size =  320
    H_View_size = 240

    BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200
    current_status = STATUS['line tracing']

    serial_use = True
    #-------------------------------------
    img = create_blank(320, 240)
    
    cv2.namedWindow(WINNAME['main'])
    cv2.imshow(WINNAME['main'], img)
    #---------------------------
    # LOAD CAMERA
    camera = cv2.VideoCapture(0)
    time.sleep(0.5)
    #---------------------------
    
    if serial_use: #? Serial 통신 활성화 시, 미리 버퍼를 클리어
       serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
       serial_port.flush() # serial cls
       pass
    #    t = Thread(target=receiving, args=(serial_port,)) #? receiving가 무엇을 송신하려 하는 것인지 모르겠음
    #    time.sleep(0.1)
    #    t.start()

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
        current_status = STATUS['line tracing']

        # -------- Action :: Debug --------
        if current_status == STATUS['debug']:
            pass # TODO : 디버그 모드 (여유가 되면)

        # -------- Action :: Line Tracing --------
        elif current_status == STATUS['line tracing']:
            pass # TODO : 라인트레이싱 (급함, 우선순위 1)
        
        cv2.imshow(WINNAME['main'], current_frame)


    # cleanup the camera and close any open windows
    if serial_use:
       serial_port.close()
    camera.release()
    cv2.destroyAllWindows()