import cv2

Video = None

RESOLUTION = (200, 150)
#-----------------------------------------------
def init():
    global Video
    Video = cv2.VideoCapture(0)

    if not Video.isOpened():
        raise Exception("Could not open video device")

    print('Camera initialized.')
    Video.set(cv2.CAP_PROP_FRAME_WIDTH,  RESOLUTION[0])
    Video.set(cv2.CAP_PROP_FRAME_HEIGHT, RESOLUTION[1])
    return Video
#-----------------------------------------------
def getFrame(imshow=False):
    grab, now = Video.read()
    if not grab:
        raise Exception("Could not grab next frame. [EOF or Device is lost]")
        
    frame = cv2.resize(now, RESOLUTION)
    if imshow:
        cv2.imshow('CAM', frame)

    return frame