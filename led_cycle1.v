`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 

module led_cycle1(
    input clk,
    input rst_n,
    output led    
    );
    
    parameter PERIOD = 2500;
    
    reg [17:0] cnt;
    reg LED;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 0;
        else if (cnt == PERIOD - 1)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            LED <= 1;
        else begin
            case(cnt)
                PERIOD / 10 - 1:  LED <= 0;
                (PERIOD / 5 + PERIOD / 10 - 1): LED <= 1;
                (3 * PERIOD / 5  - 1): LED <= 0;
                PERIOD - 1: LED <= 1;
                default: LED <= LED; 
            endcase
        end
    end
    
    assign led = LED;
    
endmodule
