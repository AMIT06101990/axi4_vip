//-------------------------------------------------------------------------//
// Title       : AXI Environment Class                                     // 
// Class Name  : axi_env                                                   //
// Description :                                                           //
//              - This class encapsulates the entire AXI verification      //
//               environment, which includes creating the AXI agent and    //
//               setting up necessary configurations.                      //
//              - Contains multiple, reusable verification components and  //
//               defines their default configuration as required by the    //
//               application.                                              //
//                                                                         //
// Author      : [ASICraft technologies Pvt Ltd.]                          //
// Created On  : [Date]                                                    //
// Last Updated: [Date]                                                    //
//-------------------------------------------------------------------------//

class axi_env extends uvm_env;
// Component Registration
`uvm_component_utils(axi_env)

// Create Agent Handle
axi_agent  agent; 

// Default Constructor
function new(string name = "axi_env", uvm_component parent);
  super.new (name, parent);
endfunction

// Create Agent using Factory Create Method
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  agent = axi_agent :: type_id :: create("agent", this);
endfunction

endclass : axi_env
