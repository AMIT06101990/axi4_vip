#-------------------------------------------------------------------------#
# Title       : AXI Verification Makefile                                 #
# Description : This Makefile automates the compilation and simulation    #
#               of an AXI-based SystemVerilog/UVM testbench using         #
#               Mentor Graphics Questasim.                                #
#                                                                         #
# Author      : [ASICraft technologies Pvt Ltd.]                          #
# Created On  : [Date]                                                    #
# Last Updated: [Date]                                                    # 
#-------------------------------------------------------------------------#

# Variables
# Paths to source files and tools
RTL         = ../../RTL/axi_rtl.v
QUESTA_PATH = ../../../Mentor_Graphics_QuestaSim_2021.2.1/installation/questasim
UVM_SRC     = $(QUESTA_PATH)/verilog_src/uvm-1.1d/src
UVM_LIB     = $(QUESTA_PATH)/uvm-1.1d/linux

# Paths to testbench, testcases, and environment directories
TB_DIR      = ../verif/top
TEST_DIR    = ../verif/test
ENV_DIR     = ../verif/env

# File Defination Path 
#INTERFACE   = $(TB_DIR)/axi_intf.sv
TESTBENCH   = $(TB_DIR)/top_tb.sv
#PACKAGE     = $(TB_DIR)/axi_pkg.sv
#TESTNAME    ?= axi_base_test
TESTNAME    = axi_wr_rd_testcase

# Simulation Purpose
VERBOSITY   = UVM_DEBUG
VSIM_FLAGS  = -c -novopt -suppress 12110 -suppress 8386 -sv_lib $(UVM_LIB)/uvm_dpi -sv_seed random

# Waveform and Logfile purpose
WAVES       = top_tb/pif/*
TIME        = $(shell date +%m%d_%H%M)
COMLOGFILE  = compile.log
SIMLOG      = $(TESTNAME)_$(TIME).log

# Default target
all: simulate

# Compile the testbench
# This target compiles the RTL, testbench and required UVM files
compile:
	vlog $(RTL)  +incdir+$(UVM_SRC) +incdir+$(TB_DIR) +incdir+$(TEST_DIR) +incdir+$(ENV_DIR) $(TESTBENCH)  > $(COMLOGFILE) 2>&1 |tee $(COMLOGFILE)
	#vlog $(RTL)  +incdir+$(UVM_SRC) +incdir+$(TB_DIR) +incdir+$(TEST_DIR) +incdir+$(ENV_DIR)  $(PACKAGE) $(TESTBENCH)  > $(COMLOGFILE) 2>&1 |tee $(COMLOGFILE)

# This target runs the simulation for the compiled testbench
# Run simulation
#simulate: compile
#	vsim top_tb $(VSIM_FLAGS) +UVM_TESTNAME=$(TESTNAME) +UVM_VERBOSITY=$(VERBOSITY) -do "log -r /*; run -all; quit" -l "$(SIMLOG)"
simulate: compile
	vsim top_tb $(VSIM_FLAGS) +UVM_TESTNAME=$(TESTNAME) +UVM_VERBOSITY=$(VERBOSITY)  -do "add wave -position insertpoint $(WAVES); run -all; quit" -l "$(SIMLOG)"

# Viewing  Waveform
DUMP:
	vsim -view vsim.wlf

#close Simulation
close:
	vsim -do exit

# Clean files
clean:
	rm -rf work transcript vsim.wlf *.log  compile.log

#=====================================================================================


#  #------------
#  hello:
#  	 echo "higig, jkhnj"
#  #------------
#  some_file: other_file
#  	echo "This will run second, because it depends on other_file"
#  	touch some_file
#  
#  other_file:
#  	echo "This will run first"
#  	touch other_file
#  #------------
#  some_file1: clean
#  	touch some_file
#  
#  clean:
#  	rm -f some_file
#  #-------------
#  some_file2:
#  	touch some_file
#  	touch clean
#  
#  .PHONY: clean
#  clean:
#  	rm -f some_file
#  	rm -f clean
#  #-------------
#  
#  files = file1 file2
#  some_file3: $(files)
#  	echo "Look at this variable: " $(files)
#  	touch some_file
#  
#  file1:
#  	touch file1
#  file2:
#  	touch file2
#  
#  clean:
#  	rm -rf file1 file2 some_file
#  #-------------
#  
#  # Implicit command of: "cc blah.o -o blah"
#  # Note: Do not put a comment inside of the blah.o rule; the implicit rule will not run!
#  blah:
#  
#  # Implicit command of: "cc -c blah.c -o blah.o"
#  blah.o:
#  
#  blah.c:
#  	echo "int main() { return 0; }" > blah.c
#  
#  clean:
#  	rm -f blah.o blah blah.c
#  
#  #-----------------------------------------------
#  wrong = *.o # Wrong
#  objects := $(wildcard *.c) # Right
#  some_binary:
#  	touch f1.c
#  	touch f2.c
#  	echo $(wrong)
#  	echo $(objects)
#  
#  clean1:
#  	rm -f *.c
#  #-----------------------------------------------
#  
#  #--------Simple assignment ":=" /*immediate Evaluation  -------------
#  XX := $(shell date) # date will be executed once
#  tt:
#  	@echo $(XX)
#  	sleep 2
#  	@echo $(XX)
#  
#  #--------Expanded / Dynamic  assignment "=" /-------------
#  XX = $(shell date) # date will be executed once
#  tt1:
#  	@echo $(XX)
#  	sleep 2
#  	sleep 2
#  	sleep 2
#  	@echo $(XX)
