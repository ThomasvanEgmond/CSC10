LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY component_tutorial IS
	PORT (
		CLOCK_50 : IN STD_LOGIC;
		KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END component_tutorial;

ARCHITECTURE Structure OF component_tutorial IS
	COMPONENT embedded_system IS
		PORT (
			clk_clk : IN STD_LOGIC;
			reset_reset_n : IN STD_LOGIC;
			hex_0_3_bus_readdata : OUT STD_LOGIC_VECTOR (41 DOWNTO 0)
		);
	END COMPONENT embedded_system;
BEGIN
	U0 : embedded_system
	PORT MAP(
		clk_clk => CLOCK_50, 
		reset_reset_n => KEY(0), 
		hex_0_3_bus_readdata(6 downto 0) => HEX0,
		hex_0_3_bus_readdata(13 downto 7) => HEX1,
		hex_0_3_bus_readdata(20 downto 14) => HEX2,
		hex_0_3_bus_readdata(27 downto 21) => HEX3,
		hex_0_3_bus_readdata(34 downto 28) => HEX4,
		hex_0_3_bus_readdata(41 downto 35) => HEX5
		
	);
END Structure;