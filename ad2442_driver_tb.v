`timescale 1ns / 1ps

module ad2442_driver_tb();

	// clock
	parameter T = 5;
	always # T r_clk = ~ r_clk;
	
	
	// incentitive signal
	reg		r_clk = 0;	
	reg		r_rst_n;	
	reg		r_cs_n;	
	reg		r_sclk;	
	wire	w_sdi;	
	reg		r_sdo;	
	
	initial begin
		
		r_rst_n = 1;
		# 100
		r_rst_n = 0;
		
	end


	
	// instantiate
	ad2442_driver ad2442 (
		.clk	(r_clk),  // 100m
		.rst_n	(r_rst_n), 
		.cs_n	(r_cs_n),
		.sclk	(r_sclk),
		.sdi	(w_sdi),
		.sdo	(r_sdo)
		
    );

endmodule