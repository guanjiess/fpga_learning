`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 

module iic_driver(
	/******* user interface **********/
	input				i_clk,
	input				i_rst,
	input	[2:0]		i_slave_address,
	input	[15:0]		i_operation_addr,
	input	[7:0]		i_operation_len,
	input	[1:0]		i_operation_type,
	input				i_operation_valid,
	output				o_operation_ready,   // handshaking of tx and rx sides.
	input	[7:0]		i_write_data,
	output				o_write_req,
	output	[7:0]		o_read_data,
	output				o_read_valid,
	/******* iic interface ***********/
	inout				o_iic_sda,
	output				o_iic_scl
    );

/***********************   	parameter      	******************************/

parameter				IIC_IDLE 		= 3'd1;
parameter				IIC_START 		= 3'd2;
parameter				IIC_DEV_ADDR 	= 3'd3;
parameter				IIC_OP_ADDR1 	= 3'd4;
parameter				IIC_OP_ADDR2 	= 3'd5;
parameter				IIC_WRITE_DATA 	= 3'd6;
parameter				IIC_READ_DATA 	= 3'd7;
parameter				IIC_STOP 		= 3'd8;

/***********************	wire reg 		******************************/	
reg		[2:0]			ri_slave_address	;
reg		[12:0]			ri_operation_addr	;
reg		[12:0]			ri_operation_len	;
reg		[1:0]			ri_operation_type	;
reg		[7:0]			ri_write_data		;
wire					wo_operation_ready	;
wire					w_operation_active	;
reg						ro_iic_sda 			;
reg						ro_iic_scl 			;
reg						r_iic_st			;


/***********************	state machine	******************************/	
reg		[2:0]			r_current_state	;
reg		[2:0]			r_next_state	;

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		r_current_state	<=	0;
	else 
		r_current_state	<=	r_next_state;
end


always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) begin
		r_next_state	<=	IIC_IDLE;
	end else if (w_operation_active) begin
		case(r_next_state)
			IIC_IDLE: begin
			end
			IIC_START: begin	
				
			end
			IIC_DEV_ADDR: begin
			end
			IIC_OP_ADDR1: begin
			end
			IIC_OP_ADDR2: begin
			end
			IIC_WRITE_DATA: begin
			end
			IIC_READ_DATA: begin
			end
			IIC_STOP: begin
			end
			default begin
				r_next_state	<=	IIC_STOP;
			end
		endcase
	end else begin
		r_next_state	<=	r_next_state;
	end
end

/************************	always			******************************/
/** template for always block
always @(posedge i_clk, posedge i_rst) begin
	if (i_rst) 
	else if ()
	else if ()
	else 
end
**/
// 1. when active, save the input information to registers
always @(posedge i_clk, posedge i_rst) begin
	if (i_rst) begin
		ri_slave_address	<=	0;
		ri_operation_addr	<=	0;
		ri_operation_len	<=	0;
		ri_operation_type	<=	0;
		ri_write_data		<=	0;
	end else if (w_operation_active) begin	
		ri_slave_address	<=	i_slave_address	;
	     ri_operation_addr	<=	i_operation_addr	;
	     ri_operation_len	<=	i_operation_len	     ;
	     ri_operation_type	<=	i_operation_type	;
	     ri_write_data		<=	i_write_data		;
	end else begin
		ri_slave_address	<=	ri_slave_address	;
		ri_operation_addr	<=	ri_operation_addr	;
		ri_operation_len	<=	ri_operation_len	;
		ri_operation_type	<=	ri_operation_type	;
		ri_write_data		<=	ri_write_data		;
	end 
end

/************************   assign			******************************/
assign		w_operation_active	= i_operation_valid && o_operation_ready;
assign		o_iic_sda = ro_iic_sda		;
assign		o_iic_scl = ro_iic_scl		;


endmodule
