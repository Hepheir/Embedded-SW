# -*- coding: utf-8 -*-

import numpy as np
import cv2
import serial

import time
import math


if __name__ == '__main__':
    BPS = 4800
    serial_use = False
    serial_port = None

    if serial_use:
        serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
        serial_port.flush() # serial cls
        print('Serial enabled.')
    else:
        print('Serial disabled.')

    video = cv2.VideoCapture(0)
    if video.isOpened():
        video.set(cv2.CAP_PROP_FRAME_WIDTH,  320)
        video.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)
        print('Camera loaded.')
    else:
        raise Exception("Could not open video device")
    
    print('Start mainloop.')
    while True:
        frame = video.read()[1]
        if not frame:
            break
        cv2.imshow('CAM', frame)
        
        