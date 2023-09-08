module doublesync_no_reset(indata,
				  outdata,
				  clk);

input indata,clk;
output outdata;

wire reg1, reg2;


//special coding for SRL16 inference in Xilinx devices
wire clock_enable = 1'b1;
reg [1:0] sync_srl16_inferred;
   always @(posedge clk)
         sync_srl16_inferred[1:0] <= {sync_srl16_inferred[0], indata};
			
assign reg2 = sync_srl16_inferred[1];
				
assign outdata = reg2;

endmodule
