#include <stdint.h>
#define WPR 40   // 640px / 16px-per-word -> 40 Words/Row

int main(void){
    volatile uint32_t *topEdge    = (volatile uint32_t *)0x9B28;  
    volatile uint32_t *bottomEdge = (volatile uint32_t *)0x13128; 
    volatile uint32_t *leftEdge   = (volatile uint32_t *)0x9B28;  
    volatile uint32_t *rightEdge  = (volatile uint32_t *)0x9B78;  

    for(int i = 0; i <= 240; i++){       
        leftEdge[i * WPR]  = 0x00000003; 
        rightEdge[i * WPR] = 0x00000003;
    }

    for(int i = 0; i < 20; i++){
        topEdge[i]    = 0xFFFFFFFF;
        bottomEdge[i] = 0xFFFFFFFF;
    }

    while(1);
}

/*
Frame buffer is automatically initialized to black in hardware
For a 640x480 screen, if we want game to take up half the screen
The y distance from top to center is 240px. Border at  y=120, y=360
The x distance from edge to center is 320px. Border at x=160, x=480
Top edge: (160,120) to (480, 120)
        = 40x120 + 1/16(160) to 40x120 + 1/16(480)
        = Addr 4810 to Addr 4830 (w/o fb offset) in words
        = Addr 19240 to Addr 19320 (w/o fb offset) in bytes
        = 0x9B28 to 0x9B78 (w/fb offset), offset = 0x5000
Does this make sense?
If a row is 640 px, and there is 2b/px, we have
2b/px * 640 px = 1280 bits = 160 bytes
If the edge is half of this, it should be 80 bytes. This checks
Note that the memory is byte addressible (Address N and N+1 are 1 byte apart)
but it is word accessible (load/store only writes/reads in 32 bit data chunks)
*/
