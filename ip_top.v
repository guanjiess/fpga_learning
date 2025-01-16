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
	reg [10:0]	r_count2 = 0;
	reg [10:0]	r_count3 = 0;
	
	
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
  .wea		(					),
  .addra	(					),
  .dina		(					),
  .clkb		(	w_clk_50m		),
  .enb		(					),
  .addrb	(					),
  .doutb    (					)
);
 
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
 
    
endmodule
