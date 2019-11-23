import cv2

def getFrame(video,resolution=None,imshow=False):
    grab, now = video.read()
    if not grab:
        return None
        
    if resolution != None:
        frame = cv2.resize(now, resolution)

    if imshow:
        cv2.imshow('CAM', frame)
    return frame

def getCenter(frame):
    fh,fw = frame.shape[:2]
    cy, cx = (fh//2, fw//2)
    return (cx, cy)

def printCursor(frame, radius=6, color=(0,0,255)):
    cx,cy = getCenter(frame)

    x1,y1 = (cx-radius, cy-radius)
    x2,y2 = (cx+radius, cy+radius)

    cut = frame[y1:y2, x1:x2].copy()
    cv2.rectangle(frame, (x1,y1), (x2,y2), color, 1)
    return cut

