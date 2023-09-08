/* The following module is for task 3*/

// Input:
// start: the start signal to start cracking
// found_key: input signal indicates that correct secret key is found
// next_key: input signal indicates that previous key is not the secret key
// Output:
// start_cracking: output to input task1_initialize to start initializing memory
// LED: output when done cracking
// secret_key: output the current scanning key

module task3_crack3 (
    input clk,
    input rst,
    input start,
    input found_key,
    input next_key,

    //output reg reset_Fsms,                                                                           
    output reg start_cracking,                                                                       
    output reg [1:0] LED,    
    output reg [5:0] state,                                                                        
    output [23:0] secret_key                    
);

    reg [23:0] current_key = 24'h1FFFFE;                                                                     //scanning key

    reg incKey;

    //state parameters
    parameter idle          = 6'b000_0000;                                                            //idle state
    parameter scan          = 6'b001_0001;                                                           //checks key
    parameter increment     = 6'b010_1001;                                                            //scan next key
    parameter null_key      = 6'b100_0100;                                                            //no found
    parameter cracked       = 6'b101_0010;                                                            //found key

	 
    always @(posedge clk, posedge rst) begin
        if (rst)                                                  state <= idle;                    //go to idle if rst is assert
        else                        
            case (state)                
            idle:       if (start)                                state <= scan;                    //go to scan if start is assert
                        else                                      state <= idle;                    //stay idle if start is not assert    

            scan: begin 
                        if (found_key)                            state <= cracked;                 //go to cracked if found key
                        else if (next_key) begin    
                            if (current_key == 24'h2FFFFC)        state <= null_key;                //go to null_key if no found key
                            else                                  state <= increment;               //go to increment if there still key need to searched
                        end 
                        else                                      state <= scan;                    //stay if not done scanning
            end 

            increment:                                            state <= scan;           //go to hold state to wait for FSM to reset

            null_key:                                             state <= null_key;                //stay at null_key 

            cracked:                                              state <= cracked;                 //stay at cracked
            endcase 
    end

    always @(posedge clk) begin
        if (incKey)        current_key <= current_key + 24'd1;
        else               current_key <= current_key;
    end

    always @(*) begin
         start_cracking   = state [0];                                                        //send start signal to initialize memory 

         LED              = {state[2], state[1]};                                             //display leds if found/no found key

         incKey           = state [3];  
         //reset_Fsms       = state [4];
    end          
    
    assign secret_key     = current_key;                                                      //output key need to scan

endmodule


