`timescale 10ns/100ps


module kbdControlFsm_tb();
    reg clk, reset, kbd_data_ready, readDone;
    reg [7:0] keyboardIp; //as the key2ascii i/p and o/p are 8 bits
    wire canReadFlash, isFwrd, restartKey; 
    wire [5:0] state;
/* Letter declarations */
parameter character_D           = 8'h44;
parameter character_E           = 8'h45;
parameter character_B           = 8'h42;
parameter character_F           = 8'h46;
parameter character_R           = 8'h52;
parameter character_lowercase_d = 8'h64;
parameter character_lowercase_e = 8'h65;
parameter character_lowercase_b = 8'h62;
parameter character_lowercase_f = 8'h66;
parameter character_lowercase_r = 8'h72;

kbdControlFsm dut(
    .clk(clk),              //clock cycle
    .reset(reset),          //for debugging
    .keyboardIp(keyboardIp),     //key pressed
    .canReadFlash(canReadFlash),   //indicates ready to read Flash (ie audio should be playing)
    .readDone(readDone),       //indicates that read processed (to fully process restart before return to play state)
    .state(state),          //current state
    .isFwrd(isFwrd),         //audio playing fwrd
    .restartKey(restartKey),     //indicate to restart audio
    .kbd_data_ready(kbd_data_ready)  //indicates kbd data ready
);
initial
begin
    clk = 1'b0;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    reset = 1'b0;
    readDone = 1'b1;
    kbd_data_ready = 1'b1;
    #2;
    //fwrd_play
    keyboardIp = character_E; 
    #2;
    //fwrd_stop
    keyboardIp = character_D;
    #2;
    //fwrd_play
    keyboardIp = character_E;
    #2;
    //restart
    keyboardIp = character_R;
    #2;
    //reset
    reset = 1'b1;
    #2;
    reset = 1'b0;
    #2;
    //backward play
    keyboardIp = character_B;
    #2;
    //backward stop
    keyboardIp = character_D;
    #2;
    //backward play
    keyboardIp = character_E;
    #2;
    //backward restart
    keyboardIp = character_R;
    #2;
    //reset
    reset = 1'b1;
    #2;
    reset = 1'b0;
end


endmodule