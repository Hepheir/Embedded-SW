# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math

#-----------  0:노란색, 1:빨강색, 3:파란색

import color
import frame as fr
    
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
    print('Start mainloop.')
    while True:
        frame = fr.getFrame(video,resolution=RESOLUTION,imshow=False)
        if frame is None: break

        cut = fr.printCursor(frame,radius=4,color=(0,255,255))
        
        cut_hsv = cv2.cvtColor(cut, cv2.COLOR_BGR2HSV)
        h,s,v = color.pickColor(cut_hsv)
        cref = color.colorRef([h,s,v])
        print("%4d %4d %4d %10s"%(h,s,v, color.toString(cref)))
        
        cv2.imshow('CUT', cut)
        cv2.imshow('FRAME', frame)


        # mask = eye.getMask(frame)

        key = cv2.waitKey(1)
        # if (key == ord('\'')):
        #     cv2.destroyAllWindows()
        #     break
        
        # elif (key == ord('a')):
        #     color -= 1
        #     print('color', color)
        # elif (key == ord('s')):
        #     color += 1
        #     print('color', color)

        # elif (key == ord('d')):
        #     COLOR.debugMode(video, RESOLUTION)

        # cv2.imshow('CAM', COLOR.autoSet(frame))
        
# ******************************************************************
# ******************************************************************
# ******************************************************************
    