/* The following module is to instantiate a 5-bit LFSR  */
/* Following logic from noticing pattern from given waveform in binary radix*/
module LFSR (
             clk,       //clk signal 
             rst,       //reset signal
             lfsr   //5-bit output
);
input clk, rst;

output reg [4:0] lfsr = 5'h1;
wire feedback;

assign feedback = lfsr[0] ^ lfsr[2]; //feedback = lfsr[0] XOR lfsr[2] per diagram


always @(posedge clk, posedge rst) begin
    if (rst)    lfsr <= 5'h1;
    else        lfsr <= {feedback, lfsr[4:1]}; //latter bits are "right shifted"
end                                            //4 -> 3, 3 -> 2, 2 ->1, 1 -> 0

endmodule