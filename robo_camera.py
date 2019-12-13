# -*- coding: utf-8 -*-

import cv2

WIDTH, HEIGHT = (320, 240)

Video = None
RESOLUTION = (WIDTH, HEIGHT)
CENTER = (WIDTH//2, HEIGHT//2)
# -----------------------------------------------
def init(device=0, offset_ms=0):
    global Video

    print('"robo_camera.py" initialized')

    Video = cv2.VideoCapture(device)

    if not Video.isOpened():
        print('    Could not find video device.')
        print('    >> capturing disabled.')
        raise Exception("Could not open video device")

    print('    Successfully opened video capturing device.')
    Video.set(cv2.CAP_PROP_FRAME_WIDTH,  WIDTH)
    Video.set(cv2.CAP_PROP_FRAME_HEIGHT, HEIGHT)
    if offset_ms != 0:
        Video.set(cv2.CAP_PROP_POS_MSEC, offset_ms)
        print('    Set video offset : %d ms' % offset_ms)

    print('    Screen resolution :', RESOLUTION)
    print('    >> capturing enabled.')
    return Video
# -----------------------------------------------
def getFrame(imshow=False):
    grab, now = Video.read()
    if not grab:
        raise Exception("Could not grab next frame. [EOF or Device is lost]")
        
    frame = cv2.resize(now, RESOLUTION)
    if imshow:
        cv2.imshow('CAM', frame)

    return frame
# -----------------------------------------------
def printCursor(frame, radius=6, cursorColor=(0,0,255)):
    cx,cy = CENTER

    x1,y1 = (cx-radius, cy-radius)
    x2,y2 = (cx+radius, cy+radius)

    cut = frame[y1:y2, x1:x2].copy()
    cv2.rectangle(frame, (x1,y1), (x2,y2), cursorColor, 1)
    return cut
# -----------------------------------------------