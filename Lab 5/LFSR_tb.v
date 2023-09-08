`timescale 1ns/1ps

module LFSR_tb();
reg clk, rst;
wire [4:0] lfsr;

LFSR dut (.clk(clk), 
          .rst(rst),  
          .lfsr(lfsr)
          );

    initial begin
        clk = 1'b01;
        forever #1 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        #2;
        rst = 1'b0;
    end
endmodule