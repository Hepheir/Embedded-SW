# -*- coding: utf-8 -*-

import numpy as np
import cv2

import time
import math

import robo_serial as serial
import robo_camera as cam
import robo_color as color
import frame as fr


Serial = serial.init()
Video = cam.init()

if __name__ == '__main__':
    # Load camera
    
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
    