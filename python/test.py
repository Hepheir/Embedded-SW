# -*- coding: utf-8 -*-

import platform
import numpy as np
import argparse
import cv2
import serial
import time
import sys
from threading import Thread

import math


X_255_point = 0
Y_255_point = 0
X_Size = 0
Y_Size = 0
Area = 0
Angle = 0
#-----------------------------------------------
Top_name = 'test'
hsv_Lower = 0
hsv_Upper = 0

hsv_Lower0 = 0
hsv_Upper0 = 0

hsv_Lower1 = 0
hsv_Upper1 = 0

#-----------  0:노란색, 1:빨강색, 3:파란색, 4: 000, 5:보라색
color_num = [   0,  1,  2,  3,  4, 5]
    
h_max =     [ 252, 65,196,111,110, 111]
h_min =     [ 150,  0,158, 59, 74,  81]
    
s_max =     [ 194,200,223,110,255, 146]
s_min =     [ 113,140,150, 51,133, 127]
    
v_max =     [  255,151,239,156,255, 141]
v_min =     [   89,95,104, 61,104, 126]
    
min_area =  [  50, 50, 50, 10, 10, 40]

now_color = 0
serial_use = 1

serial_port =  None
Temp_count = 0
Read_RX =  0

mx,my = 0,0

threading_Time = 5/1000.

# **************************************************
# **************************************************
# **************************************************

if __name__ == '__main__':

    #-------------------------------------
    print ("-------------------------------------")
    print ("(2018-6-15) mini CTS4 Program.    MINIROBOT Corp.")
    print ("-------------------------------------")
    print ("")
    os_version = platform.platform()
    print (" ---> OS " + os_version)
    python_version = ".".join(map(str, sys.version_info[:3]))
    print (" ---> Python " + python_version)
    opencv_version = cv2.__version__
    print (" ---> OpenCV  " + opencv_version)

    #-------------------------------------
    #---- user Setting -------------------
    #-------------------------------------
    W_View_size = 320
    H_View_size = W_View_size // 1.333

    BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200
    serial_use = 1
    now_color = 0
    View_select = 1
    #-------------------------------------
    print(" ---> Camera View: " + str(W_View_size) + " x " + str(H_View_size) )
    print ("")
    print ("-------------------------------------")
    #-------------------------------------
    ap = argparse.ArgumentParser()
    ap.add_argument("-v", "--video",
                    help="path to the (optional) video file")
    ap.add_argument("-b", "--buffer", type=int, default=64,
                    help="max buffer size")
    args = vars(ap.parse_args()) # ? IS DIRECTORY

    img = create_blank(320, 50, rgb_color=(0, 0, 255))
    
    cv2.namedWindow(Top_name)    