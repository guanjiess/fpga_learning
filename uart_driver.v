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
	input 						i_clk,
	input						i_rst,
	
	input						i_uart_rx,  		//uart is full-duplex communication, following is the rx part
	output	[P_DATA_WIDTH-1:0]	o_user_rx_data	,
	output						o_user_rx_valid	,
													
	input	[P_DATA_WIDTH-1:0]	i_user_tx_data	, 	// tx part
	input						i_user_tx_valid	,
	output						o_uart_tx		,
	output						o_uart_tx_ready
);

wire				w_uart_baud_clk;
wire				w_uart_baud_clk_rst;


// frequency divider, output frequency should be the same as baudrate
CLK_DIV_module #(
	.P_CLK_DIV_CNT		(2) 
)
CLK_DIV_module_u0 
(
	.i_clk		(	i_clk),
	.i_rst      (	i_rst),
	.o_clk_div  (	w_uart_baud_clk)
);

// reset signal can be reused in the context if different clock domain, thus a rst generator is needed.
// clk and rst must be paired.
rst_gen_module #(  
	.P_RST_CYCLE(1)
)
rst_gen_module0(
	.i_clk 		(	i_clk				),
	.o_rst		(	w_uart_baud_clk_rst)
);



uart_tx #(
	.P_BAUDRATE		(	P_BAUDRATE			),
	.P_SYS_CLK		(	P_SYS_CLK			),
	.P_DATA_WIDTH	(	P_DATA_WIDTH		),
	.P_STOP_WIDTH   (	P_STOP_WIDTH		)
)
u_tx(
	.i_clk				(	w_uart_baud_clk		),
	.i_rst              (	w_uart_baud_clk_rst	),
	.i_user_tx_data	    (	i_user_tx_data		),
	.i_user_tx_valid	(	i_user_tx_valid		),
	.o_uart_tx			(	o_uart_tx			),
	.o_uart_tx_ready	(	o_uart_tx_ready		)	
);

uart_rx #(
	.P_BAUDRATE		(	P_BAUDRATE			),
	.P_SYS_CLK		(	P_SYS_CLK			),
	.P_DATA_WIDTH	(	P_DATA_WIDTH		),
	.P_STOP_WIDTH   (	P_STOP_WIDTH		)
)
u_rx(
	.i_clk			(	w_uart_baud_clk		),
	.i_rst			(	w_uart_baud_clk_rst	),

	.i_uart_rx		(	i_uart_rx			),  
	.o_user_rx_data	(	o_user_rx_data		),
	.o_user_rx_valid(	o_user_rx_valid		)	
);



endmodule
