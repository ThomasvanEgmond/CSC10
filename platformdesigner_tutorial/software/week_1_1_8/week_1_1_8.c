#include <system.h>                  // Voor alle BSP-definities (zoals base addresses en IRQs)
#include <altera_avalon_pio_regs.h>  // Voor de IORD/IOWR-macro's voor PIO (LEDs, 7-seg)
#include <altera_avalon_timer_regs.h> // Voor de timer-registerdefinities
#include <sys/alt_irq.h>             // Voor de interrupt registratie functie (alt_ic_isr_register) [cite: 1648]

volatile int interrupt_count = 0;

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

void interval_timer_isr(void* isr_context) {
    interrupt_count++;

    // Wis de interrupt-vlag (TO-bit) van de timer.
    // Dit is nodig zodat de timer een nieuwe interrupt kan genereren.
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
        0,                  // ic_id (0 voor de interne interrupt controller)
        TIMER_0_IRQ,        // irq (de IRQ-lijn van de timer, uit system.h)
        interval_timer_isr, // isr (pointer naar onze ISR-functie)
        NULL,               // isr_context (geen context nodig)
        NULL                // flags (geen vlaggen nodig)
    );

    while (1) {
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

        IOWR_ALTERA_AVALON_PIO_DATA(HEX_0_2_BASE, (seg2 << 14) | (seg1 << 7) | seg0);
        IOWR_ALTERA_AVALON_PIO_DATA(HEX_3_5_BASE, (seg5 << 14) | (seg4 << 7) | seg3);
    }

    return 0;
}
