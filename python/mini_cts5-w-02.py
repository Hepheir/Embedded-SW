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

#-----------  0:노란색, 1:빨강색, 3:파란색, 4: 000, 5:보라색, 6:DEBUG
color_num = [   0,  1,  2,  3,  4,   5,   6]

default_color = 6
debug_color = (66, 21, 242)
bandwidth = 32
    
h_max =     [ 252, 65,196,111,110, 111, debug_color[0]+bandwidth]
h_min =     [ 150,  0,158, 59, 74,  81, debug_color[0]-bandwidth]
    
s_max =     [ 194,200,223,110,255, 146, debug_color[1]+bandwidth]
s_min =     [ 113,140,150, 51,133, 127, debug_color[1]-bandwidth]
    
v_max =     [  255,151,239,156,255, 141, debug_color[2]+bandwidth]
v_min =     [   89, 95,104, 61,104, 126, debug_color[2]-bandwidth]
    
min_area =  [  50, 50, 50, 10, 10, 40, 50]

now_color = default_color

# CUSTOM =================================================


DEBUG_MODE = True
STATUS = {
    'debug' : -1,
    'stop' : 0,
    'line tracing' : 1 # line tracing
}
CURRENT_STATUS = 1
COLOR_REF = {
    'line' : { 'hsv' : (66, 21, 242), 'bandwidth' : 32, 'minArea' : 40 }
}
HIGHLIGHT = {
    'color' : (0,0,255),
    'thickness' : 2
}


# ============================================================


serial_use = 1

serial_port =  None
Temp_count = 0
Read_RX =  0

mx,my = 0,0

threading_Time = 5/1000.

    
#-----------------------------------------------

def nothing(x):
    pass

#-----------------------------------------------
def create_blank(width, height, rgb_color=(0, 0, 0)):

    image = np.zeros((height, width, 3), np.uint8)
    color = tuple(reversed(rgb_color))
    image[:] = color

    return image
#-----------------------------------------------
def draw_str2(dst, target, s):
    x, y = target
    cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, 0.8, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, 0.8, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def draw_str3(dst, target, s):
    x, y = target
    cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, 1.5, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, 1.5, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def draw_str_height(dst, target, s, height):
    x, y = target
    cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, height, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, height, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()
#-----------------------------------------------

def Trackbar_change(now_color):
    global  hsv_Lower,  hsv_Upper
    hsv_Lower = (h_min[now_color], s_min[now_color], v_min[now_color])
    hsv_Upper = (h_max[now_color], s_max[now_color], v_max[now_color])

