# -*- coding: utf-8 -*-

import numpy as np
import cv2

import robo_serial  as serial
import robo_camera  as cam
import robo_color   as color
import robo_move    as move
import robo_debug   as debug

import threading
import sys


video_fname = '1.mp4'

# ******************************************************************
# ******************************************************************
# ******************************************************************
if __name__ == '__main__':
    Serial = serial.init()
    Video  = cam.init(video_fname) # 불러올 동영상 파일 이름 넣기 (index.py랑 같은 폴더에 있어야 함.)
    color.init()

    if debug.isRasp():
        video_fname = 0

        print('trying to test')
        im = cv2.imread('yuv.jpg')
        im = cv2.cvtColor(im, cv2.COLOR_BGR2YUV)
        masks = color.colorMaskAll(im)
        for c in masks:
            cv2.imshow(c, masks[c])
            
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
        context = move.context(masks)
        
        debug._print("\r%s %-20s" % (debug.runtime(), context))

        debug.showAllColorMasks(cut_frame, masks)
# ******************************************************************
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
print('Exit program')