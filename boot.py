# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math
import serial

import module.mainloop as mainloop

# -------- User Setting --------
BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200

# -------- Camera Load --------
video = cv2.VideoCapture(0)
time.sleep(0.5)

if not video.isOpened():
    raise Exception("Could not open video device")

video.set(cv2.CAP_PROP_FRAME_WIDTH,  320)
video.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)

print('Camera loaded.')
# -------- Serial Setting --------
serial_use = False
serial_port =  None

if serial_use: #? Serial 통신 활성화 시, 미리 버퍼를 클리어
    serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
    serial_port.flush() # serial cls

print('Serial setting done.')
# -------- Screen Setting --------
FRAME_HEIGHT, FRAME_WIDTH = video.read()[1].shape[:2]
FRAME_CENTER = (FRAME_WIDTH//2, FRAME_HEIGHT//2)

SCREEN_PADDING = 32
SCREEN_HEIGHT, SCREEN_WIDTH = (FRAME_HEIGHT + 2*SCREEN_PADDING, FRAME_WIDTH)
SCREEN_CENTER = (SCREEN_WIDTH//2, SCREEN_HEIGHT//2)

SCREEN_FRAME_AREA = (
    # HEIGHT
    SCREEN_PADDING,
    FRAME_HEIGHT+SCREEN_PADDING,
    # WIDTH
    0,
    FRAME_WIDTH
)

SCREEN_BLACK = np.zeros((SCREEN_HEIGHT,SCREEN_WIDTH,3), dtype=np.uint8)

main_frame = None

def frame_top_text(text):
    global main_frame
    cv2.putText(main_frame, text, (4, 16), cv2.FONT_HERSHEY_PLAIN, 1, (0xFF,0xFF,0xFF), thickness = 1)

def frame_bottom_text(text):
    global main_frame, SCREEN_HEIGHT, SCREEN_PADDING
    cv2.putText(main_frame, text, (4, SCREEN_HEIGHT-SCREEN_PADDING+16), cv2.FONT_HERSHEY_PLAIN, 1, (0xFF,0xFF,0xFF), thickness = 1)

cv2.namedWindow(WINNAME['main'])
cv2.namedWindow(WINNAME['mask'])

print('Screen setting done : %dx%d' % (FRAME_WIDTH,FRAME_HEIGHT))
# -------- Debug Preset --------

SHOW_TRACKBAR = False

if SHOW_TRACKBAR:
    
    DEBUG_H_MAX = 360
    DEBUG_SV_MAX = 100

    def changeRef(colorname, keyname, hsv_select, value):
        global COLOR_REF
        global DEBUG_H_MAX, DEBUG_SV_MAX
        h,s,v = COLOR_REF[colorname][keyname]
        new_hsv = None
        if hsv_select is 'h':
            new_hsv = (value * 255 // DEBUG_H_MAX, s, v)
        elif hsv_select is 's':
            new_hsv = (h, value * 255 // DEBUG_SV_MAX, v)
        elif hsv_select is 'v':
            new_hsv = (h, s, value * 255 // DEBUG_SV_MAX)
        
        COLOR_REF[colorname][keyname] = new_hsv

        if 'next' in COLOR_REF[colorname]:
            nextcolorname = COLOR_REF[colorname]['next']
            changeRef(nextcolorname, keyname, hsv_select, value)


    cv2.createTrackbar('DEBUG', WINNAME['main'],0x00,0xFF, onDebugTrackbar_Change)

current_status = STATUS['line_tracing']

# -------- Main Loop Start --------
print('Start main loop!')
while True:
    pass

# cleanup the camera and close any open windows
video.release()
cv2.destroyAllWindows()

if serial_use:
    serial_port.close()