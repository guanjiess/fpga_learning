`timescale 1ns / 1ps


module sim_uart_driver_tb#(
	parameter	P_BAUDRATE 	=	9600	,
	parameter	P_SYS_CLK 	=	50		,		
	parameter	P_DATA_WIDTH = 	8		,
	parameter	P_STOP_WIDTH  =	1
);

localparam CLOCK_PERIOD = 20;
/***********************	wire reg 		******************************/
reg									r_clk			;
reg									r_rst			;
reg									r_uart_rx		;

wire	[P_DATA_WIDTH - 1 : 0]		w_user_rx_data	;
wire								w_user_rx_valid	;
reg		[P_DATA_WIDTH - 1 : 0]		r_user_tx_data		;
reg									r_user_tx_valid	;
wire								w_uart_tx			;
wire								w_user_tx_ready	;

wire								w_user_active		;
wire								w_uart_clk			;
wire								w_uart_rst			;

uart_driver
#(
	.P_BAUDRATE 		(P_BAUDRATE)	,
	.P_SYS_CLK 			(P_SYS_CLK)		,
	.P_DATA_WIDTH 		(P_DATA_WIDTH)	,
	.P_STOP_WIDTH 		(P_STOP_WIDTH)
)
uart_driver_u0
(
	.i_clk			(	r_clk				),
	.i_rst			(	r_rst				),

	.i_uart_rx		(	w_uart_tx			),  		//uart is full-duplex communication, following is the rx part
	.o_user_rx_data	(	w_user_rx_data		),
	.o_user_rx_valid(	w_user_rx_valid		),

	.i_user_tx_data	(	r_user_tx_data		), 	// tx part
	.i_user_tx_valid(	r_user_tx_valid		),
	.o_uart_tx		(	w_uart_tx			),
	.o_user_tx_ready(	w_user_tx_ready		),
	.o_uart_clk		(	w_uart_clk			),
	.o_uart_rst		(	w_uart_rst			)
);

/***********************   	CLOCK      	******************************/
initial begin
	r_rst = 1;
	r_clk = 0;
	# 100
	@(posedge r_clk) r_rst = 0;
end
always # (CLOCK_PERIOD / 2) r_clk = ~ r_clk;

/************************	incentive signals		******************************/
always @(posedge w_uart_clk, posedge w_uart_rst) begin
	if(r_rst)
		r_user_tx_data		<=	0;
	else if (w_user_active)
		r_user_tx_data		<=	r_user_tx_data + 1;
	else
		r_user_tx_data		<=	r_user_tx_data;
end

always @(posedge w_uart_clk, posedge w_uart_rst) begin
	if(r_rst)
		r_user_tx_valid	<= 	0;
	else if (w_user_active)
		r_user_tx_valid	<= 0;
	else if (w_user_tx_ready)
		r_user_tx_valid	<= 1;
	else
		r_user_tx_valid	<=	r_user_tx_valid;
end

assign w_user_active = w_user_tx_ready && r_user_tx_valid;

endmodule
