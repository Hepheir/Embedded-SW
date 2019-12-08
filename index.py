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
        key_chr = chr(key) if key else 'NO_KEY'
        tx_data = 'NO_TX'
        # --------
        if key is 27: # ESC
            break
        elif key_chr is '`':
            debug.DEBUG_MODE = not debug.DEBUG_MODE
        elif key_chr is '/':
            serial.TX_data(int(input('SERIAL : ')))
            debug.waitKey(5*1000)
            print('TIMEOUT')
            continue
        # --------
        if debug.DEBUG_MODE:
            if key:
                tx_data = debug.remoteCtrl(key)
                tx_data = str(tx_data)
        # --------

        # 현재 상황 파악
        context = move.context(frame)
        # if context is move.WALKING:
        #     serial.TX_data(2) # 전진종종걸음
        # else:
        #     serial.TX_data(12) # 안정화자세
        
        debug._print("\r%-64s" % ('[t=%s][cntx=%s][key=%s][tx=%s]'%(debug.runtime_str(), context, key_chr, tx_data) ))
# ******************************************************************
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
print('')
print('Exit program')
