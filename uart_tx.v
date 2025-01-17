`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/17 21:21:34
// Design Name: 
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx
#(
	parameter P_BAUDRATE = 9600,
	parameter P_SYS_CLK = 100,
	parameter P_DATA_WIDTH = 8,
	parameter P_STOP_WIDTH = 1
)
(
	input 						i_clk,
	input						i_rst,

	input	[P_DATA_WIDTH-1:0]	i_user_tx_data	, // tx part
	input						i_user_tx_valid	,
	output						o_uart_tx		,
	output						o_uart_tx_ready
);



endmodule
