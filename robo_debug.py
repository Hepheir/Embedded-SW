import numpy as np
import cv2

import robo_color as color
# 디버그용으로 임시로 쓰고 말 것들

#-----------------------------------------------
def showAllColorMasks(frame,color_masks):
    height, width = frame.shape[:2]
    colors = len(color.DETECTABLE_COLORS)

    detected = np.zeros((height, width * colors, 3), dtype=np.uint8)

    i = 0
    for color_name in color_masks:
        mask = color_masks[color_name]
        ref = color.getRef(color_name)
        color_bgr = ref['rgb'][::-1] # [::-1], RGB 를 역순으로 --> BGR

        # RETR_EXTERNAL : 외곽선만 구함 --> 처리속도 효율 향상 / APPROX_SIMPLE : 근사화 --> 데이터 량 줄임, 속도 향상
        contours = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
        if contours:
            max_cont = max(contours, key=cv2.contourArea)
            x,y,w,h = cv2.boundingRect(max_cont)

            # mask는 GRAY_SCALE 이므로, 컬러를 입히려면 BGR로 convert 해주어야함.
            mask = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR) 
            cv2.rectangle(mask, (x,y), (x+w,y+h), color_bgr, 2)
        else:
            mask = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR)

        mask = cv2.addWeighted(mask, .8, frame, .2, 0)

        stX = width * i # StartX : 이미지 붙여넣을 위치 (x좌표)
        detected[:, stX:(stX+width)] = mask # 마스크 붙여넣기
        detected[:, (stX+width-1)] = (255,255,255) # 각 마스크별 흰색 두께 1의 경계선

        i += 1

    scaler = 0.5 # 이미지 축소/확대 비율
    cv2.imshow('masks', cv2.resize(detected, ( int(width*colors*scaler), int(height*scaler))))
#-----------------------------------------------
def record():
    # find the webcam
    cap = cv2.VideoCapture(0)

    # video recorder
    w = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
    h = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
    fourcc = cv2.VideoWriter_fourcc(*'MJPG')
    out = cv2.VideoWriter('output.avi',fourcc, 15.0, (int(w),int(h)))

    # record video
    while (cap.isOpened()):
        ret, frame = cap.read()
        if ret:
            out.write(frame)
            cv2.imshow('Video Stream', frame)
        else:
            break

        if cv2.waitKey(1) & 0xFF == ord(' '):
            break

    cap.release()
    cv2.destroyAllWindows()
#-----------------------------------------------
if __name__ == "__main__":
    record()