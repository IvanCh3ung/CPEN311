module ksa (
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,
    output [9:0] LEDR,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);


    wire core1_found_signal;
    wire core2_found_signal;
    wire core3_found_signal;
    wire core4_found_signal;

    reg [23:0] secret_key;


    SevenSegmentDisplayDecoder sevenseg0 (.ssOut(HEX0), .nIn(secret_key[3:0]));
    SevenSegmentDisplayDecoder sevenseg1 (.ssOut(HEX1), .nIn(secret_key[7:4]));
    SevenSegmentDisplayDecoder sevenseg2 (.ssOut(HEX2), .nIn(secret_key[11:8]));
    SevenSegmentDisplayDecoder sevenseg3 (.ssOut(HEX3), .nIn(secret_key[15:12]));
    SevenSegmentDisplayDecoder sevenseg4 (.ssOut(HEX4), .nIn(secret_key[19:16]));
    SevenSegmentDisplayDecoder sevenseg5 (.ssOut(HEX5), .nIn(secret_key[23:20]));

    assign reset_n = KEY[3];

    //  clock_Ndiv #(.N(50000)) ( //50 000 000 to get 1hz
    //      .inclk(CLOCK_50),
    //      .speed_param(0),
    //      .outclk(clk)
    //  );

    assign clk = CLOCK_50;

    assign LEDR[1:0] = core1_LED;
    wire [23:0] core1_secret_key;

    /*core1 craking from */
    core1 craking_core1(
        .clk(clk),
        .start(SW[1]),
        .rst(~KEY[3]),

        .found_signal(core1_found_signal),
        .core1_secret_key(core1_secret_key),
        .core1_LED(core1_LED)
    );


    assign LEDR[3:2] = core2_LED;
    wire [23:0] core2_secret_key;

    core2 craking_core2(
        .clk(clk),
        .start(SW[1]),
        .rst(~KEY[3]),

        .found_signal(core2_found_signal),
        .core2_secret_key(core2_secret_key),
        .core2_LED(core2_LED)
    );


    assign LEDR[5:4] = core3_LED;
    wire [23:0] core3_secret_key;

    core3 craking_core3(
        .clk(clk),
        .start(SW[1]),
        .rst(~KEY[3]),

        .found_signal(core3_found_signal),
        .core3_secret_key(core3_secret_key),
        .core3_LED(core3_LED)
    );


    assign LEDR[7:6] = core4_LED;
    wire [23:0] core4_secret_key;

    core4 craking_core4(
        .clk(clk),
        .start(SW[1]),
        .rst(~KEY[3]),

        .found_signal(core4_found_signal),
        .core4_secret_key(core4_secret_key),
        .core4_LED(core4_LED)
    );


    always @(*) begin
        if      (core1_found_signal)        secret_key = core1_secret_key;
        else if (core2_found_signal)        secret_key = core2_secret_key;
        else if (core3_found_signal)        secret_key = core3_secret_key;
        else if (core4_found_signal)        secret_key = core4_secret_key;
        else                                secret_key = core1_secret_key;
    end

endmodule