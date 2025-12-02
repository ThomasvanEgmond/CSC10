#include <altera_up_avalon_audio.h>
#include <altera_avalon_pio_regs.h>
#include <sys/alt_stdio.h>
#include <stdlib.h>
#include <system.h>

#define N 8
// Q1.15 : 16 bits fixed point fraction length is 15 bits
const short int B[N + 1] = {0, -528, -2817, -6383, 24580, -6383, -2817, -528, 0};

// static short int buffer[N + 1] = {0};
// unsigned int r_buf = alt_up_audio_read_fifo_head(audio_dev, ALT_UP_AUDIO_RIGHT);
// buffer[0] = r_buf;
// int output = 0;
// for (size_t k = 0; k <= N; k++) output += buffer[k] * B[k];
// for (size_t i = N; i >= 1; i--) buffer[i] = buffer[i - 1];
// alt_up_audio_write_fifo_head(audio_dev, ((output >> 14) + 1) >> 1, ALT_UP_AUDIO_RIGHT);

int main(void)
{
    alt_up_audio_dev *audio_dev = alt_up_audio_open_dev("/dev/audio_0");
    if (audio_dev == NULL)
    {
        alt_printf("Error: could not open audio device\n");
        return -1;
    }
    else
        alt_printf("Opened audio device\n");

    while(1)
    {

        int fifospace_right = alt_up_audio_read_fifo_avail(audio_dev, ALT_UP_AUDIO_RIGHT);
        if (fifospace_right > 0)
        {

            static short int buffer[N + 1] = {0};
            unsigned int r_buf = alt_up_audio_read_fifo_head(audio_dev, ALT_UP_AUDIO_RIGHT);
            buffer[0] = r_buf;
            int output = 0;
            for (size_t k = 0; k <= N; k++){
            	output += buffer[k] * B[k];
            }
            for (size_t i = N; i >= 1; i--){
            	buffer[i] = buffer[i - 1];
            }
            IOWR_ALTERA_AVALON_PIO_DATA(PIO_LEDS_BASE, abs((short)r_buf) >> 5); // light up the leds
            alt_up_audio_write_fifo_head(audio_dev, ((output >> 14) + 1) >> 1, ALT_UP_AUDIO_RIGHT);

            // unsigned int r_buf = alt_up_audio_read_fifo_head(audio_dev, ALT_UP_AUDIO_RIGHT);
            // IOWR_ALTERA_AVALON_PIO_DATA(PIO_LEDS_BASE, abs((short)r_buf) >> 5); // light up the leds
            // alt_up_audio_write_fifo_head(audio_dev, r_buf, ALT_UP_AUDIO_RIGHT);
        }

        int fifospace_left = alt_up_audio_read_fifo_avail(audio_dev, ALT_UP_AUDIO_LEFT);
        if (fifospace_left > 0)
        {
            unsigned int l_buf = alt_up_audio_read_fifo_head(audio_dev, ALT_UP_AUDIO_LEFT);
            alt_up_audio_write_fifo_head(audio_dev, l_buf, ALT_UP_AUDIO_LEFT);
        }
    }
    IOWR_ALTERA_AVALON_PIO_DATA(PIO_LEDS_BASE, 0); // switch off the leds
}
