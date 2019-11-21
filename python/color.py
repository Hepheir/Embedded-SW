import numpy as np
import cv2


# HSV
YELLOW_ub = [  32, 255, 255 ]
YELLOW_lb = [  20,  40, 112 ]

RED_ub = [ 192, 255, 255 ]
RED_lb = [ 156,  40, 112 ]

#
ref = {
    'YELLOW' : 0,
    'RED' : 1
}

hsv_ub = np.array([YELLOW_ub, RED_ub])
hsv_lb = np.array([YELLOW_lb, RED_lb])

# ******************************************************************

def nothing(x):
    pass

def getMask(src, color):
    mask = cv2.inRange(src, hsv_ub[color], hsv_lb[color])
    mask = cv2.erode(mask, (3,3), iterations=1)
    mask = cv2.dilate(mask, (3,3), iterations=1)
    return mask


def debugMode(video, resolution):
    frame = None
    upperb = None
    lowerb = None

    winname = 'DEBUG'
    cv2.namedWindow(winname)
    cv2.createTrackbar('max_h', winname, 255, 255, nothing)
    cv2.createTrackbar('max_s', winname, 255, 255, nothing)
    cv2.createTrackbar('max_v', winname, 255, 255, nothing)
    cv2.createTrackbar('min_h', winname, 0, 255, nothing)
    cv2.createTrackbar('min_s', winname, 0, 255, nothing)
    cv2.createTrackbar('min_v', winname, 0, 255, nothing)

    while True:
        key = cv2.waitKey(1)
        if (key == ord(' ')):
            break

        grab, now = video.read()
        if not grab: break
        else:
            frame = cv2.resize(now, resolution)
            cv2.imshow('CAM', frame)

        upperb = np.array([cv2.getTrackbarPos('max_h', winname), cv2.getTrackbarPos('max_s', winname), cv2.getTrackbarPos('max_v', winname)])
        lowerb = np.array([cv2.getTrackbarPos('min_h', winname), cv2.getTrackbarPos('min_s', winname), cv2.getTrackbarPos('min_v', winname)])
            
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        mask = cv2.inRange(hsv, lowerb, upperb)
        mask = cv2.erode(mask, (3,3), iterations=2)
        mask = cv2.dilate(mask, (3,3), iterations=2)


        cv2.imshow('CAM', frame)
        cv2.imshow('MASK', mask)