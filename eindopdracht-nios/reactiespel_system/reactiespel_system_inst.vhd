	component reactiespel_system is
		port (
			clk_clk           : in  std_logic                     := 'X';             -- clk
			conduit_writedata : out std_logic_vector(9 downto 0);                     -- writedata
			conduit_readdata  : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- readdata
			hex_readdata      : out std_logic_vector(41 downto 0);                    -- readdata
			reset_reset_n     : in  std_logic                     := 'X'              -- reset_n
		);
	end component reactiespel_system;

	u0 : component reactiespel_system
		port map (
			clk_clk           => CONNECTED_TO_clk_clk,           --     clk.clk
			conduit_writedata => CONNECTED_TO_conduit_writedata, -- conduit.writedata
			conduit_readdata  => CONNECTED_TO_conduit_readdata,  --        .readdata
			hex_readdata      => CONNECTED_TO_hex_readdata,      --     hex.readdata
			reset_reset_n     => CONNECTED_TO_reset_reset_n      --   reset.reset_n
		);

