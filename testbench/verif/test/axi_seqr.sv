//--------------------------------------------------------------------------//
// Title       : AXI Sequencer Class                                        //
// Class Name  : axi_seqr                                                   //
// Description :                                                            //
//              - This class extends uvm_sequencer for handling the         //
//               generation of AXI transactions.                            //
//              - The sequencer controls the flow of request and            //
//               response sequence items between sequences and the driver   //
//                                                                          //
// Author      : [ASICraft technologies Pvt Ltd.]                           //
// Created On  : [Date]                                                     //
// Last Updated: [Date]                                                     //
//--------------------------------------------------------------------------//

class axi_seqr extends uvm_sequencer#(axi_tx);

// Component registration 
`uvm_component_utils(axi_seqr)

//Default Constructor
function new(string name = "axi_seqr", uvm_component parent=null);
  super.new (name, parent);
endfunction

endclass : axi_seqr 

