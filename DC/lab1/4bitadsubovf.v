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
wire [3:0] Axrd;
wire [2:0] Cint;

XOR2 X1(Axrd[0], A[0], SUB);
XOR2 X2(Axrd[1], A[1], SUB);
XOR2 X3(Axrd[2], A[2], SUB);
XOR2 X4(Axrd[3], A[3], SUB);
FA A1(Cint[0], S[0], Axrd[0], B[0], SUB);
FA A2(Cint[1], S[1], Axrd[1], B[1], Cint[0]);
FA A3(Cint[2], S[2], Axrd[2], B[2], Cint[1]);
FA A4(CO,      S[3], Axrd[3], B[3], Cint[2]);
XOR2 X5(OVF, CO, Cint[2]);
endmodule 


module ADD_4_OVF_TEST;
reg [3:0] A, B;
reg SUB;
wire [3:0] Y;
wire CO, OVF;

ADD_4_OVF A4_1(OVF, CO, Y, A, B, SUB);

initial begin
    #100;
    SUB = 1'b0;
    A = 4'b0000;
    B = 4'b0000;
    repeat (2) begin
        repeat(16) begin
            repeat(16) #100 B = B + 1;
        #100 A = A + 1;
        end
        #100 SUB = ~SUB;
    end
    $finish;
end

initial begin
    $monitor("%t: %b + %b = %b, C:%b, OVF:%b", $time, A, B, Y, CO, OVF);
    $dumpfile("add_4_ovf_test.vcd");
    $dumpvars(0, ADD_4_OVF_TEST);
    $dumpon();
end

endmodule
