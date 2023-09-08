`timescale 1ns/10ps

/*
test bench for the clock divider
*/
module clkdiv_tb();
reg inclk;
reg [31:0] div_clk_count;
wire outclk;
clkdiv dut(.inclk(inclk), .outclk(outclk), .div_clk_count(div_clk_count));

/*inclk declaration*/
initial begin
    inclk = 1'b0;
    forever #1 inclk = ~inclk;
    
end
    
initial begin
    div_clk_count = 32'd2;
    #50;
    div_clk_count = 32'd4;
    #100;
    div_clk_count = 32'd8;
    #500;
end

endmodule