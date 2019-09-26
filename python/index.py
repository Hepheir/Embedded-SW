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
Top_name = 'mini CTS5 setting' # 송출된 화면 창의 이름
hsv_Lower = 0
hsv_Upper = 0

hsv_Lower0 = 0
hsv_Upper0 = 0

hsv_Lower1 = 0
hsv_Upper1 = 0


# CUSTOM =================================================

class HSV_Values():
    def __init__(self,h,s,v):
        self.h = h
        self.s = s
        self.v = v

STATUS = {
    'debug' : -1,
    'stop' : 0,
    'line tracing' : 1 # line tracing
}
# bandwidth : lower, upper hsv를 파악하는데 사용.
COLOR_REF = {
    'line' : {
        'hsv' : HSV_Values(66,21,242),
        'bandwidth' : HSV_Values(32,32,32),
        'minArea' : 40
    },
    'yellow' : {
        'hsv' : { 'h' : 201, 's' : 153 , 'v' : 172 },
        'bandwidth' : { 'h' : 102, 's' : 82 , 'v' : 166 },
        'minArea' : 50
    },
    'red' : {
        'hsv' : { 'h' : 32, 's' : 170 , 'v' : 123 },
        'bandwidth' : { 'h' : 66, 's' : 60 , 'v' : 56 },
        'minArea' : 50
    },
    'blue' : {
        'hsv' : { 'h' : 85, 's' : 80 , 'v' : 108 },
        'bandwidth' : { 'h' : 52, 's' : 60 , 'v' : 96 },
        'minArea' : 10
    }
}
HIGHLIGHT = {
    'color' : (0,0,255),
    'thickness' : 2
}
VIEW_SIZE = { 'width' : 320, 'height' : 240 }
BPS = 4800


WINNAME = {
    'main' : 'main',
    'mask' : 'masking'
}
KEY = {
    'esc' : 27,
    'spacebar' : ord(' ')
}

# ============================================================

serial_use = False
serial_port =  None

system_pause = False


Serial_error_count = 0
Read_RX =  0

threading_Time = 5/1000.

#-----------------------------------------------
def nothing(x):
    pass
#-----------------------------------------------
def create_blank(width, height):
    image = np.zeros((height, width, 3), dtype=np.uint8)
    return image
#-----------------------------------------------
def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()
#-----------------------------------------------
def TX_data(serial, one_byte): # one_byte= 0~255
    global Serial_error_count
    try:
        serial.write(chr(int(one_byte)))
    except:
        Serial_error_count += 1
        print("Serial Not Open " + str(Serial_error_count))
#-----------------------------------------------
def RX_data(serial):
    global Serial_error_count
    try:
        if serial.inWaiting() > 0:
            result = serial.read(1)
            RX = ord(result)
            return RX
        else:
            return 0
    except:
        Serial_error_count += 1
        print("Serial Not Open " + str(Serial_error_count))
        return 0
#-----------------------------------------------

def GetLengthTwoPoints(XY_Point1, XY_Point2):
    return math.sqrt( (XY_Point2[0] - XY_Point1[0])**2 + (XY_Point2[1] - XY_Point1[1])**2 )
# *************************
def FYtand(dec_val_v ,dec_val_h):
    return ( math.atan2(dec_val_v, dec_val_h) * (180.0 / math.pi))
# *************************
# 라디안값을 degree 값으로 변환하는 함수
def rad2deg(rad):
    return rad * 180.0 / math.pi
# *************************
#degree 값을 라디안 값으로 변환하는 함수
def deg2rad(deg):
    return deg / 180.0 * math.pi

# *************************
def GetAngleTwoPoints(XY_Point1, XY_Point2):
    xDiff = XY_Point2[0] - XY_Point1[0]
    yDiff = XY_Point2[1] - XY_Point1[1]
    cal = math.degrees(math.atan2(yDiff, xDiff)) + 90
    if cal > 90:
        cal =  cal - 180
    return  cal
# *************************
# **************************************************
# **************************************************
# **************************************************

