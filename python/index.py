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
        grab, now = video.read()
        if not grab:
            break
        else:
            frame = cv2.resize(now, RESOLUTION)
            cv2.imshow('CAM', frame)

        yuv = cv2.cvtColor(frame, cv2.COLOR_BGR2YUV)
        yuv[:,:,0] = cv2.equalizeHist(yuv[:,:,0])
        bgr = cv2.cvtColor(yuv, cv2.COLOR_YUV2BGR)

        cv2.imshow('EqCAM', bgr)
        cv2.waitKey(1)
        
        