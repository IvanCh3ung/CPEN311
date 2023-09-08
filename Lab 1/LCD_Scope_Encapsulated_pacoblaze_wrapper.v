module LCD_Scope_Encapsulated_pacoblaze_wrapper
                       (inout [7:0] lcd_d,
                        output wire lcd_rs,
                        output lcd_rw,
                        output wire lcd_e,
								input clk,
								input wire[7:0] InA,
								input wire[7:0] InB,
								input wire[7:0] InC,
								input wire[7:0] InD,
								input wire[7:0] InE,
								input wire[7:0] InF,
								input wire[7:0] InG,
								input wire[7:0] InH,
								input wire[15:0] InfoA,
								input wire[15:0] InfoB,
								input wire[15:0] InfoC,
								input wire[15:0] InfoD,
								input wire[15:0] InfoE,
								input wire[15:0] InfoF,	
								input wire[15:0] InfoG,
							   input wire[15:0] InfoH,
								input wire[31:0] ScopeInfoA,
								input wire[31:0] ScopeInfoB,
								input wire choose_scope_or_LCD,
								input wire [15:0] scope_channelA,
								input wire [15:0] scope_channelB,
								output wire enable_scope);
								
	LCD_Scope_Encapsulated_pacoblaze
	LCD_Scope_Encapsulated_pacoblaze_inst
	 (                              
	   .lcd_d                       ( lcd_d               ),
       .lcd_rs                      ( lcd_rs              ),
       .lcd_rw                      ( lcd_rw              ),
       .lcd_e                       ( lcd_e               ),
	   .clk                         ( clk                 ),
	   .InA                         ( InA                 ),
	   .InB                         ( InB                 ),
	   .InC                         ( InC                 ),
	   .InD                         ( InD                 ),
	   .InE                         ( InE                 ),
	   .InF                         ( InF                 ),
	   .InG                         ( InG                 ),
	   .InH                         ( InH                 ),
	   .InfoA                       ( InfoA               ),
	   .InfoB                       ( InfoB               ),
	   .InfoC                       ( InfoC               ),
	   .InfoD                       ( InfoD               ),
	   .InfoE                       ( InfoE               ),
	   .InfoF	                    ( InfoF	              ),
	   .InfoG                       ( InfoG               ),
       .InfoH                       ( InfoH               ),
	   .ScopeInfoA                  ( ScopeInfoA          ),
	   .ScopeInfoB                  ( ScopeInfoB          ),
	   .choose_scope_or_LCD         ( choose_scope_or_LCD ),
	   .scope_channelA              ( scope_channelA      ),
	   .scope_channelB              ( scope_channelB      ),
	   .enable_scope                 ( enable_scope       )
	);
							
endmodule
								
								