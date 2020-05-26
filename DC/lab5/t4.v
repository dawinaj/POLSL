// Perforemd by: Najda Dawid
//
// Task 4. Implement (complete implementation of) a period meter 
// that measures the single period of the F_IN signal.
// The controller contains parts typical for counter going through states 0, 1, 2, 3,
// and 4, 5, 6, 7. There are only two "jumps" between 0 - 4 and 3 – 7 that requires 
// the use of load inputs. In the remaining cases it is enough to use EN (enable) input 
// of counter to allow it passing from state to state. When counter enters states 2, 3, 
// and 5, 6 the reference clock signal is passed through the gate to counters. The number 
// of pulses passed is controlled by F_IN period. The initial adjustment states 1, 4 are 
// required for precise adjustment of the measured period. The state 7 is used for latching 
// the result while state 0 clears the period time counters. 

`timescale 1ns/100ps

module PERIOD_M(CLK, nCLR, F_IN, QH, QD, QU, OVF, nDONE);
    input CLK;  //Reference clock
    input nCLR; //Frequency meter clear signal
    input F_IN; //Measured period 
    output [3:0] QH, QD, QU; //Measurement result
    output OVF; //Resoult overflow notification
    output nDONE; //Notification about completing measurement process

    wire F_IN_Q, nF_IN_Q; // Synchronized F_IN signal

    //Control unit
    wire CTRL_DUMMY;
    wire [2:0] CTRL_Q;
    wire [2:0] nCTRL_Q;
    wire CTRL_LD; 
    wire CTRL_EN;
    wire GATE_EN; //Gate
    wire G_F_IN; //Gated F_IN
    wire CNT_CLR; //Counter clear
    wire LD; //Load latch

    //Counters and latches
    wire [3:0] QC_H, QC_D, QC_U;

    //Synchronizing register of F_IN to CLK
    SN7474 FF_SYNC(.CLK(CLK), .nR(nCLR), .nS(1'b1), .D(F_IN), .Q(F_IN_Q), .nQ(nF_IN_Q));
    //Control unit -> look at state diagram in PDF
    //Loaded value .D() (CTRL_Q = 0)->4  3'b000 -> 3'b100 and (CTRL_Q = 3)->7 3'b011 -> 3'b111
    //Remember CTRL_LD is activated conditionally
    SN74161 CTRL_C(
        .CLK(CLK), .nCLR(nCLR), 
        .LD(CTRL_LD), .EN(CTRL_EN), 
        .D({{1'b1, CTRL_Q[1:0]}}),  // <- Destination selection to be filled
    .Q({CTRL_DUMMY, CTRL_Q}), .ENO()); 


    not #2 CTRL_Q_INV[2:0](nCTRL_Q, CTRL_Q[2:0]);
    //CTRL_EN - When to activate -> see state diagram and comment - set inputs .I({...}) using 
    // F_IN_Q, nF_IN_Q or 1'b1 when unconditional
    
    SN74151 CTRL_M(
        .Y(CTRL_EN), 
        .SEL(CTRL_Q[2:0]), 
        .I({1'b1, F_IN_Q, nF_IN_Q, F_IN_Q, nF_IN_Q, F_IN_Q, nF_IN_Q, F_IN_Q})); //

    //CTRL_LD - When LD input is to be activated CTRL_Q = {0, 3}

    wire wireA, wireB;
    nand #2(wireA, ~CTRL_Q[2], ~CTRL_Q[1], ~CTRL_Q[0]);
    nand #2(wireB, ~CTRL_Q[2],  CTRL_Q[1],  CTRL_Q[0]);
    nand #2(CTRL_LD, wireA, wireB); //Build apropriate circuit

    //Generate latch pulse when CTRL_Q = 7
    wire nLD;

    nand #2(nLD, CTRL_Q[2], CTRL_Q[1], CTRL_Q[0]);
    not #2(LD, nLD);
    assign nDONE = LD;

    //Generate CNT_CLR when CTRL_Q = 0
    nor #2(CNT_CLR, CTRL_Q[2], CTRL_Q[1], CTRL_Q[0]);

    //CLK_EN - when clock pulses should be counted CTRL_Q = {2,3,4,6}
    wire n2y0, y2n0;

    nand #2 (n2y0, ~CTRL_Q[2],  CTRL_Q[0]);
    nand #2 (y2n0,  CTRL_Q[2], ~CTRL_Q[0]);
    nand #2 (CLK_EN, n2y0, y2n0);
    nand #2 (G_CLK, CLK, CLK_EN);

    //Counter
    SN7490 C1(.CLK(G_CLK), .R0(CNT_CLR), .R9(1'b0), .Q(QC_U));
    SN7490 C2(.CLK(QC_U[3]), .R0(CNT_CLR), .R9(1'b0), .Q(QC_D));
    SN7490 C3(.CLK(QC_D[3]), .R0(CNT_CLR), .R9(1'b0), .Q(QC_H));

    //Latch
    SN7474_4 L1(.CLK(LD), .nCLR(nCLR), .D(QC_U), .Q(QU));
    SN7474_4 L2(.CLK(LD), .nCLR(nCLR), .D(QC_D), .Q(QD));
    SN7474_4 L3(.CLK(LD), .nCLR(nCLR), .D(QC_H), .Q(QH));

endmodule

module T4_TEST;
reg CLK;  //Reference clock
reg nCLR;
reg F_IN; //Measured period
output [3:0] QH, QD, QU; //Measurement result
wire OVF;
wire nDONE;
reg [31:0] F_SET;

PERIOD_M PM_UUT(
    .CLK(CLK), .nCLR(nCLR), 
    .F_IN(F_IN), 
    .QH(QH), .QD(QD), .QU(QU), .OVF(OVF) ,
    .nDONE(nDONE));

initial begin
    F_SET = 32'd145_00;
    nCLR = 1'b0;
    repeat(2) @(posedge CLK);
    nCLR = 1'b1;    
    repeat(3) @(negedge nDONE);
    $display("Period change");
    F_SET = 32'd323_50;
    repeat(2) @(negedge nDONE);    
    repeat(100) @(posedge CLK);
    $display("%t : Simulation finish", $time);
    $finish;
end

initial begin
    #350_000;
    $display("%t : Simulation finish on timeout - circuit requires improvements.", $time);    
    $finish;
end

initial begin
    forever begin
        F_IN = 1'b0;
        #F_SET;
        F_IN = 1'b1;
        #F_SET;
    end
end

always @(negedge nDONE)
    $display("Measured frequency : %b : %d%d%d ", OVF, QH, QD, QU);

initial begin
    CLK = 1'b0;
    forever begin
        #50 CLK = ~CLK;
    end
end

initial begin
    $dumpfile("t4.vcd");
    $dumpvars;
    $dumpon;
end

endmodule

