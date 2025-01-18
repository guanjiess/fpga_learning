`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
module led_drive #(
	parameter	P_LED_CNT = 1,
	parameter	P_I_CLK	 = 5,		// MHz
	parameter	P_LED_FLIP_CYCLE = 1000  //ms
)
(
	input						i_clk,
	input						i_rst,
	output	[P_LED_CNT - 1 : 0]	o_led
);
	
wire						w_div_clk;
reg		[P_LED_CNT - 1 : 0]	r_led;

always @(posedge w_div_clk, posedge i_rst) begin
	if(i_rst)
		r_led <= 0;
	else 
		r_led <= ~r_led;
end

CLK_DIV_module #(
	.P_DIV_CYCLE (P_I_CLK * P_LED_FLIP_CYCLE * 500)
)
CLK_DIV_module(
	.i_clk		(	i_clk			),
	.i_rst		(	i_rst			),
	.o_clk_div  	(	w_div_clk	 	)
);
assign o_led = r_led;
endmodule