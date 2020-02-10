`timescale 1ns / 1ps
// equal comparator 
module eqcmp(
    input [31:0]a,b,
    output eq
);
    assign eq = (a==b?1:0);
endmodule 