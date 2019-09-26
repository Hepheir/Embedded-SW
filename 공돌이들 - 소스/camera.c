/*
 *(C) Copyright 2006 Marvell International Ltd.  
 * All Rights Reserved 
 *
 * Author:     Neo Li
 * Created:    March 07, 2007
 * Copyright:  Marvell Semiconductor Inc. 
 *
 * Sample code interface header for PXA Linux release. All interfaces
 * introduced in this file is not multiple thread safe unless it's 
 * specified explicitly. 
 *
 */


#include <stdio.h>
#include <signal.h>
#include <pxa_lib.h>
#include <pxa_camera_zl.h>
#include <camera_function.h>
#include <robot_uart.h>
#include <action.h>

// VIDEOBUF_COUNT must be larger than STILLBUF_COUNT
#define VIDEOBUF_COUNT  3
#define STILLBUF_COUNT  2

#define CAM_STATUS_INIT     0
#define CAM_STATUS_READY    1
#define CAM_STATUS_BUSY     2



struct pxa_camera{
    int handle;
    int status;
    int mode;
    int sensor;
    int ref_count;

    // Video Buffer
    int width;
    int height;
    enum    pxavid_format format;
};
int fd;
struct sigaction act;
void sighandler(int signo)
{
	close(fd);

	exit(0);
}
int main(int argc, char* argv[])
{
	int a=0;

	int handle;
	int handle_overlay2;
	struct pxa_video_buf* vidbuf;
	struct pxacam_setting camset;
	struct pxa_video_buf vidbuf_overlay;
	int len;

	int count =0;
	int cap_cb, cap_cr;
	int rect_point[4] = {0};	
	int rect_point1[4] = {90, 130, 150, 190};
	int dect=0;	

	unsigned char Y_buf[320*240], Y_buf_label[320*240], Cb_buf[(320*240)/2], Cr_buf[(320*240)/2];

   int thr_id;
	pthread_t p_thread;


	handle = camera_open(NULL,0);
	ASSERT(handle);

	system("echo b > /proc/invert/tb"); //LCD DriverIC top-bottom invert ctrl

	memset(&camset,0,sizeof(camset));
	camset.mode = CAM_MODE_VIDEO;
	camset.format = pxavid_ycbcr422;
	camset.width = 320;
	camset.height = 240;

	camera_config(handle,&camset);

	camera_start(handle);

    handle_overlay2 = overlay2_open(NULL,pxavid_ycbcr422,NULL, 320, 240, 0 , 0);

    overlay2_getbuf(handle_overlay2,&vidbuf_overlay);
    len = vidbuf_overlay.width*vidbuf_overlay.height;


	uart_fd = open_serial();

	thr_id = pthread_create(&p_thread, NULL, (void *)read_func, NULL);  
	if (thr_id < 0)  
	{    
		perror("thread create error : ");  
		exit(0);  
	}


	routine = 0;

	capb_cb_blue = 168;          
	capb_cb_yellow = 60;      
	capb_cb_red = 131;            

	while(1){
		vidbuf = camera_get_frame(handle);

		memcpy(Y_buf, vidbuf->ycbcr.y,len);		
		memcpy(Cb_buf, vidbuf->ycbcr.cb,len/2);
		memcpy(Cr_buf, vidbuf->ycbcr.cr,len/2);
		memcpy(Y_buf_label, vidbuf->ycbcr.y,len);

	

			switch(routine)
			{


				case 0: break;

				case 1:

						if(count == 0){
							capb_cb_init = 0; capb_cr_init = 0;
						}
							cap_cb = 0; cap_cr = 0;
							init(&cap_cb, &cap_cr, Cb_buf, Cr_buf);
							capb_cb_init += cap_cb;
							capb_cr_init += cap_cr;
							count++;

						if(count == 10){				
							capb_cb_init = capb_cb_init/10;
							capb_cr_init = capb_cr_init/10;

							routine = 0;
							count = 0;
						}
						draw_rect(Y_buf, Cb_buf, Cr_buf, rect_point1);		
					break;



				case 2:
						dect = find_color(Y_buf_label, Cb_buf, Cr_buf, rect_point);

						if(dect){

							//edge_point2(Y_buf_label, Y_buf, Cb_buf, Cr_buf, rect_point);
							draw_rect(Y_buf,Cb_buf,Cr_buf,rect_point);
						}
						break;

				case 3:
						dect = find_color(Y_buf_label, Cb_buf, Cr_buf, rect_point);

						if(dect){

							//edge_point2(Y_buf_label, Y_buf, Cb_buf, Cr_buf, rect_point);
							draw_rect(Y_buf,Cb_buf,Cr_buf,rect_point);

							if(safe ==1){							
								center_move(rect_point);

							}
						}
						break;

			
			}

		memcpy(vidbuf_overlay.ycbcr.y, Y_buf,len);
		memcpy(vidbuf_overlay.ycbcr.cb, Cb_buf,len/2);
		memcpy(vidbuf_overlay.ycbcr.cr, Cr_buf,len/2);

		camera_release_frame(handle,vidbuf);
	}
	
	camera_stop(handle);
	camera_close(handle);
	return 0;
}
