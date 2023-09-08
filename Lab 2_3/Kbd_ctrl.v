`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:42:09 03/11/2008 
// Design Name: 
// Module Name:    Kbd_ctrl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
 
module Kbd_ctrl(kbd_clk, kbd_data, clk, received_data, reset_kbd_reg, data_ready, 
old_kbd_data, very_old_kbd_data, extended, scan_code);

    input kbd_clk; 
    input kbd_data; 
    input clk;
    output [10:0] received_data; 
    input reset_kbd_reg;
    output data_ready;
	 output [10:0] old_kbd_data;
	 output [10:0] very_old_kbd_data;
	 output [7:0] scan_code;
	 output extended;
 
    parameter EXTENDED_SCAN_CODE=8'hE0;
    parameter KEY_UP_SCAN_CODE=8'hF0;
	 wire data_ready_clk_reset, data_ready_clk_enable;
	 reg [10:0] kbd_reg, old_kbd_reg, very_old_kbd_reg;
	 reg [5:0] bit_count;
	 reg extended;
	 reg data_ready;
	 assign received_data = kbd_reg;
	 
	 wire[7:0] scan_code;
	 assign scan_code[7:0] = {kbd_reg[2],kbd_reg[3],kbd_reg[4],kbd_reg[5],kbd_reg[6],kbd_reg[7],kbd_reg[8],kbd_reg[9]};

	 async_trap_and_reset ensure_data_ready_hold(.async_sig(~kbd_clk), .outclk(~clk), .out_sync_sig(data_ready_clk_enable), 
				.auto_reset(1'h1), .reset(1'h1));

	 async_trap_and_reset ensure_data_ready_reset(.async_sig(~reset_kbd_reg), .outclk(~clk), .out_sync_sig(data_ready_clk_reset), 
				.auto_reset(1'h1), .reset(1'h1));
				
	 always @ (negedge kbd_clk)
	 begin //this is a shift register
			
		    kbd_reg <= {kbd_reg[9:0],kbd_data};
	 end
	
    always @ (negedge kbd_clk)
	 begin	
			    old_kbd_reg <= {old_kbd_reg[9:0],kbd_reg[10]};		
	 end
	
	
    always @ (negedge kbd_clk)
	 begin
				    very_old_kbd_reg <= {very_old_kbd_reg[9:0],old_kbd_reg[10]};
	 end
	
	 always @ (negedge kbd_clk or posedge data_ready_clk_reset)
	 begin
			if (data_ready_clk_reset)
			begin 
			    bit_count <= 4'h0;
			end else
			begin
				 bit_count <= bit_count + 4'h1;
			end
	end	
	 
			
	always @ (posedge clk or posedge data_ready_clk_reset)
	begin
			if (data_ready_clk_reset)
			begin
					data_ready<=0;
					extended <= 0;
			end else
	      if (data_ready_clk_enable)
			begin
					data_ready <= (((bit_count == 6'hB) & (scan_code !=  EXTENDED_SCAN_CODE) &  (scan_code !=  KEY_UP_SCAN_CODE)) |
										((bit_count == 6'h16) & ((old_kbd_reg ==  KEY_UP_SCAN_CODE) & (scan_code !=  EXTENDED_SCAN_CODE))) |
										(bit_count >= 6'h21)); 
					extended <= ((bit_count == 6'h16) & (old_kbd_reg ==  EXTENDED_SCAN_CODE)) | (bit_count >= 6'h21); 
																	
			end
 end
			

endmodule
