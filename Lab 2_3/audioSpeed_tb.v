`timescale 1ns/10ps

module audioSpeed_tb();

reg clk, speedUp, speedDown, speedReset;
wire [31:0] outputClkDiv;


audioSpeed dut(.clk(clk), 
               .speedUp(speedUp), 
               .speedDown(speedDown), 
               .speedReset(speedReset), 
               .outputClkDiv(outputClkDiv));

initial 
begin
    clk = 1'b0;
    forever begin
        #1 clk = ~clk;
    end
end 

initial begin
    speedUp = 1'b0;
    speedDown = 1'b0;
    speedReset = 1'b1;
    #2;
    //test speed up
    speedUp = 1'b1;
    #2;
    //test slow down
    speedUp = 1'b0;
    speedDown = 1'b1;
    #6;
    //test reset
    speedDown = 1'b0;
    speedReset = 1'b1;
    
end

endmodule