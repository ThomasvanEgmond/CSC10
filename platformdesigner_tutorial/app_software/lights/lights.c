#define switches (volatile short *) 0x0002000
#define leds (short *) 0x0002010
void main()
{ while (1)
*leds = *switches;
}