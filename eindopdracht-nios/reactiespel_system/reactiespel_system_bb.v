
module reactiespel_system (
	buttons_export,
	clk_clk,
	conduit_leds,
	hex_readdata,
	reset_reset_n);	

	input	[2:0]	buttons_export;
	input		clk_clk;
	output	[9:0]	conduit_leds;
	output	[41:0]	hex_readdata;
	input		reset_reset_n;
endmodule
