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

# ******************************************************************


# ******************************************************************

frame = None
key = None
key_chr = None

routine_stoppers = []

main_routine_time_s = 0.5
main_routine_args = {}

sub_routine_time_s = 2
sub_routine_args = {}

serial_queue = []

# ******************************************************************

@debug.setInterval(main_routine_time_s)
def main_routine(main_routine_args):
    context = move.context(frame)


    main_routine_args['frame'] = frame
    main_routine_args['context'] = context
    main_routine_args['color_masks'] = color.colorMaskAll(frame)
    main_routine_args['stacked_cmask'] = debug.stackedColorMasks(frame, main_routine_args['color_masks'])


@debug.setInterval(sub_routine_time_s)
def sub_routine(sub_routine_args):
    if not serial_queue:
        sub_routine_args['tx_data'] = -1
    else:
        sub_routine_args['tx_data'] = serial_queue[0]

        del serial_queue[0]
        serial.TX_data(sub_routine_args['tx_data'])

# ******************************************************************
# ******************************************************************
# ******************************************************************
if __name__ == '__main__':
    serial.init()
    # cam.init(0 if debug.isRasp() else '1.mp4')
    cam.init(0)
    color.init()
    # --------
    frame = cam.getFrame()
    key_chr = '_'
    
    routine_stoppers.append( main_routine(main_routine_args) )
    routine_stoppers.append(  sub_routine( sub_routine_args) )

    time.sleep(max([main_routine_time_s, sub_routine_time_s]))
    # --------
    print('')
    print('Start mainloop')
    print('')
    while True:
        frame = cam.getFrame(imshow=True)
        key = debug.waitKey(10)
        key_chr = chr(key) if key else key_chr
        # --------
        if key == 27: # ESC
            break
        elif key_chr == '`':
            key_chr = '_'
            debug.DEBUG_MODE = not debug.DEBUG_MODE
            continue
        # --------
        if key:
            remote = debug.remoteCtrl(key)
            if not (remote is None):
                serial_queue.append(remote)
        # --------
        try:
            debug._print('\r%-12s %-24s %-8s %-8s %-6s %-8s ' % (
                '[t=%s]'        % debug.runtime_ms_str(),
                '[cntx=%s]'     % main_routine_args['context'],
                '[key=%c]'      % key_chr,
                '[tx=%d]'       % sub_routine_args['tx_data'],
                '[d=%c]'        % ('T' if debug.DEBUG_MODE else 'F'),
                '[txq=%d]'      % len(serial_queue)
            ))
            cv2.imshow('frame', main_routine_args['frame'])
            cv2.imshow('cmask', main_routine_args['stacked_cmask'])
        except:
            pass


# ******************************************************************
# ******************************************************************
# ******************************************************************
cv2.destroyAllWindows()
for stop in routine_stoppers:
    stop.set()
print('')
print('')
print('Exit program')
print('')
