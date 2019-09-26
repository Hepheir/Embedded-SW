
#define IMAGE_HEIGHT     				240		
#define IMAGE_WIDTH     				320		
#define REFERENCE_DISTANCE   			70.0
#define REFERENCE_DISTANCE_PIXEL    115.0
#define FILTER		         			9

#define CENTER_POINT_X		160		
#define CENTER_POINT_Y		120		

#define CLOSE					255		
#define DILATION				0

#define FIND_PIXEL_NUMBER	200		

#define Y_MIN	0
#define X_MIN	1
#define Y_MAX	2
#define X_MAX	3

#define	RIGHT		2
#define	LEFT		3

#define BLUE	1                    
#define YELLOW 2                                 
#define RED	4 
                  

char safe;
int many_label;

int capb_cb_init, capb_cr_init;      


void find_color_blue(unsigned char *Y_buf_label, unsigned char *Cb_buf, unsigned char *Cr_buf)
{
	int i,j;
	for(i=0; i<IMAGE_HEIGHT; i++)
	{
		for(j=0; j<IMAGE_WIDTH; j++)
		{          
			
			if(	(capb_cb_blue - COLOR_RANGE<(Cb_buf[(i*IMAGE_WIDTH + j)/2]))
 			&& 	(capb_cb_blue + COLOR_RANGE>(Cb_buf[(i*IMAGE_WIDTH + j)/2]))
			&& 	(capb_cr_blue - COLOR_RANGE<(Cr_buf[(i*IMAGE_WIDTH + j)/2]))
			&& 	(capb_cr_blue + COLOR_RANGE>(Cr_buf[(i*IMAGE_WIDTH + j)/2]))	)
			{
				Y_buf_label[i*IMAGE_WIDTH + j] = 255;
			}
			else
			{
				Y_buf_label[i*IMAGE_WIDTH + j] = 0;
			}
		}
	}
}

void find_color_yellow(unsigned char *Y_buf_label, unsigned char *Cb_buf, unsigned char *Cr_buf)
{
	int i,j;
	for(i=0; i<IMAGE_HEIGHT; i++)
	{
		for(j=0; j<IMAGE_WIDTH; j++)
		{          
			
			if((capb_cb_yellow - COLOR_RANGE<(Cb_buf[(i*IMAGE_WIDTH + j)/2]))
 			&& (capb_cb_yellow + COLOR_RANGE>(Cb_buf[(i*IMAGE_WIDTH + j)/2]))
			&& (capb_cr_yellow - COLOR_RANGE<(Cr_buf[(i*IMAGE_WIDTH + j)/2]))
			&& (capb_cr_yellow + COLOR_RANGE>(Cr_buf[(i*IMAGE_WIDTH + j)/2])))
			{
				Y_buf_label[i*IMAGE_WIDTH + j] = 255;
			}
			else
			{
				Y_buf_label[i*IMAGE_WIDTH + j] = 0;
			}
		}
	}
}








void find_color_red(unsigned char *Y_buf_label, unsigned char *Cb_buf, unsigned char *Cr_buf)
{
	int i,j;
	for(i=0; i<IMAGE_HEIGHT; i++)
	{
		for(j=0; j<IMAGE_WIDTH; j++)
		{          
			
			if((capb_cb_red - 10<(Cb_buf[(i*IMAGE_WIDTH + j)/2]))
 			&& (capb_cb_red + 10>(Cb_buf[(i*IMAGE_WIDTH + j)/2]))
			&& (capb_cr_red - 10<(Cr_buf[(i*IMAGE_WIDTH + j)/2]))
			&& (capb_cr_red + 10>(Cr_buf[(i*IMAGE_WIDTH + j)/2])))
			{
				Y_buf_label[i*IMAGE_WIDTH + j] = 255;
			}
			else
			{
				Y_buf_label[i*IMAGE_WIDTH + j] = 0;
			}
		}
	}
}


int find_color(unsigned char *Y_buf_label, unsigned char *Cb_buf, unsigned char *Cr_buf, int *rect_point,int color){

	int label=0, dect=0;

		if(color == BLUE)		find_color_blue(Y_buf_label, Cb_buf, Cr_buf);
		if(color == YELLOW )	find_color_yellow(Y_buf_label, Cb_buf, Cr_buf);
		if(color == RED)		find_color_red(Y_buf_label, Cb_buf, Cr_buf);

		close_dilation(Y_buf_label, DILATION);
		close_dilation(Y_buf_label, CLOSE);
		
		label = grass_labeling(Y_buf_label);

		dect = find_max(Y_buf_label, label, rect_point);
	
	return dect;
}

