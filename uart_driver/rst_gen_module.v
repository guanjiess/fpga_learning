`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/17 20:12:43
// Design Name: 

module rst_gen_module#(
		parameter P_RST_CYCLE	=	1
)
(
	input	i_clk,
	output	o_rst
);

reg	[7:0]	r_cnt = 0;
reg			r_rst = 1;
// generate rst signal to avoid the cross clock problem
// P_RST_CYCLE = 0 is a corner case.
always @(posedge i_clk) begin
	if(r_cnt == P_RST_CYCLE - 1 || P_RST_CYCLE == 0)
		r_cnt <= r_cnt;
	else
		r_cnt <= r_cnt + 1;
end

always @(posedge i_clk) begin
	if(r_cnt == P_RST_CYCLE - 1 || P_RST_CYCLE == 0)
		r_rst <= 'd0;
	else
		r_rst <= 'd1;
end

assign o_rst = r_rst;

endmodule 
