// Perforemd by: Najda Dawid
//
// Task 2. Design a memory system that consists of 64 words by 16 bits memory 
// with bidirectional data port D using the RAM_16X4 module. Use simple components 
// (gates) available in the delivered library to connect multiple memory blocks.
// Prepare the test bench that checks designed memory capacity by writing unique 
// patterns to each cell. In the next cycle verify the memory content.
//

`timescale 1ns/100ps

module RAM_64x16(nCS, nWE, nOE, A, D);
    input nCS, nWE, nOE;
    input [5:0] A;
    inout [15:0] D;
    wire [15:0] Q;
    
    wire nCS1, nCS2, nCS3, nCS4;
    
    NAND3 G1(nCS1, !nCS, !A[5], !A[4]);
    NAND3 G2(nCS2, !nCS, !A[5],  A[4]);
    NAND3 G3(nCS3, !nCS,  A[5], !A[4]);
    NAND3 G4(nCS4, !nCS,  A[5],  A[4]);
    
    RAM_16X4 M11(nCS1, nWE, nOE, A[3:0], D[3:0],   Q[3:0]);
    RAM_16X4 M12(nCS1, nWE, nOE, A[3:0], D[7:4],   Q[7:4]);
    RAM_16X4 M13(nCS1, nWE, nOE, A[3:0], D[11:8],  Q[11:8]);
    RAM_16X4 M14(nCS1, nWE, nOE, A[3:0], D[15:12], Q[15:12]);
    
    RAM_16X4 M21(nCS2, nWE, nOE, A[3:0], D[3:0],   Q[3:0]);
    RAM_16X4 M22(nCS2, nWE, nOE, A[3:0], D[7:4],   Q[7:4]);
    RAM_16X4 M23(nCS2, nWE, nOE, A[3:0], D[11:8],  Q[11:8]);
    RAM_16X4 M24(nCS2, nWE, nOE, A[3:0], D[15:12], Q[15:12]);
    
    RAM_16X4 M31(nCS3, nWE, nOE, A[3:0], D[3:0],   Q[3:0]);
    RAM_16X4 M32(nCS3, nWE, nOE, A[3:0], D[7:4],   Q[7:4]);
    RAM_16X4 M33(nCS3, nWE, nOE, A[3:0], D[11:8],  Q[11:8]);
    RAM_16X4 M34(nCS3, nWE, nOE, A[3:0], D[15:12], Q[15:12]);
    
    RAM_16X4 M41(nCS4, nWE, nOE, A[3:0], D[3:0],   Q[3:0]);
    RAM_16X4 M42(nCS4, nWE, nOE, A[3:0], D[7:4],   Q[7:4]);
    RAM_16X4 M43(nCS4, nWE, nOE, A[3:0], D[11:8],  Q[11:8]);
    RAM_16X4 M44(nCS4, nWE, nOE, A[3:0], D[15:12], Q[15:12]);
    
    assign D = nOE ? {16{1'bz}} : {Q[15:12], Q[11:8], Q[7:4], Q[3:0]}; //{16{1'bz}}

endmodule

module RAM_64x16_TEST;
    reg nCS, nWE, nOE;
    reg  [5:0] A;
    wire [15:0] D;
    reg  [15:0] D_DRV;
    
    RAM_64x16 M1(.nCS(nCS), .nWE(nWE), .nOE(nOE), .A(A), .D(D));
    
    //For writing the data use D_DRV - remember about conflicts
    assign D = D_DRV;
    
    initial begin
        A = 5'd7;
        
        MEM_WR(A, 8'h12);
        #100;
        MEM_RD(A, D_DRV);
        
        //MEM_WR(6'd10,16'd3141);
        //...?
        #100;
        $finish;
    end
    
    
    initial begin
        $dumpfile("mem_test_big.vcd");
        $dumpvars;
        $dumpon;
    end
    
    task MEM_RD;
    input [5:0] Ain;
    output [15:0] DQ;
    begin
        nWE = 1'b1;
        nOE = 1'b1;
        nCS = 1'b0;
        D_DRV = 16'hzzzz;
        A = Ain;
        nOE = 1'b0;
        #100;
        DQ = D;
        nOE = 1'b1;
        nCS = 1'b1;
    end
    endtask
    
    task MEM_WR;
    input [5:0] Ain;
    input [15:0] Din;
    begin
        nWE = 1'b1;
        nOE = 1'b1;
        nCS = 1'b0;
        A = Ain;
        D_DRV = Din;
        nWE = 1'b0;
        #100;
        nWE = 1'b1;
        nCS = 1'b1;
    end
    endtask
    
endmodule

