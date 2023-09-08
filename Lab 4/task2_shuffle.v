
/*
// Input:
// secret_key [] : array of bytes that represent the secret key. In our implementation,
// we will assume a key of 24 bits, meaning this array is 3 bytes long
// encrypted_input []: array of bytes that represent the encrypted message. In our
// implementation, we will assume the input message is 32 bytes
// Output:
// decrypted _output []: array of bytes that represent the decrypted result. This will
// always be the same length as encrypted_input [].


// shuffle the array based on the secret key. You will build this in Task 2
j = 0
for i = 0 to 255 {
j = (j + s[i] + secret_key[i mod keylength] ) //keylength is 3 in our impl.
swap values of s[i] and s[j]
}


*/
module task2_shuffle (
    input clk,                                                                  //input clk
    input rst,                                                                  //input rst - ACTIVE LOW
    input [7:0] s_memory_q,                                                     //read_data from s_memory 
    input start,                                                                //signal to start FSM
    input [23:0] secret_key,                                                  //input secret key
    output doneFsm2a,                                                           //signal to say FSM done
    output wren_2a,                                                             //Write enable signal
    output  [7:0] s_memory_addr,                                                //provides input to s_memory of addr to read/write at
    output  [7:0] s_memory_data,                                                //provdes input to s_memory of data to write at
    output reg [11:0] state                                                     //state signal
);

    reg [1:0] indexSecretKey;
    reg [7:0] secret_key_data;

    reg [7:0] i = 8'b0;            
    reg [7:0] j = 8'b0;

    reg [7:0] si;
    reg [7:0] sj;

    

// j = (j + s[i] + secret_key[i mod keylength] ) //keylength is 3 in our impl.
// swap values of s[i] and s[j]

    /* State parameters */

    parameter idle          = 12'b0000_0000_0000;                               //idle state

    parameter setAddrI      = 12'b0001_0000_0000;                               //set address to i
    parameter getDataI      = 12'b0010_0000_0100;                               //read from address i and store in si



    parameter computeJ      = 12'b0101_0010_0000;                               //compute j

    parameter setAddrJ      = 12'b0110_0100_0000;                               //set address to j
    parameter getDataJ      = 12'b0111_0000_1000;                               //read from address j and store in sj


    parameter swap_iToj     = 12'b1010_0101_0000;                               //select address j and write s[i]
    parameter swap_jToi     = 12'b1011_1001_0000;                               //select address i and write s[j]

    parameter incrementI    = 12'b1100_0000_0010;                               //increment index
    parameter finished      = 12'b1101_0000_0001;                               //finshed!



    
    /* State logic*/
    always @(posedge clk, posedge rst) begin
        if (rst) state <= idle;
        else begin
            case (state)
                idle: if (start)             state <= setAddrI;                 //start once fsm taks1 done
                      else                   state <= idle;                     //stay if fsm task1 is not done

                setAddrI:                    state <= getDataI;                 //set i index 
                getDataI:                    state <= computeJ;                 //gets and store in s[i]
               
                computeJ:                    state <= setAddrJ;                 //compute swap index j
                setAddrJ:                    state <= getDataJ;                 //set j index 
                getDataJ:                    state <= swap_iToj;                //get data stored at j
                
                swap_iToj:                   state <= swap_jToi;                //swap data at i to j
                swap_jToi:                   state <= incrementI;               //swap data at j to i 

                incrementI: if (i == 8'd255) state <= finished;                 //go to finish if done swapping
                            else             state <= setAddrI;                 //keep swaping if not done
                finished:                    state <= idle;
                default:                     state <= idle;                     //set default state to idle
            endcase
        end
    end

/* Internal signal logic */

//compute indexSecretKey
    // always @(*) begin
    //     indexSecretKey = i % 8'd3;
    // end

//key position logic
    always @(*) begin
        case (i % 8'd3) //i % scret_key_length
            2'b00:   secret_key_data = secret_key [23:16];
            2'b01:   secret_key_data = secret_key [15:8];
            2'b10:   secret_key_data = secret_key [7:0];
            default: secret_key_data = 8'b0;
        endcase
    end

reg incI, updateJ;


//increment i
always @(posedge clk) begin
    if (incI)                 i <= i + 8'd1;
    else if (rst | doneFsm2a) i <= 0;
end

//update j
always @ (posedge clk) begin
    if (updateJ)                j <= j + si + secret_key_data;
    else if (rst | doneFsm2a)   j <= 0;
end



reg setSi, setSj;


//set si to s_memory_q
always @(posedge clk) begin
    if (setSi)      si <= s_memory_q;
end

//set sj to s_memory_q
always @(posedge clk) begin
    if (setSj)      sj <= s_memory_q;
end


reg sel_s_memory_address_j, sel_s_memory_data_sj;


/* Output logic*/
always@(*) begin
    
    incI                    = state[1];
    setSi                   = state[2];
    setSj                   = state[3];

    
    updateJ                 = state[5];
    sel_s_memory_address_j  = state[6];
    sel_s_memory_data_sj    = state[7];
end



//if statements seemed to cause issues - use ternary
assign s_memory_addr = sel_s_memory_address_j   ? j : i;
assign s_memory_data = sel_s_memory_data_sj     ? sj : si;
//do assign for below - ModelSim throws error otherwise
assign doneFsm2a               = state[0];
assign wren_2a                 = state[4];


endmodule

