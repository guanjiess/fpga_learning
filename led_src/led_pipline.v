`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ////////////////////////////////////////////////////////////////////


module led_pipline(
    input clk,
    input rst_n,
    output [7:0] led
    );
    
    reg [12:0] cnt;
    reg [7:0] LED;

    always @(posedge clk or negedge rst_n) 
        if(!rst_n)
            cnt <= 0;
        else if (cnt == 13'd2499) 
            cnt <= 0;
        else
            cnt <= cnt + 1;
     
     always @(posedge clk or negedge rst_n)
        if(!rst_n)
            LED <= 8'b0000_0001;
        else if (cnt == 13'd2499) begin
            // Á÷Ë®µÆÂß¼­
            if(LED == 8'b1000_0000) 
                LED <= 8'b0000_0001;
            else
                LED <= LED << 1;
        end else
            LED <= LED;
        
        assign led = LED;
    
endmodule
