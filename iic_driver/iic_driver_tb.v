`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
module iic_driver_tb();


/************************   interface signals			******************************/
reg							i_clk					;
reg							i_rst					;
reg		[2:0]				i_slave_address		     ;
reg		[15:0]				i_operation_addr		;
reg		[7:0]				i_operation_len		     ;
reg		[1:0]				i_operation_type		;
reg							i_operation_valid		;
wire						o_operation_ready		;
reg		[7:0]				i_write_data			;
wire						o_write_req			     ;
wire	[7:0]				o_read_data			     ;
wire						o_read_valid			;
wire						io_iic_sda				;
wire						o_iic_scl				;				
/***********************	CLOCKS	RESET		******************************/
localparam	P_CLK_PERIOD = 10;

always begin
	i_clk = 0;
	# (P_CLK_PERIOD / 2);
	i_clk = 1;
	# (P_CLK_PERIOD / 2);
end
initial begin
	i_rst = 1;
	# 100
	@ (posedge i_clk) i_rst = 0;
end

/***********************	Initials		******************************/
initial begin
	i_slave_address		=	0;
	i_operation_addr	=	0;
	i_operation_len		=	0;
	i_operation_type	=	0;
	i_operation_valid	=	0;
	i_write_data		= 	8'h55;
	wait(!i_rst);  // locked until rst is 0
	repeat(10) @(posedge i_clk);
	send_data();
	//forever begin
	//end
end

/************************	component		******************************/
iic_driver	iic_driver_u0(
	/******* user interface **********/
	.i_clk					(	i_clk						),
	.i_rst					(	i_rst						),
	.i_slave_address		(	i_slave_address				),
	.i_operation_addr		(	i_operation_addr			),
	.i_operation_len		(	i_operation_len				),
	.i_operation_type		(	i_operation_type			),
	.i_operation_valid		(	i_operation_valid			),
	.o_operation_ready		(	o_operation_ready			),   // handshaking of tx and rx sides.
	.i_write_data			(	i_write_data				),
	.o_write_req			(	o_write_req					),
	.o_read_data			(	o_read_data					),
	.o_read_valid			(	o_read_valid				),
	/******* iic interface *****			******/
	.io_iic_sda				(	io_iic_sda					),
	.o_iic_scl				(	o_iic_scl					)
 );

AT24C64 AT24C64_u0
(
    .SDA                        (io_iic_sda         ), 
    .SCL                        (o_iic_scl          ), 
    .WP                         (0                  )
);

/************************	tasks		******************************/
// monitoring write data
task send_data();
begin
	i_slave_address			<=	3;
	i_operation_addr		<=	16'h0001;
	i_operation_len			<=	2;
	i_operation_type		<=	1;
	i_operation_valid		<=	1;
	i_write_data			<=	8'h55;
	@(posedge i_clk)
	wait(!o_operation_ready);
	i_slave_address			<=	0;
	i_operation_addr		<=	16'h0000;
	i_operation_len			<=	0;
	i_operation_type		<=	0;
	i_operation_valid		<=	0;
	i_write_data			<=	8'h00;
	@(posedge i_clk);
	wait(o_operation_ready);
end
endtask

// monitoring read data from EEPROM 
task rec_data();
begin
end
endtask

/**
always @(posedge i_clk, posedge i_rst) begin
	if(i_rst)
		i_write_data	<= 	'd0;
	else if (o_write_req)
		i_write_data	<=	8'haa;
	else 
		i_write_data	<=	i_write_data;
end
**/


endmodule
