// Performed by: Najda Dawid
//
// Task 4. Implement using the RAM16D memory module a ring register. 
// Implement notification lines for the empty and full queue. Protect 
// against writing to the full queue and reading from the empty queue. 
// Assure proper operation during simultaneous read and write.
// Prepare the test bench and prove the correctness of the queue 
// operation. Prove protection against reading the empty queue and 
// writing to the full queue. Prove correctness of simultaneous read 
// and write operation
//


`timescale 1ns/100ps

module QUEUE(CLK, INIT, WR, RD, DI, DQ, EMPTY, FULL);
    input CLK, WR, RD, INIT;
    input [7:0] DI;
    output [7:0] DQ;
    output EMPTY, FULL;
    wire winc, wdec;
    wire [3:0] wA;
    wire [3:0] wQ;
    wire [3:0] wAR;

    RAM16D #(.W(8)) QUEU_MEM  (CLK, winc, wA, wAR, DI, DQ);
    CBUD   #(.W(5)) C_DATA_CNT(CLK, INIT, wdec, winc, {wQ, FULL});
    CB     #(.W(4)) C_RD_PTR  (CLK, INIT, winc, wA);
    CB     #(.W(4)) C_WR_PTR  (CLK, INIT, wdec, wAR);

    NAND5 N5(EMPTY, wQ[0], wQ[1], wQ[2], wQ[3], FULL);
    NAND2 N21(winc, WR, FULL);
    NAND2 N22(wdec, RD, EMPTY);

endmodule

module QUEUE_TEST;
    reg CLK, INIT, WR, RD;
    reg [7:0] DI;
    wire [7:0] DQ;
    wire EMPTY, FULL;

    QUEUE Q(CLK, INIT, WR, RD, DI, DQ, EMPTY, FULL);
        
    initial begin
        DI = 8'b0;
        INIT = 1'b1;
        #10;
        INIT = 1'b0;
        #10;
        RD = 0;
        #10;
        repeat(30) begin
            #5 WR = 1;
            #4 DI = DI +1; 
            #10 WR = 0;
            #10;
        end
        repeat(16) #10 RD=1;
        #10;
        RD = 0;
        #10;
        repeat(5) begin
            #5 WR = 1;
            #4 DI = DI +1; 
            #10 WR = 0;
            #10;
        end
        #10;
        RD = 1;
        #10;
        RD = 0;
        #10;
        $finish;
    end
    
    // Clock generator
    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        $dumpfile("queue.vcd");
        $dumpvars;
        $dumpon;
        $monitor("DI: %b , DQ: %b, WR:%b, RD:%b, EMPTY:%b, FULL:%b", DI, DQ, WR, RD, EMPTY, FULL);
    end
endmodule
