# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math

if __name__ == '__main__':
    BPS = 4800
    RESOLUTION = (160, 120) # (120, 90) # 
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

        # 
        yuv = cv2.cvtColor(frame, cv2.COLOR_BGR2YUV)
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

        cv2.imshow('yuv_Y', yuv[:,:,0])
        cv2.imshow('yuv_U', yuv[:,:,1])
        cv2.imshow('yuv_V', yuv[:,:,2])

        cv2.imshow('hsv_H', hsv[:,:,0])
        cv2.imshow('hsv_S', hsv[:,:,1])
        cv2.imshow('hsv_V', hsv[:,:,2])

        cv2.waitKey(1)
        
# ******************************************************************
# ******************************************************************
# ******************************************************************
        