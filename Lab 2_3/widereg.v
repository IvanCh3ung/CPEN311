module widereg(indata,outdata,inclk);

parameter width = 8;
input [width-1:0] indata;
output [width-1:0] outdata;
input inclk;

reg [width-1:0] outdata;

always @ (posedge inclk)
begin
	 outdata <= indata;
end

endmodule
