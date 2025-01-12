`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ad2442_driver(
		input	clk,   // 100m
		input	rst_n, 
		output	cs_n,
		output	sclk,
		output	sdi,
		input	sdo
    );
	
	
	/*--------------------   parameters   ----------------*/ 
	localparam 	[14:0] 	ADC_FREQ_DIV = 20000;
	localparam	[2:0]	CS_FLIP = 5;
	localparam	[5:0]	SCLK_MX = 32;

	/*--------------------   1. cs_n related signals   ----------------*/ 
	// the purpose is to generate a cn_n which will flip every 5 clocks
	reg [2:0] 	r_cs_flip_cnt = 0;
	reg			r_cs_test;	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			r_cs_flip_cnt <= 0;
		end else begin
			if(r_cs_flip_cnt == CS_FLIP - 1) 
				r_cs_flip_cnt <= 0;
			else 
				r_cs_flip_cnt <= r_cs_flip_cnt + 1;
		end
	end
	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			r_cs_test <= 1;
		end else begin
			if(r_cs_flip_cnt == CS_FLIP - 1)
				r_cs_test <= 0;
			else
				r_cs_test <= 1;
		end
	end
	
	/*--------------------   2. sclk related signals   ----------------*/ 
	reg r_sclk_test = 0;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			r_sclk_test <= 0;
		end else begin
			if(r_sclk_div_cnt == ADC_FREQ_DIV - 1) 
				r_sclk_test <= ~r_sclk_test;
			else
				r_sclk_test <= r_sclk_test;
		end 
	end
	
	reg [15:0] r_sclk_div_cnt = 0;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			r_sclk_div_cnt <= 0;
		end else if(r_sclk_div_cnt == ADC_FREQ_DIV - 1) begin
			r_sclk_div_cnt <= 0;
		end else begin
			r_sclk_div_cnt <= r_sclk_div_cnt +1;
		end 
	end
	
	reg [6:0] r_sclk_cnt = 0;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			r_sclk_cnt <= 0;
		end else begin
			if(r_sclk_cnt == SCLK_MX - 1 ) begin
				r_sclk_cnt <= 0;
			end else begin
				r_sclk_cnt <= r_sclk_cnt + 1;
			end
		end
	end
	
	/*--------------------   3. sdo related signals   ----------------*/ 
	// detecting falling edge of sdo, which means the end of a conversion, and the start of sclk
	reg r_sdo_1d = 0;
	reg	r_sdo_2d = 0;
	reg r_sdo_negedge = 0;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			r_sdo_1d <= 1;
			r_sdo_2d <= 1;
		end else begin
			r_sdo_1d <= sdo;
			r_sdo_2d <= r_sdo_1d;
		end
	end
	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			r_sdo_negedge <= 0;
		end else begin
			r_sdo_negedge = r_sdo_1d ^ r_sdo_2d;
		end
	end
	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			
		end else begin
			
		end
	end
	
	/*--------------------   4. sdi related signals   ----------------*/ 
	
	
	
	// incentive signals
	
	
	
endmodule
