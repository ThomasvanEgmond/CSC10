#include "nios2_ctrl_reg_macros.h"

/* the global variables are written by interrupt service routines; we have to
 * declare
 * these as volatile to avoid the compiler caching their values in registers */

/*******************************************************************************
 * This program demonstrates use of interrupts. It
 * first starts the interval timer with 50 msec timeouts, and then enables
 * Nios II interrupts from the interval timer and pushbutton KEYs
 *
 * The interrupt service routine for the interval timer displays a pattern on
 * the LED lights, and shifts this pattern either left or right. The shifting
 * direction is reversed when KEY[1] is pressed
********************************************************************************/

#define hex_0_2 (volatile int *) 0x0002030
#define hex_3_5 (volatile int *) 0x0002020
#define leds (short *) 0x0002010

#define TIMER_BASE 0x0002000
#define HEX_0_2 0x0002030
#define HEX_3_5 0x0002020
#define LED_BASE 0x0002050
#define SWITCHES_BASE 0x0002040

volatile int interrupt_count = 50000;

int hex_to_7_seg(int hex_digit) {
	if (hex_digit == 0x0) return 0x40;
	if (hex_digit == 0x1) return 0x79;
	if (hex_digit == 0x2) return 0x24;
	if (hex_digit == 0x3) return 0x30;
	if (hex_digit == 0x4) return 0x19;
	if (hex_digit == 0x5) return 0x12;
	if (hex_digit == 0x6) return 0x02;
	if (hex_digit == 0x7) return 0x78;
	if (hex_digit == 0x8) return 0x00;
	if (hex_digit == 0x9) return 0x10;
	if (hex_digit == 0xA) return 0x08;
	if (hex_digit == 0xB) return 0x03;
	if (hex_digit == 0xC) return 0x46;
	if (hex_digit == 0xD) return 0x21;
	if (hex_digit == 0xE) return 0x06;
	if (hex_digit == 0xF) return 0x0E;
    return 0x7F;
}

int main(void) {
    /* Declare volatile pointers to I/O registers (volatile means that IO load
     * and store instructions will be used to access these pointer locations,
     * instead of regular memory loads and stores)
     */

    volatile int * interval_timer_ptr =
        (int *)TIMER_BASE;                    // interal timer base address

    /* set the interval timer period for scrolling the LED lights */
    int counter                 = 50000; // 1/(50 MHz) x (2500000) = 50 msec
    *(interval_timer_ptr + 0x2) = (counter & 0xFFFF);
    *(interval_timer_ptr + 0x3) = (counter >> 16) & 0xFFFF;

    /* start interval timer, enable its interrupts */
    *(interval_timer_ptr + 1) = 0x7; // STOP = 0, START = 1, CONT = 1, ITO = 1

    /* set interrupt mask bits for levels 0 (interval timer) and level 1
     * (pushbuttons) */
    NIOS2_WRITE_IENABLE(0x1);

    NIOS2_WRITE_STATUS(1); // enable Nios II interrupts

    while (1){

        int current_count = interrupt_count;

        int d0 = (current_count >> 0)  & 0xF;
        int d1 = (current_count >> 4)  & 0xF; 
        int d2 = (current_count >> 8)  & 0xF;
        int d3 = (current_count >> 12) & 0xF;
        int d4 = (current_count >> 16) & 0xF;
        int d5 = (current_count >> 20) & 0xF;

        int seg0 = hex_to_7_seg(d0);
        int seg1 = hex_to_7_seg(d1);
        int seg2 = hex_to_7_seg(d2);
        int seg3 = hex_to_7_seg(d3);
        int seg4 = hex_to_7_seg(d4);
        int seg5 = hex_to_7_seg(d5);

        *hex_0_2 = (seg2 << 14) | (seg1 << 7) | seg0;
            
        *hex_3_5 = (seg5 << 14) | (seg4 << 7) | seg3;
    }; 
}
