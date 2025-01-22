`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/13 21:21:13
// Design Name: 
module uart_top(
	input	i_clk		,  // system clk
	input	i_uart_rx	,
	output	o_uart_tx
);

/***********************   	parameter      	******************************/
wire	w_locked	;
wire	w_clk_50m	;
/***********************	wire reg 		******************************/



/***********************	state machine   ******************************/
/************************	always			******************************/
/************************   assign			******************************/
/************************	component		******************************/
uart_driver
#(
	.P_BAUDRATE 		(9600)	,
	.P_SYS_CLK 			(50),
	.P_DATA_WIDTH 		(8),
	.P_STOP_WIDTH 		(1)
)
uart_driver_u0
(
	.i_clk			(	i_clk		),
	.i_rst			(	~w_locked	),

	.i_uart_rx		(	i_uart_rx	),  		//uart is full-duplex communication, following is the rx part
	.o_user_rx_data	(		),
	.o_user_rx_valid(		),

	.i_user_tx_data	(		), 	// tx part
	.i_user_tx_valid(		),
	.o_uart_tx		(	o_uart_tx	),
	.o_user_tx_ready(		)
);

system_clk system_clk_u0
 (
  .clk_out1		(	w_clk_50m		),
  .locked		(	w_locked		),
  .clk_in1      	(	i_clk			)
 );

endmodule