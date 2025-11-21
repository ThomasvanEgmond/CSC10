#include <system.h>                  // Voor alle BSP-definities (zoals base addresses en IRQs)
//#include <altera_avalon_pio_regs.h>  // Voor de IORD/IOWR-macro's voor PIO (LEDs, 7-seg)
#include <altera_avalon_timer_regs.h> // Voor de timer-registerdefinities
#include <sys/alt_irq.h>             // Voor de interrupt registratie functie (alt_ic_isr_register) [cite: 1648]
#include <io.h>

volatile int interrupt_count = 0;


void interval_timer_isr(void* isr_context) {
    interrupt_count++;

    // clear de interrupt-vlag TO bit van de timer.
    IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0);
}

int main(void) {

	#define PERIODE_MS 1

	#define TICKS_PER_MS (TIMER_0_FREQ / 1000)

	//    (N - 1) omdat de timer N+1 stappen telt (van N tot 0).
	alt_u32 load_value = (PERIODE_MS * TICKS_PER_MS) - 1;

	IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_0_BASE, (load_value & 0xFFFF));
	IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_0_BASE, (load_value >> 16) & 0xFFFF);

    IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE,
        ALTERA_AVALON_TIMER_CONTROL_START_MSK |
        ALTERA_AVALON_TIMER_CONTROL_CONT_MSK  |
        ALTERA_AVALON_TIMER_CONTROL_ITO_MSK);

    alt_ic_isr_register(
        1,                  // ic_id (voor de interrupt controller)
        TIMER_0_IRQ,        // irq (de IRQ lijn van de timer)
        interval_timer_isr, // isr (pointer naar de ISR functie)
        NULL,               // isr_context
        NULL                // flags
    );

    while (1) {
        int current_count = interrupt_count;

        IOWR_32DIRECT(REG32_AVALON_INTERFACE_0_BASE, 0, current_count);

//        IOWR_ALTERA_AVALON_PIO_DATA(REG32_AVALON_INTERFACE_0_BASE, current_count);
    }
    return 0;
}
