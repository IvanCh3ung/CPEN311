module FDC_1 ( d, c, clr, q);
input d,c,clr;
output q;
reg q;
always@(negedge c, posedge clr) begin
    if (clr) q<= 1'b0;
    else q<=d;
end
endmodule

