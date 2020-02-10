`timescale 1ns / 1ps

module hazard(
    input [4:0]rsD,rtD,rsE,rtE,
    input [4:0]writeregE,writeregM,writeregW,
    input regwriteE,regwriteM,regwriteW,
    input mem2regE,mem2regM,branchD,
    output forwardaD,forwardbD,
    output reg [1:0]forwardaE,forwardbE,
    output stallF,stallD,flushE
);

wire lwstallD,branchstallD;

//Branch equality
// Decode stage forwarding logic
assign forwardaD = (rsD != 0 & rsD == writeregM & regwriteM);
assign forwardbD = (rtD != 0 & rtD == writeregM & regwriteM);

//forwarding sources to Execute stage(ALU)
always@(*) begin
    forwardaE = 2'b00;
    forwardbE = 2'b00;
    // source A forwarding logic
    if (rsE != 0)
        if (rsE == writeregM & regwriteM) forwardaE = 2'b10;
        else if (rsE == writeregW & regwriteW) forwardaE = 2'b01;

    // source B forwarding logic
    if (rtE != 0)
        if (rtE== writeregM & regwriteM) forwardbE = 2'b10;
        else if (rtE == writeregW & regwriteW) forwardbE = 2'b01;
end 

//lw stall data hazard
assign #1 lwstallD = mem2regE & (rtE == rsD | rtE == rtD);

//control hazard
assign #1 branchstallD = branchD & (regwriteE & (writeregE == rsD | writeregE == rtD) | 
                                     mem2regM & (writeregM == rsD | writeregM ==rtD));

// fordward logic
assign #1 stallD = lwstallD | branchstallD;
assign #1 stallF = stallD;
assign #1 flushE = stallD;


endmodule