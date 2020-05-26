// Perforemd by: Najda Dawid
//
// Task 3. Implement a frequency meter capable of subtracting an intermediate 
// frequency of 107 (FM IF = 10.7MHz) using synchronous counters with a parallel 
// load instead of clear. Determine the initial value that will satisfy the given condition.

`timescale 1ns/100ps

module RCV_FM(CLK, nCLR, F_IN, QH, QD, QU, OVF, DONE);
input CLK;  //Reference clock
input nCLR; //Frequency meter clear signal
input F_IN; //Measured frequency 
output [3:0] QH, QD, QU; //Measurement result
output OVF; //Resoult overflow notification
output DONE; //Notification about completing measurement process

//Control unit
wire [3:0] CTRL_Q, nCTRL_Q;

wire Q_OVF;
wire CTRL_EN; //Gate
wire CTRL_LD; //Latch, Counter initialize
wire CTRL_EOC; //End Of Cycle
wire GATE_J, GATE_K;

//Counters and latches
wire [3:0] QC_H, QC_D, QC_U, QC_O;

//Control unit -> synchronous implementation
SN74161 CTRL_C1(
    .CLK(CLK), .nCLR(nCLR), 
    .LD(CTRL_EOC), .EN(1'b1), 
    .D(4'd0), .Q(CTRL_Q), .ENO());

assign DONE = CTRL_EOC;

not #2 CTRL_Q_INV [3:0] (nCTRL_Q, CTRL_Q);

nor #2 (J,         CTRL_Q[3],  CTRL_Q[2],  CTRL_Q[1],  CTRL_Q[0]);
nor #2 (K,        nCTRL_Q[3],  CTRL_Q[2], nCTRL_Q[1],  CTRL_Q[0]);
nor #2 (CTRL_LD,  nCTRL_Q[3],  CTRL_Q[2], nCTRL_Q[1], nCTRL_Q[0]);
nor #2 (CTRL_EOC, nCTRL_Q[3], nCTRL_Q[2],  CTRL_Q[1],  CTRL_Q[0]);
//GATE J <- 0
//GATE K <- 10
//CTRL_LD <- 11
//CTRL_EOC <- 12

SN7472 FF_GATE(.CLK(CLK), .nR(nCLR), .nS(1'b1), .J(J), .K(K), .Q(CTRL_EN), .nQ());

// Counters ->
// Determine initial value to be loaded to the counters (.D(??)) 
// to get result smaller for 107 pulses    1000 - 107 = 893
SN74162 C1(
    .CLK(F_IN), .nCLR(nCLR),
    .LD(CTRL_EOC), .EN(CTRL_EN),
    .D(4'd3), .Q(QC_U), .ENO(EN_D));

SN74162 C2(
    .CLK(F_IN), .nCLR(nCLR),
    .LD(CTRL_EOC), .EN(EN_D),
    .D(4'd9), .Q(QC_D), .ENO(EN_H));

SN74162 C3(
    .CLK(F_IN), .nCLR(nCLR),
    .LD(CTRL_EOC), .EN(EN_H),
    .D(4'd8), .Q(QC_H), .ENO(EN_O));

SN74162 OV(
    .CLK(F_IN), .nCLR(nCLR),
    .LD(CTRL_EOC), .EN(EN_O),
    .D(4'd9), .Q(QC_O), .ENO());

nor #2 (Q_OVF, QC_O[3], QC_O[2], QC_O[1], QC_O[0]);

//Latch
SN74173 L1(.CLK(F_IN), .nCLR(nCLR), .EN(CTRL_LD), .D(QC_U), .Q(QU));
SN74173 L2(.CLK(F_IN), .nCLR(nCLR), .EN(CTRL_LD), .D(QC_D), .Q(QD));
SN74173 L3(.CLK(F_IN), .nCLR(nCLR), .EN(CTRL_LD), .D(QC_H), .Q(QH));
SN7474  L4(.CLK(F_IN), .nS(1'b1), .nR(1'b1), .D(Q_OVF), .Q(OVF));



endmodule


module T3_TEST;
reg CLK;  //Reference clock
reg nCLR;
wire F_IN; //Measured frequency 
output [3:0] QH, QD, QU; //Measurement result
wire OVF;
wire nDONE;
reg [31:0] F_SET;

RCV_FM UUT(
    .CLK(CLK), .nCLR(nCLR), 
    .F_IN(F_IN), 
    .QH(QH), .QD(QD), .QU(QU), .OVF(OVF) ,
    .DONE(DONE));

FREQ_GEN FG(.CLK(F_IN), .F(F_SET));

initial begin
    F_SET = 32'd766;
    nCLR = 1'b0;
    repeat(2) @(posedge CLK);
    nCLR = 1'b1;
    repeat(3) @(posedge DONE);
    F_SET = 32'd847;
    repeat(2) @(posedge DONE);    
    repeat(5) @(posedge CLK);
    $display("%t : Simulation finish", $time);
    $finish;
end

initial begin
    #8_000_000;
    $display("Finish on timeout - implementation requires improvements");
    $finish;
end

always @(posedge DONE)
    $display("Measured frequency : %b : %d%d%d ", OVF, QH, QD, QU);

initial begin
    CLK = 1'b0;
    forever begin
        #50_000 CLK = ~CLK;
    end
end

initial begin
    $dumpfile("t3.vcd");
    $dumpvars;
    $dumpon;
end

endmodule

