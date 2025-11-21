	component embedded_system is
		port (
			clk_clk              : in  std_logic                     := 'X'; -- clk
			hex_0_3_bus_readdata : out std_logic_vector(41 downto 0);        -- readdata
			reset_reset_n        : in  std_logic                     := 'X'  -- reset_n
		);
	end component embedded_system;

	u0 : component embedded_system
		port map (
			clk_clk              => CONNECTED_TO_clk_clk,              --         clk.clk
			hex_0_3_bus_readdata => CONNECTED_TO_hex_0_3_bus_readdata, -- hex_0_3_bus.readdata
			reset_reset_n        => CONNECTED_TO_reset_reset_n         --       reset.reset_n
		);

