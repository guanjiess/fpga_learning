`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
module CLK_DIV_module #(
	parameter	P_DIV_CYCLE = 1
)
(
	input		i_clk,
	input		i_rst,
	output		o_clk_div
);
	
reg	[15:0] 		 r_cnt;
reg				 r_clk_div = 0;
always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		r_cnt <= 'd0;
	else if(r_cnt == P_DIV_CYCLE >> 1 - 1)
		r_cnt <= 0;
	else
		r_cnt <= r_cnt +	1;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		r_clk_div <= 0;
	else if (r_cnt == P_DIV_CYCLE >> 1 - 1)
		r_clk_div = ~ r_clk_div;
	else
		r_clk_div <= r_clk_div;
end

assign o_clk_div = r_clk_div;
endmodule