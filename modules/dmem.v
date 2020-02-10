`timescale 1ns / 1ps
// Modified Data Memory ported from Single-Cycle Mips.
// We modify the original memory to now read the instruction file
// 
// Read Data output to M/W pipelined register.
module dmem(input clk, we,
				input [31:0] a, wd,
				output [31:0] rd);
				
reg [31:0] RAM[63:0];

initial
	begin
		$readmemh("test1.dat",RAM);
	end
	
	assign rd = RAM[a[31:2]]; // word aligned
	
	always @(posedge clk)
	if (we)
	RAM[a[31:2]] <= wd;
	
endmodule
