`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/17 21:21:13
// Design Name: 


module uart_rx
#(
	parameter P_BAUDRATE = 9600,
	parameter P_SYS_CLK = 100,
	parameter P_DATA_WIDTH = 8,
	parameter P_STOP_WIDTH = 1
)
(
	input 						i_clk,
	input						i_rst,
	
	input						i_uart_rx,  //uart is full-duplex communication, following is the rx part
	output	[P_DATA_WIDTH-1:0]	o_user_rx_data	,
	output						o_user_rx_valid	
);



endmodule
