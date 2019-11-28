import cv2

Video = None

RESOLUTION = (320, 240)
CENTER = (100, 75)
# -----------------------------------------------
def init():
    global Video
    Video = cv2.VideoCapture(0)

    if not Video.isOpened():
        raise Exception("Could not open video device")

    print('Camera initialized.')
    Video.set(cv2.CAP_PROP_FRAME_WIDTH,  RESOLUTION[0])
    Video.set(cv2.CAP_PROP_FRAME_HEIGHT, RESOLUTION[1])
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