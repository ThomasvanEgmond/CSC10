-- altera vhdl_input_version vhdl_2008
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg32_avalon_interface is
	port (
		clock, resetn : in std_logic;
		read, write, chipselect : in std_logic;
		address : in std_logic_vector(1 downto 0);
		readdata : out std_logic_vector(31 downto 0);
		writedata : in std_logic_vector(31 downto 0);
		byteenable: in std_logic_vector(3 downto 0);
		Q_export : out std_logic_vector(41 downto 0)
	);
end reg32_avalon_interface;

architecture rtl of reg32_avalon_interface is
	type registers is array (0 to 1) of std_logic_vector(31 downto 0);
	signal regs: registers;
	
	function hex_to_seven_seg(hex_nibble : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable segment_pattern : std_logic_vector(6 downto 0);
    begin
        case hex_nibble is
            when "0000" => segment_pattern := "1000000"; -- 0
            when "0001" => segment_pattern := "1111001"; -- 1
            when "0010" => segment_pattern := "0100100"; -- 2
            when "0011" => segment_pattern := "0110000"; -- 3
            when "0100" => segment_pattern := "0011001"; -- 4
            when "0101" => segment_pattern := "0010010"; -- 5
            when "0110" => segment_pattern := "0000010"; -- 6
            when "0111" => segment_pattern := "1111000"; -- 7
            when "1000" => segment_pattern := "0000000"; -- 8
            when "1001" => segment_pattern := "0010000"; -- 9
            when "1010" => segment_pattern := "0001000"; -- A
            when "1011" => segment_pattern := "0000011"; -- b
            when "1100" => segment_pattern := "1000110"; -- C
            when "1101" => segment_pattern := "0100001"; -- d
            when "1110" => segment_pattern := "0000110"; -- E
            when "1111" => segment_pattern := "0001110"; -- F
            when others => segment_pattern := "1111111"; -- Alles uit
        end case;
        return segment_pattern;
    end function;
	
begin
	process(clock, resetn)
		variable reg_index : integer;
	begin
		if not resetn then
			for i in 0 to 0 loop
				regs(i) <= (others => '0');
			end loop;
		elsif rising_edge(clock) then
			reg_index := to_integer(unsigned(address));
			if chipselect then
				if read then
					readdata <= regs(reg_index);
				elsif write then
					if byteenable(0) then
						regs(reg_index)(7 downto 0) <= writedata(7 downto 0);
					end if;
					if byteenable(1) then
						regs(reg_index)(15 downto 8) <= writedata(15 downto 8);
					end if;
					if byteenable(2) then
						regs(reg_index)(23 downto 16) <= writedata(23 downto 16);
					end if;
					if byteenable(3) then
						regs(reg_index)(31 downto 24) <= writedata(31 downto 24);
					end if;
				end if;
			end if;
		end if;
	end process;
--	Q_export <= regs(0);
    Q_export(6 downto 0)   <= hex_to_seven_seg(regs(0)(3 downto 0));    
    Q_export(13 downto 7)  <= hex_to_seven_seg(regs(0)(7 downto 4));    
    Q_export(20 downto 14) <= hex_to_seven_seg(regs(0)(11 downto 8));    
    Q_export(27 downto 21) <= hex_to_seven_seg(regs(0)(15 downto 12));
	 
	Q_export(34 downto 28) <= hex_to_seven_seg(regs(1)(3 downto 0));
	Q_export(41 downto 35) <= hex_to_seven_seg(regs(1)(7 downto 4));
	
end architecture rtl;