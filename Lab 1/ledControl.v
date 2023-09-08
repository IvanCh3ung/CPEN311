module ledControl(clk, LEDS);
//have LED start at LEDS2 and go right (decreasing) first 
input clk; //note that clk is 1Hz -> period is 1s = time bwtn posedges
output reg [7:0] LEDS = 8'b00000100; //LEDR2 is on first per sof demo
reg isShiftRight = 1'b1;
always @ (posedge clk) begin
    if (isShiftRight && (LEDS[0] == 1)) begin
        isShiftRight <= ~isShiftRight;
        LEDS <= LEDS << 1;
    end
    else if (~isShiftRight && (LEDS[7] == 1)) begin
        isShiftRight <= ~isShiftRight;
        LEDS <= LEDS >> 1;
    end
    else begin
        if (isShiftRight) begin
            LEDS <= LEDS >>1;
        end
        else begin 
            LEDS <= LEDS << 1;
        end
    end  
end
endmodule