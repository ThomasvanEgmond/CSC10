
module week4_system (
	clk_clk,
	reset_reset_n,
	switches_export,
	leds_export,
	audio_ADCDAT,
	audio_ADCLRCK,
	audio_BCLK,
	audio_DACDAT,
	audio_DACLRCK,
	audio_video_SDAT,
	audio_video_SCLK,
	external_audio_clk_clk);	

	input		clk_clk;
	input		reset_reset_n;
	input	[9:0]	switches_export;
	output	[9:0]	leds_export;
	input		audio_ADCDAT;
	input		audio_ADCLRCK;
	input		audio_BCLK;
	output		audio_DACDAT;
	input		audio_DACLRCK;
	inout		audio_video_SDAT;
	output		audio_video_SCLK;
	output		external_audio_clk_clk;
endmodule
