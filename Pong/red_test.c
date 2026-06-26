#include <stdint.h>

int main(void){
	volatile uint32_t *fb = (volatile uint32_t *)0x00005000; // Pointer to the start of frame buffer
	
	for(int i = 0; i<19200; i++){
		fb[i] = 0x55555555;
	}
	
	while(1);
}

