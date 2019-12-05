import numpy as np
import cv2

def onChange(x):
    # 변화한 트랙바의 값이 x로 전달됨.
    # 0~100사이의 값을 (가중치에 맞게) 0.0 ~ 1.0 사이의 값으로 조정
    w = x / 100
    
    # 가중합체 굼바를 다시 구함
    cg = cv2.addWeighted(goomba, w, goomgirl, (1-w), 0)
    cv2.imshow(winname, cg) # 'Trackbar Test'창에 출력

winname = 'Trackbar Test'
goomba   = cv2.imread('flower1.jpg')
goomgirl = cv2.imread('flower2.jpg')

cv2.namedWindow(winname)
cv2.createTrackbar('Goomba Weight', winname, 0, 100, onChange)
# 트랙바의 값은 정수만 가능 (0 ~ 100사이의 정수로 설정)
# 트랙바의 값이 변할 때 마다 onChange()가 실행 됨.
onChange(0)

cv2.waitKey(0)
cv2.destroyAllWindows()
