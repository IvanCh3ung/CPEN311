`timescale 10ns/100ps

module flashReadFsm_tb (
);
    reg clk, reset, start, read, waitReq, readDataValid;
    wire [4:0] state;
    wire done;

    flashReadFsm dut ( .clk(clk),
                    .reset(reset),
                    .start(start),
                    .read(read),
                    .waitReq(waitReq),
                    .readDataValid(readDataValid),
                    .state(state),
                    .done(done)

    );
initial
begin
    clk = 1'b0;
    forever begin
        #1 clk = ~clk;
    end
end
initial begin
    reset = 1'b1;
    #2;
    reset = 1'b0;
    start = 1'b1;
    read  = 1'b1;
    waitReq = 1'b0;
    readDataValid = 1'b0;
end


endmodule