#-----------------------------------------------
def Hmax_change(a):
    
    h_max[now_color] = cv2.getTrackbarPos('Hmax', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Hmin_change(a):
    
    h_min[now_color] = cv2.getTrackbarPos('Hmin', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Smax_change(a):
    
    s_max[now_color] = cv2.getTrackbarPos('Smax', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Smin_change(a):
    
    s_min[now_color] = cv2.getTrackbarPos('Smin', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Vmax_change(a):
    
    v_max[now_color] = cv2.getTrackbarPos('Vmax', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Vmin_change(a):
    
    v_min[now_color] = cv2.getTrackbarPos('Vmin', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def min_area_change(a):
   
    min_area[now_color] = cv2.getTrackbarPos('Min_Area', Top_name)
    if min_area[now_color] == 0:
        min_area[now_color] = 1
        cv2.setTrackbarPos('Min_Area', Top_name, min_area[now_color])
    Trackbar_change(now_color)
#-----------------------------------------------
def Color_num_change(a):
    global now_color, hsv_Lower,  hsv_Upper
    now_color = cv2.getTrackbarPos('Color_num', Top_name)
    cv2.setTrackbarPos('Hmax', Top_name, h_max[now_color])
    cv2.setTrackbarPos('Hmin', Top_name, h_min[now_color])
    cv2.setTrackbarPos('Smax', Top_name, s_max[now_color])
    cv2.setTrackbarPos('Smin', Top_name, s_min[now_color])
    cv2.setTrackbarPos('Vmax', Top_name, v_max[now_color])
    cv2.setTrackbarPos('Vmin', Top_name, v_min[now_color])
    cv2.setTrackbarPos('Min_Area', Top_name, min_area[now_color])

    hsv_Lower = (h_min[now_color], s_min[now_color], v_min[now_color])
    hsv_Upper = (h_max[now_color], s_max[now_color], v_max[now_color])
#----------------------------------------------- 
def TX_data(serial, one_byte): # one_byte= 0~255
    global Temp_count
    try:
        serial.write(chr(int(one_byte)))
    except:
        Temp_count = Temp_count  + 1
        print("Serial Not Open " + str(Temp_count))
        pass
#-----------------------------------------------
def RX_data(serial):
    global Temp_count
    try:
        if serial.inWaiting() > 0:
            result = serial.read(1)
            RX = ord(result)
            return RX
        else:
            return 0
    except:
        Temp_count = Temp_count  + 1
        print("Serial Not Open " + str(Temp_count))
        return 0
        pass
#-----------------------------------------------

#*************************
# mouse callback function
def mouse_move(event,x,y,flags,param):
    global mx, my

    if event == cv2.EVENT_MOUSEMOVE:
        mx, my = x, y


# *************************
def receiving(ser):
    global receiving_exit

    global X_255_point
    global Y_255_point
    global X_Size
    global Y_Size
    global Area, Angle


    receiving_exit = 1
    while True:
        if receiving_exit == 0:
            break
        time.sleep(threading_Time)
        while ser.inWaiting() > 0:
            result = ser.read(1)
            RX = ord(result) #? 수신한 숫자
            #print ("RX=" + str(RX))
            if RX >= 100 and RX < 200:  # Color mode
                now_color = (RX - 100) / 10 #? 0~10, .1간격
                cv2.setTrackbarPos('Color_num', Top_name, now_color)
                RX = RX % 10
                if RX == 2:  # Center - X
                    ser.write(chr(int(X_255_point)))
                elif RX == 3:  # Center - Y
                    ser.write(chr(int(Y_255_point)))
                elif RX == 4:  # X_Size
                    ser.write(chr(int(X_Size)))
                elif RX == 5:  # Y_Size
                    ser.write(chr(int(Y_Size)))
                elif RX == 6:  # Angle
                    ser.write(chr(int(Angle)))
                    print("106=>" + str(Angle))
                elif RX == 1:  # Area
                    ser.write(chr(int(Area)))
                else:
                    ser.write(chr(int(0)))

            else:
                ser.write(chr(int(0)))

def GetLengthTwoPoints(XY_Point1, XY_Point2):
    return math.sqrt( (XY_Point2[0] - XY_Point1[0])**2 + (XY_Point2[1] - XY_Point1[1])**2 )
# *************************
def FYtand(dec_val_v ,dec_val_h):
    return ( math.atan2(dec_val_v, dec_val_y) * (180.0 / math.pi))
# *************************
#degree 값을 라디안 값으로 변환하는 함수
def FYrtd(rad_val ):
    return  (rad_val * (180.0 / math.pi))

# *************************
# 라디안값을 degree 값으로 변환하는 함수
def FYdtr(dec_val):
    return  (dec_val / 180.0 * math.pi)

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
    W_View_size =  320
    #H_View_size = int(W_View_size / 1.777)
    H_View_size = int(W_View_size / 1.333)

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
    args = vars(ap.parse_args())

    img = create_blank(320, 50, rgb_color=(0, 0, 255))
    
    cv2.namedWindow(Top_name)

    
    cv2.createTrackbar('Hmax', Top_name, h_max[now_color], 255, Hmax_change)
    cv2.createTrackbar('Hmin', Top_name, h_min[now_color], 255, Hmin_change)
    cv2.createTrackbar('Smax', Top_name, s_max[now_color], 255, Smax_change)
    cv2.createTrackbar('Smin', Top_name, s_min[now_color], 255, Smin_change)
    cv2.createTrackbar('Vmax', Top_name, v_max[now_color], 255, Vmax_change)
    cv2.createTrackbar('Vmin', Top_name, v_min[now_color], 255, Vmin_change)
    cv2.createTrackbar('Min_Area', Top_name, min_area[now_color], 255, min_area_change)
    cv2.createTrackbar('Color_num', Top_name,color_num[now_color], len(color_num)-1, Color_num_change) # 임의 컬러 보라색을 위해서 4->5로 변경하여 num 값 추가

    Trackbar_change(now_color)

    draw_str3(img, (15, 25), 'MINIROBOT Corp.')

    cv2.imshow(Top_name, img)
    #---------------------------

    if not args.get("video", False):
        camera = cv2.VideoCapture(0)  # 카메라에서 영상을 불러옴
    else: # -video 플래그가 입력된 경우
        camera = cv2.VideoCapture("C:\video.mp4") # 영상파일에서 영상을 불러옴
    #---------------------------
    # camera.set(3, W_View_size)
    # camera.set(4, H_View_size)

    time.sleep(0.5)
    #---------------------------
    
    if serial_use != 0: #? Serial 통신 활성화 시, 미리 버퍼를 클리어
       serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
       serial_port.flush() # serial cls
    
    #---------------------------
    (next_frame, frame) = camera.read()

    # 대충 화면에 정보 표시
    draw_str2(frame, (5, 15), 'X_Center x Y_Center =  Area' )
    draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d.  Space: Fast <=> Video and Mask.'
                      % (W_View_size, H_View_size))
    draw_str_height(frame, (5, int(H_View_size/2)), 'Fast operation...', 3.0 )
    cv2.imshow('mini CTS4 - Video', frame )

    cv2.setMouseCallback('mini CTS4 - Video', mouse_move)
    #
    #---------------------------
    
    if serial_use != 0: #? Serial 통신 활성화 시, 쓰레드를 사용하여 송신
       t = Thread(target=receiving, args=(serial_port,)) #? receiving가 무엇을 송신하려 하는 것인지 모르겠음
       time.sleep(0.1)
       t.start()
        
    # First -> Start Code Send
    TX_data(serial_port, 0) #? Start Code : 250
    
    old_time = clock()

    # 초기화 끝
    
    # -------- Main Loop Start --------
    while True:

        next_frame, frame = camera.read()
        if args.get("video") and not next_frame: break

        # TOGGLE DEBUG MODE
        key = 0xFF & cv2.waitKey(1)
        if key == 27:  # ESC  Key
            break
        elif key == ord(' '):  # spacebar Key
            DEBUG_MODE = False if DEBUG_MODE else True
        
        # 현재 상황 파악


        # 각 상황별 동작 설정
        if CURRENT_STATUS == STATUS['debug']:
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

        elif CURRENT_STATUS == STATUS['line tracing']:
            # 세로 3분할 최하단 영역으로 라인 트레이싱
            tr_frame = frame[H_View_size//3:H_View_size, :]
            # 타켓의 색상 영역의 마스크 이미지 구하기
            tr_mask = cv2.inRange(
                tr_frame,
                np.subtract(COLOR_REF['line']['hsv'], COLOR_REF['line']['bandwidth']),
                np.add(COLOR_REF['line']['hsv'], COLOR_REF['line']['bandwidth']))
            # 마스크의 노이즈 제거
            tr_mask = cv2.morphologyEx(tr_mask, cv2.MORPH_OPEN, (3,3), iterations=2)
            # 마스크 이미지로부터 윤곽선 검출
            contours = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center = None
            
            # 최적화
            if len(contours) == 0: continue # 윤곽선이 검출되지 않으면, 아래 작업을 하지 않음
            
            target_contour = max(contours, key=cv2.contourArea) # 가장 큰 윤곽선을 찾음
            Area = cv2.contourArea(target_contour)
            if Area < COLOR_REF['line']['minArea']: continue # 윤곽선의 면적이 기준치에 못 미치면 검출되지 않은 것으로 간주
            
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
                
            cv2.imshow('mini CTS4 - Video', tr_frame )
            cv2.imshow('mini CTS4 - Mask', tr_mask)


    # cleanup the camera and close any open windows
    if serial_use != 0:
       serial_port.close()
    camera.release()
    cv2.destroyAllWindows()
