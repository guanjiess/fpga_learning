`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/18 11:03:48

module led_top(
	input		i_clk,  //顶层使用板载晶振，不需要复位
	//input		i_rst,  
	output		o_led
    );
	
	wire 	w_clk_100m	;
	wire 	w_clk_5m	;
	wire	w_locked	;
	
	
 led_drive #(
	.P_LED_CNT			(1),
	.P_I_CLK			(5),		// MHz
	.P_LED_FLIP_CYCLE	(1000)		//ms
)led_drive_u0(
	.i_clk	(	w_clk_5m	),
	.i_rst	(	~w_locked	),
	.o_led	(	o_led		)
);

clk_generate clk_generate_u0
 (
  // Clock out ports
  .clk_out1		(	w_clk_100m		),
  .clk_out2		(	w_clk_5m		),
  .reset			(	0				),
  .locked		(	w_locked		),	// 所有时钟稳定后，自动拉高
  .clk_in1      	(	i_clk			)   //板载晶振
 );

endmodule
