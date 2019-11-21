# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math

#-----------  0:노란색, 1:빨강색, 3:파란색

COLOR_RED   = 0
COLOR_BROWN = 1
COLOR_RED2  = 2
COLOR_GREEN = 3
COLOR_BLUE  = 4
    
hsv_max = np.array([
    [252, 65,196,111,110],  # H
    [194,200,223,110,255],  # S
    [255,151,239,156,255]]) # V

hsv_min = np.array([
    [150,  0,158, 59, 74],  # H
    [113,140,150, 51,133],  # S
    [ 89, 95,104, 61,104]]) # V
    
min_area =  [  50, 50, 50, 10, 10]


def findColor(src, color):
    global hsv_max, hsv_min
    mask = cv2.inRange(src, hsv_min[:,color], hsv_max[:,color])
    # mask = cv2.erode(mask, None, iterations=1)
    # mask = cv2.dilate(mask, None, iterations=1)
    return mask


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
 
        mask = findColor(hsv, color)
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

        # _, hsv_h_l1 = cv2.threshold(hsv[:,:,0], 32, 255, cv2.THRESH_BINARY_INV)
        # _, hsv_s_h3 = cv2.threshold(hsv[:,:,1], 128, 255, cv2.THRESH_BINARY)
        
        # _, yuv_v_l1 = cv2.threshold(yuv[:,:,2], 32, 255, cv2.THRESH_BINARY_INV)

        # yellow  = cv2.bitwise_and(hsv_s_h3, yuv_v_l1)
        # red     = cv2.bitwise_xor(yellow, cv2.bitwise_and(hsv_h_l1, hsv_s_h3))

        # cv2.imshow('yellow', yellow)
        # cv2.imshow('hsv_h_l1', hsv_h_l1)
        # cv2.imshow('red', red)




        
# ******************************************************************
# ******************************************************************
# ******************************************************************
    