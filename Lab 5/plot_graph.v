//////////////////////////////////////////////////////////////////////////////////
// Company: 		SEMILLERO ADT
//https://sites.google.com/site/semilleroadt/
// Engineer: 	Holguer Andres Becerra Daza
// 
// Create Date:    11:23:41 09/24/2009 
// Design Name: 	
// Module Name:    plot_graph
// Project Name: 
// Target Devices: Altera Devices, Cyclone III, Cyclone IV, etc etc
// Tool versions: 
// Description: Este modulo, utiliza la posicion de soncronizacion para hacer graficas
// utilizando Hardware. Este modulo puede ser adpatado a cualquier procesador
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module plot_graph(CountX_in,// VGA,LCD, OR TFT SYNC COUNT_X
						CountY_in,// VGA,LCD, OR TFT SYNC COUNT_Y
						data_graph,// DATA GRAPH
						data_graph_rdy,// DATA READY GRAPH
						display_clk,// CLK SYNC VGA, LCD OR TFT
						color_graph,// COLOR OF GRAPHI
						scroll_en,// MODE PAINT, COULD BE SCROLL OR OVERPAINT
						Pos_X,// POSITION ON X
						Pos_Y,// POSITION ON Y
						Witdh,// NUMBER OF DATA TO GRAPH
						Height,// MAX AMP
						line_width,// WIDTH OF LINE
						Graph_en,// GRAPH VISIBLE OR NOT
						Graph_on,// IF DATA OUT FOR GRAPH ON
						R,// RED
						G,// GREEN
						B,// BLUE
						reset_n,// RESET NEGEDGE
						pause_graph);// PAUSE O HOLD GRAPHIC

parameter Xcount = 11;
parameter Ycount = 11;
parameter size_data = 8;
parameter numberRGB = 24;
parameter width_grp = 11;
parameter height_grp = 3;


input [Xcount-1:0]CountX_in;
input [Ycount-1:0]CountY_in;
input [size_data-1:0]data_graph;
input data_graph_rdy;
input display_clk;
input [numberRGB-1:0]color_graph;
input scroll_en;
input [Xcount-1:0]Pos_X;
input [Ycount-1:0]Pos_Y;
input [width_grp-1:0]Witdh;
input [height_grp-1:0]Height;
input Graph_en;
input [2:0]line_width;
input	reset_n;
input pause_graph;
output Graph_on;
output [numberRGB-17:0]R;
output [numberRGB-17:0]G;
output [numberRGB-17:0]B;

reg [9:0]SDRAM_OUT_ANT=10'd0;//DATO ANTERIOR A SDRAM_OUT
reg [9:0]Dif_SCROLL=10'd0;
reg [9:0]SDRAM_ADD_WRITE=10'd640;// donde empieza a escribir.
reg Bandera_Scroll_FX=1'b0;


wire [9:0]SDRAM_OUT;
wire [9:0]SDRAM_OUT1=~(SDRAM_OUT);	

// control de Pause
wire clock_data_graph_module= (pause_graph==1'b0) ? data_graph_rdy: 1'b0 ;

wire PendienteFX=((CountY_in+line_width)>=((SDRAM_OUT_ANT[7:0]/Height)+ Pos_Y))?((CountY_in<=((SDRAM_OUT1[7:0]/Height)+ Pos_Y))&((CountY_in+line_width)>=((SDRAM_OUT_ANT[7:0]/Height)+ Pos_Y))):
					  ((CountY_in)<=((SDRAM_OUT_ANT[7:0]/Height)+ Pos_Y))?(((CountY_in+line_width)>=((SDRAM_OUT1[7:0]/Height)+ Pos_Y))&(CountY_in<=((SDRAM_OUT_ANT[7:0]/Height)+ Pos_Y))):
						1'b0;
wire vertical_line=(scroll_en==1'b0)? (((CountX_in[9:0]+Dif_SCROLL-Pos_X)==SDRAM_ADD_WRITE)& (CountY_in>=Pos_Y) & (CountY_in<=((8'd255/Height)+Pos_Y))):
						  1'b0;
