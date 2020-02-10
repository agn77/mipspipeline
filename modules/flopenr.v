`timescale 1ns / 1ps
// D flip-flop with enable and reset! 
module flopenr #(parameter W = 8)(
	input clk,reset,en,
	input [W-1:0]d,
	output reg [W-1:0]q
);

always @(posedge clk, posedge reset)
	if(reset) q <= 0;
	else if(en) q<= d;

endmodule
