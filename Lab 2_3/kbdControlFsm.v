/* The following module is for the keyboard controls FSM */

module kbdControlFsm(
    clk,            //clock cycle
    reset,          //for debugging
    keyboardIp,     //key pressed
    canReadFlash,   //indicates ready to read Flash (ie audio should be playing)
    readDone,       //indicates that read processed (to fully process restart before return to play state)
    state,          //current state
    isFwrd,         //audio playing fwrd
    restartKey,     //indicate to restart audio
    kbd_data_ready  //indicates kbd data ready
);

/*
D: stops
E: resumes
B: backwards
F: forwards
R: restart
*/

input clk, reset, kbd_data_ready, readDone;
input [7:0] keyboardIp; //as the key2ascii i/p and o/p are 8 bits
output canReadFlash, isFwrd, restartKey; 
reg canReadFlash, isFwrd, restartKey;  //Modelsim don't like if wire
output [5:0] state;

reg [5:0] state;

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

/* State declarations */
parameter idle          = 6'b000_000; 

parameter fwrd_play     = 6'b001_011;
parameter fwrd_stop     = 6'b010_010;

parameter bckwrd_play   = 6'b100_001;
parameter bckwrd_stop  = 6'b011_000;

parameter fwrd_rstrt    = 6'b101_111; 
parameter bckwrd_rstrt  = 6'b110_101;

always @(posedge clk, posedge reset) begin
    if (reset)                           state <= idle;
    else begin
    case (state)
    idle:           if((keyboardIp == character_E)||(keyboardIp ==character_lowercase_e))        state <= fwrd_play;
                    else if ((keyboardIp == character_B)||(keyboardIp == character_lowercase_b)) state <= bckwrd_play;
                    else               state <= idle;

    fwrd_play:      if ((keyboardIp == character_D)||(keyboardIp == character_lowercase_d))      state <= fwrd_stop;
                    else if ((keyboardIp == character_B)||(keyboardIp == character_lowercase_b)) state <= bckwrd_play;
                    else if ((keyboardIp == character_R)||(keyboardIp == character_lowercase_r)) begin
                        if (kbd_data_ready) //add o/w high pitch squeak
                        state <= fwrd_rstrt;
                        else state <= fwrd_play;
                    end
                    else               state <= fwrd_play;

    fwrd_stop:      if ((keyboardIp == character_B)||(keyboardIp == character_lowercase_b))      state <= bckwrd_stop;
                    else if ((keyboardIp == character_E)||(keyboardIp ==character_lowercase_e))  state <= fwrd_play;
                    else if ((keyboardIp == character_R)||(keyboardIp == character_lowercase_r)) state <= fwrd_rstrt;
                    else               state <= fwrd_stop;
    
    fwrd_rstrt:     if (readDone)                  state <= fwrd_play; //wait for restart instruction to process until return to play

    bckwrd_play:    if ((keyboardIp == character_F)||(keyboardIp == character_lowercase_f))      state <= fwrd_play;
                    else if ((keyboardIp == character_D)||(keyboardIp == character_lowercase_d)) state <= bckwrd_stop;
                    else if ((keyboardIp == character_R)||(keyboardIp == character_lowercase_r)) begin
                        if (kbd_data_ready) //add o/w high pitch squeak
                        state <= bckwrd_rstrt;
                        else state <= bckwrd_play;
                    end
                    else               state <= bckwrd_play;        //wait for restart instruction to process until return to play

    bckwrd_stop:    if ((keyboardIp == character_E)||(keyboardIp ==character_lowercase_e))      state <= bckwrd_play;
                    else if ((keyboardIp == character_F)||(keyboardIp == character_lowercase_f)) state <= fwrd_stop;
                    else if ((keyboardIp == character_R)||(keyboardIp == character_lowercase_r)) state <= bckwrd_rstrt;
                    else               state <= bckwrd_stop;

    bckwrd_rstrt:  if(readDone)                    state <= bckwrd_play;

    default:                           state <= idle;
    endcase
    end
end
always @(*) begin
    canReadFlash  = state[0];
    isFwrd   = state[1]; 
    restartKey = state[2];
end
endmodule