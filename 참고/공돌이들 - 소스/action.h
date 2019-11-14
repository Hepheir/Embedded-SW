
#define	SIDE_STEP_RIGHT_70		24
#define	SIDE_STEP_LEFT_70			23
#define	stop							21
#define	move							22
#define	box_catch					25
#define	back_move					26
#define	turn_right					27
#define	turn_left					28	
#define	box_move						29
#define	drop							30
		

 //four_adc
#define ADC_1CH 				0x1000  
#define ADC_2CH 				0x1000  
#define ADC_3CH 				0x1000  
#define ADC_4CH 				0x1000 

 
//static unsigned short rxbuf[4];
//int adcfd;
int temp =0;


int object_distance(int ch)
{
	int adcfd;
	static unsigned short rxbuf[4];
	struct timeval start, end; 

	if((adcfd = open("/dev/FOUR_ADC", O_RDONLY )) < 0)
	{         // KEY open
		perror("open faile /dev/FOUR_ADC");
		exit(-1);
	}
	
	read(adcfd,rxbuf,sizeof(rxbuf));	// ADC READ
	//printf("ch1 %04x,  ch2 %04x,  ch3 %04x,  ch4 %04x\n", rxbuf[0], rxbuf[1], rxbuf[2] ,rxbuf[3]);
	//printf("ch1 %d,  ch2 %d,  ch3 %d,  ch4 %d\n", rxbuf[0], rxbuf[1], rxbuf[2] ,rxbuf[3]);	
	
	usleep(100000); //0.1 sec
	
	return rxbuf[ch-1];
}
//////////////////////////////////////////////////////

int center_table(int *rect_point){

	int posx,posy;
	posx = object_pos_x(rect_point);
	posy = object_pos_y(rect_point);
	printf("x= %d , y = %d \n ", posx,posy);
		if(posx < -55){
			write_uart(SIDE_STEP_RIGHT_70);
		}else if(posx > 55){
			write_uart(SIDE_STEP_LEFT_70);
		}else	if(posy > -75){
			write_uart(box_move); 
		}else	if(posy <= -85){
			write_uart(stop); routine=8; return 0;
		}	
	
}
int center_obj(int *rect_point){

	int posx,posy;
	posx = object_pos_x(rect_point);
	posy = object_pos_y(rect_point);
	printf("x= %d , y = %d \n ", posx,posy);
		if(posx < -55){
			write_uart(SIDE_STEP_RIGHT_70);
		}else if(posx > 55){
			write_uart(SIDE_STEP_LEFT_70);
		}else	if(posy > -75){
			write_uart(move); 
		}else	if(posy <= -85){
			write_uart(stop); routine=4; sleep(1);return 0;
		}	
}
	
int catch_motion(void){
	
	write_uart(box_catch);
	sleep(1);
	write_uart(box_catch);
	sleep(5);
	write_uart(back_move);
	sleep(1);
	write_uart(back_move);
	routine=5; return 0;

}
int drop_motion(void){
	
	write_uart(drop);
	sleep(1);
	write_uart(drop);
	routine=9;	return 0;

}

int detect(void)
{
	write_uart(turn_right); return 0;
}

int position(int *rect_point){
	int posx,posy;
	posx = object_pos_x(rect_point);
	posy = object_pos_y(rect_point);
	printf(" x = %d \n", posx);
	printf(" y = %d \n", posy);

	if(posx>-60 && posx < 60 && posy < -75)
	{
		printf("catch");
	}

	return 0;

}




