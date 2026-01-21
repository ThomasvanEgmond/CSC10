
module reactiespel_system (
	clk_clk,
	conduit_writedata,
	conduit_readdata,
	hex_readdata,
	reset_reset_n);	

	input		clk_clk;
	output	[9:0]	conduit_writedata;
	input	[3:0]	conduit_readdata;
	output	[41:0]	hex_readdata;
	input		reset_reset_n;
endmodule
