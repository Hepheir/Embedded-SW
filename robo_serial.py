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
        raise Exception('Could not find module <serial>')
        return None

    print('Serial initialized.')
    Serial = serial.Serial('/dev/ttyAMA0', bps, timeout=0.001) # sudo chmod 666 /dev/ttyAMA0
    Serial.flush() # serial cls
    return Serial
#-----------------------------------------------
def TX_data(serial, one_byte):  # one_byte= 0~255
    global attempts
    if not SERIAL_USABLE: return None
    try:
        serial.write(chr(int(one_byte)))
    except:
        attempts = attempts  + 1
        print("Serial Not Open ", attempts)
#-----------------------------------------------
def RX_data(serial):
    global attempts
    if not SERIAL_USABLE: return None
    try:
        if serial.inWaiting() > 0:
            result = serial.read(1)
            RX = ord(result)
            return RX
    except:
        attempts = attempts  + 1
        print("Serial Not Open ",attempts)
    return 0
