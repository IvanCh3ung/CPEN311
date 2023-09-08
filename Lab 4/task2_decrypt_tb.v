`timescale 1ns/1ps

//testbench for t2b

module task2_decrypt_tb ();
    reg clk;
    reg rst; 
    reg start;
    reg [7:0] s_memory_q; //this is from output of s_memory
    reg [7:0] e_rom_q;    //this is encrypted input

    wire doneFsm2b;
    wire [7:0] s_memory_addr;             //s_memory_addr output
    wire [7:0] s_memory_data;            //s_memory_data output
    wire [7:0] e_rom_addr;
    wire [7:0] d_ram_addr;
    wire [7:0] d_ram_data;                //this is decrpyted output
    wire s_wren_2b;
    wire d_ram_wren;
    wire [15:0] state;

    task2_decrypt dut (
                          .clk(clk),
                          .rst(rst), 
                          .start(start),
                          .s_memory_q(s_memory_q), //this is from output of s_memory
                          .e_rom_q(e_rom_q),    //this is encrypted input
                      
                          .doneFsm2b(doneFsm2b),
                          .s_memory_addr(s_memory_addr),             //s_memory_addr output
                          .s_memory_data(s_memory_data),            //s_memory_data output
                          .e_rom_addr(e_rom_addr),
                          .d_ram_addr(d_ram_addr),
                          .d_ram_data(d_ram_data),                //this is decrpyted output
                          .s_wren_2b(s_wren_2b),
                          .d_ram_wren(d_ram_wren),
                          .state(state)
    );


    initial begin
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

     initial begin
       rst = 1'b1;
        start = 1'b0;
        #2;
        rst = 1'b0;
        start = 1'b1;

        s_memory_q  = 8'd10;
        e_rom_q     = 8'd20;
        #20;
        s_memory_q  = 8'd30;
        e_rom_q     = 8'd40;
        #20;
        s_memory_q  = 8'd50;
        e_rom_q     = 8'd60;
        #20;
        s_memory_q  = 8'd70;
        e_rom_q     = 8'd80;
        #20;
        s_memory_q  = 8'd90;
        e_rom_q     = 8'd100;
        #20;
        s_memory_q  = 8'd110;
        e_rom_q     = 8'd120;
        #20;
        s_memory_q  = 8'd30;
        e_rom_q     = 8'd40;
        #20;
        s_memory_q  = 8'd50;
        e_rom_q     = 8'd60;
        #20;
        s_memory_q  = 8'd70;
        e_rom_q     = 8'd80;
        #20;
        s_memory_q  = 8'd90;
        e_rom_q     = 8'd100;
        #20;
        s_memory_q  = 8'd110;
        e_rom_q     = 8'd120;
        #20;
        s_memory_q  = 8'd30;
        e_rom_q     = 8'd40;
        #20;
        s_memory_q  = 8'd50;
        e_rom_q     = 8'd60;
        #20;
        s_memory_q  = 8'd70;
        e_rom_q     = 8'd80;
        #20;
        s_memory_q  = 8'd90;
        e_rom_q     = 8'd100;
        #20;
        s_memory_q  = 8'd110;
        e_rom_q     = 8'd120;
        #20;

    end
endmodule