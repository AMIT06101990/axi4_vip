//-------------------------------------------------------------------------------//
// Title       : AXI Testcase Class                                              //
// Class Name  : axi_base_test, axi_wr_rd_testcase, axi_multi_wr_rd_testcase     //
// Description :                                                                 //
//              - Test class contains the environment, configuration properties, //
//               class overrides etc.                                            //
//              - Implements base test, sanity testcases and other testcase      //
//               for AXI Write and Read operations.                              //
//                                                                               //
// Author      : [ASICraft technologies Pvt Ltd.]                                //
// Created On  : [Date]                                                          //
// Last Updated: [Date]                                                          //
//-------------------------------------------------------------------------------//
class axi_base_test extends uvm_test;
// Component Registration
`uvm_component_utils(axi_base_test)

// Create Environment handle
axi_env env;

//Default Constructor
function new(string name = "axi_base_test", uvm_component parent);
  super.new (name, parent);
endfunction

//Create env component using Factory Create Method
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = axi_env :: type_id :: create("env", this);
endfunction

//Print Heirchchy of each connected component
function void end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();//print heirchchy component (integration)
endfunction

endclass : axi_base_test 

//--------------------------------------------------------
//Sanity Testcase for Write and read operation 
//--------------------------------------------------------
class axi_wr_rd_testcase extends axi_base_test;
// Component Registration
`uvm_component_utils(axi_wr_rd_testcase)

//Default Constructor
function new(string name = "axi_wr_rd_testcase", uvm_component parent);
  super.new (name, parent);
endfunction

// Run Phase: Executes the Write and Read sanity sequence
task run_phase (uvm_phase phase);

   // Create Sequence Handle
   axi_wr_rd_sanity_seq wr_rd_sanity_seq;

   // Create and instantiate the sequence
   wr_rd_sanity_seq = axi_wr_rd_sanity_seq :: type_id :: create("wr_rd_sanity_seq");
   
   // Raise objection for the duration of the sequence
   phase.raise_objection(this);

   // Start the sequence on a given sequencer
   wr_rd_sanity_seq.start(env.agent.seqr);
   
   // Set Extra time for end of simulation 
   phase.phase_done.set_drain_time(this, 200);

   // Drop objection once sequence execution completes
   phase.drop_objection(this);

endtask
endclass : axi_wr_rd_testcase

//-------------------------------------------------------
//Sanity Testcase for Multiple  Write and read operation 
//-------------------------------------------------------
class axi_multi_wr_rd_testcase extends axi_base_test;
// Component Registration
`uvm_component_utils(axi_multi_wr_rd_testcase)

//Default Constructor
function new(string name = "axi_multi_wr_rd_testcase", uvm_component parent);
  super.new (name, parent);
endfunction

// Run Phase: Executes the Multiple  Write and Read sanity sequence
task run_phase (uvm_phase phase);
   
   // Create Sequence Handle
   axi_multi_wr_rd_sanity_seq multi_wr_rd_sanity_seq;
   
   // Create and instantiate the sequence
   multi_wr_rd_sanity_seq = axi_multi_wr_rd_sanity_seq:: type_id :: create("multi_wr_rd_sanity_seq");
 
   // Raise objection for the duration of the sequence
   phase.raise_objection(this);
 
   // Start the sequence on a given sequencer
   multi_wr_rd_sanity_seq.start(env.agent.seqr);

   // Set Extra time for end of simulation 
   phase.phase_done.set_drain_time(this, 200);

   // Drop objection once sequence execution completes
   phase.drop_objection(this);

endtask


endclass : axi_multi_wr_rd_testcase
