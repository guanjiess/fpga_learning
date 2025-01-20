`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/17 21:21:34
// Design Name: 

module uart_tx
#(
	parameter P_1 = 9600,
	parameter P_2 = 9600,
	parameter P_3 = 9600,
	parameter P_4 = 9600
)
(
	input 						i_clk,
	input						i_rst,

	input	[P_DATA_WIDTH-1:0]	i_user_tx_data	, // tx part
	input						i_user_tx_valid	,
	output						o_uart_tx		,
	output						o_uart_tx_ready
);  

/***********************   	parameter      	******************************/

/***********************	wire reg 		******************************/

/***********************	state machine   ******************************/

/************************	always			******************************/

/************************   assign			******************************/

/************************	component		******************************/

endmodule