//assign Graph_on= vertical_line |(PendienteFX & (CountX_in>=Pos_X)&(CountX_in<=(Witdh+Pos_X))&(CountY_in<=(10'd65+Pos_Y)));
assign Graph_on=(Graph_en==1'b1 && reset_n==1'b1) ? (vertical_line ) | PendienteFX & (CountX_in>=Pos_X)&(CountX_in<=(Witdh+Pos_X))&(CountY_in<=((8'd255/Height)+Pos_Y)):
					 1'b0;
assign R=(vertical_line==1'b0)? color_graph[23:16]:
			~color_graph[23:16];
assign G=(vertical_line==1'b0)? color_graph[15:8]:
			~color_graph[15:8];
assign B=(vertical_line==1'b0)? color_graph[7:0]:
			~color_graph[7:0];


always@(posedge clock_data_graph_module, negedge reset_n)	 // cada vez que llega un dato
begin
	if(!reset_n)
		begin
			SDRAM_ADD_WRITE<=10'd0;
		end
	else
		begin
			if(SDRAM_ADD_WRITE>=(Witdh-1'b1))
						begin
							//Bandera_Scroll_FX<=1'b1;// despues de la direccion SDRAM_ADD_WRITE, se activa el SCROLL GRAFICO
							if(scroll_en==1'b1)
								begin
								SDRAM_ADD_WRITE<=SDRAM_ADD_WRITE+1'b1;// cada vez que llega un dato, cambia la direccion de memoria de la RAM
								end
							else
								begin
								SDRAM_ADD_WRITE<=10'd0;// cada vez que llega un dato, cambia la direccion de memoria de la RAM
								end
			
						end
			else
						begin
							//Bandera_Scroll_FX<=Bandera_Scroll_FX;// se mantiene el SCROLL dependiendo si esta activado o no
							SDRAM_ADD_WRITE<=SDRAM_ADD_WRITE+1'b1;// cada vez que llega un dato, cambia la direccion de memoria de la RAM
							
						end
		end				
end

always@(posedge clock_data_graph_module, negedge reset_n)	 // cada vez que llega un dato
begin
	if(!reset_n)
		begin
			Bandera_Scroll_FX<=1'b0;
		end
	else
		begin
			if(SDRAM_ADD_WRITE>=(Witdh-1'b1))
						begin
							if(scroll_en==1'b1)
								begin
									Bandera_Scroll_FX<=1'b1;// despues de la direccion SDRAM_ADD_WRITE, se activa el SCROLL GRAFICO
								end
							else
								begin
									Bandera_Scroll_FX<=1'b0;
								end
							
						end
			else
						begin
							Bandera_Scroll_FX<=Bandera_Scroll_FX;// se mantiene el SCROLL dependiendo si esta activado o no
							
						end
		end				
end


always@(posedge clock_data_graph_module, negedge reset_n)
begin
	if(!reset_n)
		begin
			Dif_SCROLL<=10'd0;
		end
	else
		begin
			if(scroll_en==1'b0)
				begin
						Dif_SCROLL<=10'd0;
				end
			else
				begin
					if(Bandera_Scroll_FX)
						begin
							Dif_SCROLL<=Dif_SCROLL+1'b1;
						end
					else
						begin
							Dif_SCROLL<=10'd0;
						end
				end		
		end		
end


always@(posedge display_clk, negedge reset_n)
begin
	if(!reset_n)
		begin
		 SDRAM_OUT_ANT<=10'd0;
		end
	else
		begin
			SDRAM_OUT_ANT<=SDRAM_OUT1;
		end
end
			
sdram1	sdram1_inst (
	.data ({{2{data_graph[7]}},data_graph[7:0]}),
	.rdaddress ( CountX_in[9:0]+Dif_SCROLL-Pos_X),
	.rdclock ( display_clk ),
	.wraddress ( SDRAM_ADD_WRITE ),
	.wrclock (clock_data_graph_module),
	.wren ( 1'b1 ),
	.q ( SDRAM_OUT )
	); 
	
endmodule