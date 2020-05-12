// Task 1: Design the microprogrammable controller according 
// to state diagram and outputs activity shown in the instruction 
// Use components from uprog_lib.v only

`timescale 1ns/100ps

module UP_STAR(CLK, CLR, W, X, Y);
//Symbolic states declaration - Encoding
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

input CLK;   /* Clock signal */
input CLR;   /* Synchronous clear */
input W;     /* Controller input */
output X, Y; /* Controller outputs */

wire [2:0] Q, nextQ;

// Parameterized memory
ROM #(.D_W(5), .A_W(4))M1(
    .A({Q,W}), /* Memory inputs */
    .Q({nextQ, X, Y}) /* Memory outputs */ );

// Parameterized register
REG #(.W(3)) R1(
    .CLK(CLK), 
    .CLR(CLR), 
    .D(nextQ), 
    .Q(Q));

initial begin
    //Initializing ROM memory using SET task
    M1.SET({S0,1'b0}, {S1, 1'b0, 1'b0});
    M1.SET({S0,1'b1}, {S2, 1'b0, 1'b0});
    M1.SET({S1,1'b0}, {S2, 1'b1, 1'b0});
    M1.SET({S1,1'b1}, {S3, 1'b1, 1'b0});
    M1.SET({S2,1'b0}, {S3, 1'b0, 1'b1});
    M1.SET({S2,1'b1}, {S4, 1'b0, 1'b1});
    M1.SET({S3,1'b0}, {S4, 1'b1, 1'b1});
    M1.SET({S3,1'b1}, {S0, 1'b1, 1'b1});
    M1.SET({S4,1'b0}, {S0, 1'b1, 1'b0});
    M1.SET({S4,1'b1}, {S1, 1'b1, 1'b0});
end

endmodule

module UP_STAR_TB;
reg CLK;   /* Clock signal */
reg CLR;   /* Synchronous clear */
reg W;     /* Controller input */
wire X, Y; /* Controller outputs */

// Tested controller
UP_STAR UP_1(
    .CLK(CLK), 
    .CLR(CLR), 
    .W(W), 
    .X(X), 
    .Y(Y));

//Main test vector generator
initial begin
    W = 1'b0;
    CLR = 1'b1;
    
    
    repeat(3) @(negedge CLK);
    CLR = 1'b0;
    $display("//Going in sequential mode S0->S1->S2->...");
    W = 1'b0;
    repeat(5) @(negedge CLK);
    $display("//Going in jump mode S0->S2->S4->...");
    W = 1'b1;
    repeat(5) @(negedge CLK);
    $display("//We are in S0 now");
    $display("//funny jumping");
    repeat(5) begin
        W = 1'b0;
        @(negedge CLK);
        W = 1'b1;
        @(negedge CLK);
    end
    //We are back in S0
    $finish;
end

// Clock generator
initial begin
    CLK = 1'b0;
    forever #50 CLK = ~CLK;
end

initial begin
    $dumpfile("up_star.vcd");
    $dumpvars;
    $dumpon;
    //Ordinary monitor
    $monitor("%b:%b -> %b:%b%b", UP_1.Q, W, UP_1.nextQ, X, Y);
end

//Cutom monitoring of the machine
reg [2:0] last_Q;

always @(UP_1.Q) begin
    $display("State change: %d -> %d", last_Q, UP_1.Q);
    last_Q = UP_1.Q;
end

always @(UP_1.nextQ)
    $display("Next state is: %d for W = %b", UP_1.nextQ, W);

endmodule

