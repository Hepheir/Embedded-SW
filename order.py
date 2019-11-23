import serial

SERIAL_ENABLE = False

BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200
SERIAL_PORT = None

attempts = 0

#-----------------------------------------------
def TX_data(serial, one_byte):  # one_byte= 0~255
    try:
        serial.write(chr(int(one_byte)))
    except:
        attempts = attempts  + 1
        print("Serial Not Open ", attempts)
#-----------------------------------------------
def RX_data(serial):
    try:
        if serial.inWaiting() > 0:
            result = serial.read(1)
            RX = ord(result)
            return RX
    except:
        attempts = attempts  + 1
        print("Serial Not Open ",attempts)
    return 0
# ******************************************************************
# ******************************************************************
# ******************************************************************

if SERIAL_ENABLE:
    SERIAL_PORT = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001) # sudo chmod 666 /dev/ttyAMA0
    SERIAL_PORT.flush() # serial cls
    
    TX_data(SERIAL_PORT, 250)