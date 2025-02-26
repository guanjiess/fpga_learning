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
	inout				io_iic_sda,
	output				o_iic_scl
    );

/***********************   	parameter      	******************************/

parameter				P_IIC_IDLE 			= 4'd1;
parameter				P_IIC_START 		= 4'd2;
parameter				P_IIC_SLAVE_ADDR 	= 4'd3;
parameter				P_IIC_OP_ADDR1 		= 4'd4;
parameter				P_IIC_OP_ADDR2 		= 4'd5;
parameter				P_IIC_WRITE_DATA 	= 4'd6;
parameter				P_IIC_RESTART 		= 4'd7;
parameter				P_IIC_READ_DATA 	= 4'd8;
parameter				P_IIC_STOP 			= 4'd9;

/***********************	wire reg 		******************************/	
// registers for caching user inputs
reg		[2:0]			ri_slave_address	;
reg		[12:0]			ri_operation_addr	;
reg		[12:0]			ri_operation_len	;
reg		[1:0]			ri_operation_type	;
reg		[7:0]			ri_write_data		;
// registers for caching user outputs.
reg						ro_operation_ready	;
reg						ro_write_req		;
reg 					ro_write_valid		;
reg		[7:0]			ro_read_data		;
reg						ro_read_valid		;
// registers and wires for generating IIC signals.
reg						ro_iic_scl 			;  // iic clock, saying scl
reg						r_iic_scl_st		;  // scl's reverse
reg						ro_iic_sda 			;  // sda output
wire					wo_iic_sda			;  // sda input
wire					o_iic_scl			;
reg						r_iic_sda_ctrl		;
// active signal for a valid operation.
wire					w_operation_active	;

// registers for state machine control signals
reg [3:0]				r_scl_cnt			;	
wire					w_state_turn		;

/************************   assign			******************************/
assign		w_operation_active	=	i_operation_valid && o_operation_ready	;
assign		o_operation_ready	=	ro_operation_ready						;
assign		o_read_valid		=	ro_read_valid							;
assign		o_write_req			= 	ro_write_req							;
assign		o_read_data			=	ro_read_data							;

// three-state gate
assign		io_iic_sda = r_iic_sda_ctrl ? ro_iic_sda	: 1'bz;  // io_iic_sda as output of master
assign		wo_iic_sda = !r_iic_sda_ctrl ? io_iic_sda : 1'b0; // io_iic_sda as input, reciving data from device
assign		o_iic_scl = ro_iic_scl;
assign		w_state_turn = (r_scl_cnt == 8) &&  (r_iic_scl_st == 1);

/***********************	state machine	******************************/	
reg		[2:0]			r_current_state	;
reg		[2:0]			r_next_state	;

always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		r_current_state	<=	P_IIC_IDLE;
	else 
		r_current_state	<=	r_next_state;
end


always @(*) begin
	case(r_current_state)
		P_IIC_IDLE: begin
			if(w_operation_active) 
				r_next_state	<=	P_IIC_START;
			else 
				r_next_state	<=	r_next_state;
		end 
		P_IIC_START: begin
			r_next_state	<=	P_IIC_SLAVE_ADDR;
		end
		P_IIC_SLAVE_ADDR: begin// r_next_state <=  w_state_turn ? P_IIC_OP_ADDR1 : r_next_state;
			if(w_state_turn) 
				r_next_state	<=	P_IIC_OP_ADDR1;
			else 
				r_next_state	<=	r_next_state;	
		end
		P_IIC_OP_ADDR1: begin
			if(w_state_turn)
				r_next_state	<=	P_IIC_OP_ADDR2;
			else 
				r_next_state 	<=	r_next_state;
		end
		P_IIC_OP_ADDR2: begin
			if(w_state_turn)
				r_next_state	<=	P_IIC_WRITE_DATA;
			else 
				r_next_state 	<=	r_next_state;
		end
		P_IIC_WRITE_DATA: begin
			if(w_state_turn)
				r_next_state	<=	P_IIC_STOP;
			else 
				r_next_state 	<=	r_next_state;
		end
		P_IIC_RESTART: begin
			r_next_state	<=	P_IIC_STOP;
		end
		P_IIC_READ_DATA: begin
		end
		
		
		P_IIC_STOP: begin
		end
		
		default begin
			r_next_state	<=	P_IIC_IDLE;
		end
	endcase
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

