-- altera vhdl_input_version vhdl_2008
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg32_reaction_game is
	port (
		clock, resetn 				: in std_logic;
		read, write, chipselect : in std_logic;
		address 						: in std_logic_vector(1 downto 0);
		readdata 					: out std_logic_vector(31 downto 0);
		writedata 					: in std_logic_vector(31 downto 0);
		conduit_LED 				: out std_logic_vector(9 downto 0);
		conduit_buttons			: in std_logic_vector(3 downto 0)
	);
end reg32_reaction_game;

architecture rtl of reg32_reaction_game is
	-- Register signals
	signal reg_game_ctrl		:	std_logic_vector(31 downto 0);
	signal reg_game_speed	:	std_logic_vector(31 downto 0);
	
	-- Game signals
	signal tick_counter		:	unsigned(31 downto 0) 				:= (others => '0');
	signal current_pos		:	integer range 0 to 9 				:= 0;
	signal hit_flag			:	std_logic								:= '0';
	signal miss_flag			:	std_logic								:=	'0';
	signal reg_game_status	: 	std_logic_vector(31 downto 0);
begin
	-- WRITE
	process(clock, resetn)
	begin
		if resetn = '0' then
			reg_game_ctrl 	<= (others => '0');
			reg_game_speed <= (others => '0');
		elsif rising_edge(clock) then
			if chipselect = '1' and write = '1' then
				case address is
					when "00" 	=> reg_game_ctrl 	<=	writedata;
					when "01" 	=> reg_game_speed	<= writedata;
					when others => null;
				end case;
			end if;
		end if;	
	end process;
	
	-- READ
	
	reg_game_status(31 downto 26) <= (others => '0');
   reg_game_status(25 downto 16) <= std_logic_vector(to_unsigned(current_pos, 10));
   reg_game_status(15 downto 2)  <= (others => '0');
   reg_game_status(1)            <= miss_flag;
   reg_game_status(0)            <= hit_flag;
	 
	 
	process(address, reg_game_ctrl, reg_game_speed, reg_game_status)
   begin
		case address is
			when "00" 	=> readdata <= reg_game_ctrl;
			when "01" 	=> readdata <= reg_game_speed;
			when "10" 	=> readdata <= reg_game_status;
			when others => readdata <= (others => '0');
        end case;
    end process;
	 
	-- DRIVE LED ON CURRENT POS
	process(current_pos)
	begin
		conduit_LED <= (others => '0');
		conduit_LED(current_pos) <= '1';
	end process;
	-- GAME LOGIC
	
	process(clock, resetn)
    begin
        if resetn = '0' then
            tick_counter <= (others => '0');
            current_pos  <= 0;
        elsif rising_edge(clock) then
            -- Only move if ENABLE (Bit 0 of CTRL) is high
            if reg_game_ctrl(0) = '1' then
                if tick_counter >= unsigned(reg_game_speed) then
                    tick_counter <= (others => '0');
                    -- Movement Logic
                    if current_pos = 9 then
                        current_pos <= 0;
                    else
                        current_pos <= current_pos + 1;
                    end if;
                else
                    tick_counter <= tick_counter + 1;
                end if;
            end if;
        end if;
    end process;
	
end architecture rtl;