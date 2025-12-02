#include <altera_up_avalon_audio.h>
#include <altera_avalon_pio_regs.h>
#include <altera_up_avalon_audio_and_video_config.h>
#include <altera_up_avalon_audio_and_video_config_regs.h>
#include <altera_avalon_performance_counter.h>
#include <sys/alt_stdio.h>
#include <stdlib.h>
#include <system.h>

# define N 50
// Q1.15 : 16 bits fixed point fraction length is 15 bits
const short int B[N +1] = {
-24 , 0, 30 , 53 , 48 , 0, -79 , -143 , -127 ,
0, 195 , 338 , 290 , 0, -419 , -711 , -602 , 0,
877 , 1520 , 1344 , 0, -2377 , -5135 , -7341 , 24552 , -7341 ,
-5135 , -2377 , 0, 1344 , 1520 , 877 , 0, -602 , -711 ,
-419 , 0, 290 , 338 , 195 , 0, -127 , -143 , -79 ,
0, 48 , 53 , 30 , 0, -24
};

// static short int buffer[N + 1] = {0};
// unsigned int r_buf = alt_up_audio_read_fifo_head(audio_dev, ALT_UP_AUDIO_RIGHT);
// buffer[0] = r_buf;
// int output = 0;
// for (size_t k = 0; k <= N; k++) output += buffer[k] * B[k];
// for (size_t i = N; i >= 1; i--) buffer[i] = buffer[i - 1];
// alt_up_audio_write_fifo_head(audio_dev, ((output >> 14) + 1) >> 1, ALT_UP_AUDIO_RIGHT);

int main(void)
{
	alt_up_av_config_dev* av_config_dev = alt_up_av_config_open_dev(AUDIO_AND_VIDEO_CONFIG_0_NAME);
	alt_up_av_config_write_audio_cfg_register(av_config_dev, 0x08, 0b00001100);
	while (!alt_up_av_config_read_ready(av_config_dev)){
		continue;
	}
    alt_up_audio_dev *audio_dev = alt_up_audio_open_dev("/dev/audio_0");
    if (audio_dev == NULL)
    {
        alt_printf("Error: could not open audio device\n");
        return -1;
    }
    else
        alt_printf("Opened audio device\n");

    PERF_RESET(PERFORMANCE_COUNTER_0_BASE);
    PERF_START_MEASURING(PERFORMANCE_COUNTER_0_BASE);

    const int run_time_in_seconds = 30;
	const int run_time_in_samples = run_time_in_seconds * 8000;
	int sample_count = 0;
	do {
		PERF_BEGIN(PERFORMANCE_COUNTER_0_BASE, 1);
        int fifospace_right = alt_up_audio_read_fifo_avail(audio_dev, ALT_UP_AUDIO_RIGHT);
        if (fifospace_right > 0)
        {
        	sample_count++;
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
        PERF_END(PERFORMANCE_COUNTER_0_BASE, 1);
        PERF_BEGIN(PERFORMANCE_COUNTER_0_BASE, 2);
        int fifospace_left = alt_up_audio_read_fifo_avail(audio_dev, ALT_UP_AUDIO_LEFT);
        if (fifospace_left > 0)
        {
            unsigned int l_buf = alt_up_audio_read_fifo_head(audio_dev, ALT_UP_AUDIO_LEFT);
            alt_up_audio_write_fifo_head(audio_dev, l_buf, ALT_UP_AUDIO_LEFT);
        }
        PERF_END(PERFORMANCE_COUNTER_0_BASE, 2);
	} while (sample_count < run_time_in_samples);
    IOWR_ALTERA_AVALON_PIO_DATA(PIO_LEDS_BASE, 0); // switch off the leds

    PERF_STOP_MEASURING(PERFORMANCE_COUNTER_0_BASE);
	perf_print_formatted_report(
		(void *)PERFORMANCE_COUNTER_0_BASE, // Peripheral's HW base address
		alt_get_cpu_freq(), // defined in "system.h"
		2, // How many sections to print
		"RIGHT", // Display-names of sections
		"LEFT"
		);
}
