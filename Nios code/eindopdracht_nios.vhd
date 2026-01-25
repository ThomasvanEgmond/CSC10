library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eindopdracht_nios IS
	PORT (
		CLOCK_50	:	IN 	STD_LOGIC;
		KEY		:	IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		SW			:	IN		STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0		:	OUT 	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1		:	OUT 	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2		:	OUT 	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX3		:	OUT 	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4		:	OUT 	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX5		:	OUT 	STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR		:	OUT	STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END eindopdracht_nios;

ARCHITECTURE Structure OF eindopdracht_nios IS
	COMPONENT reactiespel_system is
		PORT (
			clk_clk        	: IN  STD_LOGIC                     := 'X';             -- clk
			reset_reset_n  	: IN  STD_LOGIC                     := 'X';             -- reset_n
			buttons_export		: IN  STD_LOGIC_VECTOR(3 DOWNTO 3)  := (others => 'X'); -- KEY(3)
			switches_export	: IN  STD_LOGIC_VECTOR(9 DOWNTO 0)	:= (others => 'X'); -- SW(9-0)
			hex_readdata   	: OUT STD_LOGIC_VECTOR(41 DOWNTO 0);                    -- readdata
			conduit_leds		: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)                      -- export
			
		);
	END COMPONENT reactiespel_system;

BEGIN
	u0 : COMPONENT reactiespel_system
		PORT MAP (
			clk_clk        					=> CLOCK_50,		  --     clk.clk
			reset_reset_n  					=> KEY(0),   		  --   	reset.reset_n
			buttons_export			   		=> KEY(3 DOWNTO 3), -- 		buttons.export
			switches_export					=> SW(9 DOWNTO 0),  -- 		switches.export
			hex_readdata(6 DOWNTO 0)   	=> HEX0,			     --     hex.readdata
			hex_readdata(13 DOWNTO 7)   	=> HEX1,			     --     hex.readdata
			hex_readdata(20 DOWNTO 14)   	=> HEX2,			     --     hex.readdata
			hex_readdata(27 DOWNTO 21)   	=> HEX3,			     --     hex.readdata
			hex_readdata(34 DOWNTO 28)   	=> HEX4,			     --     hex.readdata
			hex_readdata(41 DOWNTO 35)   	=> HEX5,			     --     hex.readdata
			conduit_leds			    		=> LEDR	    		  --    leds.export
			
		);
END Structure;