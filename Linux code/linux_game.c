#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <signal.h>
#include <stdbool.h>
#include <pthread.h>

#define HW_REGS_BASE (0xff200000)
#define HW_REGS_SPAN (0x00200000)
#define HWREG(x) (*(volatile uint32_t *)(x))

#define MOVING_LED_OFFSET 0x10
#define SEG7_OFFSET       0x20
#define SWITCHES_OFFSET   0x30

#define REG_CTRL   0  
#define REG_SPEED  4  
#define REG_STATUS 8  

volatile void *led_game_addr;
volatile void *switches_addr;
volatile void *seg7_addr;
volatile bool running = true;


void *config_thread(void *arg) {
    uint32_t sw_val;
    uint32_t speed_val;
    uint32_t ctrl_val;
    uint32_t prev_sw_val = 0xFFFFFFFF;

    printf("Config Thread gestart: SW0-7=Speed, SW8=Mode, SW9=On/Off\n");

    while (running) {
        sw_val = HWREG(switches_addr);

        if (sw_val != prev_sw_val) {
            printf("Switches gewijzigd: 0x%03X\n", sw_val);
            prev_sw_val = sw_val;
        }

        uint32_t sw_speed = sw_val & 0xFF;
        speed_val = 5000000 - (sw_speed * 15000); 
        
        HWREG(led_game_addr + REG_SPEED) = speed_val;
        
        ctrl_val = 0;
        
        if (sw_val & (1 << 9)) {
            ctrl_val |= 1;
        }

        if (sw_val & (1 << 8)) {
            ctrl_val |= (1 << 1);
        }

        HWREG(led_game_addr + REG_CTRL) = ctrl_val;

        usleep(100000); 
    }
    return NULL;
}

int main() {
    sigset_t signal_set;
    sigemptyset(&signal_set);
    sigaddset(&signal_set, SIGINT);
    sigaddset(&signal_set, SIGIO);
    sigprocmask(SIG_BLOCK, &signal_set, NULL);

    int mem_fd = open("/dev/mem", (O_RDWR | O_SYNC));
    if (mem_fd == -1) { perror("open /dev/mem"); return -1; }

    void *virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, mem_fd, HW_REGS_BASE);
    if (virtual_base == MAP_FAILED) { perror("mmap"); close(mem_fd); return -1; }

    led_game_addr = virtual_base + MOVING_LED_OFFSET;
    seg7_addr     = virtual_base + SEG7_OFFSET;
    switches_addr = virtual_base + SWITCHES_OFFSET;

    int dev_fd = open("/dev/reactie_button", O_RDONLY);
    if(dev_fd < 0) { perror("open driver"); return EXIT_FAILURE; }

    fcntl(dev_fd, F_SETOWN, getpid());
    int flags = fcntl(dev_fd, F_GETFL);
    fcntl(dev_fd, F_SETFL, flags | FASYNC);

    pthread_t tid;
    if (pthread_create(&tid, NULL, config_thread, NULL) != 0) {
        perror("pthread_create");
        return 1;
    }

    printf("Game Main Loop gestart. Wacht op interrupts...\n");
    uint32_t score = 0;
    int target_pos = 4;
	int target_pos2 = 5;

    HWREG(seg7_addr) = score;

    while (running) {
        int sig_number;
        
        sigwait(&signal_set, &sig_number);

        if (sig_number == SIGIO) {
            uint32_t current_pos = HWREG(led_game_addr + REG_STATUS);
            
            printf("Interrupt! Positie: %d ... ", current_pos);

            if (current_pos == target_pos | current_pos == target_pos2) {
                printf("RAAK!\n");
                score++;
            } else {
                printf("MIS!\n");
            }
            HWREG(seg7_addr) = score;
        }
        else if (sig_number == SIGINT) {
            printf("\nAfsluiten...\n");
            running = false;
        }
    }

    pthread_join(tid, NULL);
    HWREG(led_game_addr + REG_CTRL) = 0;
    close(dev_fd);
    munmap(virtual_base, HW_REGS_SPAN);
    close(mem_fd);

    return 0;
}