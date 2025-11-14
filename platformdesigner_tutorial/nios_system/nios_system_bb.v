
module nios_system (
	clk_clk,
	hex_0_2_export,
	hex_3_5_export,
	leds_export,
	reset_reset_n,
	switches_export);	

	input		clk_clk;
	output	[20:0]	hex_0_2_export;
	output	[20:0]	hex_3_5_export;
	output	[9:0]	leds_export;
	input		reset_reset_n;
	input	[9:0]	switches_export;
endmodule
