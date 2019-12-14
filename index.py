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

video_fps = 15
video_fname = 'records/t.mp4' if not debug.isRasp() else 0
video_offset = 80 * 1000 if not debug.isRasp() else 0

doRecord = False
paused = False

# ******************************************************************

frame = None
key = None
key_chr = None

routine_stoppers = []

main_routine_time_s = 0.1
main_routine_args = {}

sub_routine_time_s = 1
sub_routine_args = {}

macroMode = False
action_queue = []

# ******************************************************************
def veryImportantAction(action):
    global action_queue
    global macroMode
    if action is None:
        print('action is None!')
        return

    if macroMode:
        print('aborted')
        return

    if not macroMode and type(action) is type([]):
        macroMode = True
        action_queue = action
        print('Macro registered : ' + str(action))
        return

    if not (action.code is None):
        del action_queue[:]
        action_queue.append(action)

@debug.setInterval(main_routine_time_s)
def main_routine(main_routine_args):
    cmasks = color.colorMaskAll(frame)
    action = move.context(cmasks)

    if not debug.DEBUG_MODE and not macroMode:
        veryImportantAction(action)

    main_routine_args['frame']      = frame
    main_routine_args['color_masks'] = cmasks
    main_routine_args['scmsk full'] = debug.stackedColorMasks(frame, main_routine_args['color_masks'])


@debug.setInterval(sub_routine_time_s)
def sub_routine(sub_routine_args):
    global macroMode
    if action_queue:
        action = action_queue[0]
        del action_queue[0]

        serial.TX_data(action.code)
        sub_routine_args['action'] = action

    elif macroMode and len(action_queue) == 0:
        macroMode = False
# ******************************************************************
# ******************************************************************
# ******************************************************************
if __name__ == '__main__':
    serial.init()
    cam.init(video_fname, video_offset)
    color.init()
    # --------
    recorder = None
    if doRecord:
        fourcc = cv2.VideoWriter_fourcc(*'MJPG')
        recorder = cv2.VideoWriter('records/%s.avi' % time.ctime() ,fourcc, video_fps, cam.RESOLUTION)
    # --------
    frame = cam.getFrame()
    key_chr = '_'

    routine_stoppers = [
        main_routine(main_routine_args),
        sub_routine( sub_routine_args)
    ]

    try:
        open('1.txt', 'r')
        macroMode = True
        action_queue = 50 * [move.STOP_MOTION.STABLE]
    except:
        pass

    time.sleep(max([main_routine_time_s, sub_routine_time_s]))
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
        elif key_chr == '/':
            macroMode = True
            key_chr = '_'
            action_queue = move.debug()
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
            ymsk = main_routine_args['color_masks']['yellow']
            action = sub_routine_args['action']

            debug._print('\r'+' '*72)
            debug._print('\r' +
                '[%s]' % debug.runtime_ms_str() +
                '[key=%c]' % key_chr +
                '[D=%c]' % ('T' if debug.DEBUG_MODE else 'F') +
                '[P=%c]' % ('T' if paused else 'F') +
                '[M=%c]' % ('T' if macroMode else 'F') +
                str([act.code for act in action_queue]) + 
                '[act=%s]' % action.name
                )
            cv2.imshow('frame', main_routine_args['frame'])
            cv2.imshow('scmsk full', main_routine_args['scmsk full'])
            # cv2.imshow('y', ymsk)
            # cv2.imshow('h', move.detectHoriLine(ymsk))
            # cv2.imshow('v', move.detectVertLine(ymsk))
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
