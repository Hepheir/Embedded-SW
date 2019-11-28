# -*- coding: utf-8 -*-

Serial = None # initialize with serial_init()

SERIAL_USABLE = True
attempts = 0

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
        return None

    Serial.write(chr(int(byte)))
#-----------------------------------------------
def RX_data():
    if not SERIAL_USABLE:
        return None

    if Serial.inWaiting() <= 0:
        return None
    
    return Serial.read(1)
