`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ad2442_driver(
		input	clk,   // 100m
		input	rst_n, 
		output	cs_n,
		output	sclk,
		output	sdi,
		input	sdo, 
		
		output [23:0] adc_data,
		output 		  adc_data_vld
    );
	
	
	/*--------------------   parameters   ----------------*/ 
	localparam 	[14:0] 	ADC_FREQ_DIV = 200;
	localparam	[5:0]	CS_FLIP = 5;
	localparam	[5:0]	SCLK_MX = 32;
	
	/*--------------------   state machine   ----------------*/ 

	localparam			SPI_IDLE = 2'b00;
	localparam			SPI_TX = 2'b10;
	localparam			SPI_END = 2'b11;
	reg			[2:0]	r_spi_state = 0;
	
	always @(posedge r_sclk_test or negedge rst_n) begin
		if(!rst_n) begin
			r_spi_state <= 0;
		end else begin
			case(r_spi_state)
				
				SPI_IDLE: begin
					if(EOC == 1)
						r_spi_state <= SPI_TX;
					else
						r_spi_state <= r_spi_state;
				end
				
				SPI_TX : begin
					if(r_sclk_cnt == SCLK_MX - 1)
						r_spi_state <= SPI_END;
					else 
						r_spi_state <= r_spi_state;
				end
				
				SPI_END : begin
					r_spi_state <= SPI_IDLE;
				end
				
				default : begin
					r_spi_state <= SPI_IDLE;
				end
			endcase
		end
	end
	

	/*--------------------   1. cs_n related signals   ----------------*/ 
	// the purpose is to generate a cn_n which will flip every 5 clocks
	reg [5:0] 	r_cs_flip_cnt = 0;
	reg			r_cs_test;	
	always @(posedge r_sclk_test or negedge rst_n) begin
		if(!rst_n) begin
			r_cs_flip_cnt <= 0;
		end else begin
			if(r_cs_flip_cnt == CS_FLIP - 1) 
				r_cs_flip_cnt <= 0;
			else 
				r_cs_flip_cnt <= r_cs_flip_cnt + 1;
		end
	end
	
	always @(posedge r_sclk_test or negedge rst_n) begin
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
	reg	r_sclk = 0;
	reg	r_spi_en = 0;
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
	always @(posedge r_sclk_test or negedge rst_n) begin
		if(!rst_n) begin
			r_sclk_cnt <= 0;
		end else if(r_spi_state == SPI_TX) begin
			if(r_sclk_cnt == SCLK_MX - 1 ) begin
				r_sclk_cnt <= 0;
			end else begin
				r_sclk_cnt <= r_sclk_cnt + 1;
			end
		end else begin
			r_sclk_cnt <= 0;
		end
	end
	
	always @(posedge r_sclk_test or negedge rst_n) begin
		if(!rst_n) begin
			r_spi_en <= 0;
		end else begin
			if(r_spi_state == SPI_TX) 
				r_spi_en <= 1;
			else
				r_spi_en <= 0;
		end
	end
	
	
	/*--------------------   3. sdo related signals   ----------------*/ 
	// detecting falling edge of sdo, which means the end of a conversion, and the start of sclk
	/*
	reg r_sdo_1d = 1;
	reg	r_sdo_2d = 1;
	wire w_sdo_negedge;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			r_sdo_1d <= 1;
			r_sdo_2d <= 1;
		end else begin
			r_sdo_1d <= sdo;
			r_sdo_2d <= r_sdo_1d;
		end
	end
	
	assign w_sdo_negedge = r_sdo_1d ^ r_sdo_2d;
	*/
	wire EOC;
	assign EOC = ~(r_cs_test | sdo);
	
	// when meeting rising edge of sclk, begin serial to parallel transformation

	reg [23:0]	r_adc_data = 0;
	reg			r_adc_adta_vld;
	always @(posedge r_sclk_test or negedge rst_n) begin
		if(!rst_n) begin
			r_sdi <= 0;
		end else if (r_spi_state == SPI_TX)begin
			if(r_sclk_cnt >= 4 && r_sclk_cnt < 28)
				r_adc_data <= {r_adc_data[22:0], sdo};
			if(r_sclk_cnt == 4)
				r_adc_adta_vld <= 1;
			else
				r_adc_adta_vld <= 0;
		end
	end
	
	
	/*--------------------   4. sdi related signals   ----------------*/ 
	// write data to sdi to configure the adc chip
	reg 			r_sdi = 0;
	reg	[12:0]		sdi_config = 13'b101_00000_00010;
	always @(posedge r_sclk_test or negedge rst_n) begin
		if(!rst_n) begin
			r_sdi <= 0;
		end else if(r_spi_state == SPI_TX) begin
			if(r_sclk_cnt < 13) begin
				r_sdi <= sdi_config[0];
				sdi_config <= {0, sdi_config[12:1]};
			end
		end
	end

	
	
	/*--------------------   OUTPUTS   ----------------*/ 
	assign sdi = r_sdi;
	assign cs_n = r_cs_test & (~r_spi_en);
	assign sclk = r_sclk_test & r_spi_en;
	assign adc_data = r_adc_data;
	assign adc_data_vld = r_adc_adta_vld;
	
endmodule
