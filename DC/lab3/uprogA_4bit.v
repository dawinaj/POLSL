// Performed by: Najda Dawid
//
// Task 2. Implement two versions of a micro-programmable 
// finite state machine (FSM) working according to the given state diagram.
// Use only ROM and Register
// Create a testbench to verify the operation of both circuits. In the testbench
// assure going through all transitions. 
// Report in the console using $display task the state change.


`timescale 1ns/100ps

module UPROG_A(CLK, CLR, A, B, X, Y);
    //Symbolic states declaration - Encoding
    parameter S1 = 2'b00;
    parameter S2 = 2'b01;
    parameter S3 = 2'b10;
    parameter S4 = 2'b11;
    //Outputs declaration
    parameter S1o = 2'b01;
    parameter S2o = 2'b11;
    parameter S3o = 2'b00;
    parameter S4o = 2'b10;
    input CLK, CLR;
    input A, B;
    output X, Y;
    wire [1:0] Q, nextQ;
    
    // Parameterized register
    REG #(.W(2)) R1(CLK, CLR, nextQ, Q);
    
    // Parameterized memory
    ROM #(.D_W(4), .A_W(4)) M1({Q, A, B}, {nextQ, X, Y});
    
    initial begin
        M1.SET({S1, 1'b0, 1'b0}, {S2, S1o});
        M1.SET({S1, 1'b0, 1'b1}, {S3, S1o});
        M1.SET({S1, 1'b1, 1'b0}, {S2, S1o});
        M1.SET({S1, 1'b1, 1'b1}, {S3, S1o});
        
        M1.SET({S2, 1'b0, 1'b0}, {S4, S2o});
        M1.SET({S2, 1'b0, 1'b1}, {S4, S2o});
        M1.SET({S2, 1'b1, 1'b0}, {S4, S2o});
        M1.SET({S2, 1'b1, 1'b1}, {S4, S2o});
        
        M1.SET({S3, 1'b0, 1'b0}, {S2, S3o});
        M1.SET({S3, 1'b0, 1'b1}, {S2, S3o});
        M1.SET({S3, 1'b1, 1'b0}, {S3, S3o});
        M1.SET({S3, 1'b1, 1'b1}, {S3, S3o});
        
        M1.SET({S4, 1'b0, 1'b0}, {S3, S4o});
        M1.SET({S4, 1'b0, 1'b1}, {S1, S4o});
        M1.SET({S4, 1'b1, 1'b0}, {S3, S4o});
        M1.SET({S4, 1'b1, 1'b1}, {S1, S4o});
    end
endmodule

module UPROG_A_TEST;
    reg CLK, CLR, A, B;
    wire X, Y;

    //Unit Under Test
    UPROG_A UUT(.CLK(CLK), .CLR(CLR), .A(A), .B(B), .X(X), .Y(Y));

    //Main test vector generator
    initial begin
        A = 1'b0;
        B = 1'b0;
        CLR = 1'b1;
        repeat(2) @(negedge CLK);
        CLR = 1'b0;
        repeat(4) @(negedge CLK);
        
        A = 1'b0;
        B = 1'b1;
        CLR = 1'b1;
        repeat(2) @(negedge CLK);
        CLR = 1'b0;
        repeat(4) @(negedge CLK);
        
        A = 1'b1;
        B = 1'b0;
        CLR = 1'b1;
        repeat(2) @(negedge CLK);
        CLR = 1'b0;
        repeat(4) @(negedge CLK);
        
        A = 1'b1;
        B = 1'b1;
        CLR = 1'b1;
        repeat(2) @(negedge CLK);
        CLR = 1'b0;
        repeat(4) @(negedge CLK);
        
        $finish;
    end
    
    // Clock generator
    initial begin
        CLK = 1'b0;
        forever #50 CLK = ~CLK;
    end
    
    initial begin
        $dumpfile("uprog_a.vcd");
        $dumpvars;
        $dumpon;
        $monitor("AB=%b%b, xy=%b%b", A, B, X, Y);
    end
    
    //State change reporter ...
    reg [1:0] last_Q;
    always @(UUT.Q) begin
        $display("State change: %d -> %d", last_Q, UUT.Q);
        last_Q = UUT.Q;
    end
endmodule
