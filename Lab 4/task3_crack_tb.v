`timescale 1ns/1ps

module task3_crack_tb();
    reg clk, rst, start, found_key, next_key;

    wire start_cracking;
    wire [1:0] LED;
    wire [5:0] state;
    wire [23:0] secret_key;
    task3_crack_simulation dut (
                    .clk(clk),
                    .rst(rst),
                    .start(start),
                    .found_key(found_key),
                    .next_key(next_key),

                    .start_cracking(start_cracking),
                    .LED(LED),
                    .state(state),
                    .secret_key(secret_key)
    );

    initial begin
        clk = 1'b0;
        forever #1 clk = ~clk;
    end
    initial begin
        rst = 1'b1;
        start = 1'b0;
        #2;

        //go to scan key and stay
        rst = 1'b0;
        start = 1'b1;
        found_key = 1'b0;
        next_key = 1'b0;     
        #6;

        //go to increment
        found_key = 1'b0;
        next_key = 1'b1; 
        #10;


        //go to cracked
        found_key = 1'b1;
        next_key = 1'b0;
        #10;

        rst = 1'b1;
        //go to increment and eventually null_key
        #2;
        rst = 1'b0;
        found_key = 1'b0;
        next_key = 1'b1; 
        #10;


        
        //

    end
endmodule