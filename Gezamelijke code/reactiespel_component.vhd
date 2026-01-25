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
		conduit_LED 				: out std_logic_vector(9 downto 0)
	);
end reg32_reaction_game;

architecture rtl of reg32_reaction_game is
	-- Register signals
	signal reg_game_ctrl		:	std_logic_vector(31 downto 0) := (others => '0');
	signal reg_game_speed	:	std_logic_vector(31 downto 0) := (others => '0');
	signal reg_game_status	: 	std_logic_vector(31 downto 0) := (others => '0');
	
	
	-- Game signals
	signal tick_counter		:	unsigned(31 downto 0) 				:= (others => '0');
	signal current_pos		:	integer range 0 to 9 				:= 0;
	signal direction			:	std_logic								:= '0';
	
begin

	-- Write
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
	
	-- Read
	-- Status register has only the position of the LED
   reg_game_status(9 downto 0) <= std_logic_vector(to_unsigned(current_pos, 10));
	 
	-- Select correct data to read depending on address
	process(address, reg_game_ctrl, reg_game_speed, reg_game_status)
   begin
		case address is
			when "00" 	=> readdata <= reg_game_ctrl;
			when "01" 	=> readdata <= reg_game_speed;
			when "10" 	=> readdata <= reg_game_status;
			when others => readdata <= (others => '0');
        end case;
    end process;
	 
	-- Drive led on current_pos
	process(current_pos)
	begin
		conduit_LED <= (others => '0');
		conduit_LED(current_pos) <= '1';
	end process;
	
	-- Game logic (only led moving)
	
	process(clock, resetn)
	begin
		if resetn = '0' then
			tick_counter <= (others => '0');
         current_pos  <= 0;
         direction    <= '0';
		elsif rising_edge(clock) then
			if reg_game_ctrl(0) = '1' then
				if tick_counter >= unsigned(reg_game_speed) then
					tick_counter <= (others => '0');
					-- Back and forth (ping-pong)
               if reg_game_ctrl(1) = '0' then  
						-- If going left
						if direction = '0' then
							if current_pos >= 9 then
								direction <= '1';
                        current_pos <= 8;
                     else
                        current_pos <= current_pos + 1;
                     end if;
						-- If going right
                  else
							if current_pos <= 0 then
								direction <= '0';
                        current_pos <= 1;
                     else
                        current_pos <= current_pos - 1;
                     end if;
                  end if;
					else                            
						-- Circular 
						if current_pos >= 9 then
							current_pos <= 0;
                  else
                     current_pos <= current_pos + 1;
						end if;
               end if;
            else
                tick_counter <= tick_counter + 1;
				end if;
			end if;
		end if;
	end process;
	
end architecture rtl;