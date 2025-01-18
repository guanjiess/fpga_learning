`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Create Date: 2025/01/18 13:48:28

module led_top_tb();


reg 	r_clk;
reg		r_rst;
wire	w_led;
initial begin
	r_clk = 0;
	r_rst = 1;
	# 100
	r_rst = 0;
end

always #10 r_clk = ~r_clk;

led_top led_top_u0(
	.i_clk		(	r_clk	),
	//.i_rst		(	r_rst	),
	.o_led		(	w_led	)
);
endmodule
