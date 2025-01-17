`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/13 21:21:13
// Design Name: 


module uart_driver
#(
	parameter P_BAUDRATE = 9600,
	parameter P_SYS_CLK = 100,
	parameter P_DATA_WIDTH = 8,
	parameter P_STOP_WIDTH = 1
)
(
	input 	sys_clk = P_SYS_CLK,
	input	rst,
	
	input	i_uart_rx,  //uart is full-duplex communication, following is the rx part
	output	[P_DATA_WIDTH-1:0]	o_user_rx_data	,
	output						o_user_rx_valid	,
													
	input	[P_DATA_WIDTH-1:0]	i_user_tx_data	, // tx part
	input						i_user_tx_valid	,
	output						o_uart_tx		,
	output						o_uart_tx_ready
);


uart_tx 
#(
	.P_BAUDRATE		(	P_BAUDRATE			),
	.P_SYS_CLK		(	P_SYS_CLK			),
	.P_DATA_WIDTH	(	P_DATA_WIDTH		),
	.P_STOP_WIDTH   (	P_STOP_WIDTH		)
)
u_tx(
	.sys_clk			(					),
	.rst                (					),
	.i_user_tx_data	    (					),
	.i_user_tx_valid	(					),
	.o_uart_tx			(					),
	.o_uart_tx_ready	(					)	
);

uart_rx 
#(
	.P_BAUDRATE		(	P_BAUDRATE			),
	.P_SYS_CLK		(	P_SYS_CLK			),
	.P_DATA_WIDTH	(	P_DATA_WIDTH		),
	.P_STOP_WIDTH   (	P_STOP_WIDTH		)
)
u_rx(
	.sys_clk		(					),
	.rst			(					),
										
	.i_uart_rx		(					),  
	.o_user_rx_data	(					),
	.o_user_rx_valid(					)	
);



endmodule
