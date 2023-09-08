`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:07:43 03/11/2008 
// Design Name: 
// Module Name:    Write_Kbd_To_LCD 
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
module Write_Kbd_To_LCD(kbd_data, kbd_ready, reset_kbd_data, start_LCD_writer, LCD_writer_finished, sm_clk, DB, is_command, reset, finish);
    input [10:0] kbd_data;
    input kbd_ready;
    output reset_kbd_data;
    output start_LCD_writer;
	 output finish;
    input LCD_writer_finished;
    input sm_clk;
    output [7:0] DB;
    output is_command;
    input reset;
	 
	 assign is_command = 0;
	 
	 parameter idle                   = 8'b0000_0000;
	 parameter start_write_LCD_state  = 8'b0101_0001;
	 parameter wait_write_LCD         = 8'b0100_0010;
    parameter clear_kbd_data 		    = 8'b0010_0011;
	 parameter finished               = 8'b1000_0101;
		
	 reg[7:0] state;
	 
	 assign start_LCD_writer = state[4];
	 assign reset_kbd_data = state[5];
	 assign finish = state[7];
	 wire DB_sel = state[6];
	 wire write_Yair_finish;
	 assign DB = DB_sel ? {kbd_data[2],kbd_data[3],kbd_data[4],kbd_data[5],kbd_data[6],kbd_data[7],kbd_data[8],kbd_data[9]} : 8'h0;
	 
	 async_trap_and_reset make_kbd_ready_signal(.async_sig(kbd_ready), .outclk(sm_clk), .out_sync_sig(actual_kbd_ready), 
								  .auto_reset(1'b1), .reset(1'b1));
		
	 always @(posedge sm_clk or negedge reset)
	 begin
	  if (!reset)
	  begin
	  		state <= idle;
	  end else
	  begin
	  		case (state) 
			idle : if (actual_kbd_ready)
						state <= start_write_LCD_state;
				    else
						state <= idle;
						
			start_write_LCD_state : state <= wait_write_LCD;
			
			wait_write_LCD : if (LCD_writer_finished)
											state <= clear_kbd_data;
								 else
										state <= wait_write_LCD;
										
			
			clear_kbd_data :  state <= finished;																
			
			finished : state <= idle;
			endcase
	  end
	end


endmodule
