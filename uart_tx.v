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
	parameter P_BAUDRATE 	= 9600	,
	parameter P_SYS_CLK 		= 100	,
	parameter P_DATA_WIDTH 	= 8		,
	parameter P_STOP_WIDTH 	= 1		,
	parameter P_CHECK		= 1
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
reg							ro_uart_tx			;
reg							ro_uart_tx_ready	; // 1 means user can use uart_tx module to transmitt data, 0 means uart_tx is occupied.
reg	[4:0]					r_cnt				;
reg	[P_DATA_WIDTH - 1 : 0]	ri_user_tx_data		;
reg							ro_check			;

/***********************	state machine   ******************************/

/************************	always			******************************/

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		ro_uart_tx_ready	<=	1;	// power on, default value is 1
	else if(w_tx_active)
		ro_uart_tx_ready	<=	0;	// start transmitting data
	else if(r_cnt == 1 + P_DATA_WIDTH + 1 + P_STOP_WIDTH)
		ro_uart_tx_ready	<= 	1;
	else
		ro_uart_tx_ready	<= 	ro_uart_tx_ready;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		r_cnt	<= 0;   //power on
	else if(r_cnt == 1 + P_DATA_WIDTH + 1 + P_STOP_WIDTH)
		r_cnt 	<= 0;
	else if(~ro_uart_tx_ready)
		r_cnt	<= r_cnt + 1;
	else
		r_cnt	<= r_cnt;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		ri_user_tx_data		<= 0;
	else if (w_tx_active)
		ri_user_tx_data		<= i_user_tx_data;
	else if (r_cnt >= 1 && r_cnt <=  P_DATA_WIDTH)
		ri_user_tx_data		<= ri_user_tx_data >> 1;
	else
		ri_user_tx_data		<=	ri_user_tx_data;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		ro_uart_tx	<=	1;
	else if (w_tx_active && r_cnt == 0)
		ro_uart_tx	<= 0;
	else if (r_cnt >= 1 && r_cnt <= P_DATA_WIDTH)
		ro_uart_tx	<= ri_user_tx_data[0];
	else if (r_cnt == P_DATA_WIDTH + 1)
		ro_uart_tx	<=	ro_check;
	else if (r_cnt > P_DATA_WIDTH + 1 && r_cnt <= P_DATA_WIDTH + 1 + P_STOP_WIDTH)
		ro_uart_tx	<=	1;
	else
		ro_uart_tx	<=	1;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		ro_check	<=	0;
	else if(r_cnt >= 2 && r_cnt <= P_DATA_WIDTH + 1)
		ro_check	<=	ro_check ^ ro_uart_tx;
	else
		ro_check	<=	ro_check;
end

/************************   assign			******************************/
assign		w_tx_active		=	ro_uart_tx_ready && i_user_tx_valid;
assign		o_uart_tx		=	ro_uart_tx;
assign		o_uart_tx_ready	=	ro_uart_tx_ready;	
/************************	component		******************************/


endmodule
