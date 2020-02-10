`timescale 1ns / 1ps
module alu(
	input [31:0]a,
	input [31:0]b,
	input [2:0]alucont,
	output reg [31:0]result,
	output zero
);

reg sltresult=0;
always @(*)
    begin
    if(a[31] == b[31]) sltresult = (a<b);
    else if(a[31]==1) sltresult = 1;
    else sltresult = 0;  
    end

always @(*)
	case(alucont)
		// each of the instructions in the ALU during Execute stage.
	// ported from single-cycle mips as ALU did not need to be modified!
	// output of ALU, aluout, is input into the EX/M pipeline register.
		3'b000: result = a&b; //and
		3'b001: result = a|b; //or
		3'b010: result = a+b; //add
		3'b011: result = b << a; //not used
		3'b110: result = a-b; //sub
		3'b111: result = sltresult;//slt
	endcase

assign #1 zero = !result;

endmodule 