/* The following code for task 1*/

/* Transcribes the following code to HW
    // initialize s array. You will build this in Task 1
    for i = 0 to 255 {
    s[i] = i;
    }
*/
module task1_init_mem (
    clk,                         //input clk
    rst,                         //active high rst for debugging
    start,                       //start signal
    wren_1,
    task1_init_data,             //output data
    doIncrement,                 //signal to increment
    doneFsm1,                    //signal indicating done FSM
    state                        //state signal for debugging
);


output reg wren_1;
input clk, rst, start;
output [4:0] state;
reg [4:0] state;
output reg doIncrement;
output reg doneFsm1;
output [7:0] task1_init_data;
reg [7:0] task1_init_data;

    //index declaration
    reg [7:0] i = 8'd0;                 //index

    /* State Declarations*/
    parameter idle      = 5'b00_100;
    parameter increment = 5'b01_010;
    parameter done      = 5'b10_001;

    //State logic
    always @(posedge clk, posedge rst) begin
        if (rst) state <= idle;
        else begin
            case (state)
                idle:       if (start)            state <= increment;   //go to increment step when start signal high
                            else                  state <= idle;

                increment:  if (i == 8'd255)      state <= done;        //increment until i = 255
                            else                  state <= increment;

                done:                             state <= done;       
                default:                          state <= idle;
            endcase    
        end
    end

    //Output logic
    always @ (*) begin
        doneFsm1    =  state[0];
        doIncrement =  state[1];    
    end

    //Increment logic
    always @ (posedge clk) begin
        if (doIncrement)  begin
            task1_init_data <= task1_init_data + 1;
            wren_1 <= 1; 
            i <= i + 8'd1;                                  //might not need this
		end
        else if (doneFsm1| rst) begin
            wren_1 <= 0;
            i <= 8'd0;                                      //redundent
        end
    end
        

endmodule