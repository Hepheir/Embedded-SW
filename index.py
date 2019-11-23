# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math

#-----------  0:노란색, 1:빨강색, 3:파란색

# import order
import color
import frame as fr

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
    c = 1
    while True:
        frame = fr.getFrame(video, resolution=RESOLUTION, imshow=True)
        if frame is None:
            break

        key = cv2.waitKey(1)
        if key == 27: # ESC
            break
        elif key == ord(' '):
            c = c + 1
            print('change color (%s)' % color.toString(c))

        frame_hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        mask = color.colorMask(frame_hsv, c)
        cv2.imshow('MASK', mask)

cv2.destroyAllWindows()
print('Exit program')
# ******************************************************************
# ******************************************************************
# ******************************************************************
    