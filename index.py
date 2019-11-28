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

        canvas = 42 * np.ones(frame.shape, dtype=np.uint8)
        for c in color.DETECTABLE_COLORS:
            mask = color.colorMask(frame, c, useFilter=True)

            pallete = np.zeros(frame.shape, dtype=np.uint8)
            pallete[:,:] = 1/len(color.DETECTABLE_COLORS) * np.array(color.toRGB(c))
            pallete = cv2.add(pallete, pallete, mask=mask)
            canvas = cv2.add(canvas, pallete)

            contours = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            for cont in contours:
                if cv2.contourArea(cont) < 50:
                    continue
                x,y,w,h = cv2.boundingRect(cont)
                cv2.rectangle(canvas, (x,y), (x+w, y+h), color.toRGB(c), 2)
        
        cv2.imshow('Objects', canvas)

        # # 그냥 넣어본 기능 (마스크에 색 입히기)
        # if printColor:
        #     canvas = np.zeros(frame.shape, dtype=np.uint8)
        #     canvas[:,:] = toRGB(colorRef)
        #     mask = cv2.bitwise_and(canvas, canvas, mask=mask)
            
# ******************************************************************
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
print('Exit program')