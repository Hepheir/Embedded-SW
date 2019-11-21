# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math

#-----------  0:노란색, 1:빨강색, 3:파란색

import color as COLOR
    
min_area =  [  50, 50, 50, 10, 10]

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
    color = 0
    print('Start mainloop.')
    while True:
        frame = None
        
        # Read a new frame
        grab, now = video.read()
        if not grab: break
        else:
            frame = cv2.resize(now, RESOLUTION)
            cv2.imshow('CAM', frame)
        
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
 
        mask = COLOR.getMask(hsv, color)
        cv2.imshow('mask', mask)

        key = cv2.waitKey(1)
        if (key == ord(' ')):
            cv2.destroyAllWindows()
            break
        
        elif (key == ord('a')):
            color -= 1
            print('color', color)
        elif (key == ord('s')):
            color += 1
            print('color', color)

        elif (key == ord('d')):
            COLOR.debugMode(video, RESOLUTION)
        
# ******************************************************************
# ******************************************************************
# ******************************************************************
    