module syncClk ( async_sig,   outclk,   out_sync_sig);
input async_sig, outclk;
output out_sync_sig;

wire n1, n2, n3,n4;

FDC_1 fdc1(.d(out_sync_sig), .c(outclk), .clr(1'b0), .q(n2));
FDC fdc2(.d(1'b1), .c(async_sig), .clr(n2), .q(n1));
FDC fdc3 (.d(n1), .c(outclk), .clr(1'b0), .q(n3));
FDC fdc4(.d(n3), .c(outclk), .clr(1'b0), .q(n4));

assign out_sync_sig = n4;

endmodule