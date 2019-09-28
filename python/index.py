# -*- coding: utf-8 -*-

import numpy as np
import cv2
# import serial

import time
import math


# CUSTOM =================================================


def HSV_Parser(h_deg, s_per, v_per):
    # degree, percent --> 0~255 value
    h = h_deg * 255 // 360
    s = s_per * 255 // 100
    v = v_per * 255 // 100
    return h,s,v

# -------- Global Constants --------

STATUS = {
    # -- 시스템 제어 --
    'shutdown' : 27, # ESC
    'paused' : ord(' '), # Space Bar
    # -- 디버그 및 조정 --
    'color_picker' : ord('p'),
    'color_calibration' : ord('a'),
    'set_current_color': ord('s'),
    # -- 통상 모드 --
    'auto' : ord('0'),
    # -- 개별 모드 --
    'line_tracing' : ord('1'), # 라인트레이싱
    'line_tracing:opening' : ord('2'), # 길뚫
    'line_tracing:recall' : ord('3'), # 라인으로 복귀
    'door:push' : ord('4'), # 문
    'door:shutter' : ord('5'), # 셔터
    'deliver' : ord('6'), # 파란박스
    'bridge' : ord('7'), # 다리
    'limbo' : ord('8'), # 림보
    'waiting' : ord('9') # 대기
}

# bandwidth : lower, upper hsv를 파악하는데 사용.
COLOR_REF = {
    'line' : {
        'hsv' : (201,153,172),
        'bandwidth' : 20,
        'minArea' : 40
    },
    'white' : {
        'hsv_lower' : HSV_Parser(0,0,68),
        'hsv_upper' : HSV_Parser(360,15,100),
        'minArea' : 40
    },
    'yellow' : {
        'hsv_lower' : HSV_Parser(30,60,45),
        'hsv_upper' : HSV_Parser(50,100,100),
        'minArea' : 50
    },
    'red' : {
        'hsv_lower' : HSV_Parser(0,40,40),
        'hsv_upper' : HSV_Parser(8,100,100),
        'minArea' : 50,
        'next' : 'red+'
    }, 'red+' : {
        'hsv_lower' : HSV_Parser(245,30,40),
        'hsv_upper' : HSV_Parser(360,100,100),
        'minArea' : 50
    },
    'blue' : {
        'hsv_lower' : HSV_Parser(124,40,40),
        'hsv_upper' : HSV_Parser(186,100,100),
        'minArea' : 10
    },
    'black' : {
        'hsv_lower' : HSV_Parser(0,0,0),
        'hsv_upper' : HSV_Parser(360,80,27),
        'minArea' : 10
    }
}
HIGHLIGHT = {
    'color' : (0,0,255),
    'thickness' : 2
}
CURSOR = {
    'color' : (0x00,0x00,0xFF),
    'radius' : 5,
    'thickness' : 2
}

BPS = 4800


WINNAME = {
    'main' : 'main',
    'mask' : 'mask'
}

# -------- Global Variables --------

current_color = 'yellow'
current_status = STATUS['auto']
onStatusChange = False

# ============================================================
def color_detection(image, color_reference):
    lower = color_reference['hsv_lower']
    upper = color_reference['hsv_upper']

    mask = cv2.inRange(image, lower, upper)

    if 'next' in color_reference:
        next_ref = COLOR_REF[color_reference['next']]
        mask_2 = cv2.inRange(image, next_ref['hsv_lower'], next_ref['hsv_upper'])
        mask = cv2.add(mask, mask_2)
    
    return mask
#-----------------------------------------------

# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# **************************************************
# 84022014

if __name__ == '__main__':
    pass

# -------- User Setting --------
BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200

# -------- Camera Load --------
video = cv2.VideoCapture(0)
time.sleep(0.5)

if not video.isOpened():
    raise Exception("Could not open video device")

video.set(cv2.CAP_PROP_FRAME_WIDTH,  320)
video.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)

print('Camera loaded.')
# -------- Serial Setting --------
serial_use = False
serial_port =  None

if serial_use: #? Serial 통신 활성화 시, 미리 버퍼를 클리어
    serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
    serial_port.flush() # serial cls

