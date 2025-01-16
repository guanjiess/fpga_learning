`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 

module ip_top_tb();

reg 	r_i_clk;
reg		rst	;
wire	w_locked;

initial begin
	r_i_clk = 0;
	rst = 1;
	# 100
	rst = 0;
end

always #5 r_i_clk = ~r_i_clk;


ip_top top(
    .i_clk		(r_i_clk),
    .locked		(w_locked)
);


endmodule