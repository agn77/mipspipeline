`timescale 1ns / 1ps
//register module ported from Single-cycle mips. 
module regfile(
	input clk,
	input we3,
	input [4:0] ra1, ra2, wa3,
	input [31:0] wd3,
	output [31:0] rd1, rd2
);

reg [31:0] register [31:0];
// three ported register file
// read two ports combinationally
// write third port on rising edge of clock
// register 0 hardwired to 0
always @(negedge clk)
if (we3) register[wa3] <= wd3;
	assign rd1 = (ra1 != 0) ? register[ra1] : 0;
	assign rd2 = (ra2 != 0) ? register[ra2] : 0;

endmodule  