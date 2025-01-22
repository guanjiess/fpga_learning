`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/17 21:21:13
// Design Name: 


module uart_rx
#(
	parameter 	P_BAUDRATE = 9600,
	parameter 	P_SYS_CLK = 100,
	parameter 	P_DATA_WIDTH = 8,
	parameter 	P_STOP_WIDTH = 1,
	parameter	P_CHECK		= 1
)
(
	input 						i_clk,
	input						i_rst,
	
	input						i_uart_rx,  //uart is full-duplex communication, following is the rx part
	output	[P_DATA_WIDTH-1:0]	o_user_rx_data	,
	output						o_user_rx_valid	
);

/***********************   	parameter      	******************************/

/***********************	wire reg 		******************************/
reg		[P_DATA_WIDTH-1:0]		ro_user_rx_data		;
reg								ro_user_rx_valid	;
reg		[4:0]					r_cnt				;
reg								ro_check			;
/***********************	state machine   ******************************/
/************************	always			******************************/

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		r_cnt	<=	0;
	else if(r_cnt == (1 + P_DATA_WIDTH + 1 + P_STOP_WIDTH) - 1) 
		r_cnt	<=	0;
	else if(!i_uart_rx || r_cnt > 0)
		r_cnt	<=	r_cnt + 1;
	else
		r_cnt	<= 	r_cnt;
end

always @(posedge i_clk, posedge	i_rst) begin
	if(i_rst) 
		ro_user_rx_data	<= 0;
	else if (r_cnt >= 1 && r_cnt <= P_DATA_WIDTH)
		ro_user_rx_data	<= {i_uart_rx, ro_user_rx_data[7:1]};
	else
		ro_user_rx_data	<= ro_user_rx_data;
end

always @(posedge i_clk, posedge	i_rst) begin
	if(i_rst) 
		ro_user_rx_valid	<= 0;
	//else if (r_cnt == P_DATA_WIDTH + 1 && P_CHECK == 1 && ~ro_check == i_uart_rx)
	//	ro_user_rx_valid	<= 1; 
	//else if (r_cnt == P_DATA_WIDTH + 1 && P_CHECK == 2 && ro_check == i_uart_rx)
	else if (r_cnt == P_DATA_WIDTH + 1)
		ro_user_rx_valid	<= 1;
	else
		ro_user_rx_valid	<= 0;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		ro_check	<= 0;
	else if(r_cnt >= 1 && r_cnt <= P_DATA_WIDTH) 
		ro_check	<= ro_check ^ i_uart_rx;
	else
		ro_check	<= 0;	
end

/************************   assign			******************************/
assign			o_user_rx_data	=	ro_user_rx_data;
assign			o_user_rx_valid	=	ro_user_rx_valid;

/************************	component		******************************/

endmodule
