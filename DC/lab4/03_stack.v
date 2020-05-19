// Performed by: Najda Dawid
//
// Task 3. Implement using the RAM16 synchronous memory module 
// a 16 level stack consisting of 8-bit words. Protect it against 
// stack overflow. Implement outputs notifying about the empty and 
// the full stack.
// Prepare the test bench and prove the correctness of the operation 
// of the designed stack. In the testbench check 

`timescale 1ns/100ps

module STACK(CLK, INIT, PUSH, POP, DI, DQ, EMPTY, FULL);
    input CLK, INIT, PUSH, POP;
    input  [7:0] DI;
    output [7:0] DQ;
    output EMPTY, FULL;
    wire INC, DEC, UP, WE, CE;
    wire [4:0] Q_A;
    reg  [4:0] Q;
    
    initial begin
        Q = 0;
    end
    
    // prevent pop-push simulteneously
    assign CE = (PUSH & !POP) | (!PUSH & POP);
    
    // Full when Q[4] is high
    assign FULL = Q[4];
    // Empty when Q pointer is all zeros
     NAND5 N1(EMPTY, !Q[0], !Q[1], !Q[2], !Q[3], !Q[4]);
    assign INC = PUSH & !FULL;
    assign DEC = POP & !EMPTY;
    
    assign WE = INC;
    assign UP = INC & !DEC;
    
    assign Q_A = Q;

    RAM16S #(.W(8)) STACK_MEM(CLK, WE, Q[3:0], DI, DQ);
    CBUD   #(.W(5)) SP_CNT(CLK, INIT, CE, INC, Q_A);
endmodule

module STACK_TEST;
    reg CLK, INIT, PUSH, POP;
    reg  [7:0] DI;
    wire [7:0] DQ;
    wire EMPTY, FULL;
    
    STACK ST1(CLK, INIT, PUSH, POP, DI, DQ, EMPTY, FULL);
    
    //Main test vector generator
    initial begin
        INIT = 0;
        DI = 7'd1;
        PUSH = 1'b1;
        POP = 1'b0;
        repeat(3) @(negedge CLK) DI = DI + 1;
        
        PUSH = 1'b0;
        POP = 1'b1;
        repeat(3) @(negedge CLK) DI = DI + 1;
        
        PUSH = 1'b1;
        POP = 1'b1;
        repeat(3) @(negedge CLK) DI = DI + 1;
        
        $finish;
    end
    
    // Clock generator
    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        $dumpfile("stack.vcd");
        $dumpvars;
        $dumpon;
        $monitor("%t: Empty: %b, Full: %b, DQ: %b; Push: %b, Pop: %b, DI: %b ", $time, EMPTY, FULL, DQ, PUSH, POP, DI);
    end
endmodule