if __name__ == '__main__':
    #-------------------------------------
    #---- user Setting -------------------
    #-------------------------------------
    W_View_size =  320
    H_View_size = 240

    BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200
    current_status = STATUS['line tracing']

    serial_use = True
    #-------------------------------------
    img = create_blank(320, 240)
    
    cv2.namedWindow(WINNAME['main'])
    cv2.imshow(WINNAME['main'], img)
    #---------------------------
    # LOAD CAMERA
    camera = cv2.VideoCapture(0)
    time.sleep(0.5)
    #---------------------------
    
    if serial_use: #? Serial 통신 활성화 시, 미리 버퍼를 클리어
       serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
       serial_port.flush() # serial cls
       pass
    #    t = Thread(target=receiving, args=(serial_port,)) #? receiving가 무엇을 송신하려 하는 것인지 모르겠음
    #    time.sleep(0.1)
    #    t.start()

    # -------- Main Loop Start --------
    while True:
        # -------- Toggle System pause --------
        key = cv2.waitKey(1) # 0xFF 와 AND 연산
        if key is KEY['esc']:
            break
        elif key is KEY['spacebar']:
            system_pause = not system_pause

        if system_pause:
            continue

        # -------- Grab frames --------
        next_frame, current_frame = camera.read()
        if not next_frame:
            break # no more frames to read : EOF

        # -------- Check Context --------
        current_status = STATUS['line tracing']
        # 현재 상황 파악

        # -------- Action :: Debug --------
        if current_status == STATUS['debug']:
            now_color = 6

            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)  # BGR => YUV
            mask = cv2.inRange(hsv, hsv_Lower, hsv_Upper)
            mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, (3,3), iterations=1) # 마스크 이미지의 노이즈 제거
            
            contours = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2] #윤곽선 검출
            center = None


            if len(contours) > 0:
                cont = max(contours, key=cv2.contourArea) #? 가장 큰 범위의 contour를 찾음
                ((X, Y), radius) = cv2.minEnclosingCircle(cont) #? ^ 외접하는 원의 정보
                cv2.circle(frame, (int(X), int(Y)), int(radius), (0,0,255),2) # 현재 로봇이 보는 시점
                Area = cv2.contourArea(cont) / min_area[now_color]
                if Area > 255: #? Saturation max 0xFF
                    Area = 255

                if Area > min_area[now_color]:
                    x4, y4, w4, h4 = cv2.boundingRect(cont)
                    cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 0), 2)
                    Read_RX = RX_data(serial_port) # 직렬통신으로 수신한 숫자
                    #----------------------------------------
                    rows,cols = frame.shape[:2]
                    [vx,vy,x,y] = cv2.fitLine(cont, cv2.DIST_L2,0,0.01,0.01)
                    #print("rows = " + str(rows) + ", cols= " + str(cols) + ", vx= " + str(vx) + ", vy= " + str(vy) + ", x=" + str(x) + ", y= " + str(y))
    
                    lefty = int((-x*vy/vx) + y)
                    righty = int(((cols-x)*vy/vx)+y)

                    try:
                        cv2.line(frame,(cols-1,righty),(0,lefty),(0,0,255),2)
                    except:
                        print("cv2.line error~ "  + str(righty) + ", " + str(lefty))
                        pass
                    point1 = (cols-1,righty)
                    point2 = (0,lefty)
                    
                    Angle = 100 + int(GetAngleTwoPoints(point2, point1))
                    
                    #print(angle)
                    #----------------------------------------
                    
                    X_Size = int((255.0 / W_View_size) * w4)
                    Y_Size = int((255.0 / H_View_size) * h4)
                    X_255_point = int((255.0 / W_View_size) * X)
                    Y_255_point = int((255.0 / H_View_size) * Y)
            else:

                x = 0
                y = 0
                X_255_point = 0
                Y_255_point = 0
                X_Size = 0
                Y_Size = 0
                Area = 0
                Angle = 0


            #--------------------------------------
            
                draw_str2(frame, (3, 15), 'X: %.1d, Y: %.1d, Area: %.1d, Angle: %.2f ' % (X_255_point, Y_255_point, Area, Angle))
                draw_str2(frame, (3, H_View_size - 5), 'View: %.1d x %.1d Time: %.1f ms  Space: Fast <=> Video and Mask.'
                        % (W_View_size, H_View_size, Frame_time))


                #------------------------------------------
                mx2 = mx
                my2 = my
                pixel = hsv[my2, mx2] # 마우스 커서가 올려진  픽셀의 hsv 색상
                set_H = pixel[0] # 색종류
                set_S = pixel[1] # 채도
                set_V = pixel[2] # 밝기
                pixel2 = frame[my2, mx2] # 마우스 커서가 올려진 bgr 이미지 픽셀의 색상
                

                # 화면에 툴팁 정보를 마우스 커서 주변에 표시
                if my2 < (H_View_size / 2): # 위쪽 (멀리있음)
                    if mx2 < 50: # 0~50
                        x_p = -30
                    elif mx2 > (W_View_size - 50): # 50~뷰경계
                        x_p = 60
                    else: # 뷰경계~끝
                        x_p = 30

                    draw_str2(frame, (mx2 - x_p, my2 + 15), '-HSV-')
                    draw_str2(frame, (mx2 - x_p, my2 + 30), '%.1d' % (pixel[0]))
                    draw_str2(frame, (mx2 - x_p, my2 + 45), '%.1d' % (pixel[1]))
                    draw_str2(frame, (mx2 - x_p, my2 + 60), '%.1d' % (pixel[2]))
                
                else: # 아래쪽 (가까이있음) --> 천천히 직진
                    x_p = 30
                    draw_str2(frame, (mx2 - x_p, my2 - 60), '-HSV-')
                    draw_str2(frame, (mx2 - x_p, my2 - 45), '%.1d' % (pixel[0]))
                    draw_str2(frame, (mx2 - x_p, my2 - 30), '%.1d' % (pixel[1]))
                    draw_str2(frame, (mx2 - x_p, my2 - 15), '%.1d' % (pixel[2]))

                cv2.imshow('mini CTS4 - Video', frame )
                cv2.imshow('mini CTS4 - Mask', mask)

                #----------------------------------------------

                # Read_RX = RX_data(serial_port)
                if Read_RX != 0:
                    print("Read_RX = " + str(Read_RX))
                
                #TX_data(serial_port,255)
                
                #--------------------------------------    

                Frame_time = (clock() - old_time) * 1000.
                old_time = clock()

        # -------- Action :: Line Tracing --------
        elif current_status == STATUS['line tracing']:
            # 세로 3분할 최하단 영역으로 라인 트레이싱
            tr_frame = current_frame[H_View_size//3:H_View_size, :]
            # 타켓의 색상 영역의 마스크 이미지 구하기
            tr_mask = cv2.inRange(
                tr_frame,
                np.subtract(COLOR_REF['line']['hsv'], COLOR_REF['line']['bandwidth']),
                np.add(COLOR_REF['line']['hsv'], COLOR_REF['line']['bandwidth']))
            # 마스크의 노이즈 제거
            tr_mask = cv2.morphologyEx(tr_mask, cv2.MORPH_OPEN, (3,3), iterations=2)
            # 마스크 이미지로부터 윤곽선 검출
            contours = cv2.findContours(tr_mask.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center = None
            
            # 최적화
            if len(contours) == 0: # 윤곽선이 검출되지 않으면, 아래 작업을 하지 않음
                print('contour not found')
                continue 
            
            target_contour = max(contours, key=cv2.contourArea) # 가장 큰 윤곽선을 찾음
            Area = cv2.contourArea(target_contour)
            if Area < COLOR_REF['line']['minArea']: # 윤곽선의 면적이 기준치에 못 미치면 검출되지 않은 것으로 간주
                print('contour not big enough')
                continue
            
            # 제대로 검출 된 경우.
            bx,by,bw,bh = cv2.boundingRect(target_contour) # boundingbox x, y, w, h
            cv2.rectangle(frame, (bx,by), (bx+bw, by+bh), HIGHLIGHT['color'], HIGHLIGHT['thickness'])

            CURVE_SENSOR = {
                'left' : 50,
                'right' : tr_frame.shape[1] - 50
            }
            if bx < CURVE_SENSOR['left'] or bx+bw > CURVE_SENSOR['right']:
                # 커브 모드
                print('curve mode')

            else: 
                # 직진 모드
                print('linear mode')
                # x1,y1,x2,y2 = cv2.fitLine(target_contour, cv2.DIST_L2,0,0.01,0.01) # 직선을 표현하기 위해 필요한 두 점
                # try:
                #     cv2.line(frame,(cols-1,righty),(0,lefty),(0,0,255),2)
                # except:
                #     print("cv2.line error~ "  + str(righty) + ", " + str(lefty))
                #     pass
        
        cv2.imshow(WINNAME['main'], current_frame)


    # cleanup the camera and close any open windows
    if serial_use:
       serial_port.close()
    camera.release()
    cv2.destroyAllWindows()