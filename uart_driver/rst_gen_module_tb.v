`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
module rst_gen_module_tb( );

reg     clk;
wire    w_rst;
initial begin
    clk = 0;
end

always # 5 clk = ~clk;

rst_gen_module# (
		.P_RST_CYCLE(2)
)
rst_gen_modle_u0
(
		.i_clk            (clk),
		.o_rst            (w_rst)
);

endmodule
