`timescale 1ns / 1ps
// Modified Datapath from Single-Cycle MIPS.
// We specify the datapth for the registers
// we use to pipeline the orignal design. 
// The instantiation of each of the modules is
// described for the specific use in the design.
module datapath(input clk, reset,
					 input memtoregE, memtoregM,
					 memtoregW,
					 input pcsrcD, branchD,
					 input alusrcE, regdstE,
					 input regwriteE, regwriteM,regwriteW,
					 input jumpD,
				  	 input [2:0] alucontrolE,
					 output equalD,
					 output [31:0] pcF,
					 input [31:0] instrF,
					 output [31:0] aluoutM, writedataM,
					 input [31:0] readdataM,
					 output [5:0] opD, functD,
					 output flushE);

//wires for datapath 					 
wire forwardaD, forwardbD;
wire [1:0] forwardaE, forwardbE;
wire stallF;
wire [4:0] rsD, rtD, rdD, rsE, rtE, rdE;
wire [4:0] writeregE, writeregM, writeregW;
wire flushD;
wire [31:0] pcnextFD, pcnextbrFD, pcplus4F,pcbranchD;
wire [31:0] signimmD, signimmE, signimmshD;
wire [31:0] srcaD, srca2D, srcaE, srca2E;
wire [31:0] srcbD, srcb2D, srcbE, srcb2E, srcb3E;
wire [31:0] pcplus4D, instrD;
wire [31:0] aluoutE, aluoutW;
wire [31:0] readdataW, resultW;


//instantiating hazard detection unit
hazard h(rsD, rtD, rsE, rtE, writeregE, writeregM,writeregW,regwriteE, regwriteM, regwriteW,
memtoregE, memtoregM, branchD,forwardaD, forwardbD, forwardaE,forwardbE,stallF, stallD, flushE);

// next PC logic (operates in fetch and decode)
mux2 #(32) pcbrmux(pcplus4F, pcbranchD, pcsrcD,pcnextbrFD);
mux2 #(32) pcmux(pcnextbrFD,{pcplus4D[31:28],
instrD[25:0], 2'b00},jumpD, pcnextFD);

// register file (operates in decode and writeback)
regfile rf(clk, regwriteW, rsD, rtD, writeregW,resultW, srcaD, srcbD);

// Fetch stage logic
// Instantiate the adder and the pipeline registers! 
flopenr #(32) pcreg(clk, reset, ~stallF,pcnextFD, pcF);
adder pcadd1(pcF, 32'b100, pcplus4F);

// Decode stage
flopenr #(32) r1D(clk, reset, ~stallD, pcplus4F,pcplus4D);
flopenrc #(32) r2D(clk, reset, ~stallD, flushD, instrF, instrD);
signext se(instrD[15:0], signimmD);
sl2 immsh(signimmD, signimmshD);
adder pcadd2(pcplus4D, signimmshD, pcbranchD);
mux2 #(32) forwardadmux(srcaD, aluoutM, forwardaD,srca2D);
mux2 #(32) forwardbdmux(srcbD, aluoutM, forwardbD,srcb2D);
eqcmp comp(srca2D, srcb2D, equalD);

//controller instructions
assign opD = instrD[31:26];
assign functD = instrD[5:0];

//register instructions for pipeline D/EX
assign rsD = instrD[25:21];
assign rtD = instrD[20:16];
assign rdD = instrD[15:11];
assign flushD = pcsrcD | jumpD;

// Execute stage
floprc #(32) r1E(clk, reset, flushE, srcaD, srcaE);
floprc #(32) r2E(clk, reset, flushE, srcbD, srcbE);
floprc #(32) r3E(clk, reset, flushE, signimmD, signimmE);
floprc #(5) r4E(clk, reset, flushE, rsD, rsE);
floprc #(5) r5E(clk, reset, flushE, rtD, rtE);
floprc #(5) r6E(clk, reset, flushE, rdD, rdE);
mux3 #(32) forwardaemux(srcaE, resultW, aluoutM,forwardaE, srca2E);
mux3 #(32) forwardbemux(srcbE, resultW, aluoutM,forwardbE, srcb2E);
mux2 #(32) srcbmux(srcb2E, signimmE, alusrcE,srcb3E);
alu alu(srca2E, srcb3E, alucontrolE, aluoutE);
mux2 #(5) wrmux(rtE, rdE, regdstE, writeregE);

// Memory stage
flopr #(32) r1M(clk, reset, srcb2E, writedataM);
flopr #(32) r2M(clk, reset, aluoutE, aluoutM);
flopr #(5) r3M(clk, reset, writeregE, writeregM);

// Writeback stage
flopr #(32) r1W(clk, reset, aluoutM, aluoutW);
flopr #(32) r2W(clk, reset, readdataM, readdataW);
flopr #(5) r3W(clk, reset, writeregM, writeregW);
mux2 #(32) resmux(aluoutW, readdataW, memtoregW,resultW);
endmodule 