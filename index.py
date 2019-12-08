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
if debug.isRasp():
    video_fname = 0

# ******************************************************************
# ******************************************************************
# ******************************************************************
if __name__ == '__main__':
    Serial = serial.init()
    Video  = cam.init(video_fname) # 불러올 동영상 파일 이름 넣기 (index.py랑 같은 폴더에 있어야 함.)
    color.init()

    debug.DEBUG_MODE = True
    key = None
    print('Start mainloop.')
# ******************************************************************
    while True:
        # --------
        frame = cam.getFrame(imshow=True)
        key = debug.waitKey(1)
        # --------
        if key is 27: # ESC
            break
        elif key is ord('`'):
            debug.DEBUG_MODE = not debug.DEBUG_MODE
        elif key is ord('/'):
            serial.TX_data(int(input('SERIAL : ')))
        # --------
        if debug.DEBUG_MODE:
            if key:
                debug.remoteCtrl(key)
            continue
        # --------
        # 분할된 프레임으로부터 검출할 수 있는 모든 색상을 검출
        masks = color.colorMaskAll(frame)
        # 반환 값은 Dict 형식으로, { "색상1" : 마스크1, "색상2" : 마스크2, ... } 형식

        # 현재 상황 파악
        context = move.context(masks)
        # if context is move.WALKING:
        #     serial.TX_data(2) # 전진종종걸음
        # else:
        #     serial.TX_data(12) # 안정화자세
        
        debug._print("\r%s %-20s" % (debug.runtime(), context))

        debug.showAllColorMasks(frame, masks)
# ******************************************************************
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
print('')
print('Exit program')