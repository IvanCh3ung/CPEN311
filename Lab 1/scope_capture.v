module scope_capture #(parameter scope_bits = 16)
(input wire clk, input wire the_signal, input wire capture_enable, output reg[scope_bits-1:0] captured_data,
input wire  reset);


wire synced_capture_enable;
doublesync sync_enable(.indata(capture_enable),
				  .outdata(synced_capture_enable),
				  .clk(~clk),
				  .reset(1'b1));

always @ (posedge clk or negedge reset)
begin
      if (~reset)
		   captured_data <= 0;
	   else
		begin
				if (synced_capture_enable)
				begin
						captured_data <= {captured_data[scope_bits-2:0],the_signal};
				end
		end
end

endmodule
