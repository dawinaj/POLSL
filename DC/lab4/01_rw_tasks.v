// Perforemd by: Najda Dawid
//
// Task 1. Build from RAM_16X4 a memory module equipped with bidirectional 
// data port D. Write a testbench that verifies the operation of reading 
// and writing data to the memory component RAM_16X4 available in mem_lib.v. 
// Prepare the following tasks: 
// task MEM_WR(input A, input D); 
// task MEM_RD(input A, output D); 
// That are responsible for writing and reading data. Remember for assuring 
// the correct driving of bus lines to avoid conflicts and assure the proper 
// sequence of signals. In the testbench write a test of memory operation 
// using prepared tasks
//

`timescale 1ns/100ps



module RAM_16SP(nCS, nWE, nOE, A, D);
    input nCS, nWE, nOE;
    input [3:0] A;
    inout [3:0] D;
    wire  [3:0] Q;
    
    RAM_16X4 M1(nCS, nWE, nOE, A, D, Q);
    
    assign D = nOE ? {4{1'bz}} : Q;
    
endmodule

module MEM_TEST;
    reg nCS, nOE, nWE;
    reg  [3:0] A;
    wire [3:0] D;
    reg  [3:0] D_DRV;
    
    RAM_16SP M1(.nCS(nCS), .nWE(nWE), .nOE(nOE), .A(A), .D(D));
    
    //For writing the data use D_DRV - remember about conflicts
    assign D = D_DRV;
    
    initial begin
        $display("My testbench...");
        A = 4'b0010;
        
        MEM_WR(4'b0010, 4'b1010);
        #100;
        MEM_WR(4'b1010, 4'b0101);
        #100;
        MEM_RD(4'b0010, D_DRV);
        #100;
        MEM_WR(4'b0010, 4'b1110);
        #100;
        MEM_RD(4'b1010, D_DRV);
        #100;
        $display("Finish...");
        $finish;
    end

    initial begin
        $dumpfile("mem_test.vcd");
        $dumpvars;
        $dumpon;
    end
    
    task MEM_RD;
    input [3:0] Ain;
    output [3:0] DQ;
    begin
        nWE = 1'b1;
        nOE = 1'b1;
        nCS = 1'b0;
        D_DRV = 4'hz;
        A = Ain;
        nOE = 1'b0;
        #100;
        DQ = D;
        nOE = 1'b1;
        nCS = 1'b1;
    end
    endtask
    
    task MEM_WR;
    input [3:0] Ain;
    input [3:0] Din;
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

