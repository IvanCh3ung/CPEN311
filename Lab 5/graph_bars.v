module graph_bars(
input [2047:0]histoGrama,
input [10:0]CounterX,
input [10:0]CounterY,
output bar_on);


wire [255:0]barn_on;

genvar index;
generate

	for (index=0; index<256; index=index+1)
	begin: generate_graph

		assign barn_on[index]=(CounterX==(11'd3 + index))  && (CounterY>={3'd0,~(histoGrama[(index * 8)+8-1:(index * 8)])}) && (CounterY<=11'd265);
	end

endgenerate

assign bar_on=|barn_on[255:0];

endmodule


