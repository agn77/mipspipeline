`timescale 1ns / 1ps
// D flip-flop with reset, clear, and enable.
// Used as our pipeline register during Decode stage.
module flopenrc #(parameter W = 8)(
	input clk,reset,en,clear,
	input [W-1:0]d,
	output reg [W-1:0]q
);

always @(posedge clk, posedge reset)
	if(reset) q <= 0;
	else if(clear) q <= 0;
	else if(en) q<= d;

endmodule 