# -*- coding: utf-8 -*-

import numpy as np
import cv2

import time
import math

import robo_serial as serial
import robo_camera as cam
import robo_color as color

# ******************************************************************
# ******************************************************************
# ******************************************************************
if __name__ == '__main__':
    # Serial = serial.init()
    Video = cam.init()
    cNum = 0 # current color : index of color.DETECTABLE_COLORS
    debugMode = False

    print('Start mainloop.')
# ******************************************************************
    while True:
        frame = cam.getFrame(imshow=True)

        key = cv2.waitKey(1)
        if key == 27: # ESC
            break
        elif key == ord(' '):
            cNum += 1
            if cNum == len(color.DETECTABLE_COLORS):
                cNum = 0
            print('change color (%s)' % color.toString(color.DETECTABLE_COLORS[cNum]))
        elif key == ord('d'):
            debugMode = not debugMode
            if debugMode:
                color.trackBar_init()
            else:
                cv2.destroyWindow(color.trackBar_winname)

        if debugMode:
            colorSpace = cv2.cvtColor(frame, cv2.COLOR_BGR2YUV)
            color.trackBar_update(colorSpace)

        mask = color.colorMask(frame, color.DETECTABLE_COLORS[cNum], useFilter=False)
        cv2.imshow('MASK', mask)

        # boundingBoxes = []
        # for c in color.DETECTABLE_COLORS:
        #     mask = color.colorMask(frame, c)
        #     contours = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
        #     largestContour = max(contours, key=cv2.contourArea)
        #     box = cv2.boundingRect(largestContour)
        #     return box
# ******************************************************************
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
print('Exit program')