def c(videoStream):
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
    next_frame, current_frame = videoStream.read()
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
        
        # 가장 큰 윤곽선을 찾고, 윤곽선의 면적이 충분히 큰지 검사
        max_cont, max_area = None, 0
        if len(contours) > 0:
            max_cont = max(contours, key=cv2.contourArea)
            max_area = cv2.contourArea(max_cont)

        if max_area > line_min_area:
            # fitLine() 함수를 이용하여 직선을 검출하고 화면에 출력
            dx,dy,x0,y0 = cv2.fitLine(max_cont, cv2.DIST_L2,0,0.01,0.01)
            
            if dy != 0:
                # (y-y0)/dy == (x-x0)/dx
                x_top = int(-y0*dx/dy + x0)
                x_bot = int((roi_height-y0)*dx/dy + x0)
                
                cv2.circle(current_frame, (x0,y0+roi_y1), 5, hl_line_color, thickness=2)
                cv2.line(current_frame, (x_top,roi_y1),(x_bot,roi_y2), hl_line_color, 1)
            else:
                print('Could not calculate line. : divide by zero')
            
            cv2.drawContours(line_mask,[max_cont],-1,128,-1)

        frame_bottom_text('MAX AREA : %d [(%d,%d),(%d,%d)]'%(max_area,x_top,roi_y1,x_bot,roi_y2))
        cv2.imshow(WINNAME['mask'], line_mask)

    # --------- Show Robot's Vision --------
    main_frame[SCREEN_FRAME_AREA[0]:SCREEN_FRAME_AREA[1],SCREEN_FRAME_AREA[2]:SCREEN_FRAME_AREA[3]] = current_frame
    cv2.imshow(WINNAME['main'], main_frame)