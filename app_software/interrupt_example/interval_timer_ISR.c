extern volatile int interrupt_count;

#define TIMER_BASE 0x0002000


void interval_timer_ISR() {
    volatile int * interval_timer_ptr = (int *)TIMER_BASE;

    extern volatile int interrupt_count;

    interrupt_count++;
    
    *(interval_timer_ptr) = 0; // clear the interrupt
    return;
}

