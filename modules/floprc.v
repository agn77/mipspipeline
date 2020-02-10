`timescale 1ns / 1ps
// D flip-flop with reset and clear. Will act as one of our pipeline registers
// in the Execute stage!
module floprc #(parameter W = 8)(
	input clk,reset,clear,
	input [W-1:0]d,
	output reg [W-1:0]q
);

always @(posedge clk, posedge reset)
	if(reset) q <= 0;
	else if(clear) q <= 0;
	else q<= d;

endmodule 