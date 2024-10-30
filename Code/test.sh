# Using Icarus Verilog to simulating the design
iverilog -g2012 -o ./iverilog_output_file ./rtl/fsm_1_always.sv ./rtl/fsm_2_always.sv ./rtl/fsm_3_always.sv ./rtl/fsm_4_always.sv ./tb/test_fsm.sv