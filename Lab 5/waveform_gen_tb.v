`timescale 1ns/1ps

module waveform_gen_tb();

reg clk, reset, en;
reg [31:0] phase_inc;
wire [11:0] sin_out, cos_out, squ_out, saw_out;

waveform_gen dut (.clk(clk), 
                  .reset(reset), 
                  .en(en), 
                  .phase_inc(phase_inc),
                  .sin_out(sin_out),
                  .cos_out(cos_out),
                  .squ_out(squ_out),
                  .saw_out(saw_out)
                  );

initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

task increment_phase(input phase_inc);
begin
#20;
phase_inc = phase_inc + 1;
end
endtask

initial begin
    reset = 1'b0; //active low rst
    en = 1'b0; //active high en
    #2;
    reset =1'b1;
    en = 1'b1;
    phase_inc = 32'd2147483649;
    // #100;
    // phase_inc = 32'd0;

    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);
    // increment_phase(phase_inc);



    
end

endmodule