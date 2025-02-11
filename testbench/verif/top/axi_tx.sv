//--------------------------------------------------------------------------//
// Title       : AXI Transaction Class                                      //
// Class Name  : axi_tx                                                     //
// Description :                                                            //
//              - This class represents an AXI transaction used for         //
//               driving  field on an AXI interface.                        //
//              - It includes various randomizable fields such as address,  //
//               data, write strobe, burst length, and ID values.           //
//              - The class constraints ensure valid transaction properties //
//               based on the AXI protocol, including burst sizes,          //
//               address boundaries, and ID consistency for write and       //
//               read operations.                                           //
//                                                                          //
// Author      : [ASICraft technologies Pvt Ltd.]                           //
// Created On  : [Date]                                                     //
// Last Updated: [Date]                                                     //
//--------------------------------------------------------------------------//

class axi_tx extends uvm_sequence_item;

//Default Constructor
function new(string name = "axi_tx");
  super.new (name);
endfunction

//I want to generate write & read on diff address parallaly. 
//Field Declaration 
//addr_wdith & data_width needs to parameterised 
rand bit[7:0]              awid;
rand bit[`ADDR_WIDTH - 1:0]awaddr;
rand bit[7:0]              awlen;
rand bit[2:0]              awsize;
rand burst_type_t          burst_type; 

rand bit[7:0]              wid;
rand bit[`DATA_WIDTH - 1:0]wdataQ[$];
rand bit[7:0]              wstrbQ[$];

rand bit[7:0]              bid;
     bit[1:0]              bresp;


rand bit[7:0]              arid;
rand bit[`ADDR_WIDTH - 1:0]araddr;
rand bit[7:0]              arlen;
rand bit[2:0]              arsize;


rand bit[7:0]              rid;
rand bit[`DATA_WIDTH - 1:0]rdataQ[$];
rand bit                   rresp;
rand bit                   wr_rd;

//Field registration 
`uvm_object_utils_begin(axi_tx)
   `uvm_field_int(awid, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(awaddr, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(awlen, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(awsize, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_enum(burst_type_t, burst_type, UVM_ALL_ON) //Enum variable registration macro
   
   `uvm_field_int(wid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_queue_int(wdataQ, UVM_ALL_ON) //Queue field registration macro
   `uvm_field_queue_int(wstrbQ, UVM_ALL_ON)//Queue field registration macro
   
   `uvm_field_int(bid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(bresp, UVM_ALL_ON) //Integer/bit field registration macro
  
   `uvm_field_int(arid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(araddr, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(arlen, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(arsize, UVM_ALL_ON) //Integer/bit field registration macro 
  
  
   `uvm_field_int(rid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_queue_int(rdataQ, UVM_ALL_ON) //Queue field registration macro
   `uvm_field_int(rresp, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(wr_rd, UVM_ALL_ON) //Integer/bit field registration macro
`uvm_object_utils_end

//function void post_randomize();
//  if(!awlen inside {[0:255]} || !arlen inside {[0:255]})
//    `uvm_fatal("FATAL_ERROR","Constrain for AWLEN and ARLEN not satisfy")
//endfunction

//function void post_randomize();
//  if(!awaddr + (2**awsize*(awlen+1)))
////  if(awaddr % 4096 == (awaddr + (awsize * awlen)) % 4096)
//    `uvm_fatal("FATAL_ERROR","Constrain For 4KB not satisfy")
//endfunction

//Constraint for Max Burst legth 
constraint max_burst_len{
	  awlen inside {[0:255]};
	  arlen inside {[0:255]};
}

//Constraint for AWID and ARID generation
constraint id_c{awid inside {[1:256]};
                arid inside {[1:256]};             
}
  
//Constraint for Same Write and Read ID 
constraint awid_wid_c {
                awid == wid && wid == bid && awid == bid;
                arid == rid;
}

//Constraint for Data size & Burst legth
constraint  burst_len_c{
  wdataQ.size() == awlen+1;
  rdataQ.size() == arlen+1;
}

// Constraint for defaul burst_type & burst_size
constraint  soft_c{
	soft burst_type == INCR;
	soft awsize == 2;//by default 2**2=4 byte/beat

}

// Constraint for AXI 4KB boundary
constraint boundary_c{
	awaddr + (2**awsize*(awlen+1));
 //(awaddr / 4096) ==( (awaddr + (awsize * awlen)) / 4096);
}


endclass : axi_tx