print('Serial setting done.')
# -------- Screen Setting --------
FRAME_HEIGHT, FRAME_WIDTH = video.read()[1].shape[:2]
FRAME_CENTER = (FRAME_WIDTH//2, FRAME_HEIGHT//2)

SCREEN_PADDING = 32
SCREEN_HEIGHT, SCREEN_WIDTH = (FRAME_HEIGHT + 2*SCREEN_PADDING, FRAME_WIDTH)
SCREEN_CENTER = (SCREEN_WIDTH//2, SCREEN_HEIGHT//2)

SCREEN_FRAME_AREA = (
    # HEIGHT
    SCREEN_PADDING,
    FRAME_HEIGHT+SCREEN_PADDING,
    # WIDTH
    0,
    FRAME_WIDTH
)

SCREEN_BLACK = np.zeros((SCREEN_HEIGHT,SCREEN_WIDTH,3), dtype=np.uint8)

main_frame = None

def frame_top_text(text):
    global main_frame
    cv2.putText(main_frame, text, (4, 16), cv2.FONT_HERSHEY_PLAIN, 1, (0xFF,0xFF,0xFF), thickness = 1)

def frame_bottom_text(text):
    global main_frame, SCREEN_HEIGHT, SCREEN_PADDING
    cv2.putText(main_frame, text, (4, SCREEN_HEIGHT-SCREEN_PADDING+16), cv2.FONT_HERSHEY_PLAIN, 1, (0xFF,0xFF,0xFF), thickness = 1)

cv2.namedWindow(WINNAME['main'])
cv2.namedWindow(WINNAME['mask'])

print('Screen setting done : %dx%d' % (FRAME_WIDTH,FRAME_HEIGHT))
# -------- Debug Preset --------

SHOW_TRACKBAR = False

if SHOW_TRACKBAR:
    
    DEBUG_H_MAX = 360
    DEBUG_SV_MAX = 100

    def changeRef(colorname, keyname, hsv_select, value):
        global COLOR_REF
        global DEBUG_H_MAX, DEBUG_SV_MAX
        h,s,v = COLOR_REF[colorname][keyname]
        new_hsv = None
        if hsv_select is 'h':
            new_hsv = (value * 255 // DEBUG_H_MAX, s, v)
        elif hsv_select is 's':
            new_hsv = (h, value * 255 // DEBUG_SV_MAX, v)
        elif hsv_select is 'v':
            new_hsv = (h, s, value * 255 // DEBUG_SV_MAX)
        
        COLOR_REF[colorname][keyname] = new_hsv

        if 'next' in COLOR_REF[colorname]:
            nextcolorname = COLOR_REF[colorname]['next']
            changeRef(nextcolorname, keyname, hsv_select, value)


    cv2.createTrackbar('DEBUG', WINNAME['main'],0x00,0xFF, onDebugTrackbar_Change)

current_status = STATUS['line_tracing']

# -------- Main Loop Start --------
print('Start main loop!')
while True:
    # -------- Check Context --------
    # TODO : 현재 상황을 자동으로 파악 하는 부분
    # 임시로 키보드로 부터 직접 상황을 입력받음
    key = cv2.waitKey(1) & 0xFF # 상수 STATUS 참고.
    if key is not 255:
        current_status = key
        onStatusChange = True
    else:
        onStatusChange = False

    # -------- Act: SYSTEM CONFIGURE --------
    # SHUTDOWN
    if current_status == STATUS['shutdown']:
        print('shutdown')
        break

    # PAUSE
    elif current_status == STATUS['paused']:
        frame_bottom_text('PAUSED')
        cv2.imshow(WINNAME['main'], main_frame)
        print('paused')
        continue

    # -------- Grab frames --------
    next_frame, current_frame = video.read()
    if not next_frame:
        break # no more frames to read : EOF

    main_frame = SCREEN_BLACK.copy()

    # -------- Act: DEBUG and CALIBRATION --------
    # SET CURRENT COLOR
    if current_status == STATUS['set_current_color']:
        frame_top_text('SET CURRENT COLOR')

        SELECTABLES = [
            'red',
            'blue',
            'yellow',
            'white',
            'black'
        ]

        if onStatusChange:
            _index = SELECTABLES.index(current_color) + 1

            if not _index < len(SELECTABLES):
                _index -= len(SELECTABLES)

            current_color = SELECTABLES[_index]

        frame_bottom_text('CURRENT COLOR : %s'%(current_color))

    # COLOR PICKER
    elif current_status == STATUS['color_picker']:
        frame_top_text('COLOR PICKER')

        # -- 커서가 가리키는 HSV 색상 --
        cv2.circle(current_frame, VIEW_CENTER, CURSOR['radius'], CURSOR['color'], CURSOR['thickness'])


        current_frame_hsv = cv2.cvtColor(current_frame, cv2.COLOR_BGR2HSV)

        current_frame[pointer_pos] = HIGHLIGHT['color']

        # -- key hold시, line색상으로 설정 --
        key = cv2.waitKey(1) & 0xFF # '& 0xFF' For python 2.7.10
        if key is KEY['0']:
            COLOR_REF['line']['hsv'] = current_frame_hsv[pointer_pos]
            print('Set line color as : ', COLOR_REF['line']['hsv'])


        putText(current_frame, (0,0), 'DEBUG MODE')
        putText(current_frame, (8,16), 'DEBUG MODE')
        cv2.imshow(WINNAME['main'], current_frame)

        def color_picker():
            pass
        
        def hue_adjust():
            print('adjusting... ')
            _COLOR = 0 # B:0, G:1, R:2
            for col in range(VIEW_SIZE['width']):
                for row in range(VIEW_SIZE['height']):
                    pixel = current_frame[row,col]
                    pixel[_COLOR] += debug_color_adjust
                    if pixel[_COLOR] >= 256:
                        pixel[_COLOR] -= 256
                    current_frame[row,col] = pixel
            print('Done')

        # -- key hold시, 조정된 이미지 출력 --
        key = cv2.waitKey(1) & 0xFF # '& 0xFF' For python 2.7.10
        if key is KEY['0']:
            hue_adjust()
            cv2.imshow('Adjusted', current_frame)
            
        putText(current_frame, (0,0), 'DEBUG MODE')
        cv2.imshow(WINNAME['main'], current_frame)

    # -------- Act: ORDINARY MODE --------
    # LINE TRACING
    elif current_status == STATUS['line_tracing']:
        frame_top_text('LINE TRACING : (%s)'%(current_color.upper()))
        
        # TODO : 라인트레이싱 (급함, 우선순위 1)
        # 관심 영역
        roi_x1,roi_y1 = (0, FRAME_HEIGHT*2//3)
        roi_x2,roi_y2 = (FRAME_WIDTH,FRAME_HEIGHT)
        roi_height = roi_y2 - roi_y1

        line_color_ref = COLOR_REF[current_color] # 라인 색상
        line_min_area = 20

        hl_roi_box_color = (0x00,0xFF,0x00) # 관심영역 표기 색상
        hl_line_color = (0xFF,0x00,0xFF) # 경로 표기 색상

        # ---- Region of Interest : 관심영역 지정 ----
        roi_frame = current_frame[roi_y1:roi_y2,roi_x1:roi_x2]
        roi_frame_hsv = cv2.cvtColor(roi_frame, cv2.COLOR_BGR2HSV)

        cv2.rectangle(current_frame, (roi_x1,roi_y1), (roi_x2,roi_y2),hl_roi_box_color,thickness=1)
        
        # ---- Line 검출 ----
        line_mask = color_detection(roi_frame_hsv, line_color_ref)
        
        # 모폴로지 연산을 이용하여 노이즈 제거
        _kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5,5))
        line_mask = cv2.morphologyEx(line_mask, cv2.MORPH_OPEN, _kernel)

        # 윤곽선 검출
        contours,hierarchy = cv2.findContours(line_mask.copy(), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)[-2:]
        
        max_cont, max_area = None, 0
        if len(contours) > 0:
            max_cont = max(contours, key=cv2.contourArea)
            max_area = cv2.contourArea(max_cont)

        if max_area > line_min_area:
            dx,dy,x0,y0 = cv2.fitLine(max_cont, cv2.DIST_L2,0,0.01,0.01)
            # (y-y0)dy == (x-x0)dx
            x_top = int(-y0*dx/dy + x0)
            x_bot = int((roi_height-y0)*dx/dy + x0)
            
            cv2.circle(current_frame, (int(x0),int(y0+roi_y1)), 5, hl_line_color, thickness=2)
            cv2.line(current_frame, (x_top,roi_y1),(x_bot,roi_y2), hl_line_color, 1)
            cv2.drawContours(line_mask,[max_cont],-1,128,-1)

        frame_bottom_text('MAX AREA : %d [(%d,%d),(%d,%d)]'%(max_area,x_top,roi_y1,x_bot,roi_y2))
        cv2.imshow(WINNAME['mask'], line_mask)

    # --------- Show Robot's Vision --------
    main_frame[SCREEN_FRAME_AREA[0]:SCREEN_FRAME_AREA[1],SCREEN_FRAME_AREA[2]:SCREEN_FRAME_AREA[3]] = current_frame
    cv2.imshow(WINNAME['main'], main_frame)

# cleanup the camera and close any open windows
video.release()
cv2.destroyAllWindows()

if serial_use:
    serial_port.close()