int find_color_int(unsigned char *Y_buf_label, unsigned char *Cb_buf, unsigned char *Cr_buf, int *rect_point){

	int label=0, dect=0;

		find_color_binary(Y_buf_label, Cb_buf, Cr_buf);

		close_dilation(Y_buf_label, DILATION);
		close_dilation(Y_buf_label, CLOSE);
		
		label = grass_labeling(Y_buf_label);

		dect = find_max(Y_buf_label, label, rect_point);
	
	return dect;
}
void find_color_binary(unsigned char *Y_buf_label, unsigned char *Cb_buf, unsigned char *Cr_buf)
{
	int i,j;
	for(i=0; i<IMAGE_HEIGHT; i++)
	{
		for(j=0; j<IMAGE_WIDTH; j++)
		{          
			
			if(	(capb_cb_init - COLOR_RANGE<(Cb_buf[(i*IMAGE_WIDTH + j)/2]))
 			&& 	(capb_cb_init + COLOR_RANGE>(Cb_buf[(i*IMAGE_WIDTH + j)/2]))
			&& 	(capb_cr_init - COLOR_RANGE<(Cr_buf[(i*IMAGE_WIDTH + j)/2]))
			&& 	(capb_cr_init + COLOR_RANGE>(Cr_buf[(i*IMAGE_WIDTH + j)/2]))	)
			{
				Y_buf_label[i*IMAGE_WIDTH + j] = 255;
			}
			else
			{
				Y_buf_label[i*IMAGE_WIDTH + j] = 0;
			}
		}
	}
}



void close_dilation(unsigned char *Y_buf_label, int clo_dil)
{
	unsigned char *result_buf;
	unsigned char mask = clo_dil;

	int i, k, n, m;
	int count = 0;
	
	result_buf = (unsigned char *)malloc(IMAGE_HEIGHT * IMAGE_WIDTH);

	for(i = 1; i < IMAGE_HEIGHT-1; i++)
		for(k = 1; k < IMAGE_WIDTH-1; k++)
		{		
			for(n = -1; n <= 1; n++)
				for(m = -1; m <= 1; m++)
				{	
					if(Y_buf_label[(i + n)*IMAGE_WIDTH + (k+m)] == mask)		count++;
				}
			if(CLOSE == clo_dil)
			{
				if(count == FILTER)	result_buf[i*IMAGE_WIDTH + k] = 255;
				else  					result_buf[i*IMAGE_WIDTH + k] = 0;
			}
			else if(DILATION == clo_dil)
			{
				if(count == FILTER)	result_buf[i*IMAGE_WIDTH + k] = 0;
				else  					result_buf[i*IMAGE_WIDTH + k] = 255;
			}
			count = 0;
	}
	memcpy(Y_buf_label, result_buf, IMAGE_HEIGHT*IMAGE_WIDTH);
	free(result_buf);
}



void init(int *cb, int *cr, unsigned char *Cb_buf, unsigned char *Cr_buf){

	int i, j;
	int cb_buf=0, cr_buf=0;

	for(i = 120 - 30; i < 120 + 30; i++)
		for(j = 160 - 30; j < 160 + 30; j++){
			cb_buf += Cb_buf[(i*IMAGE_WIDTH + j)/2];
			cr_buf += Cr_buf[(i*IMAGE_WIDTH + j)/2];
		}
	*cb = cb_buf/3600;
	*cr = cr_buf/3600;
}


