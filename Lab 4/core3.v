module core3 (
    input clk,
    input start,
    input rst,

    output found_signal,
    output [1:0] core3_LED,
    output [23:0] core3_secret_key
);

    assign core3_secret_key = secret_key;
    assign found_signal = doneFsm2b;


    wire reset_n;
    wire [7:0] write_mem;
    wire [7:0] write_data;
    wire [7:0] read_data;
    wire wren;

    wire [23:0] secret_key;
    
    task3_crack3 craking (
        .clk(clk),
        .rst(rst),
        .start(start),
        .found_key(doneFsm2b),
        .next_key(reset_Fsms),

        .start_cracking(startT1),                                                                       
        .LED(core3_LED),                                                                            
        .secret_key(secret_key)                    
    );

    
    wire doneFsm1;
    wire wren_1;
    wire wren_2a;
    wire [4:0] task1State;
    wire [7:0] write_mem_1;
    wire [7:0] write_data_1;
    wire startT1;

    //task 1
    task1_init_mem initialize (
        .clk(clk),
        .rst(reset_Fsms),                      //check again
        .start(startT1),                       //will be op to controller
        .task1_init_data(write_mem_1),
        .wren_1(wren_1),     
        .doneFsm1(doneFsm1),
        .state(task1State)
    );                                      //task1 works

    wire doneFsm2a;
    wire startT2a;
    wire [11:0] task2aState;
    wire [7:0] write_data_2a;
    wire [7:0] write_mem_2a;

    //task 2a - done (NOTE: UN/COMMENT SECRET_KEY AND DONT INSTANTIATE IN MODULE)
    task2_shuffle shuffle (
       .clk(clk),                                   //input clk
       .rst(1'b0),                                  //input rst - ACTIVE LOW
       .s_memory_q(read_data),                      //task1_init_data
       .start(startT2a),                            //start FSM signal
       .secret_key(secret_key),                           //input secret key
       .doneFsm2a(doneFsm2a),                       //done FSM signal
       .wren_2a(wren_2a),                           //Write enable signal
       .s_memory_addr(write_mem_2a),                //write_mem output
       .s_memory_data(write_data_2a),               //write_data output
       .state(task2aState)
    );

    wire startT2b;
    wire doneFsm2b;
    wire [7:0] e_rom_q;
    wire [7:0] write_data_2b;
    wire [7:0] write_mem_2b;
    wire [7:0] e_rom_addr;
    wire [7:0] d_ram_addr;
    wire [7:0] d_ram_data;

    wire d_ram_wren;
    wire s_wren_2b;
    wire [15:0] decryptState;
    wire reset_Fsms;
    wire [7:0] d_memory_q;

    task2_decrypt decrypt (
       .clk(clk),
       .rst(1'b0), 
       .start(startT2b),
       .s_memory_q(read_data),                                      //this is from output of s_memory
       .e_rom_q(e_rom_q),                                           //this is from output of e_memory

       .doneFsm2b(doneFsm2b),
       .reset_Fsms(reset_Fsms),
       .s_memory_addr(write_mem_2b),                                //s_memory_addr output
       .s_memory_data(write_data_2b),                               //s_memory_data output
       .e_rom_addr(e_rom_addr),
       .d_ram_addr(d_ram_addr),
       .d_ram_data(d_ram_data),                                                 //this is decrpyted output
       .s_wren_2b(s_wren_2b),
       .d_ram_wren(d_ram_wren),
       .state(decryptState)
    );



    wire [7:0] controllerState;
    controller_fsm controlFsm (
        .clk(clk),
        .rst(reset_Fsms),
        .write_mem_1(write_mem_1),
        .write_data_1(write_data_1),
        .wren_1(wren_1),
        .write_mem_2a(write_mem_2a),
        .write_data_2a(write_data_2a),
        .wren_2a(wren_2a),
        .write_mem_2b(write_mem_2b),
        .write_data_2b(write_data_2b),
        .s_wren_2b(s_wren_2b),
        .doneTask1(doneFsm1),
        .doneTask2a(doneFsm2a),
        .doneTask2b(doneFSm2b),
        //.startTask1(startT1),
        .startTask2a(startT2a),
        .startTask2b(startT2b),
        .write_mem(write_mem),
        .write_data(write_data),
        .wren(wren),
        .state(controllerState)
    );

    core3_s_memory working_memory (
        .clock(clk),                                                //input clock
	    .address(write_mem),                                        //input address
	    .data(write_data),                                           //input write data to memory
	    .wren(wren),                                                //input write signal
	    .q(read_data)                                               //output data at input address
    );

    core3_D_RAM d_memory (
        .address(d_ram_addr),
        .clock(clk),
        .data(d_ram_data),
        .wren(d_ram_wren),
        .q(d_memory_q)
    );

    core3_E_ROM e_memory(
            .address(e_rom_addr),
            .clock(clk),
            .q(e_rom_q)
    );

endmodule