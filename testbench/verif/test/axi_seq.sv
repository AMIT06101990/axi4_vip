//------------------------------------------------------------------------------//
// Title       : AXI Sequence Class                                             //
// Class Name  : axi_base_seq, axi_wr_rd_sanity_seq, axi_multi_wr_rd_sanity_seq //   
// Description :                                                                //
//              -  A sequence generates a series of sequence_item’s and         //
//                 sends it to the driver via sequencer, Sequence is written    //
//                 by extending the uvm_sequence.                               //
//              -  Base sequence class for Axi Sequence                         //
//                                                                              //
//                                                                              //
// Author      : [ASICraft technologies Pvt Ltd.]                               //
// Created On  : [Date]                                                         //
// Last Updated: [Date]                                                         //
//------------------------------------------------------------------------------//

class axi_base_seq extends uvm_sequence#(axi_tx);

// Object Registration
`uvm_object_utils(axi_base_seq)

//Default Constructor 
function new(string name = "axi_base_seq");
  super.new (name);
endfunction

//pre_body
task pre_body();
  
endtask
//body

//post_body
endclass : axi_base_seq

//======sanity WR_RD sequence========================
class axi_wr_rd_sanity_seq extends axi_base_seq;

// Object Registration
`uvm_object_utils(axi_wr_rd_sanity_seq)

// Create sequence items Handle
axi_tx tx;

//Default Constructor 
function new(string name = "axi_wr_rd_sanity_seq");
  super.new (name);
endfunction

// Task for randomization to required field
task body();
  tx = axi_tx :: type_id :: create("tx");
   `uvm_do_with (req,{req.wr_rd == 1; req.burst_len == 4;})
  	tx = new req;
   `uvm_do_with (req, {req.wr_rd == 0;
  		req.addr == tx.addr; 
      req.burst_len == tx.burst_len;
  		req.burst_size == tx.burst_size;
      req.burst_type == tx.burst_type;
    
 })
endtask
  
endclass : axi_wr_rd_sanity_seq

//====== multi_WR_RD sequence========================

class axi_multi_wr_rd_sanity_seq extends axi_base_seq;
`uvm_object_utils(axi_multi_wr_rd_sanity_seq)
axi_tx tx;
function new(string name = "axi_multi_wr_rd_sanity_seq");
  super.new (name);
endfunction

task body();
  `uvm_info("MULTi_SEQ", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
  `uvm_do(req)
endtask
  
endclass : axi_multi_wr_rd_sanity_seq
