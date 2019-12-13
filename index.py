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
import time

# 32cm h / 24 cm w

# ******************************************************************

video_fname = 'records/Wed Dec 11 09:15:59 2019.avi'
doRecord = False
paused = False

# ******************************************************************

frame = None
key = None
key_chr = None

routine_stoppers = []

main_routine_time_s = 0.8
main_routine_args = {}

sub_routine_time_s = 1.2
sub_routine_args = {}

action_queue = []

# ******************************************************************
def veryImportantAction(action):
    global action_queue
    if not (action.code is None):
        del action_queue[:]
        action_queue.append(action)

@debug.setInterval(main_routine_time_s)
def main_routine(main_routine_args):
    cmasks = color.colorMaskAll(frame)
    action = move.context(cmasks)

    if not debug.DEBUG_MODE:
        veryImportantAction(action)

    main_routine_args['frame']      = frame
    main_routine_args['color_masks'] = cmasks
    main_routine_args['scmsk full'] = debug.stackedColorMasks(frame, main_routine_args['color_masks'])
    main_routine_args['scmsk 1/3']  = debug.stackedColorMasks(frame[cam.HEIGHT//2:,:], color.colorMaskAll(frame[cam.HEIGHT//2:,:]))


@debug.setInterval(sub_routine_time_s)
def sub_routine(sub_routine_args):
    if action_queue:
        action = action_queue[0]
        del action_queue[0]

        serial.TX_data(action.code)
        sub_routine_args['action'] = action
# ******************************************************************
# ******************************************************************
# ******************************************************************
if __name__ == '__main__':
    serial.init()
    cam.init(0 if debug.isRasp() else video_fname)
    color.init()
    # --------
    recorder = None
    if doRecord:
        fourcc = cv2.VideoWriter_fourcc(*'MJPG')
        recorder = cv2.VideoWriter('records/%s.avi' % time.ctime() ,fourcc, 15.0, cam.RESOLUTION)
    # --------
    frame = cam.getFrame()
    key_chr = '_'

    routine_stoppers = [
        main_routine(main_routine_args),
        sub_routine( sub_routine_args)
    ]

    time.sleep(max([main_routine_time_s, sub_routine_time_s]))
    # --------
    action_queue.append(move.HEAD.PITCH_LOWER_90)
    time.sleep(sub_routine_time_s)
    # --------
    print('')
    print('Start mainloop')
    print('')
    while True:
        key = debug.waitKey(1)
        key_chr = chr(key) if key else key_chr
        # --------
        if key == 27: # ESC
            break
        elif key_chr == '`':
            key_chr = '_'
            debug.DEBUG_MODE = not debug.DEBUG_MODE
            continue
        elif key_chr == ' ':
            del action_queue[:]
            action_queue.append(move.STOP_MOTION.STABLE)
            key_chr = '_'
            paused = not paused
            continue
        # --------
        if key:
            action = debug.remoteCtrl(key)
            veryImportantAction(action)
        # --------
        if not paused:
            frame = cam.getFrame(imshow=True)
            if doRecord:
                recorder.write(frame)
        # --------
        try:
            action = sub_routine_args['action']
            debug._print('\r'+' '*64)
            debug._print('\r' +
                '[%s]' % debug.runtime_ms_str() +
                '[key=%c]' % key_chr +
                '[act=%s]' % action.name +
                '[d=%c]' % ('T' if debug.DEBUG_MODE else 'F') +
                '[p=%c]' % ('T' if paused else 'F') +
                str([act.code for act in action_queue]) + ' ')
            cv2.imshow('frame', main_routine_args['frame'])
            cv2.imshow('scmsk full', main_routine_args['scmsk full'])
        except:
            pass


# ******************************************************************
# 공학 페스티벌이 ㄹㅇ 혜자인덴
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
for stop in routine_stoppers:
    stop.set()
time.sleep(max([main_routine_time_s, sub_routine_time_s]))

cam.Video.release()

print('')
print('')
print('Exit program')
print('')
