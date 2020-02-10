`timescale 1ns / 1ps
// adder module imported form single-cycle mips

module adder(
	input [31:0]a,b,
	output [31:0]re
);

assign re = a + b;

endmodule 
