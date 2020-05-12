`timescale 1ns/100ps

module ROM(A, Q);
parameter D_W = 8; //Data word size - default 8
parameter A_W = 4; //Address word size - default 4 (16 cells)
parameter S = 2**A_W; //Memory size calculation

input [A_W-1:0] A;
output [D_W-1:0] Q;

reg [D_W-1:0] MEM [S-1:0];

assign #1 Q = MEM[A];

integer i;
initial begin
    //Clearing memory content
    for(i = 0; i < S; i = i + 1)
        MEM[i] = {D_W{1'b0}};
end

task SET;
input [A_W-1:0] A;
input [D_W-1:0] D;
begin
    MEM[A] = D;
end
endtask

endmodule

module REG(CLK, CLR, D, Q);
parameter W = 4;
input CLK;
input CLR;
input [W-1:0] D;
output reg [W-1:0] Q;

always @(posedge CLK)
    if(CLR)
        Q <= #1 {W{1'b0}};
    else
        Q <= #1 D;

endmodule

module MUX16(Y, SEL, I);
output Y;
input [7:0] I;
input [2:0] SEL;

assign #1 Y = I[SEL];

endmodule

module MUX8(Y, SEL, I);
output Y;
input [7:0] I;
input [2:0] SEL;

assign #1 Y = I[SEL];

endmodule

module MUX4(Y, SEL, I);
output Y;
input [3:0] I;
input [1:0] SEL;

assign #1 Y = I[SEL];

endmodule

module MUX2(Y, SEL, I);
output Y;
input [1:0] I;
input SEL;

assign #1 Y = I[SEL];

endmodule


module TIMER(CLK, EN, T, TMO);
input CLK; 
input EN;
input [7:0] T;
output TMO;
reg [8:0] Q;

initial Q = 9'd0;

always @(posedge CLK)
    if(EN)
        Q <= #2 ((EN ? Q : T) + {9{~Q[8]}});
    else
        Q <= #2 0;

assign #2 TMO = Q[8];

endmodule

