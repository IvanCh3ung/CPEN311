/*
Code from Hw1Ex7
*/

module FDC (d, c, clr, q);

input d, c, clr;
output q;
reg q;
always @(posedge c, posedge clr) begin
    if (clr) q<= 1'b0;
    else q<=d;
end
endmodule
