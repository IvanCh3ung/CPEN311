/* signals to pass in from top module:
flash_mem_write, flash_mem_burstcount, flash_mem_read,
flash_mem_address, flash_mem_writedata, and
flash_mem_byteenable. The outputs are
flash_mem_waitrequest, flash_mem_readdata, and
flash_mem_readdatavalid.
*/

module flashReadFsm(
clk, 
reset,
start,
read,
waitReq,
readDataValid,
state,
done
);

input clk, reset, start, read, waitReq, readDataValid;
output [4:0] state;
output reg done; //turn wire -> reg b/c modelsim don't like

reg [4:0] state;

/* The following state transition descriptions are per Figure 3.5 mnl_avalon_spec and Lecture 4a*/
parameter idle              = 4'b000_0; //idle state
parameter check_oper        = 4'b001_0; //master asserts address and read
parameter handle_read_op    = 4'b010_0; //slave captures data
parameter wait_read         = 4'b100_0; //slave asserts waitrequest
parameter finished          = 4'b000_1; //all done!

always @(posedge clk, posedge reset) begin
    if (reset) state <= idle;
    else begin
        case (state)
        idle:           if (start)     state <= check_oper;
                        else           state <= idle;
        check_oper:     if (read)      state <= handle_read_op;
        handle_read_op: if (!waitReq)  state <= wait_read;      //asssrt low since high => unable respond
        wait_read:      if (!readDataValid)  state <= finished; //assert low since high => there still memory avail
        finished:                      state <= idle;
        default:                       state <= idle;
        endcase
    end
end

always@(*) begin
    done = state[0];
end


endmodule