-- Implements a Nios II system for the DE-series board.
-- Inputs: SW9-0 are parallel port inputs to the Nios II system
-- CLOCK_50 is the system clock
-- KEY0 is the active-low system reset
-- Outputs: LEDR9-0 are parallel port outputs from the Nios II system
-- HEX0-5 are 7-segment display outputs

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY lights IS
    PORT (
        CLOCK_50 : IN STD_LOGIC;
        KEY : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
        SW : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        LEDR : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
        HEX0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX1 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX3 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        HEX5 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
END lights;

ARCHITECTURE lights_rtl OF lights IS
    COMPONENT nios_system
        PORT (
            SIGNAL clk_clk: IN STD_LOGIC;
            SIGNAL reset_reset_n : IN STD_LOGIC;
            SIGNAL switches_export : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
            SIGNAL leds_export : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
				SIGNAL hex_0_2_export : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
            SIGNAL hex_3_5_export : OUT STD_LOGIC_VECTOR (20 DOWNTO 0)
        );
    END COMPONENT;
BEGIN
    NiosII : nios_system
        PORT MAP(
            clk_clk => CLOCK_50,
            reset_reset_n => KEY(0),
            switches_export => SW(9 DOWNTO 0),
            leds_export => LEDR(9 DOWNTO 0),
            
            hex_0_2_export(6 DOWNTO 0) => HEX0,
            hex_0_2_export(13 DOWNTO 7) => HEX1,
            hex_0_2_export(20 DOWNTO 14) => HEX2,
            
            hex_3_5_export(6 DOWNTO 0) => HEX3,
            hex_3_5_export(13 DOWNTO 7) => HEX4,
            hex_3_5_export(20 DOWNTO 14) => HEX5
        );
END lights_rtl;