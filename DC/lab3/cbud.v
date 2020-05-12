// Perforemd by: Najda Dawid
//
// Write a model of a 4 bit up-down (reversible) binary counter.  
// Implement the counter in the form of a micro-programmable circuit 
// using components from the delivered library. Create a test bench to 
// verify circuit (operation) operation. Prove wrapping around of counter 
// in both direction and counting direction change
//

`timescale 1ns/100ps

//CBUD - Counter Binary Up Down
module CBUD(CLK, CLR, DIR, Q);
    //Symbolic states declaration - Encoding
    parameter S0 = 4'b0000;
    parameter S1 = 4'b0001;
    parameter S2 = 4'b0010;
    parameter S3 = 4'b0011;
    parameter S4 = 4'b0100;
    parameter S5 = 4'b0101;
    parameter S6 = 4'b0110;
    parameter S7 = 4'b0111;
    input CLK; //Clock input
    input CLR; //Clear input - when asserted place counter in state 3'b000
    input DIR; //Counting direction input 
    output [2:0] Q; //Output and internal state of the machine
    wire [2:0] nextQ;
    
    // Parameterized memory
    ROM #(.D_W(3), .A_W(4)) M1(.A({Q,DIR}), .Q(nextQ));
    
    // Parameterized register
    REG #(.W(3)) R1(.CLK(CLK), .CLR(CLR), .D(nextQ), .Q(Q));
    
    initial begin // dir = 0 -> up
        //Initializing ROM memory using SET task
        M1.SET({S0,1'b0}, S1);
        M1.SET({S0,1'b1}, S7);
        M1.SET({S1,1'b0}, S2);
        M1.SET({S1,1'b1}, S0);
        M1.SET({S2,1'b0}, S3);
        M1.SET({S2,1'b1}, S1);
        M1.SET({S3,1'b0}, S4);
        M1.SET({S3,1'b1}, S2);
        M1.SET({S4,1'b0}, S5);
        M1.SET({S4,1'b1}, S3);
        M1.SET({S5,1'b0}, S6);
        M1.SET({S5,1'b1}, S4);
        M1.SET({S6,1'b0}, S7);
        M1.SET({S6,1'b1}, S5);
        M1.SET({S7,1'b0}, S0);
        M1.SET({S7,1'b1}, S6);
    end
endmodule


module CBUD_TEST;

reg CLK; //Clock signal
reg CLR; //Clear input - when asserted place counter in state 3'b000
reg DIR; //Counting direction input 
wire [2:0] Q; //Output and internal state of the machine    
    
//Unit Under Test
CBUD UUT(.CLK(CLK), .CLR(CLR), .DIR(DIR), .Q(Q));

//Main test vector generator
initial begin
    DIR = 1'b0;
    CLR = 1'b1;
    repeat(3) @(negedge CLK);
    CLR = 1'b0;
    
    repeat(10) @(negedge CLK);
    
    DIR = 1'b1;
    repeat(10) @(negedge CLK);
    $finish;
end

// Clock generator
initial begin
    CLK = 1'b0;
    forever #50 CLK = ~CLK;
end

initial begin
    $dumpfile("cbud.vcd");
    $dumpvars;
    $dumpon;
    //Complete monitor statement here to show that your counter operates properly
    $monitor("S=%b%b%b, D=%b ", Q[2], Q[1], Q[0], DIR);
end

endmodule

