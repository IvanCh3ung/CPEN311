/* code taken from Lab1, written by Ivan Cheung (me) */
module clkdiv (inclk, outclk, div_clk_count);
    input inclk;
    output reg outclk = 1'b0;
	input[31:0] div_clk_count; //#  posedges are in 1/2 a period of outclk
	reg [31:0] count = 32'd1;
    /* outclk will hold its value until count is reached */
    always @ (posedge inclk) begin

        if (count < div_clk_count) begin
            count <= count + 32'd1;
        end

        else begin
        outclk <= ~outclk;
        count <= 32'd1;
        end

    end

endmodule