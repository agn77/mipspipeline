`timescale 1ns / 1ps

module controller(input clk, reset,
						input [5:0] opD, functD,
						input flushE, equalD,
						output memtoregE, memtoregM,
						output memtoregW, memwriteM,
						output pcsrcD, branchD, alusrcE,
						output regdstE, regwriteE,
						output regwriteM, regwriteW,
						output jumpD,
						output [2:0] alucontrolE);

// connect to ALU Control module. Output of the controller at
// the decode stage is instantiated as wire and output for the
// Execute stage of the D/EX pipelined register.  
wire [1:0] aluopD;
wire memtoregD, memwriteD, alusrcD,regdstD, regwriteD;
wire [2:0] alucontrolD;
wire memwriteE;

//instantiating alu and controller decoders
maindec md(opD, memtoregD, memwriteD, branchD,alusrcD, regdstD, regwriteD, jumpD,aluopD);
aludec ad(functD, aluopD, alucontrolD);

assign pcsrcD = branchD & equalD;

// pipeline registers

//pipeline register Decode/Execute
// we use a flop with synchronous reset and clear and we flushE
floprc #(8) regE(clk, reset, flushE,{memtoregD, memwriteD, alusrcD,regdstD, regwriteD, alucontrolD},
{memtoregE, memwriteE, alusrcE,regdstE, regwriteE, alucontrolE});

//pipeline register Execute/Memory
flopr #(3) regM(clk, reset,{memtoregE, memwriteE, regwriteE},{memtoregM, memwriteM, regwriteM});

//pipeline register Memory/Writeback
flopr #(2) regW(clk, reset,{memtoregM, regwriteM},{memtoregW, regwriteW});

endmodule 