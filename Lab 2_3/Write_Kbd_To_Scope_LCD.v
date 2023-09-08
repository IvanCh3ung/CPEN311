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
module Write_Kbd_To_Scope_LCD #(parameter scope_info_bytes = 16, 
parameter scope_info_bits_per_byte = 8, parameter scope_info_counter_bits = 4)
   (kbd_ascii_data, 
    kbd_ready, reset_kbd_data, sm_clk, reset, finish,
    scope_info0, scope_info1, scope_info2,
	 scope_info3, scope_info4, scope_info5, scope_info6, scope_info7, scope_info8, 
	 scope_info9, scope_info10, scope_info11, scope_info12, scope_info13, 
	 scope_info14, scope_info15, debug, convert_now);
	 
    //The following are 15 sets of 8 bits,  which go to the "oscilloscope" LCD mode
	 output wire  [scope_info_bits_per_byte-1:0] scope_info0, scope_info1, scope_info2,
	 scope_info3, scope_info4, scope_info5, scope_info6, scope_info7, scope_info8, 
	 scope_info9, scope_info10, scope_info11, scope_info12, scope_info13, 
	 scope_info14, scope_info15;
	
	 output convert_now;
	 input [7:0] kbd_ascii_data;
    input kbd_ready;
    output reset_kbd_data;
    output finish;
    input sm_clk;
    input reset;
	 reg [scope_info_bits_per_byte-1:0] scope_info_reg[scope_info_bytes-1:0];
	 output wire [15:0] debug;
	 
    //State machine states	 
	 parameter init_state                   = 10'b000000_0000;
	 parameter init_scope_LCD_reg           = 10'b010000_0001;
	 parameter idle                         = 10'b000000_0010;
	 parameter convert_to_ascii_now         = 10'b100000_0111;
	 parameter LCD_enable_change_state      = 10'b000100_0011;
	 parameter LCD_byte_change_value_state  = 10'b000001_0100;
    parameter clear_kbd_data 		  		    = 10'b000010_0101;
	 parameter finished                     = 10'b001000_0110;
	 		
	 reg [9:0] state; //state machine register
	wire actual_kbd_ready;
   // Keyboard ready signal is not synchronous to the state machine. So let's synchronize it
   async_trap_and_reset make_kbd_ready_signal(.async_sig(kbd_ready), .outclk(sm_clk), 
   .out_sync_sig(actual_kbd_ready), .auto_reset(1'b1), .reset(1'b1));
		
	 //=======================================================================================
	 //
	 //State Machine Transitions
	 //
	 //=======================================================================================
	 
	 always @(posedge sm_clk or negedge reset)
	 begin
	  if (!reset)
	  begin
	  		state <= idle;
	  end else
	  begin
	  		case (state) 
			init_state: state <= init_scope_LCD_reg;
			init_scope_LCD_reg: state <= idle;
			idle : if (actual_kbd_ready)
						state <= convert_to_ascii_now;
				    else
						state <= idle;
						
			convert_to_ascii_now : state <= LCD_enable_change_state;
			LCD_enable_change_state : state <= LCD_byte_change_value_state;
			
			LCD_byte_change_value_state : state <= clear_kbd_data;
								 		
			
			clear_kbd_data :  state <= finished;																
			
			finished : state <= idle;
			default: state <= init_state;
			endcase
	  end
	end

	 
	 //outputs from the state machine	   
	 wire update_scope_LCD_reg = state[4];
	 assign reset_kbd_data = state[5];
	 wire change_clk_enable = state[6];
	 assign finish = state[7];
	 wire init_clk_enable = state[8];
	 assign debug = {7'h0,state};
	 assign convert_now = state[9];
	 
	 //=====================================================================================
	 //
	 //Here we use the outputs of the state machine in a useful manner
	 //
	 //
	 
	 reg [scope_info_bytes-1:0] scope_LCD_reg_clk_enable;
	 
    //======================================================================================
	 //
	 // Enable signal for the oscilloscope register
	 //
	 //======================================================================================
    always @(posedge change_clk_enable or posedge init_clk_enable or negedge reset)
	 begin //this is a register with both reset and preset
	     if (~reset)
		   scope_LCD_reg_clk_enable <= 0;
		  else if (init_clk_enable)
		   scope_LCD_reg_clk_enable <= 2**(scope_info_bytes-1);
		  else
		   scope_LCD_reg_clk_enable <= {scope_LCD_reg_clk_enable[0],scope_LCD_reg_clk_enable[scope_info_bytes-1:1]};
	 end
	//==========================================================================================
	//
	//generate the scope variables
	//
	//
	// This section uses a Verilog 2001 structure called "generate", which allows you to 
	// automatically generate lots of similar structures in Verilog. In this case, I use it to
	// generate the following structures:
	//
	//  always @ (posedge update_scope_LCD_reg)
	//		 begin
	//		       if (scope_LCD_reg_clk_enable[0])
	//				 begin
	//				      scope_info_reg[0] <= kbd_ascii_data;
	//				 end
	//		 end		
	//
	// always @ (posedge update_scope_LCD_reg)
	//		 begin
	//		       if (scope_LCD_reg_clk_enable[1])
	//				 begin
	//				      scope_info_reg[1] <= kbd_ascii_data;
	//				 end
	//		 end		
	//
	//  and so on, for the registers scope_info_reg[0]... scope_info_reg[15] 
	//
	//=========================================================================================
	
	genvar LCD_scop_reg_cnt;
   generate
       for (LCD_scop_reg_cnt=0; LCD_scop_reg_cnt < scope_info_bytes; LCD_scop_reg_cnt=LCD_scop_reg_cnt+1) 
       begin : gen1
		    always @ (posedge update_scope_LCD_reg)
			 begin
			       if (scope_LCD_reg_clk_enable[LCD_scop_reg_cnt])
					 begin
					      scope_info_reg[LCD_scop_reg_cnt] <= kbd_ascii_data;
					 end
			 end			      
       end
   endgenerate
	 
	// Assign the output of the state machine accordingly
	assign scope_info15 = scope_info_reg[15];
	assign scope_info14 = scope_info_reg[14];
   assign scope_info13 = scope_info_reg[13];	
	assign scope_info12 = scope_info_reg[12];
	assign scope_info11 = scope_info_reg[11];
	assign scope_info10 = scope_info_reg[10];
   assign scope_info9 = scope_info_reg[9];	
	assign scope_info8 = scope_info_reg[8];
	assign scope_info7 = scope_info_reg[7];
	assign scope_info6 = scope_info_reg[6];
   assign scope_info5 = scope_info_reg[5];	
	assign scope_info4 = scope_info_reg[4];
	assign scope_info3 = scope_info_reg[3];
	assign scope_info2 = scope_info_reg[2];
   assign scope_info1 = scope_info_reg[1];	
	assign scope_info0 = scope_info_reg[0];
		

endmodule