void grass(unsigned char * color_info, int i, int j, int CurColor, unsigned char * Y_buf_label)
{
	int k, I; 		
	for(k = i - 1 ; k <= i + 1; k++)
	{
		for(I = j - 1 ; I <= j + 1; I++)
		{	
			
			if(k < 0 || k >= IMAGE_HEIGHT || I < 0 || I >= IMAGE_WIDTH)	continue;
			else
			{
				index = k * IMAGE_WIDTH + I;
				
				if((Y_buf_label[k * IMAGE_WIDTH + I] == 255) && (color_info[index] == 0))
				{
					color_info[index] = CurColor;										grass(color_info,k,I,CurColor,Y_buf_label);		//Ï£ºÎ? ?îÏÜå?§ÏùÑ ?§Ïãú ?¨Í? ?®ÏàòÎ•??¥Ïö©?¥ÏÑú Í≤Ä??				}
			}
		}
	}
}

{
	unsigned char* color_info;		
	
	color_info = (unsigned char *)malloc(IMAGE_HEIGHT*IMAGE_WIDTH);
	int i, j; 

	int CurColor = 0;			
	
	for(i = 0; i < IMAGE_HEIGHT * IMAGE_WIDTH ; i++)
	{
		color_info[i] = 0;
	}


	for(i = 0 ; i < IMAGE_HEIGHT; i++)
	{
		for(j = 0 ; j < IMAGE_WIDTH; j++)
		{
			
			if((Y_buf_label[i * IMAGE_WIDTH + j] == 255) && (color_info[i * IMAGE_WIDTH + j] == 0))
			{
				CurColor++;
				grass(color_info,i,j,CurColor,Y_buf_label);
			}
		}
	}
	
	memcpy(Y_buf_label, color_info, IMAGE_HEIGHT * IMAGE_WIDTH);

	free(color_info);		
	return CurColor;
}


int find_max(unsigned char *Y_buf_label, int CurColor, int* rect_point)
{
	int i, j, k; 
	int temp=0;
	int result=0;
	int cnt=0;
	int dect_result=0;
	int temp_max_i =0, temp_max_j=0, temp_min_i=IMAGE_HEIGHT - 1, temp_min_j=IMAGE_WIDTH - 1;

	
	for( k=1; k<=CurColor; k++ )
	{
		for(i = 0; i < IMAGE_HEIGHT; i++)
		{
			for(j = 0; j < IMAGE_WIDTH; j++)
			{
				if(Y_buf_label[i*IMAGE_WIDTH+j] == k)
				{
					cnt=cnt+1;
					if( temp_min_i > i )		temp_min_i = i;
					if( temp_min_j > j )		temp_min_j = j;
					if( temp_max_i < i )		temp_max_i = i;
					if( temp_max_j < j )		temp_max_j = j;
				}
			}
		}
		if(temp<cnt)
		{
			temp=cnt;
			result = k;
			many_label = k;

			if(temp > FIND_PIXEL_NUMBER)								// test
			{
				dect_result = 1;
				rect_point[0] = temp_min_i;
				rect_point[1] = temp_min_j;
				rect_point[2] = temp_max_i;
				rect_point[3] = temp_max_j;
			}
			else
				dect_result = 0;
	
		}
		temp_max_i =0; temp_max_j=0; temp_min_i=IMAGE_HEIGHT - 1; temp_min_j=IMAGE_WIDTH - 1;
		cnt=0;
	}
	return dect_result;
}


void draw_rect(unsigned char *Y_buf,unsigned char *Cb_buf,unsigned char *Cr_buf, int* rect_point){

	int i, j;

	for(i = rect_point[0] ; i < rect_point[2]; i++)
	{
		for(j = rect_point[1] ; j < rect_point[3]; j++)
		{
			if(i < rect_point[0] + 3 || i > rect_point[2] - 3 || j < rect_point[1] + 3 || j > rect_point[3] -3)
			{
				Y_buf[i*IMAGE_WIDTH + j] = 0;
				Cr_buf[(i*IMAGE_WIDTH + j)/2] = 0;
				Cb_buf[(i*IMAGE_WIDTH + j)/2] = 0;		
			}		
		}
	}
}



int object_pos_x(int* rect_point)
{
	return ((rect_point[1] + rect_point[3])/2  - CENTER_POINT_X);
}


int object_pos_y(int* rect_point)
{
	return ((rect_point[0] + rect_point[2])/2  - CENTER_POINT_Y);
}



void edge_point2(unsigned char *Y_buf_label, unsigned char *Y_buf, unsigned char *Cb_buf, unsigned char *Cr_buf, int *rect_point){
	
	int i,k, diff;

	for(i = rect_point[0] - 10; i < rect_point[2] + 10; i++)
		for(k = rect_point[1] - 10; k < rect_point[3] + 10; k++){
			
			if((0<=i) && (i<=IMAGE_HEIGHT) && (0<=k) && (k<=IMAGE_WIDTH)){

				diff = Y_buf_label[i * IMAGE_WIDTH + k] - Y_buf_label[i * IMAGE_WIDTH + k + 1];
				if((abs(diff) == many_label)){
					Y_buf[i * IMAGE_WIDTH + k + 1] = 0;
					Cb_buf[(i * IMAGE_WIDTH + k + 1)/2] = 0;
					Cr_buf[(i * IMAGE_WIDTH + k + 1)/2] = 0;
				}

				diff = Y_buf_label[i * IMAGE_WIDTH + k] - Y_buf_label[(i +1) * IMAGE_WIDTH + k];
				if((abs(diff) == many_label)){
					Y_buf[(i + 1) * IMAGE_WIDTH + k] = 0;
					Cb_buf[((i + 1) * IMAGE_WIDTH + k)/2] = 0;
					Cr_buf[((i + 1) * IMAGE_WIDTH + k)/2] = 0;
				}
			}
		}
}

int delay(){
	
	int i;

	for(i=0;i<150000000;i++)
	{

	}

	return 0;

}
