
module reactiespel_system (
	buttons_export,
	clk_clk,
	conduit_leds,
	hex_readdata,
	reset_reset_n,
	switches_export);	

	input		buttons_export;
	input		clk_clk;
	output	[9:0]	conduit_leds;
	output	[41:0]	hex_readdata;
	input		reset_reset_n;
	input	[9:0]	switches_export;
endmodule
