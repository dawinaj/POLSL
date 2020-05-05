// Task 2: Implement using components from comp_lib.v an overflow detector
// output for 4-bit binary adder used for two's complement arithmetic. 
// Implement a unit that can add and subtract two's complement numbers, 
// using an adder with an overflow detector. Verify your implementation 
// with the respective test bench. Check correctness of operation of 
// the designed unit applying respective test vectors. Write stimulus 
// and responses to console and VCD file for waveform displaying.

`timescale 1ns/100ps


module ADD_4_OVF(OVF, CO, S, A, B, SUB);
output OVF, CO; 
output [3:0] S; 
input [3:0] A, B;
input SUB;
wire [2:0] Cint;
XOR2 X1(A[0], A[0], SUB);
XOR2 X2(A[1], A[1], SUB);
XOR2 X3(A[2], A[2], SUB);
XOR2 X4(A[3], A[3], SUB);
FA A1(Cint[0], S[0], A[0], B[0], CI);
FA A2(Cint[1], S[1], A[1], B[1], Cint[0]);
FA A3(Cint[2], S[2], A[2], B[2], Cint[1]);
FA A4(CO, S[3], A[3], B[3], Cint[2]);
XOR2 X5(OVF, CO, Cint[2]);
endmodule 


module ADD_4_OVF_TEST;
reg [3:0] A, B;
reg CI;
wire [3:0] Y;
wire CO;
wire OVF;

ADD_4_OVF A4_1(OVF, CO, Y, A, B, CI);

initial begin
    #100;
    CI = 1'b0;
    A = 4'b0000;
    B = 4'b0000;
    repeat (2) begin
        repeat(16) begin
            repeat(16) #100 B = B + 1;
        #100 A = A + 1;
        end
        #100 CI = ~CI;
    end
    $finish;
end

initial begin
    $monitor("%t: %b + %b = %b, C:%b, OVF:%b", $time, A, B, Y, CO, OVF);
    $dumpfile("add_4_test.vcd");
    $dumpvars(0, ADD_4_OVF_TEST);
    $dumpon();
end

endmodule
