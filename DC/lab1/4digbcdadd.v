// Perforemd by: {Full Last,First Name}
// Task 4: Implement a 1-digit BCD adder using delivered components 
// library and already designed components. Create a 3-digit BCD adder 
// and verify its operation by preparing respective excitation vectors. 
// Using your test bench, determine the maximal propagation time of 
// the designed adder. At the end of the simulation print out this 
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

//Carry generate and propagate module
module C_GP(nG, P, A, B);
output nG; // Carray not generate
output P;  // Carry propagate
input  A, B;
NAND2 G1(nG, A, B);
XOR2 X1 (P, A, B);
endmodule

// 4-bit carry look-ahead adder module
module ADD_FAST(CO, S, A, B, CI);
output CO;
output [3:0] S;
input [3:0] A, B;
input CI;
wire [3:0] nG, P, pici;
wire [2:1] C;
C_GP GP1(nG[0], P[0], A[0], B[0]);
C_GP GP2(nG[1], P[1], A[1], B[1]);
C_GP GP3(nG[2], P[2], A[2], B[2]);
C_GP GP4(nG[3], P[3], A[3], B[3]);
NAND2 P1(pici[0], P[0], CI);
NAND2 C1(C[1], nG[0], pici[0]);
NAND2 P2(pici[1], P[1], C[1]);
NAND2 C2(C[2], nG[1], pici[1]);
NAND2 P3(pici[2], P[2], C[2]);
NAND2 C3(CO,   nG[2], pici[2]);
NAND2 P4(pici[3], P[3], CO);
XOR2 S1(S[0], P[0], CI);
XOR2 S2(S[1], P[1], C[1]);
XOR2 S3(S[2], P[2], C[2]);
XOR2 S4(S[3], P[3], CO);
endmodule 


module ADD_BCD(CO, S, A, B, CI);
output CO; 
output [3:0] S; 
input [3:0] A, B;
input CI;
wire [3:0] Abis, Bbis;
wire C4, s3s2, s3s1;
wire GND = 0;

ADD_FAST PRIM(C4, Abis, A, B, CI);
NAND2 N1(CO, S[3], S[2]);
NAND2 N2(CO, S[3], S[1]);
NAND3 N3(CO, ~C4, s3s2, s3s1);

assign B[3] = GND;
assign B[2] = CO;
assign B[1] = CO;
assign B[0] = GND;

ADD_FAST SCND(C4, S, Abis, Bbis, GND);

endmodule 

module ADD_BCD_TEST;
reg [3:0] A, B;
reg CI;
wire [3:0] Y;
wire CO;

ADD_BCD AD_1(CO, Y, A, B, CI);

initial begin
    #100;
    CI = 1'b0;
    repeat (2) begin
        A = 4'b0000;
        repeat(10) begin
            B = 4'b0000;
            repeat(9) #100 B = B + 1;
        #100 A = A + 1;
        end
        #100 CI = ~CI;
    end
    $finish;
end

initial begin
    $monitor("%t: %b + %b = %b, C:%b", $time, A, B, Y, CO);
    $dumpfile("add_bcd.vcd");
    $dumpvars(0, ADD_BCD_TEST);
    $dumpon();
end


endmodule
