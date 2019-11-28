# -*- coding: utf-8 -*-

Serial = None # initialize with serial_init()

SERIAL_USABLE = True
failStack = 0

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
    global failStack
    if not SERIAL_USABLE:
        failStack += 1
        print('[T] Serial is not available', failStack)
        return None
        
    failStack = 0

    print('[T] Serial <%d> was sent.' % byte)
    Serial.write(chr(int(byte)))
#-----------------------------------------------
def RX_data():
    global failStack
    if not SERIAL_USABLE:
        failStack += 1
        print('[R] Serial is not available', failStack)
        return None

    failStack = 0

    if Serial.inWaiting() <= 0:
        return None
    
    byte = Serial.read(1)
    print('[R] Serial <%d> was received.' % byte)
    return byte
