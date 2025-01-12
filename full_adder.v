`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 

module full_adder(
    input a,
    input b,
    input c,
    output cout,
    output s
);
    wire g;
    wire p;
    wire cp;
    

    half_adder adder1(
        .a(a),
        .b(b),
        .s(p),
        .c(g)
    );
    
        half_adder adder2(
        .a(p),
        .b(c),
        .s(s),
        .c(cp)
    );
    
        half_adder adder3(
        .a(g),
        .b(cp),
        .s(cout),
        .c()
    );
endmodule
