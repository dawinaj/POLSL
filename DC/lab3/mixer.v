// Performed by: Najda Dawid
//
// Task 4. Design a micro-programmable finite state machine to control the process
// of preparing the mixture for filling the cyclically supplied foundry molds.
// Pour the substance into the empty mixer through the open valve V1. After the 
// substance in the mixer reaches the level L2 (L2 = 1), cut off its supply and 
// turn on the heater H and the stirrer S. The substance mixing process should 
// take 17 minutes. The clock period is 5 sec (delay of 204 clock cycles). During 
// this process, on-off temperature control is to be used, i.e. the heater H should 
// be turned on when Temp = 0 and turned off when Temp = 1 (Temp is the output signal 
// of the temperature sensor installed in the mixer). After finishing the substance 
// mixing, turn off the heater and empty the mixer through valve V2 while still 
// stirring the substance. After emptying the mixer (L1 = 0), turn off the stirrer S
// and close the V2 valve and then start the whole procedure of preparing a new 
// portion of the substance from the beginning.
// In your design try to use a ROM with the lowest possible capacity and word length.
// Link your controller with the delivered model in the MIXER_TEST module. 
// Remember to initialize your controller by applying CLR pulse and respectively 
// code initial state. Your controller should interact with the model.

`timescale 100ms/10ms

module MIXER_CTRL(CLK, CLR, L1, L2, TEMP, V1, V2, H, S);
//Enumerate states using parameters e.g. parameter S1 = 0;
    parameter S0  = 3'b000;
    parameter S1T = 3'b001;
    parameter S1C = 3'b010;
    parameter S2T = 3'b011;
    parameter S2C = 3'b100;
    parameter S3  = 3'b101;
    
    parameter S0o = 5'b01000;
    parameter S1o = 5'b10011;
    parameter S2o = 5'b10001;
    parameter S3o = 5'b00101;
    
    //Interface
    input CLK, CLR;
    input L1, L2, TEMP;
    output V1, V2, H, S;
    wire [2:0] Q, nextQ;
    wire W;
    wire T_EN;
    wire Cntr; //Counter has finished counting
    
    // Parameterized register
    REG #(.W(3)) R1(CLK, CLR, nextQ, Q);
    
    // Input mux
    MUX8 INM(W, Q, {2'b0, L1, Cntr, TEMP, Cntr, TEMP, L2});
    
    // Parameterized memory
    ROM #(.D_W(8), .A_W(4)) M1({Q, W}, {nextQ, T_EN, V1, V2, H, S});
    
    //Timer instance
    TIMER T1(.CLK(CLK), .EN(T_EN), .T(8'd15), .TMO(Cntr));
    
initial begin
    //Initialize ROM memory using SET task
    M1.SET({S0,  1'b0}, {S0,  S0o});
    M1.SET({S0,  1'b1}, {S1T, S0o});
    
    M1.SET({S1T, 1'b0}, {S1C, S1o});
    M1.SET({S1T, 1'b1}, {S2T, S1o});
    
    M1.SET({S1C, 1'b0}, {S1T, S1o});
    M1.SET({S1C, 1'b1}, {S3,  S1o});
    
    M1.SET({S2T, 1'b0}, {S2C, S2o});
    M1.SET({S2T, 1'b1}, {S1T, S2o});
    
    M1.SET({S2C, 1'b0}, {S2T, S2o});
    M1.SET({S2C, 1'b1}, {S3,  S2o});
    
    M1.SET({S3,  1'b0}, {S0,  S3o});
    M1.SET({S3,  1'b1}, {S3,  S3o});
end

endmodule

module MIXER_TEST;

parameter L_MAX = 100;
parameter L_ERR = 110;
parameter T_MIN = 250;
parameter T_MAX = 260;
parameter T_ERR = 270;
parameter T_INL = 220;
parameter TM_MIN = 194;
parameter TM_MAX = 214;

reg CLK, CLR;
reg L1, L2, TEMP;
wire V1, V2, H, S;


MIXER_CTRL UUT(
    .CLK(CLK), .CLR(CLR), 
    /* Inputs */
    .L1(L1), .L2(L2), .TEMP(TEMP),
    /* Outputs */    
    .V1(V1), .V2(V2), .H(H), .S(S));

integer TMR;

//Main test vector generator
initial begin
    CLR = 1'b1;
    repeat(2) @(negedge CLK);
    CLR = 1'b0;
    
    repeat(1000) @(negedge CLK);

    $display("Simulation finish...");
    $finish;

end

// Clock generator
initial begin
    CLK = 1'b0;
    forever #25 CLK = ~CLK;
end

initial begin
    $dumpfile("mixer.vcd");
    $dumpvars;
    $dumpon;    
end

//Mixere model
integer L;
integer T;
integer TM;

initial begin
    L = 0;
    T = T_MIN;
    TM = T_INL;
    TEMP = 1'b0;
end

always @(negedge CLK) begin
    if(V1 === 1'b1) begin
        L = L + 1;
        if(L >= L_ERR)
            $display("Process Error: Tank overflow.");
    end
    if(V2 === 1'b1) begin
        if(L > 0) L = L - 1;
        if(L2 === 1'b1) begin
            if(T < T_MIN)
                $display("Process Error: Mixture is not heated enough before placing in the mold.");
            if(S !== 1'b1)
                $display("Process Error: Mixture is not mixed.");
            if(TM < TM_MIN)
                $display("Process Error: Mixture preparation time to short.");
            if(TM > TM_MAX)                
                $display("Process Error: Mixture preparation time to long.");
        end
    end
    if(L2) begin
        TM = TM + 1;
    end
    else
        TM = 0;
    //Reinitialize tank temperature
    if(~L1)
        T = T_INL;
    if((V1 === 1'b1) && (V2 === 1'b1))
        $display("Process Error: Simultaneus fillin and empting the tank (V1 = V2 = 1).");
    L2 = (L >= L_MAX);
    L1 = (L > 0);    
    if(H === 1'b1) begin
        if(L2 === 1'b0) begin
            $display("Process Error: Only when tank is full heater can be turned on");
        end
        if(S === 1'b0)
            $display("Process Error: Stirer does not work.");
        if(T > T_ERR)            
            $display("Process Error: Mixture oveheated.");
        else 
            T = T + 1;
    end
    else if(H === 1'b0) begin
        if(T > T_INL) begin
            T = T - 1;            
        end
    end
    //Hysteresis
    TEMP = TEMP ? (T > T_MIN) : (T >= T_MAX);    
end

endmodule

