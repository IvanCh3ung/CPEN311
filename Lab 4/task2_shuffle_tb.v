`timescale 1ns/1ps

module task2_shuffle_tb ();

reg clk, rst, start;
reg [7:0] s_memory_q;
reg [23:0] secret_key;

wire doneFsm2b, wren_2a;
wire [7:0] s_memory_addr, s_memory_data;
wire [11:0] state;

task2_shuffle dut ( .clk(clk),                              //input clk
                       .rst(rst),                              //input rst - ACTIVE LOW
                       .s_memory_q(s_memory_q),                 //read_data from s_memory 
                       .start(start),                            //signal to start FSM
                       .secret_key(secret_key),               //input secret key
                       
                       .doneFsm2a(doneFsm2a),                       //signal to say FSM done
                       .wren_2a(wren_2a),                         //Write enable signal
                       .s_memory_addr(s_memory_addr),         //provides input to s_memory of addr to read/write at
                       .s_memory_data(s_memory_data),            //provdes input to s_memory of data to write at
                       .state(state)                  //state signal
        
);

initial begin
    clk = 1'b0;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    rst = 1'b1;
    start = 1'b0;
    secret_key = 24'h000249;
    #2;
    start = 1'b1;
    rst = 1'b0;
    s_memory_q = 8'd100;
    #10;
    s_memory_q = 8'd200;
    #10;
    s_memory_q = 8'd100;
    #10;
    s_memory_q = 8'd200;
    #10;
    s_memory_q = 8'd100;
    #10;
    s_memory_q = 8'd200;
    #10;
    s_memory_q = 8'd100;
    #10;
    s_memory_q = 8'd200;
    #10;
    s_memory_q = 8'd100;
    #10;
    s_memory_q = 8'd200;
    #10;
    s_memory_q = 8'd100;
    #10;
    s_memory_q = 8'd200;
    #10;
    s_memory_q = 8'd100;
    #10;
    s_memory_q = 8'd200;
    #10;
    s_memory_q = 8'd100;
    #10;
    s_memory_q = 8'd200;
    #10;
    s_memory_q = 8'd100;
    #10;
    s_memory_q = 8'd200;
    #10;
    
    
end


endmodule