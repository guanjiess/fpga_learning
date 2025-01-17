`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date: 2025/01/16 22:54:19
// Design Name: 

module ip_top(
    input i_clk		,
	input rst		,
    output locked
    );
    
	wire 		w_clk_100m	;
	wire 		w_clk_50m	;
	wire 		w_clk_25m	;
	wire		w_locked	;
	
	reg [10:0]	r_count1 = 0;
	reg [15:0]	r_count2 = 0;
	reg [10:0]	r_count3 = 0;
 
 always @(posedge w_clk_100m) begin
	if(rst) begin
		r_count1 <= 0;
	end else begin
		r_count1 <= r_count1 + 1;
	end
 end
 
 always @(posedge w_clk_50m) begin
	if(rst) begin
		r_count2 <= 0;
	end else begin
		r_count2 <= r_count2 + 1;
	end
 end
 
 
 always @(posedge w_clk_25m) begin
	if(rst) begin
		r_count3 <= 0;
	end else begin
		r_count3 <= r_count3 + 1;
	end
 end
 // write and read data
 reg 	[15:0]		r_data_in = 0;
 reg				r_wea = 0;
 reg	[11:0]		r_addra = 0;
 always @(posedge w_clk_50m) begin
	if(rst) begin
		r_data_in <= 0;
		r_wea <= 0;
		r_addra <= 0;
	end else if(r_count2 >= 20 && r_count2 <= 20 + 2047) begin
		r_addra <= r_addra + 1;
		r_data_in <= r_count2;
		r_wea <= 1;
	end else begin
		r_wea <= 0;
		r_data_in <= 0;
		r_addra <= 0;
	end
 end
 
 wire 	[15:0]		w_data_out;
 reg				r_enb = 0;
 reg	[11:0]		r_addrb = 0;
 always @(posedge w_clk_50m) begin
	if(rst) begin
		r_enb <= 0;
		r_addrb <= 0;
	end else if(r_count2 >= 20 + 2047 + 100 && r_count2 <= 20 + 2047 + 100 + 2047 + 1) begin
		r_addrb <= r_addrb + 1;
		r_enb <= 1;
	end else begin
		r_addrb <= 0;
		r_enb <= 0;
	end
 end
 
 clk_generate clk_generate1 
 (
  .clk_out1	(	w_clk_100m		),
  .clk_out2	(	w_clk_50m		),
  .clk_out3	(	w_clk_25m		),
  .reset	(	rst				),
  .locked	(	w_locked		),
  .clk_in1	(	i_clk			)
 );
 
 BRAM_16X2K ram1(
  .clka		(	w_clk_50m		),
  .ena		(		1			),
  .wea		(		r_wea		),
  .addra	(		r_addra		),
  .dina		(		r_data_in	),
  .clkb		(		w_clk_50m	),
  .enb		(		r_enb		),
  .addrb	(		r_addrb		),
  .doutb    (		w_data_out	)
);
 
 
    
endmodule
