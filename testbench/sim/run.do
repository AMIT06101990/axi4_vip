vlog ../verif/top/top_tb.sv +incdir+../../../Mentor_Graphics_QuestaSim_2021.2.1/installation/questasim/verilog_src/uvm-1.2/src \
+incdir+../verif/top \
+incdir+../verif/test \
+incdir+../verif/env
vsim top_tb -novopt -suppress 12110 -sv_lib ../../.././Mentor_Graphics_QuestaSim_2021.2.1/installation/questasim/uvm-1.2/linux/uvm_dpi +UVM_TESTNAME=axi_wr_rd_testcase
add wave -position insertpoint top_tb/pif/*
run -all







