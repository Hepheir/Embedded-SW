import cv2

if __name__ == "__main__":
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