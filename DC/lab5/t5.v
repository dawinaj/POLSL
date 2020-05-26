// Perforemd by: Najda Dawid
//
// Task 5. Implement (complete implementation of) a frequency meter with
// automatic range selection. 
// Design a control unit (single JK flip-flop) that selects measurement range 
// according to UDF and OVF signals. Attached testbench will help you 
// verify your design.

`timescale 1ns/100ps

module AUTO_FM(CLK, nCLR, F_IN, QH, QD, QU, Q_OVF, DONE);
input CLK;  //Reference clock
input nCLR; //Frequency meter clear signal
input F_IN; //Measured frequency 
output [3:0] QH, QD, QU; //Measurement result
output Q_OVF; //Resoult overflow notification
output DONE; //Notification about completing measurement process

//Control unit
wire [3:0] CTRL_Q, nCTRL_Q;

wire CTRL_EN; //CTRL unit ticke enable - range selection
wire CTRL_GATE; //Gate
wire CTRL_LD; //Latch
wire CTRL_EOC; //End Of Cycle

//Counters and latches
wire [3:0] QC_H, QC_D, QC_U;
wire OVF, nOVF; //Overflow indicator
wire UVF, nUVF; //Underflow indicator

//Reference CLK prescaler (by 10)
SN74162 PRS_C1(
    .CLK(CLK), .nCLR(nCLR), 
    .LD(1'b0), .EN(1'b1), 
    .D(4'd0), .Q(), .ENO(EN_10));

//-----------------------------------------------------------------------------
// Here is your working place
// design J and K excitation functions that assure correct range selection
// according to UDF and OVF lines. For your convenience there are 
// available nOVF and nUDF too.
// RG_SEL = 1 -> faster reference is selected

wire nDONE;
not #2 (nDONE, DONE);
SN7472 RG_SEL_FF(.CLK(nDONE), .nR(nCLR), .nS(1'b1), .J(OVF), .K(UDF), .Q(RG_SEL), .nQ());

//-----------------------------------------------------------------------------

nor #2(nCTRL_EN, RG_SEL, EN_10);
not #2(CTRL_EN, nCTRL_EN);

//Control unit -> synchronous implementation
SN74161 CTRL_C1(
    .CLK(CLK), .nCLR(nCLR), 
    .LD(CTRL_EOC), .EN(CTRL_EN), 
    .D(4'd0), .Q(CTRL_Q), .ENO());

assign DONE = CTRL_CLR;    

not #2 CTRL_Q_INV [3:0] (nCTRL_Q, CTRL_Q);
nor #2(GJ, CTRL_Q[3], CTRL_Q[2], CTRL_Q[1], nCTRL_Q[0]);
nor #2(GK, nCTRL_Q[3], CTRL_Q[2], nCTRL_Q[1], nCTRL_Q[0]);
//nor #2(CTRL_LD, nCTRL_Q[3], nCTRL_Q[2], CTRL_Q[1], CTRL_Q[0]);
nor #2(CTRL_CLR,  CTRL_Q[3],  CTRL_Q[2], CTRL_Q[1], CTRL_Q[0]);
nor #2(CTRL_EOC, nCTRL_Q[3], nCTRL_Q[2], CTRL_Q[1], CTRL_Q[0]);
assign CTRL_LD = CTRL_EOC;

SN7472 FF_GATE(.CLK(CLK), .nR(nCLR), .nS(1'b1), .J(GJ), .K(GK), .Q(CTRL_GATE), .nQ());   
// F_IN gate
nand #2(G_F_IN, CTRL_GATE, F_IN);
//Counter
SN7490 C1(.CLK(G_F_IN), .R0(CTRL_CLR), .R9(1'b0), .Q(QC_U));
SN7490 C2(.CLK(QC_U[3]), .R0(CTRL_CLR), .R9(1'b0), .Q(QC_D));
SN7490 C3(.CLK(QC_D[3]), .R0(CTRL_CLR), .R9(1'b0), .Q(QC_H));

//Overflow and underflow
not #2(nCTRL_CLR, CTRL_CLR);
SN7472 UDF_FF(.CLK(QC_D[3]), .nR(nCTRL_CLR), .nS(1'b1), .J(1'b1), .K(1'b0), .Q(nUDF), .nQ(UDF));
SN7472 OVF_FF(.CLK(QC_H[3]), .nR(nCTRL_CLR), .nS(1'b1), .J(1'b1), .K(1'b0), .Q(OVF), .nQ(nOVF));

//Latch
SN7474_4 L1(.CLK(CTRL_LD), .nCLR(nCLR), .D(QC_U), .Q(QU));
SN7474_4 L2(.CLK(CTRL_LD), .nCLR(nCLR), .D(QC_D), .Q(QD));
SN7474_4 L3(.CLK(CTRL_LD), .nCLR(nCLR), .D(QC_H), .Q(QH));
SN7474 L_OVF(.CLK(CTRL_LD), .nR(nCLR), .nS(1'b1), .D(OVF), .Q(Q_OVF), .nQ());

endmodule


module T5_TEST;
reg CLK;  //Reference clock
reg nCLR;
wire F_IN; //Measured frequency 
output [3:0] QH, QD, QU; //Measurement result
wire OVF;
wire nDONE;
reg [31:0] F_SET;

AUTO_FM UUT(
    .CLK(CLK), .nCLR(nCLR), 
    .F_IN(F_IN), 
    .QH(QH), .QD(QD), .QU(QU), .Q_OVF(OVF) ,
    .DONE(DONE));

FREQ_GEN FG(.CLK(F_IN), .F(F_SET));

initial begin
    F_SET = 32'd45; 
    nCLR = 1'b0;
    repeat(2) @(posedge CLK);
    nCLR = 1'b1;
    repeat(3) @(negedge DONE);
    F_SET = 32'd253;
    repeat(2) @(negedge DONE);
    F_SET = 32'd38;    
    repeat(2) @(negedge DONE);
    repeat(5) @(posedge CLK);
    $display("%t : Simulation finish", $time);
    $finish;
end

initial begin
    #60_000_000;
    $display("Finish on timeout - implementation requires improvements");
    $finish;
end

always @(negedge DONE) begin
    if(OVF)
        $display("Overflow detected  : %d%d%d ", QH, QD, QU);
    else        
        $display("Measured frequency : %d%d%d ", QH, QD, QU);       
end

initial begin
    CLK = 1'b0;
    forever begin
        #50_000 CLK = ~CLK;
    end
end

initial begin
    $dumpfile("t5.vcd");
    $dumpvars;
    $dumpon;
end

endmodule


