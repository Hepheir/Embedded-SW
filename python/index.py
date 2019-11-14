# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math


if __name__ == '__main__':
    BPS = 4800
    RESOLUTION = (80, 60)
    serial_use = False
    serial_port = None

    if serial_use:
        serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
        serial_port.flush() # serial cls
        print('Serial enabled.')
    else:
        print('Serial disabled.')

    video = cv2.VideoCapture(0)
    if video.isOpened():
        video.set(cv2.CAP_PROP_FRAME_WIDTH,  RESOLUTION[0])
        video.set(cv2.CAP_PROP_FRAME_HEIGHT, RESOLUTION[1])
        print('Camera loaded.')
    else:
        raise Exception("Could not open video device")
    
    print('Start mainloop.')
    while True:
        frame = None

        grab, now = video.read()
        if not grab: break
        else:
            frame = cv2.resize(now, RESOLUTION)
            cv2.imshow('CAM', frame)

        
        yuv = cv2.cvtColor(frame, cv2.COLOR_BGR2YUV)
        cv2.imshow('yuv', yuv)

        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        cv2.imshow('nor hsv', cv2.cvtColor(hsv, cv2.COLOR_HSV2BGR))
        hsv[:,:,1] = 255*np.ones(RESOLUTION[-1:0])
        cv2.imshow('adj hsv', cv2.cvtColor(hsv, cv2.COLOR_HSV2BGR))

        cv2.waitKey(1)
        
        