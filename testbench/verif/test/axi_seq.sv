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
   `uvm_do_with (req,{req.wr_rd == 1; req.awlen == 2; req.awsize == 2;})
  	tx = new req;
   `uvm_do_with (req, {req.wr_rd == 0;
  		req.araddr == tx.awaddr; 
      req.arlen == tx.awlen;
  		req.arsize == tx.awsize;
      req.burst_type == tx.burst_type;
    
 })
endtask
  
endclass : axi_wr_rd_sanity_seq

//====== multi_WR_RD sequence========================

class axi_multi_wr_rd_sanity_seq extends axi_base_seq;

 // Object Registration
`uvm_object_utils(axi_multi_wr_rd_sanity_seq)

// Create sequence items Handle
axi_tx tx;
axi_tx txQ[$];

//Default Constructor 
function new(string name = "axi_multi_wr_rd_sanity_seq");
  super.new (name);
endfunction

// Task for randomization to of Multiple time required field
task body();
   //write
	repeat(3)begin
    `uvm_info("WRITE_SEQUENCE STARTED - 1","",UVM_HIGH)
		`uvm_do_with(req,{req.wr_rd == 1; req.awlen == 2;  req.awsize == 2;})
		tx = new req; //shallow copy for read at same address location
		txQ.push_back(tx);
	end	
	//read to same address
	repeat(3)begin
    `uvm_info("READ_SEQUENCE STARTED - 1","",UVM_HIGH)
    if(txQ.size() > 0)begin
		  tx = txQ.pop_front();
		  `uvm_do_with(req,{req.wr_rd == 0;
		  				  req.araddr == tx.awaddr;
		  				  req.arlen == tx.awlen;
		  				  req.arsize == tx.awsize;
		  				  req.burst_type== tx.burst_type;
		  					})
    end
    else `uvm_error("SEQ_ERROR", "### Read transaction attempted but no stored write transactions!")
 `uvm_info("SEQUENCE ENDED - 1","",UVM_HIGH)
	end
endtask :body
//task body();
// axi_tx trans;
//         trans=axi_tx::type_id::create("trans");
//      repeat(10) begin
//         `uvm_info("SEQUENCE STARTED - 1","",UVM_HIGH);
//         start_item(trans);
//        assert (trans.randomize());
//                                
//         finish_item(trans);
//      end  
//      
//      //repeat(10) begin
//      //   `uvm_info("SEQUENCE STARTED - 1","",UVM_HIGH);
//      //   start_item(trans);
//      //   assert(trans.randomize with {
//      //                    tx.wr_rd == 0;      
//      //            });
//      //   finish_item(trans);
//      //   `uvm_info("SEQUENCE ENDED - 1","",UVM_HIGH);
//      //end   
//endtask
endclass : axi_multi_wr_rd_sanity_seq

//====== Axi_different Burst Legth Sequence ========================
class axi_diff_burst_len_seq extends axi_base_seq;

 // Object Registration
`uvm_object_utils(axi_diff_burst_len_seq)

// Create sequence items Handle
axi_tx tx;
axi_tx txQ[$];

//Default Constructor 
function new(string name = "axi_diff_burst_len_seq");
  super.new (name);
endfunction

// Task for randomization to of Multiple time required field
task body();
  //write
  for(int i=0; i<16; i++)begin
		`uvm_do_with(req,{req.wr_rd == 1; req.awlen == i; })
		tx = new req; //shallow copy for read at same address location
		txQ.push_back(tx);
	end	
	
	//read to same address
  for(int i=0; i<16; i++)begin
    if(txQ.size() > 0)begin
	  	tx = txQ.pop_front();
	  	`uvm_do_with(req,{req.wr_rd == 0;
	  					  req.araddr == tx.awaddr;
	  					  req.arlen == tx.awlen;
	  					  req.arsize == tx.awsize;
	  					  req.burst_type== tx.burst_type;
	  						})
    end
    else `uvm_error("SEQ_ERROR", "### Read transaction attempted but no stored write transactions!")
  end
endtask
endclass : axi_diff_burst_len_seq
