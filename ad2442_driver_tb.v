`timescale 1ns / 1ps

module ad2442_driver_tb();

	// clock
	parameter T = 5;
	always # T r_clk = ~ r_clk;
	
	
	// incentitive signal
	reg		r_clk = 0;	
	reg		r_rst_n;	
	wire	w_cs_n;	
	wire	w_sclk;	
	wire	w_sdi;	
	reg		r_sdo;	
	
	initial begin
		
		r_rst_n = 1;
		r_sdo = 1;
		# 100
		r_rst_n = 0;
		# 100
		r_rst_n = 1;
		r_sdo = 0;
		# 10
		r_sdo = 1;
		# 20000
		r_sdo = 0;
		# 4000
		r_sdo = 1;
		
	end
	
	// instantiate
	ad2442_driver ad2442 (
		.clk	(r_clk),  // 100m
		.rst_n	(r_rst_n), 
		.cs_n	(w_cs_n),
		.sclk	(w_sclk),
		.sdi	(w_sdi),
		.sdo	(r_sdo)
		
    );

endmodule