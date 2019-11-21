# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math

if __name__ == '__main__':
    BPS = 4800
    resolution = 50
    RESOLUTION = (4*resolution, 3*resolution) # (120, 90) # 
    serial_use = False
    serial_port = None

    # Load serial module
    if serial_use:
        serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
        serial_port.flush() # serial cls
        print('Serial \tenabled.')
    else:
        print('Serial \tdisabled.')

    # Load camera
    video = cv2.VideoCapture(0)
    if video.isOpened():
        video.set(cv2.CAP_PROP_FRAME_WIDTH,  RESOLUTION[0])
        video.set(cv2.CAP_PROP_FRAME_HEIGHT, RESOLUTION[1])
        print('Camera \tloaded.')
    else:
        raise Exception("Could not open video device")
    
# ******************************************************************
# ******************************************************************
# ******************************************************************
    print('Start mainloop.')
    while True:
        frame = None
        
        # Read a new frame
        grab, now = video.read()
        if not grab: break
        else:
            frame = cv2.resize(now, RESOLUTION)
            cv2.imshow('CAM', frame)
        
        yuv = cv2.cvtColor(frame, cv2.COLOR_BGR2YUV)
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

        key = cv2.waitKey(1)
        # 0 64 128 192 255
        LV0, LV1, LV2, LV3, LV4 = (0, 64, 128, 192, 255)

        _, hsv_h_l1 = cv2.threshold(hsv[:,:,0], LV1, 255, cv2.THRESH_BINARY_INV)
        _, hsv_s_h3 = cv2.threshold(hsv[:,:,1], LV3, 255, cv2.THRESH_BINARY)
        
        _, yuv_v_l1 = cv2.threshold(yuv[:,:,2], LV1, 255, cv2.THRESH_BINARY_INV)

        yellow  = cv2.bitwise_and(hsv_s_h3, yuv_v_l1)
        red     = cv2.bitwise_and(hsv_h_l1, hsv_s_h3)

        cv2.imshow('yellow', yellow)
        cv2.imshow('hsv_h_l1', hsv_h_l1)
        cv2.imshow('red', red)




        
# ******************************************************************
# ******************************************************************
# ******************************************************************
        