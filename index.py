# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_serial as serial
import robo_camera as cam
import robo_color as color

import threading

# ******************************************************************
# ******************************************************************
# ******************************************************************
if __name__ == '__main__':
    Serial = serial.init()
    Video  = cam.init()
    color.init()

    print('Start mainloop.')
    use_RGB = False
# ******************************************************************
    while True:
        frame = cam.getFrame(imshow=True)


        key = 0xFF & cv2.waitKey(1)
        if key == 27: # ESC
            break
        elif key == ord(' '):
            use_RGB = not use_RGB
            print('toggle rgb')

        if use_RGB:
            frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)

        masks = color.colorMaskAll(frame)
        
        detected = np.zeros((cam.HEIGHT,cam.WIDTH*7,3), dtype=np.uint8)

        i = 0
        for color_name in masks:
            mask = masks[color_name]

            printColor = color.getRef(color_name)['rgb'][::-1]

            contours = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            if contours:
                max_cont = max(contours, key=cv2.contourArea)
                x,y,w,h = cv2.boundingRect(max_cont)

                mask = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR)
                cv2.rectangle(mask, (x,y), (x+w,y+h), printColor, 4)
            else:
                mask = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR)

            stX = cam.WIDTH * i
            i += 1
            detected[:,stX:stX+cam.WIDTH] = mask
        cv2.imshow('masks', cv2.resize(detected, (cam.WIDTH*7//2, cam.HEIGHT//2)))
        # # if len(areas) > 0 and max(areas) > 50:
        # #     serial.TX_data(10)
        
        # cv2.imshow('MASK', mask)


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