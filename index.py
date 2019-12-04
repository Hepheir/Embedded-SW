# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_serial as serial
import robo_camera as cam
import robo_color as color

# ******************************************************************
# ******************************************************************
# ******************************************************************
if __name__ == '__main__':
    Serial = serial.init()
    Video  = cam.init()

    print('Start mainloop.')
# ******************************************************************
    while True:
        frame = cam.getFrame(imshow=True)

        key = cv2.waitKey(1)
        if key == 27: # ESC
            break

        canvas = 42 * np.ones(frame.shape, dtype=np.uint8)

        mask = color.colorMask(frame, color.BLACK)
        areas = [cv2.contourArea(cont) for cont in cv2.findContours(mask,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)[-2]]

        # if len(areas) > 0 and max(areas) > 50:
        #     serial.TX_data(10)
        
        cv2.imshow('MASK', mask)


        # for c in color.DETECTABLE_COLORS:
        #     mask = color.colorMask(frame, c, useFilter=True)

        #     pix = 1/len(color.DETECTABLE_COLORS) * np.array(color.toRGB(c))

        #     pallete = np.zeros(frame.shape, dtype=np.uint8)
        #     pallete[:,:] = pix
        #     pallete = cv2.bitwise_and(pallete, pallete, mask=mask)
        #     canvas = cv2.add(canvas, pallete)

        #     if c is color.GREEN and mask.any():
        #         serial.TX_data(10)

            # contours = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            # for cont in contours:
            #     if cv2.contourArea(cont) < 30:
            #         continue
            #     x,y,w,h = cv2.boundingRect(cont)
            #     cv2.rectangle(canvas, (x,y), (x+w, y+h), color.toRGB(c), 2)
        
        # cv2.imshow('Objects', canvas)
            
# ******************************************************************
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
print('Exit program')