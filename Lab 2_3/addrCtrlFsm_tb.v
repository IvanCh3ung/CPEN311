`timescale 10ns/1ps

module addrCtrlFsm_tb ();
reg clk, clkDivd_sync, reset, start, flashDone, isFwrdDir, restartKey;
reg [31:0] dataIp;
wire [7:0] opData;
wire [22:0] addr;
wire [6:0] state;
wire done, flashMemReading, startNextFlash;


addrCtrlFsm dut (.clk(clk),
    .clkDivd_sync(clkDivd_sync), //frequency divided clock
    .reset(reset),   //debugging
    .start(start),   //start reading flash
    .dataIp(dataIp),  
    .flashDone(flashDone), //done reading the flash
    .isFwrdDir(isFwrdDir),
    .addr(addr),
    .restartKey(restartKey), //restart audio
    .state(state),
    .flashMemReading(flashMemReading), //indicate that flash_mem_reading
    .startNextFlash(startNextFlash),
    .opData(opData), //data that is outputted to audio
    .done(done) //reached finished state
);

initial begin
    clk = 1'b0;
    forever #1 clk =~clk;
end

initial begin
    clkDivd_sync = 1'b0;
    forever #1   clkDivd_sync = ~clkDivd_sync;
end

initial begin
    dataIp = 32'hdc8ee429aaf273516223d273a19861ee;
    reset = 1'b1;
    #2;
    reset = 1'b0;
    start = 1'b1;
    flashDone = 1'b1;
    isFwrdDir = 1'b1;
    restartKey = 1'b1;
    #20;
    restartKey = 1'b0;
    #100;
    //now backwards
    isFwrdDir = 1'b0;
    #50;
    restartKey = 1'b1;
    #20;
    restartKey = 1'b0;

end

endmodule
