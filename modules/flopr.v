`timescale 1ns / 1ps
// D flip-flop with reset. Used as pipeline register during 
// Memory and Writeback stage!
module flopr #(parameter W = 8)(
	input clk,reset,
	input [W-1:0]d,
	output reg [W-1:0]q
);

always @(posedge clk, posedge reset)
	if(reset) q <= 0;
	else q<= d;

endmodule
