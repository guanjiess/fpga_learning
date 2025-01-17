`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 

module led_pipline_38(
    input clk,
    input rst_n,
    output [7:0] led
    );
    
    reg [12:0] cnt;
    reg [7:0] LED;
    reg [2:0] sel;

    always @(posedge clk or negedge rst_n) 
        if(!rst_n)
            cnt <= 0;
        else if (cnt == 13'd249) 
            cnt <= 0;
        else
            cnt <= cnt + 1;
     
    always @(posedge clk or negedge rst_n) 
        if(!rst_n)
            sel <= 0;
        else if (cnt == 13'd249) begin
            if(sel == 3'b111)
                sel <= 0; 
            else
                sel <= sel + 1;
        end
     
    decoder_38 dec38(
        .clk(clk),
        .sel(sel),
        .out(led)
);
    
endmodule
