#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************
source "sdc_scripts.tcl"
#**************************************************************
# Create Clock
#**************************************************************

create_clock -period 20 [get_ports CLOCK2_50]
create_clock -period 20 [get_ports CLOCK3_50]
create_clock -period 20 [get_ports CLOCK4_50]
create_clock -period 20 [get_ports CLOCK_50]


# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]
create_clock -name freqgen_audio_dac  -period 1000 [get_registers {*AudioDacDeltaStereo:AudioDacDeltaStereo_inst|frecGen:frecGen_inst|out_tmp*}] 
create_clock -name freqgen_plots -period 1000 [get_registers {*frecGen:frecGen_plots|out_tmp*}]
timid_ignore freqgen_audio_dac 50 -50


#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
# Asynchronous I/O
set_false_path -from [get_ports KEY*] -to *
set_false_path -from [get_ports SW*] -to *
set_false_path -from * -to [get_ports LED* ]
set_false_path -from * -to [get_ports HEX* ]
timid_minmax_false_path * {*doublesync_no_reset*sync_srl16_inferred[0]*}
# set_false_path  -from  [get_registers {hack_ltm_sincronization:hack_ltm_sincronization_inst|line_rdy}]  -to  [get_clocks {U0|vga|vga_clk|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]
# set_false_path  -from  [get_registers {CLK_25MHZ}]  -to  [get_clocks {U0|vga|vga_clk|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]
# set_false_path  -from  [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  -to  [get_clocks {CLOCK_50}]
# set_false_path  -from  [get_registers {*audio_controller:audio_control|audio_clock:u4|LRCK_1X*}]  -to  [get_clocks {freqgen_audio_dac}]
#**************************************************************
# Set Multicycle Path
#**************************************************************

derive_clocks -period 39

#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************
