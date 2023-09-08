`timescale 1ns/10ps

/*
The following testbench evaluates the ledControl module
*/
module ledControl_tb();
reg clk;
wire [7:0] LEDS;
ledControl dut(.clk(clk), .LEDS(LEDS));


initial 
begin
    clk = 1'b0;
    forever begin
        #1 clk = ~clk;
    end
end

//waits allow for LEDS to change value
initial begin

    #1;

    #1;
    
    #1;
   
    #1;
   
    #1;
   
    #1;
    
    #1;
   
    #1;
   
    #1;
    
    #1;
    
    #1;
    
    #1;
   
    #1;
    
    #1;
   
    #1;
    


end


endmodule