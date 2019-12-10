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

    key = None
    key_chr = '_'
    tx_data = -1
    print('Start mainloop.')
# ******************************************************************
    while True:
        # --------
        frame = cam.getFrame(imshow=True)
        key = debug.waitKey(1)
        key_chr = chr(key) if key else key_chr
        # --------
        if key == 27: # ESC
            break
        elif key_chr == '`':
            key_chr = '_'
            debug.DEBUG_MODE = not debug.DEBUG_MODE
            continue

        elif key_chr == '/':
            key_chr = '_'
            debug._print('\n\nSERIAL : ')
            
            tx_data = int( debug._scan() )
            serial.TX_data(tx_data)
        # --------
        elif debug.DEBUG_MODE:
            if key:
                tx_data = debug.remoteCtrl(key)
        # --------

        # 현재 상황 파악
        context = move.context(frame)

        if not debug.DEBUG_MODE:
            if context is move.STATUS.WALKING:
                serial.TX_data(2) # 전진종종걸음
            else:
                serial.TX_data(12) # 안정화자세
        

        cv2.imshow('Frame', frame)
        debug._print('\r%-12s %-24ss %-8s %-8s %-6s ' % (
            '[t=%s]'        % debug.runtime_str(),
            '[cntx=%s]'     % context,
            '[key=%c]'      % key_chr,
            '[tx=%d]'       % tx_data,
            '[d=%c]'        % ('T' if debug.DEBUG_MODE else 'F')
        ))
# ******************************************************************
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
print('')
print('Exit program')
