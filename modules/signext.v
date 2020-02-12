`timescale 1ns / 1ps

module signext(
	input [15:0]x,
	output [31:0]y
);

assign y = { { 16{x[15]} }, x };

endmodule 
