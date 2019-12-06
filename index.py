# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_serial  as serial
import robo_camera  as cam
import robo_color   as color
import robo_move    as move

import robo_debug as debug

import threading

# ******************************************************************
# ******************************************************************
# ******************************************************************
if __name__ == '__main__':
    Serial = serial.init()
    Video  = cam.init('2.mp4') # 불러올 동영상 파일 이름 넣기 (index.py랑 같은 폴더에 있어야 함.)
    color.init()

    print('Start mainloop.')
# ******************************************************************
    while True:
        frame = cam.getFrame(imshow=True)

        key = cv2.waitKey(1) & 0xFF
        if key == 27: # ESC
            break

        # 프레임의 세로 3분할
        cut_frame = frame[cam.HEIGHT*2//3:,:]

        # 분할된 프레임으로부터 검출할 수 있는 모든 색상을 검출
        masks = color.colorMaskAll(cut_frame)
        # 반환 값은 Dict 형식으로, { "색상1" : 마스크1, "색상2" : 마스크2, ... } 형식

        # 현재 상황 파악
        move.context(masks)

        debug.showAllColorMasks(cut_frame, masks)


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