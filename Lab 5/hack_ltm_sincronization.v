//////////////////////////////////////////////////////////////////////////////////
// Company: 	Semillero ADT	
// Engineer: 	Holguer Andres Becerra Daza
// 
// Create Date:    11:23:41 09/24/2009 
// Design Name: 	
// Module Name:    hack_ltm_sincronization 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Este modulo, captura la seal del sincronizador LTM 
// Para hacer poder hacer blendign de imagenes por medio de este a la 
// pantalla de 7" de Ampiere corp AM-800480R5TMQW-TB1H
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module hack_ltm_sincronization(clk_lcd,den_lcd,count_x,count_y,reset);
parameter WIDTH = 11'd800;
parameter HEIGHT = 11'd599;
input clk_lcd;
input den_lcd;
input reset;
output reg [10:0]count_x=11'd0;
output reg [10:0]count_y=11'd0;


reg line_rdy=1'b0;

always@(negedge clk_lcd,negedge reset)
begin
	if(!reset)
		begin
			count_x<=11'd0;
			line_rdy<=1'b0;
		end
	else
		begin
			if(den_lcd)
			begin
				if(count_x<WIDTH)
					begin
						count_x<=count_x+1'b1;
						line_rdy<=1'b1;
					end
				else 
					begin
						count_x<= 11'd0;
						line_rdy<=1'b1;
					end
			end
			else
			begin
				count_x<= 11'd0;
				line_rdy<=1'b0;
			end
		end	
end

always@(negedge line_rdy,negedge reset)
begin
	if(!reset)
		begin
			count_y<= 11'd0;
		end
	else
		begin
				if(count_y<HEIGHT)count_y<=count_y+1'b1;
				else count_y<= 11'd0;
		end
end


endmodule