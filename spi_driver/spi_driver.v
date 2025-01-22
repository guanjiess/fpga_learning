`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 

module #(
	parameter	P_DATA_WIDTH		=	8,
	parameter	P_USER_READ_WIDTH	=	8,
	parameter	P_CPOL				=	0, 	// polarity
	parameter	P_CPHA				=	0	// phase
)spi_driver(
	input									i_clk				,
	input									i_rst				,
	output									spi_clk				,
	output									spi_cs				,
	output									spi_mosi			,
	input									spi_miso			,

	input	[P_DATA_WIDTH - 1 : 0]			i_user_data			,
	input									i_user_valid		,
	output									o_user_ready		,
	output	[P_USER_READ_WIDTH - 1 : 0]		o_user_read_data	,
	output									o_user_read_valid
    );
	
/***********************   	parameter      	******************************/

/***********************	wire reg 		******************************/				
// registers for io
reg								ro_spi_clk			;	
reg								ro_spi_cs			;			
reg								ro_spi_mosi			;				
reg	[P_USER_READ_WIDTH - 1 : 0]	ri_user_data		;
reg								ro_user_ready		;	
reg								ro_user_read_data	;
reg								ro_user_read_valid	;

// registers for control logic
wire							w_spi_tx_active		;
reg								r_run				;
reg 							r_run_1d			;
reg								r_spi_cnt			; // 0-rising edge, 1 falling edge				
reg		[5:0]					r_cnt				;

/************************	always			******************************/
always @(posedge i_clk, posedge i_rst) begin
	if(!i_rst)
		ro_spi_cs	<=	1;
	else if (w_spi_tx_active)	// handshake successfully
		ro_spi_cs	<=	0;
	else if (~r_run_1d && r_run)					// r_run's falling edge detected	
		ro_spi_cs	<=	1;
	else	
		ro_spi_cs	<=	ro_spi_cs;
end


always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		ro_spi_clk	<=	0;
	else if (r_spi_cnt == 0)
		ro_spi_clk	<=	1;
	else if (r_spi_cnt)
		ro_spi_clk	<=	0;
	else
		ro_spi_clk	<= 	0;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		ro_spi_mosi	<=	0;
	else if (w_spi_tx_active)
		ro_spi_mosi	<=	i_user_data[P_DATA_WIDTH - 1];	
	else if (r_spi_cnt && r_run)
		ro_spi_mosi	<=	ri_user_data[P_DATA_WIDTH - 2];	
	else
		ro_spi_mosi	<=	0;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		ri_user_data	<=	0;
	else if (w_spi_tx_active)
		ri_user_data	<=	i_user_data;
	else if (r_spi_cnt)  
		ri_user_data	<=	ri_user_data << 1;
	else
		ri_user_data	<=	ri_user_data;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		r_run		<=	0;
	else if (w_spi_tx_active)
		r_run	<=	1;
	else if (r_cnt == 7 && r_spi_cnt)
		r_run	<=	0;
	else
		r_run	<=	r_run
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		r_run_1d	<= 0;	
	else 
		r_run_1d	<= r_run;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		ro_user_ready	<= 1;
	else if (w_spi_tx_active)
		ro_user_ready	<= 0;	// transmitting data
	else if (~r_run_1d && r_run)
		ro_user_ready	<= 1;
	else
		ro_user_ready	<=	ro_user_ready;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		ro_user_read_valid	<=	0;
	else if (r_cnt == P_DATA_WIDTH - 1 && r_spi_cnt)
		ro_user_read_valid	<=	1;
	else
		ro_user_read_valid	<=	0;
	else 
end

always @(posedge ro_spi_clk, posedge i_rst) begin
	if(i_rst) 
		ro_user_read_data	<=	0;
	else if (ro)
		ro_user_read_data	<=	{ro_user_read_data[P_DATA_WIDTH - 2 : 0],spi_miso}
	else 
		ro_user_read_data	<=	ro_user_read_data;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		r_spi_cnt	<=	0;
	else if (!ro_spi_cs)
		r_spi_cnt	<=	r_spi_cnt + 1;
	else
		r_spi_cnt	<=	0;
end

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		r_cnt	<=	0;
	else if (r_spi_cnt)
		r_cnt	<=	r_cnt + 1;
	else if (r_cnt == P_DATA_WIDTH - 1)
		r_cnt	<=	0;
	else
		r_cnt	<=	r_cnt;
end



/************************   assign			******************************/
assign 	w_spi_tx_active		=	o_user_ready && i_user_valid;

assign	o_spi_clk			=	ro_spi_clk			;
assign	o_spi_cs			=    ro_spi_cs			;
assign	o_spi_mosi			=    ro_spi_mosi			;
assign	o_user_ready		=    ro_user_ready		;
assign	o_user_read_data    	=    ro_user_read_data   ;
assign	o_user_read_valid   	=    ro_user_read_valid  ;


endmodule
