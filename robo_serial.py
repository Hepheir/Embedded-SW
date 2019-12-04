# -*- coding: utf-8 -*-

Serial = None # initialize with serial_init()

SERIAL_USABLE = True

#-----------------------------------------------
try:
    import serial
except:
    SERIAL_USABLE = False
#-----------------------------------------------
def init(bps=4800):
    global Serial
    if not SERIAL_USABLE:
        print('[!] Could not find module <serial>')
        return None

    print('Serial initialized.')
    Serial = serial.Serial('/dev/ttyAMA0', bps, timeout=0.001) # sudo chmod 777 /dev/ttyAMA0
    Serial.flush() # serial cls
    return Serial
#-----------------------------------------------
def TX_data(byte):  # one_byte= 0~255
    if not SERIAL_USABLE:
        print('[T] Serial is not available')
        return None
    
    Serial.write(chr(int(byte)))
    return True
#-----------------------------------------------
def RX_data():
    global failCount
    if not SERIAL_USABLE:
        print('[R] Serial is not available')
        return None

    if Serial.inWaiting() <= 0:
        return None
    
    byte = Serial.read(1)
    return byte
