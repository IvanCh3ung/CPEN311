/* This module implements the following code*/

/* 
// compute one byte per character in the encrypted message. You will build this in Task 2
i = 0, j=0
for k = 0 to message_length-1 { // message_length is 32 in our implementation
i = i+1
j = j+s[i]
swap values of s[i] and s[j]
f = s[ (s[i]+s[j]) ]
decrypted_output[k] = f xor encrypted_input[k] // 8 bit wide XOR function
}
*/
module task2_decrypt (
    input clk,
    input rst, 
    input start,
    input reg [7:0] s_memory_q, //this is from output of s_memory
    input reg [7:0] e_rom_q,    //this is encrypted input

    output doneFsm2b,
    output reset_Fsms,
    output reg [7:0] s_memory_addr,             //s_memory_addr output
    output reg [7:0] s_memory_data,            //s_memory_data output
    output reg [7:0] e_rom_addr,
    output reg [7:0] d_ram_addr,
    output reg [7:0] d_ram_data,                //this is decrpyted output
    output s_wren_2b,
    output d_ram_wren,
    output reg [17:0] state

);

/* State parameters */
parameter idle              = 18'b0000_100_000_00_000_000;  //idle state

parameter incrementI        = 18'b0001_000_000_00_000_001;  //increment i
parameter setAddrI          = 18'b0010_000_000_01_000_000;  //set address to I
parameter getDataI          = 18'b0011_000_000_00_001_000;  //read from address i and store in si

parameter changeJ           = 18'b0100_000_000_00_000_010;  //change j      
parameter setAddrJ          = 18'b0101_000_000_10_000_000;  //set address to j    
parameter getDataJ          = 18'b0110_000_000_00_010_000;  //read from address j and store in sj           

parameter swap_jToi         = 18'b0111_000_011_01_000_000;  //set address to i and write sj
parameter swap_iToj         = 18'b1000_000_010_10_000_000;  //set address to j and write si                                              

parameter setAddrF          = 18'b1010_000_000_11_000_000;  //set address to s[i] + s[j]
parameter getDataF          = 18'b1011_000_000_00_100_000;  //read from address si + sj and store in f

parameter loadDecrypted     = 18'b1100_000_100_00_000_000;  //store decrypted msg 

parameter incrementK        = 18'b1101_000_000_00_000_100;  //increment k

parameter finished          = 18'b1110_001_000_00_000_000;  //finished!

parameter not_key           = 18'b1111_010_000_00_000_000;


reg [7:0] i                 = 8'b0;
reg [7:0] j                 = 8'b0;
reg [7:0] k                 = 8'b0;


//registers to store data
reg [7:0] f;
reg [7:0] si;
reg [7:0] sj;

reg [7:0] check_data;

//State logic
always @(posedge clk, posedge rst) begin
    if (rst) state <= idle;
    else begin
        case(state)
        idle:           if (start)                              state <= incrementI;
                        else                                    state <= idle;

        incrementI:                                             state <= setAddrI;
        setAddrI:                                               state <= getDataI;
        getDataI:                                               state <= changeJ;

        changeJ:                                                state <= setAddrJ;
        setAddrJ:                                               state <= getDataJ;
        getDataJ:                                               state <= swap_jToi;

        swap_jToi:                                              state <= swap_iToj;
        swap_iToj:                                              state <= setAddrF;

        setAddrF:                                               state <= getDataF;
        getDataF:                                               state <= loadDecrypted;

        loadDecrypted: begin
                        if((check_data < 97 || check_data > 122)) 
                            if (check_data!=32)                 state <= not_key;                 
                            else                                state <= incrementK;
                        else                                    state <= incrementK;
        end

        //loadDecrypted: state <= incrementK;

        incrementK:     if (k == 8'd31) state <= finished;
                        else            state <= incrementI;

        finished:                       state <= finished;

        not_key:                        state <= idle;

        default:                        state <= idle;

        endcase
    end
end


/* Internal signal logic*/

//increments i
always@ (posedge clk) begin
    if (reset_var)  i <= 0;
    else if (incI)       i <= i + 8'b1;
    else if (rst| doneFsm2b)  i <= 0;
end

//updates j
always @(posedge clk) begin
    if (reset_var)  j <= 0;
    else if (chgJ)       j <= j + si; //j = j + s[i]
    else if (rst| doneFsm2b)  j <= 0;
end

//increments k
always @(posedge clk) begin
    if (reset_var)  k <= 0;
    else if (incK)       k <= 8'b1 + k; //k = k + 1
    else if (rst|doneFsm2b)  k <= 0;
end



//store si
always @(posedge clk) begin
    if (store_si)   si <= s_memory_q;

end

//store sj
always @(posedge clk) begin
    if (store_sj)   sj <= s_memory_q;

end

//store f
always @(posedge clk) begin
    if (store_f)   f <= s_memory_q;
end

//needs right timing for output
always @(*) begin
   case(select_writeMem)
   2'b01: s_memory_addr = i;
   2'b10: s_memory_addr = j;
   2'b11: s_memory_addr = si + sj;
	default: s_memory_addr = 8'b0;
   endcase 
end

assign s_memory_data = select_writeData_sj ? sj : si;


reg incI;
reg chgJ;
reg incK;
reg reset_var;
reg store_si;
reg store_sj;
reg store_f;
reg select_writeData_sj;
reg [1:0] select_writeMem; 

always @(*) begin
    d_ram_data = f ^ e_rom_q;
    check_data = f ^ e_rom_q;
    e_rom_addr = k;
    d_ram_addr = k;
    
    incI = state[0];
    chgJ = state[1];
    incK = state[2];

    store_si = state[3];
    store_sj = state[4];
    store_f = state[5];

    select_writeMem = {state[7],state[6]};

    select_writeData_sj = state[8];
    s_wren_2b = state[9];
    d_ram_wren = state [10];
    
    doneFsm2b = state[11];
    reset_Fsms = state[12];
    reset_var = state[13];
end

    
endmodule