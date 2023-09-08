module Cursor(
input iLeft,
input	iUp,
input	iDown,
input iRight,
input [10:0] iVGA_X,
input	[10:0] iVGA_Y,
output logic [11:0]oRGB,
input	iRST,
input iCLK,
input slow,
input ichangeC,
output arrow_on,
output [9:0]pointer_x,
output [9:0]pointer_y
);


reg [9:0] cur_X, cur_Y;
assign pointer_x[9:0]=cur_X[9:0];
assign pointer_y[9:0]=cur_Y[9:0];
reg arrow;
reg [20:0] debounce;
wire [3:0] speed_x, speed_y;

logic [19:0]pos_of_cursor;

always @(posedge iCLK)
begin
     pos_of_cursor <={iVGA_Y[9:0]-cur_Y,iVGA_X[9:0]-cur_X};
end

wire [11:0]RGB_C1;
wire [11:0]RGB_C2;

logic [11:0]RGB_C1_sync;
logic [11:0]RGB_C2_sync;


assign arrow_on= arrow & (oRGB[11:0]!=12'hf00);


assign speed_x = (slow ? 4'd1 : 4'hF );
assign speed_y = (slow ? 4'd1 : 4'hC );


always @(posedge iCLK)
begin
     RGB_C1_sync  <= RGB_C1;
     RGB_C2_sync  <= RGB_C2;
     oRGB <= ichangeC ? RGB_C2_sync : RGB_C1_sync;
end

// DOWN CURSOR
FFXII_LB_Cursor2 FFXII_LB_Cursor2_inst
(
	.RGB(RGB_C2) ,	// output [11:0] RGB_sig
	.YX(pos_of_cursor) 	// input [19:0] YX_sig
);


// NORMAL CURSOR
FFXII_LB_Cursor FFXII_LB_Cursor_inst
(
	.RGB(RGB_C1) ,	// output [11:0] RGB_sig
	.YX(pos_of_cursor) 	// input [19:0] YX_sig
);




always @(posedge iCLK)
begin
 if(iRST) begin
		cur_X <= 11'd400;
		cur_Y <= 11'd300;
		arrow <= 1'b0;
		debounce <= 0;
 end
 else begin
		if ( ((iVGA_X > cur_X) && (iVGA_X < cur_X + 28))) begin
				if (((iVGA_Y > cur_Y ) && (iVGA_Y < cur_Y + 36))) 
					arrow <= 1'b1;	
				else 
					arrow <= 1'b0;
		end
		else 
					arrow <= 1'b0;
		if ( iLeft ) begin
			if (debounce == 0) 
				cur_X <= cur_X - speed_x;
			debounce <= debounce + 1;
		end
		else if ( iRight  ) begin
			if (debounce == 0) 
				cur_X <= cur_X + speed_x;
			debounce <= debounce + 1;
			
		end
		else if ( iUp ) begin
			if (debounce == 0) 
				cur_Y <= cur_Y - speed_y;
			debounce <= debounce + 1;
				
		end
		else if ( iDown ) begin
			if (debounce == 0) 
				cur_Y <= cur_Y + speed_y;
			debounce <= debounce + 1;
				
		end
		else debounce <= 0;
 end
end


endmodule