// ro_iic_scl
always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		ro_iic_scl	<=	1; // default to be high
	else if (r_next_state >= P_IIC_SLAVE_ADDR && r_next_state <= P_IIC_STOP)
		ro_iic_scl	<=	~ro_iic_scl;
	else 
		ro_iic_scl <= 1;
end

// r_iic_scl_st
always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		r_iic_scl_st	<=	0; // default to be high
	else if (r_next_state >= P_IIC_SLAVE_ADDR && r_next_state <= P_IIC_STOP)
		r_iic_scl_st	<=	~r_iic_scl_st;
	else 
		r_iic_scl_st <= 0;
end


//reg [3:0]				r_scl_cnt		;	
always @(posedge i_clk, posedge i_rst) begin
	if (i_rst) 
		r_scl_cnt	<=	0;
	else if (r_next_state != r_current_state || ro_write_valid || ro_read_valid)  // clearing when finished a task, saying changing a state
		r_scl_cnt	<=	0;
	else if (r_iic_scl_st == 1 )
		r_scl_cnt	<= r_scl_cnt + 1;
	else 
		r_scl_cnt	<=	r_scl_cnt;
end
/********************	SDA's control and write signal			********************/
// control iic_sda's data flow state according to state machine.
// sda control, set to 1 when sending data, 0 when releasing and reciving data.
always @(posedge i_clk, posedge i_rst) begin
	if (i_rst) 
		r_iic_sda_ctrl	<=	0;
	else if (r_scl_cnt == 8 || r_next_state == P_IIC_IDLE)
		r_iic_sda_ctrl	<=	0;
	else if (r_next_state >= P_IIC_SLAVE_ADDR && r_next_state <= P_IIC_STOP) // CTRL = 0 means slave take over sda's  control
		r_iic_sda_ctrl	<=	1;
	else 
		r_iic_sda_ctrl	<=	r_iic_sda_ctrl;
end

// move ri_write_data to ro_iic_sda bitwise
always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		ro_iic_sda	<=	1;
	else if (r_current_state == P_IIC_START)
		ro_iic_sda	<=	0;
	else if (r_current_state == P_IIC_SLAVE_ADDR)
		ro_iic_sda	<=	ri_slave_address[7 - r_scl_cnt];
	else if (r_current_state == P_IIC_OP_ADDR1)
		ro_iic_sda	<=	ri_operation_addr[15 - r_scl_cnt];
	else if (r_current_state == P_IIC_OP_ADDR1)
		ro_iic_sda	<=	ri_operation_addr[7 - r_scl_cnt];
	else if (r_current_state == P_IIC_WRITE_DATA)
		ro_iic_sda	<=	ri_write_data[7 - r_scl_cnt];
	else
		ro_iic_sda	<=	ro_iic_sda;
end

// write valid

// write request
always @(posedge i_clk, posedge i_rst) begin
	if (i_rst) 
		ro_write_req	<=	0;
	else if (r_current_state == P_IIC_WRITE_DATA && r_scl_cnt == 8 && r_iic_scl_st == 1)
		ro_write_req	<=	1;
	else
		ro_write_req	<=	0; 
end


// pull up when idle, pull down when reciving active, default to be high
always @(posedge i_clk, posedge i_rst) begin
	if(i_rst) 
		ro_operation_ready <= 1;
	else if (w_operation_active)
		ro_operation_ready	<=	0;
	else if (r_current_state == P_IIC_IDLE)
		ro_operation_ready	<=	1;
	else 
		ro_operation_ready	<=	ro_operation_ready;
end

endmodule