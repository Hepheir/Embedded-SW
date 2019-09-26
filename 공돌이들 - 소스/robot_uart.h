#include <stdlib.h>
#include <termios.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/signal.h>
#include <sys/types.h>
#include <time.h>
#include <string.h>
#include <pthread.h> 
#include <unistd.h> 

#define BAUDRATE B4800
#define MODEDEVICE "/dev/ttyS2"

#define	INIT_ROUTINE	1
#define	COLOR_1			2
#define	COLOR_2			3
#define	COLOR_3			4


	int uart_fd;
	int routine;				

int open_serial(void)
{
    char fd_serial[20];
    int fd;
    struct termios oldtio, newtio;

    strcpy(fd_serial, MODEDEVICE); //FFUART
    
    fd = open(fd_serial, O_RDWR | O_NOCTTY );
    if (fd <0) {
        printf("Serial %s  Device Err\n", fd_serial );
        exit(1);  
    	}
	printf("robot uart ctrl %s\n", MODEDEVICE);
    
    tcgetattr(fd,&oldtio); /* save current port settings */
    bzero(&newtio, sizeof(newtio));
    newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;
    newtio.c_lflag = 0;
    newtio.c_cc[VTIME]    = 0;   /* inter-character timer unused */
    newtio.c_cc[VMIN]     = 1;   /* blocking read until 8 chars received */
    
    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);
    
    return fd;
}


void *read_func(void ) 
{     

	char read_data;

	while(1)
	{
			if(read(uart_fd, &read_data, 1))
			{
				safe = 1;
				if(read_data == INIT_ROUTINE)	routine = 0;	
				if(read_data == COLOR_1)		routine = 1;	
				if(read_data == COLOR_2)		routine = 2;	
				if(read_data == COLOR_3)		routine = 3;
				if(read_data == 5)				routine = 4;												
				printf("read : %d\n", read_data);
			}
	}
}
//Embedded -> Robot
void write_uart(int command_number)
{	
	write(uart_fd, &command_number, 1);
	printf("Embedded -> Robot [%d]\n", command_number);
}

