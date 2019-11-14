import serial
ser = serial.Serial('/dev/ttyAMA0', 4800, timeout=0.0001)
ser.open
ser.flush() # 시리얼 수신 데이터 버리는 법
# 라즈베리파이에서 시리얼 수신 방법
ser.inWaiting() > 0:
    RX_DATA = ser.read(1) # RX_DATA는 0~255, 1 Byte
    
# 라즈베리파이에서 시리얼 송신 방법
ser.write(chr(int(0))) # 숫자값은 0~255, 1byte