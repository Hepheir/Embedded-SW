
    key = None
    key_chr = '_'
    tx_data = -1
    print('Start mainloop.')
# ******************************************************************
    while True:
        # --------
        key = debug.waitKey(1)
        key_chr = chr(key) if key else key_chr
        # --------
        if key == 27: # ESC
            break
        elif key_chr == '`':
            key_chr = '_'
            debug.DEBUG_MODE = not debug.DEBUG_MODE
            continue

        elif key_chr == '/':
            key_chr = '_'
            debug._print('\n\nSERIAL : ')
            
            tx_data = int( debug._scan() )
            serial.TX_data(tx_data)
        # --------
        elif debug.DEBUG_MODE:
            if key:
                tx_data = debug.remoteCtrl(key)
        # --------
        try:
            # 현재 상황 파악
            context = move.context(frame)
            

            cv2.imshow('Frame', frame)
            debug._print('\r%-12s %-24s %-8s %-8s %-6s ' % (
                '[t=%s]'        % debug.runtime_ms_str(),
                '[cntx=%s]'     % context,
                '[key=%c]'      % key_chr,
                '[tx=%d]'       % tx_data,
                '[d=%c]'        % ('T' if debug.DEBUG_MODE else 'F')
            ))
        except:
            pass