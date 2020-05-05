// Perforemd by: Najda Dawid
// Task 1: Implement using components from comp_lib.v a 4-bit ripple 
// carry adder. Implement it with the idea of using half adder modules 
// than using half adders, implement a single bit full adder. Finally, 
// assemble a 4-bit adder. Try to use a minimal number of components. 
// Take care of implementing the XOR gate. Think about resource sharing 
// (e.g.NAND gates). Write a stimulus to observe the 4-bit adder operation. 
// Log results to waveform and console. Prove correctness of the design 
// by applying appropriate test vectors. Using your test bench, determine 
// the maximal propagation time of the designed adder. Design an observer 
// block that automatically records maximal response delay during 
// the simulation process. At the end of the simulation print out this 
// result (e.g. using $display task).

`timescale 1ns/100ps

module XOR2(Y, A, B);
output Y;
input A, B;
wire E, F;
NAND2 G1(E, A, ~B);
NAND2 G2(F, ~A, B);
NAND2 G3(Y, E, F);
endmodule

// Half adder module
module HA(nC, S, A, B);
output S, nC;
input A, B;
XOR2  G1(S, A, B);
NAND2 G2(nC, A, B);
endmodule

// 1-bit full adder module
module FA(CO, S, A, B, CI);
output CO, S;
input A, B, CI;
wire S1, C1, C2;
HA ApB(C1, S1, A, B);
HA ApBpC(C2, S, S1, CI);
NAND2 N1(CO, C1, C2);
endmodule

// 4-bit adder module
module ADD_4(CO, S, A, B, CI);
output CO;
output [3:0] S;
input [3:0] A, B;
input CI;
wire [2:0] Cint;
FA A1(Cint[0], S[0], A[0], B[0], CI);
FA A2(Cint[1], S[1], A[1], B[1], Cint[0]);
FA A3(Cint[2], S[2], A[2], B[2], Cint[1]);
FA A4(CO, S[3], A[3], B[3], Cint[2]);
endmodule

// 4-bit adder test bench
module ADD_4_TEST;
reg [3:0] A, B;
reg CI;
wire [3:0] Y;
wire CO;

ADD_4 A4_1(CO, Y, A, B, CI);

initial begin
    #100;
    CI = 1'b1;
    A = 4'b0111;
    B = 4'b0101;
    #100;
    $finish;
end

initial begin
    $monitor("%t: %b + %b = %b, C:%b", $time, A, B, Y, CO);
    $dumpfile("add_4_test.vcd");
    $dumpvars(0, ADD_4_TEST);
    $dumpon();
end

endmodule
