# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math


# CUSTOM =================================================


def HSV_Parser(h_deg, s_per, v_per):
    h = h_deg * 255 // 360
    s = s_per * 255 // 100
    v = v_per * 255 // 100
    return h,s,v

# -------- Global Constants --------

STATUS = {
    'debug' : -1,
    'stop' : 0,
    'line tracing' : 1
}

# bandwidth : lower, upper hsv를 파악하는데 사용.
COLOR_REF = {
    'line' : {
        'hsv' : (201,153,172),
        'bandwidth' : 20,
        'minArea' : 40
    },
    'white' : {
        'hsv_lower' : HSV_Parser(0,0,68),
        'hsv_upper' : HSV_Parser(360,15,100),
        'minArea' : 40
    },
    'yellow' : {
        'hsv_lower' : HSV_Parser(30,40,40),
        'hsv_upper' : HSV_Parser(50,100,100),
        'minArea' : 50
    },
    'red' : {
        'hsv_lower' : HSV_Parser(0,40,40),
        'hsv_upper' : HSV_Parser(8,100,100),
        'minArea' : 50,
        'next' : 'red+'
    }, 'red+' : {
        'hsv_lower' : HSV_Parser(245,30,40),
        'hsv_upper' : HSV_Parser(360,100,100),
        'minArea' : 50
    },
    'blue' : {
        'hsv_lower' : HSV_Parser(124,40,40),
        'hsv_upper' : HSV_Parser(186,100,100),
        'minArea' : 10
    },
    'black' : {
        'hsv_lower' : HSV_Parser(0,0,0),
        'hsv_upper' : HSV_Parser(360,80,27),
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
    'mask' : 'mask'
}
KEY = {
    'esc' : 27,
    'spacebar' : ord(' '),
    '0' : ord('0'),
    '1' : ord('1'),
    '2' : ord('2'),
    '3' : ord('3'),
    '4' : ord('4'),
    '5' : ord('5')
}

# -------- Global Variables --------

current_color = 'blue'

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
def color_detection(image, color_reference):
    lower = color_reference['hsv_lower']
    upper = color_reference['hsv_upper']

    mask = cv2.inRange(image, lower, upper)

    if 'next' in color_reference:
        next_ref = COLOR_REF[color_reference['next']]
        mask_2 = cv2.inRange(image, next_ref['hsv_lower'], next_ref['hsv_upper'])
        mask = cv2.add(mask, mask_2)
    
    return mask
#-----------------------------------------------
def putText(image, pos, text):
    x,y = pos
    cv2.putText(image, text, (x+16, y+16), cv2.FONT_HERSHEY_PLAIN, 1, (0xFF,0xFF,0xFF), thickness = 1, lineType=cv2.LINE_AA)

# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# 84022014

if __name__ == '__main__':
    # -------- User Setting --------
    BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200
    
    # -------- Camera Load --------
    video = cv2.VideoCapture(0)
    time.sleep(0.5)

    if not video.isOpened():
        raise Exception("Could not open video device")
    
    video.set(cv2.CAP_PROP_FRAME_WIDTH,  VIEW_SIZE['width'])
    video.set(cv2.CAP_PROP_FRAME_HEIGHT, VIEW_SIZE['height'])

    # -------- Serial Setting --------
    serial_use = False # DEBUG

    if serial_use: #? Serial 통신 활성화 시, 미리 버퍼를 클리어
       serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
       serial_port.flush() # serial cls

    # -------- Screen Setting --------
    cv2.namedWindow(WINNAME['main'])
    cv2.namedWindow(WINNAME['mask'])

    # -------- Debug Preset --------
    debug_colors = ['red', 'blue', 'yellow', 'white', 'black']
    debug_count = 0
    debug_color_adjust = 0

    SHOW_TRACKBAR = True

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

        def onDebugTrackbar_Change(x):
            global debug_color_adjust
            debug_color_adjust = x

        cv2.createTrackbar('DEBUG', WINNAME['main'],0x00,0xFF, onDebugTrackbar_Change)

    current_status = STATUS['line tracing']

    # -------- Main Loop Start --------
    while True:
        # -------- Toggle System Mode --------
        key = cv2.waitKey(1) & 0xFF # '& 0xFF' For python 2.7.10

        if key is KEY['spacebar']:
            # -- system : pause --
            system_pause = not system_pause

            if system_pause:
                print('paused')
            else:
                print('resumed')

        elif key is KEY['esc']:
            # -- system : exit --
            break

        elif key is KEY['1']:
            print('line tracing mode')
            current_status = STATUS['line tracing']

        elif key is KEY['2']:
            debug_count = (debug_count + 1) % len(debug_colors)
            current_color = debug_colors[debug_count]
            print('set debug color as : ', current_color)

        elif key is KEY['0']:
            print('debug mode')
            current_status = STATUS['debug']

        if system_pause:
            continue

        # -------- Grab frames --------
        next_frame, current_frame = video.read()
        if not next_frame:
            break # no more frames to read : EOF

        # -- Camera filter --
        FILTER_H = 20

        # -------- Check Context --------
        # TODO : 현재 상황 파악 하는 부분
        # current_status = ?

        # -------- Action :: Debug --------
        if current_status == STATUS['debug']:
            def color_picker():
                # -- 커서가 가리키는 HSV 색상 --
                pointer_pos = (VIEW_SIZE['width']//2, VIEW_SIZE['height']*5//6)
                current_frame_hsv = cv2.cvtColor(current_frame, cv2.COLOR_BGR2HSV)

                cv2.circle(current_frame, pointer_pos, 5, HIGHLIGHT['color'])
                current_frame[pointer_pos] = HIGHLIGHT['color']

                # -- key hold시, line색상으로 설정 --
                key = cv2.waitKey(1) & 0xFF # '& 0xFF' For python 2.7.10
                if key is KEY['0']:
                    COLOR_REF['line']['hsv'] = current_frame_hsv[pointer_pos]
                    print('Set line color as : ', COLOR_REF['line']['hsv'])
            
            def hue_adjust():
                print('adjusting... ', end='')
                for col in range(VIEW_SIZE['width']):
                    for row in range(VIEW_SIZE['height']):
                        pixel = current_frame[row,col]
                        pixel[2] += debug_color_adjust
                        if pixel[2] >= 256:
                            pixel[2] -= 256
                        current_frame[row,col] = pixel
                print('Done')

            # -- key hold시, 조정된 이미지 출력 --
            key = cv2.waitKey(1) & 0xFF # '& 0xFF' For python 2.7.10
            if key is KEY['0']:
                hue_adjust()
                cv2.imshow('Adjusted', current_frame)
                
            putText(current_frame, (0,0), 'DEBUG MODE')
            cv2.imshow(WINNAME['main'], current_frame)

        # -------- Action :: Line Tracing --------
        elif current_status == STATUS['line tracing']:
            # TODO : 라인트레이싱 (급함, 우선순위 1)

            line_color = COLOR_REF[current_color]

            # ---- Region of Interest : 관심영역 지정 ----
            # roi_frame = current_frame[VIEW_SIZE['height']*2//3 : VIEW_SIZE['height'], :]
            roi_frame = current_frame
            roi_frame_hsv = cv2.cvtColor(roi_frame, cv2.COLOR_BGR2HSV)

            # ---- Line 검출 ----
            line_mask = color_detection(roi_frame_hsv, line_color)

            kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3,3))
            line_mask = cv2.morphologyEx(line_mask, cv2.MORPH_OPEN, kernel)

            retval = cv2.findContours(line_mask.copy(), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
            contours,hierarchy = retval[1:3] if cv2.__version__.split('.')[0] == '3' else retval
            
            cv2.drawContours(roi_frame,contours,-1,HIGHLIGHT['color'],HIGHLIGHT['thickness'])

            cv2.imshow(WINNAME['mask'], line_mask)

            putText(current_frame, (0,0), 'LINE_TR MODE')
            putText(current_frame, (0,20), current_color.upper())
            cv2.imshow(WINNAME['main'], current_frame)
        


    # cleanup the camera and close any open windows
    video.release()
    cv2.destroyAllWindows()

    if serial_use:
       serial_port.close()