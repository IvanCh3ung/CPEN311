`timescale 1ns / 1ps
module Generate_Arbitrary_Divided_Clk32(inclk,outclk,outclk_Not,div_clk_count,Reset);
    input inclk;
	 input Reset;
    output outclk;
	 output outclk_Not;
	 input[31:0] div_clk_count;
	 
	 var_clk_div32 Div_Clk(.inclk(inclk),.outclk(outclk),
	 .outclk_not(outclk_Not),.clk_count(div_clk_count),.Reset(Reset));

endmodule
