`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 

module led_cycle2(
      input clk,
      input rst_n, 
      input [7:0] ctrl,
      output led
    );
    parameter Time = 2000;
    reg [12:0] cnt0;
    reg [2:0] cnt1;
    reg LED; 
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            cnt1 <= 0;
        else if(cnt0 == Time / 8 - 1)
            cnt1 <= cnt1 + 1;
        else
            cnt1 <= cnt1; 
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            cnt0 <= 0;
        else if(cnt0 == Time / 8 - 1)
            cnt0 <=0;
        else
            cnt0 <= cnt0 + 1; 
    end
    
     
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            LED <= 0;
        else begin
            case(cnt1)
                3'b000: LED <= ctrl[0];
                3'b001: LED <= ctrl[1];
                3'b010: LED <= ctrl[2];
                3'b011: LED <= ctrl[3];
                3'b100: LED <= ctrl[4];
                3'b101: LED <= ctrl[5];
                3'b110: LED <= ctrl[6];
                3'b111: LED <= ctrl[7];
                default: LED <= LED;
            endcase
        end    
    end
    
    assign led = LED;
    
endmodule
