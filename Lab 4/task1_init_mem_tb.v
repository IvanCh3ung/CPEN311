`timescale 1ns/1ps

module task1_init_mem_tb ();
    reg clk, rst, start;
    wire [7:0] task1_init_data;       //output data
    wire doIncrement;                 //signal to increment
    wire doneFsm1;                    //signal indicating done FSM
    wire [3:0] state;                  //state signal for debugging
    wire wren_1;

    task1_init_mem dut (.clk(clk),
                        .rst(rst),
                        .start(start),
                        .wren_1(wren_1),
                        .task1_init_data(task1_init_data),
                        .doIncrement(doIncrement),
                        .doneFsm1(doneFsm1),
                        .state(state)
                      );
    
    initial begin
        clk = 1'b0;
        forever begin
            #0.1 clk = ~clk;
        end
    end
    initial begin
        rst = 1'b1;
        #2;
        rst = 1'b0;
        start = 1'b1;
    end
endmodule