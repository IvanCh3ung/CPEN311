/* This following FSM allows for interaction and communication bwtn FSMs of Task 1, 2a, and 2b*/


module controller_fsm(
    input clk,
    input rst,
    input [7:0] write_mem_1,
    input [7:0] write_data_1,
    input wren_1,
    input [7:0] write_mem_2a,
    input [7:0] write_data_2a,
    input wren_2a,
    input [7:0] write_mem_2b,
    input [7:0] write_data_2b,
    input s_wren_2b,
    input doneTask1,
    input doneTask2a,
    input doneTask2b,
    
    output [7:0] write_mem,
    output [7:0] write_data,
    output wren,
    output startTask1,
    output startTask2a,
    output startTask2b,
    output [7:0] state
);

reg select_2a_output_parameter;
reg select_2b_output_parameter;

parameter check_start_1         = 8'b0000_00_00;
parameter give_start_1          = 8'b0001_00_00; 
parameter wait_for_finish_1     = 8'b0010_00_00;
parameter finished_1            = 8'b0011_00_01;

parameter check_start_2a        = 8'b0100_01_01;
parameter give_start_2a         = 8'b0101_01_01;
parameter wait_for_finish_2a    = 8'b0110_01_01;
parameter finished_2a           = 8'b0111_01_10;                             //modified bit 0 to 0 (a.ka turn off FSM2 start signal)

parameter check_start_2b        = 8'b1000_10_10;
parameter give_start_2b         = 8'b1001_10_10;
parameter wait_for_finish_2b    = 8'b1010_10_10;
parameter finished_2b           = 8'b1011_10_00;


always @ (posedge clk, posedge rst) begin
    if (rst) state <= check_start_1;
    else begin
        case(state)
        check_start_1:                         state <= give_start_1;
        give_start_1:                          state <= wait_for_finish_1;
        wait_for_finish_1: if (doneTask1)      state <= finished_1;
                           else                state <= wait_for_finish_1;
        finished_1:                            state <= check_start_2a;

        check_start_2a:                        state <= give_start_2a;
        give_start_2a:                         state <= wait_for_finish_2a;
        wait_for_finish_2a: if(doneTask2a)     state <= finished_2a;                
                            else               state <= wait_for_finish_2a;         
        finished_2a:                           state <= check_start_2b;                

        check_start_2b:                        state <= give_start_2b;
        give_start_2b:                         state <= wait_for_finish_2b;
        wait_for_finish_2b: if(doneTask2b)     state <= finished_2b;
                            else               state <= wait_for_finish_2b;
        finished_2b:                           state <= finished_2b;
        default:                               state <= check_start_1;
        endcase
    end 
end


always @(*) begin
    //startTask1                  = 1'b1;                           //use switch to start 
    startTask2a                 = state[0];
    startTask2b                 = state[1];
    select_2a_output_parameter  = state[2];
    select_2b_output_parameter  = state[3];
end


always @ (*) begin
    case ({select_2a_output_parameter, select_2b_output_parameter})
    2'b10: begin
        wren = wren_2a;
        write_mem = write_mem_2a;
        write_data = write_data_2a;
    end 
    2'b01: begin
        wren = s_wren_2b;                  
        write_mem = write_mem_2b;
        write_data = write_data_2b;
    end
    2'b00: begin
        wren = wren_1;
        write_mem = write_mem_1;
        write_data = write_mem_1; 
    end
    default: begin
        wren = 0;
        write_mem = 0;
        write_data = 0; 
    end   
    endcase
end

// always @(*) begin
//     //2a parameters
//     if (select_2a_output_parameter) begin
//         wren = wren_2a;
//         write_mem = write_mem_2a;
//         write_data = write_data_2a;
//     end
//     //2b parameters
//     else if (select_2b_output_parameter) begin
//         wren = s_wren_2b;                  
//         write_mem = write_mem_2b;
//         write_data = write_data_2b;
//     end
//     //1 parameters
//     else begin
//         wren = wren_1;
//         write_mem = write_mem_1;
//         write_data = write_mem_1;               //b/c s[i] = i per task1
//     end
// end

endmodule
