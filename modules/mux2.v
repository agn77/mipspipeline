`timescale 1ns / 1ps

module mux2 #(parameter WIDTH = 8)
(
	input [WIDTH-1:0]d1,d2,
	input s,
	output [WIDTH-1:0]re
);

assign re = s ? d2 : d1;

endmodule
