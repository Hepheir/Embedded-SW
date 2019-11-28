# -*- coding: utf-8 -*-

import numpy as np
import cv2

import time
import math

import robo_serial as serial
import robo_camera as cam
import robo_color as color

if __name__ == '__main__':
    # Serial = serial.init()
    Video = cam.init()

    current_color = color.BLACK

# ******************************************************************
# ******************************************************************
# ******************************************************************
    print('Start mainloop.')

    color.trackBar_init(winname='YUV Test')
    while True:
        frame = cam.getFrame(imshow=True)

        key = cv2.waitKey(1)
        if key == 27: # ESC
            break
        elif key == ord(' '):
            current_color +=  1
            print('change color (%s)' % color.toString(current_color))

        yuv = cv2.cvtColor(frame, cv2.COLOR_BGR2YUV)
        color.trackBar_update(yuv)
# ******************************************************************
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
print('Exit program')
    