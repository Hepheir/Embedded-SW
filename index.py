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

    print('Start mainloop.')
# ******************************************************************
    while True:
        frame = cam.getFrame(imshow=True)

        key = cv2.waitKey(1) & 0xFF
        debug._print('[%c] ' % chr(key))
        if key is 27: # ESC
            break
        elif key is ord('w'):
            move.do(move.act.FORWARD_WALK)
        elif key is ord('a'):
            move.do(move.act.TURN_LEFT_3)
        elif key is ord('s'):
            move.do(move.act.TURN_RIGHT_3)
        elif key is ord('d'):
            move.do(move.act.BACKWARD_WALK)
        else:
            move.do(move.act.STABLE)

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