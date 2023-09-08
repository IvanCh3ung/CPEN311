module doublesync(indata,
				  outdata,
				  clk,
				  reset);

input indata,clk,reset;
output outdata;

reg reg1, reg2;

always @(posedge clk or negedge reset)
begin
	 if (!reset)
	 begin
	 	reg1 <= 1'b0;
		reg2 <= 1'b0;
	 end else 
	 begin
	 	reg1 <= indata;
		reg2 <= reg1;
	 end
end

assign outdata = reg2;

endmodule
