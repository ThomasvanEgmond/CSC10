	component reactiespel_system is
		port (
			buttons_export  : in  std_logic                     := 'X';             -- export
			clk_clk         : in  std_logic                     := 'X';             -- clk
			conduit_leds    : out std_logic_vector(9 downto 0);                     -- leds
			hex_readdata    : out std_logic_vector(41 downto 0);                    -- readdata
			reset_reset_n   : in  std_logic                     := 'X';             -- reset_n
			switches_export : in  std_logic_vector(9 downto 0)  := (others => 'X')  -- export
		);
	end component reactiespel_system;

	u0 : component reactiespel_system
		port map (
			buttons_export  => CONNECTED_TO_buttons_export,  --  buttons.export
			clk_clk         => CONNECTED_TO_clk_clk,         --      clk.clk
			conduit_leds    => CONNECTED_TO_conduit_leds,    --  conduit.leds
			hex_readdata    => CONNECTED_TO_hex_readdata,    --      hex.readdata
			reset_reset_n   => CONNECTED_TO_reset_reset_n,   --    reset.reset_n
			switches_export => CONNECTED_TO_switches_export  -- switches.export
		);

