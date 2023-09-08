/* Note: speed_up/down events handles talking to KEY[2:0]*/

module audioSpeed(clk, speedUp, speedDown, speedReset, outputClkDiv);

input clk, speedUp, speedDown, speedReset;
output [31:0] outputClkDiv; //output: constant to input into clkdiv to change freq.
reg [31:0] outputClkDiv;

parameter speed22KHz    = 32'd614; //recall: div_clk_count = 27MHz/(2f), f = 22KHz. 
                                   //Notice use 27MHz b/c used in clkDiv
parameter deltaSpeed    = 32'd16;  //increment one hex val on HEX

reg [31:0] outputClkDivTemp = speed22KHz;
always @(posedge clk) begin
    if (speedUp) outputClkDivTemp <= outputClkDivTemp + deltaSpeed;
    else if (speedDown) outputClkDivTemp <= outputClkDivTemp - deltaSpeed;
    else if (speedReset) outputClkDivTemp <= speed22KHz;
    else outputClkDivTemp <= outputClkDivTemp + 0;
end

always @(*) begin
    outputClkDiv = outputClkDivTemp;
end

endmodule