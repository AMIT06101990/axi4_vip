//----------------------------------------------------------------------------//
// Title       : AXI Agent Class                                              //
// Class Name  : axi_agent                                                    //
// Description :                                                              //
//              - This class is a UVM agent which is encapsulates the driver, //
//                sequencer, monitor, and coverage                            //
//              - The agent coordinates the operation of these                //
//                components during simulation and connects them to the AXI   //
//                interface.                                                  //
//              - The agent is responsible for setting up and                 //
//                managing the different UVM phases for each sub-component    //
//                (driver, sequencer, monitor, and coverage).                 //
//              - Agent can also have configuration options like the type     //
//                of UVM agent (active/passive).                              //
//                                                                            //
// Author      : [ASICraft technologies Pvt Ltd.]                             //
// Created On  : [Date]                                                       //
// Last Updated: [Date]                                                       //
//----------------------------------------------------------------------------//

class axi_agent extends uvm_agent;
// Component Registration
`uvm_component_utils(axi_agent)

// Component Handle Create
axi_driver driver;
axi_seqr   seqr;
axi_mon    mon;
axi_cov    cov;

// Default Constructor
function new(string name = "axi_agent", uvm_component parent);
  super.new (name, parent);
endfunction

// Create Component using Factory Create method in build_phase
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  driver = axi_driver :: type_id :: create("driver", this);
  seqr   = axi_seqr   :: type_id :: create("seqr", this);
  mon    = axi_mon    :: type_id :: create("mon", this);
  cov    = axi_cov    :: type_id :: create("cov", this);
endfunction

// Connect Driver and Sequencer / Monitor and Coverage 
function void connect_phase(uvm_phase phase);
  super.build_phase(phase);
  driver.seq_item_port.connect(seqr.seq_item_export);
  mon.ap_port.connect(cov.analysis_export);
endfunction

endclass : axi_agent
