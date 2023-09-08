`timescale 1ns/10ps

/*
The following testbench evaluates the part that selects and emits the frequencies
*/

module toneOrgan_tb ();

wire [9:0] LEDR;
reg CLK;
reg [9:0] SW;

toneOrgan dut(
    .CLK(CLK),
    .LEDR(LEDR),
    .SW(SW)
);
initial begin
    CLK = 1'b0;
    forever #1 CLK = ~CLK;
end

initial begin
    SW[3:1] = 3'b000;
    #1000;
    SW[3:1] = 3'b001;
    #1000;
    SW[3:1] = 3'b010;
    #1000;
    SW[3:1] = 3'b100;
    #1000;
    SW[3:1] = 3'b011;
    #1000;
    SW[3:1] = 3'b110;
    #1000;
    SW[3:1] = 3'b101;
    #1000;
    SW[3:1] = 3'b111;
    #1000;
end

endmodule