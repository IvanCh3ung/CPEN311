/*

** input: 50Mhz Clock of DE1-SoC board
** output: 50Mhz/N Clock where N is an integer > 1

*/

module clock_Ndiv 
    #(parameter N = 10) (
    input inclk,
    input [31:0] speed_param,
    output outclk
);

    reg [31:0] pos_counter = 0;                 //counter counts up each rising edge of input clock
    reg [31:0] neg_counter = 0;                 //counter counts up each falling edge of input clock
    reg pos_outclk = 0;                         //1/N frequency clock with positive counter  
    reg neg_outclk = 0;                         //1/N frequency clock with negative counter


    //Create a positive-edge sensitive counter
    always @(posedge inclk) begin
        pos_counter <= pos_counter + 1'b1;      //increases by 1 on each rising edge of input clock

        if (pos_counter == N-1 + speed_param)
            pos_counter <= 0;                   //reset to 0 when reaching divisor-1 
    end

    //Create a negative-edge sensitive counter
    always @(negedge inclk) begin
        neg_counter <= neg_counter + 1'b1;      //increases by 1 on each falling edge of input clock

        if (neg_counter == N-1 + speed_param)
            neg_counter <= 0;                   //reset to 0 when reaching divisor 
    end

    //Generate positive 1/N frequency clock
    always @(posedge inclk) begin
        if (pos_counter < (N+speed_param)/2)
            pos_outclk <= 1;
        else
            pos_outclk <= 0;                    //invert pos_outclock every half cycle of positive counter
    end

    //Generate negative 1/N frequency clock
    always @(negedge inclk) begin
        if ((N+speed_param)%2 == 0)
            neg_outclk <= 0;                    //Deactivate clock if divisor is even
        else
            if (neg_counter < (N+speed_param)/2) 
                neg_outclk <= 1;
            else
                neg_outclk <= 0;                //inver neg_outclock every half cycle of negative counter
    end

    assign outclk = neg_outclk || pos_outclk;   //create a 50Mhz/N Clock with 50% duty cycle from neg_clock and pos_clock
   

endmodule