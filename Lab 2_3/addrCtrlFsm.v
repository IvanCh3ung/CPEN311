/* This FSM controls the address that is sent to flash*/

module addrCtrlFsm (
    clk,
    clkDivd_sync, //frequency divided clock
    reset,   //debugging
    start,   //start reading flash
    dataIp,  
    flashDone, //done reading the flash
    isFwrdDir,
    addr,
    restartKey, //restart audio
    state,
    flashMemReading, //indicate that flash_mem_reading
    startNextFlash,
    opData, //data that is outputted to audio
    done, //reached finished state
    gotNewData //flag indicating that got new data from flash
);
input clk, clkDivd_sync, reset, start, flashDone, isFwrdDir, restartKey;
input [31:0] dataIp;
output reg [7:0] opData;
output reg [22:0] addr;
output reg [7:0] state;
output reg done, flashMemReading, startNextFlash, gotNewData;


parameter maxVal = 23'h7FFFF; //per lab template

parameter idle                = 8'b0000_0000 ;
parameter handle_read_Flash   = 8'b0011_0001 ; //reading flash (every 0.045ms)
parameter handle_read_sample1 = 8'b0000_0010 ; //first audio sample [15:0]
parameter wait_read_sample1   = 8'b1000_0011;
parameter handle_read_sample2 = 8'b0000_0100;  //second audio sample [31:16]
parameter wait_read_sample2   = 8'b1000_0101;
parameter check_oper_dir      = 8'b0000_0110;
parameter handle_fwrd_op      = 8'b0000_0111;
parameter handle_bckwrd_op    = 8'b0000_1000;
parameter finished            = 8'b0100_1001;

always @(posedge clk, posedge reset) begin
    if (reset) state <= idle;
    else begin
        case (state) 
        idle:                   if (start)          state <= handle_read_Flash;
        handle_read_Flash:      if (flashDone)      state <= handle_read_sample1;
        handle_read_sample1:    if (clkDivd_sync)   state <= wait_read_sample1; //each rising edge is stimulus
        wait_read_sample1:                          state <= handle_read_sample2;
        handle_read_sample2:    if (clkDivd_sync)   state <= wait_read_sample2;
        wait_read_sample2:                          state <= check_oper_dir;
        check_oper_dir:         if (isFwrdDir)      state <= handle_fwrd_op;
                                else                state <= handle_bckwrd_op;
        handle_fwrd_op:                             state <= finished;
        handle_bckwrd_op:                           state <= finished;
        finished:                                   state <= idle;  
        default:                                    state <= idle;
        endcase
    end
end
//use [15:8] and [31:24]
always @ (posedge clk) begin
case (state)
    wait_read_sample1: if (isFwrdDir)   opData <= dataIp[15:8];
                       else             opData <= dataIp[31:24];
    wait_read_sample2: if (isFwrdDir)   opData <= dataIp[31:24];
                       else             opData <= dataIp[15:8];
    handle_fwrd_op:    if (restartKey)  addr <= 0;
                       else begin
                            addr <= addr + 23'd1;
                            if (addr > maxVal) addr <= 23'd0;
                       end
    handle_bckwrd_op: if (restartKey) addr = maxVal;
                      else begin
                          addr <= addr - 23'd1;
                          if (addr == 23'd0) addr <= maxVal;
                      end
    default: begin 
        addr <= addr + 23'd0;
        opData <= opData;
    end
endcase

end

always @(*) begin
done = state[6];
flashMemReading = state[5]; 
startNextFlash = state[4];
gotNewData = state[7];
end

endmodule