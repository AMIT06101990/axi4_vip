
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

// Write address channel
rand bit[7:0]              awid;
rand bit[`ADDR_WIDTH - 1:0]awaddr;
rand bit[7:0]              awlen;
rand bit[2:0]              awsize;
rand bit[1:0]              awburst;
rand bit                   awvalid;
     bit                   awready;

// Write data channel
rand bit[7:0]              wid;
rand bit[`DATA_WIDTH - 1:0]wdataQ[$];
rand bit[7:0]              wstrbQ[$];
     bit                   wlast;
rand bit                   wvalid;
     bit                   wready;

// Write response channel
rand bit[7:0]              bid;
     bit[1:0]              bresp;
     bit                   bvalid;
rand bit                   bready;

// Read address channel
rand bit[7:0]              arid;
rand bit[`ADDR_WIDTH - 1:0]araddr;
rand bit[7:0]              arlen;
rand bit[2:0]              arsize;
rand bit[1:0]              arburst;
rand bit                   arvalid;
     bit                   arready;

// Read data channel
     bit[7:0]              rid;
     bit[`DATA_WIDTH - 1:0]rdataQ[$];
     bit                   rresp;
     bit                   rlast;
     bit                   rvalid;
rand bit                   rready;


rand bit                   wr_rd;

//Field registration 
`uvm_object_utils_begin(axi_tx)
   `uvm_field_int(awid, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(awaddr, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(awlen, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(awsize, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(awburst, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(awvalid, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(awready, UVM_ALL_ON) //Integer/bit field registration macro 
   
   `uvm_field_int(wid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_queue_int(wdataQ, UVM_ALL_ON) //Queue field registration macro
   `uvm_field_queue_int(wstrbQ, UVM_ALL_ON)//Queue field registration macro
   `uvm_field_int(wlast, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(wvalid, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(wready, UVM_ALL_ON) //Integer/bit field registration macro 
   
   `uvm_field_int(bid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(bresp, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(bvalid, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(bready, UVM_ALL_ON) //Integer/bit field registration macro 
  
   `uvm_field_int(arid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(araddr, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(arlen, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(arsize, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(arburst, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(arvalid, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(arready, UVM_ALL_ON) //Integer/bit field registration macro 
  
  
   `uvm_field_int(rid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_queue_int(rdataQ, UVM_ALL_ON) //Queue field registration macro
   `uvm_field_int(rresp, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(rlast, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(rvalid, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_int(rready, UVM_ALL_ON) //Integer/bit field registration macro 
   
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
constraint id_c{ awid inside {[1:16]};
                 arid inside {[1:16]};             
}

constraint valid_c{
        soft awvalid==1 && wvalid==1 && arvalid==1;
}
    
 
constraint ready_c {
        soft bready==1 && rready==1;
}  

constraint data_size_c {
     soft wdataQ.size() == awlen + 1;
     soft rdataQ.size() == arlen + 1;
}  
 
// //Constraint for Same Write and Read ID 
//constraint awid_wid_c {
//                awid == wid && wid == bid && awid == bid;
//                arid == rid;
//}

//Constraint for Data size & Burst legth
//constraint  soft_c{
//	soft arburst == 1;
//	soft awburst == 1;
//	soft awsize == 2;//by default 2**2=4 byte/beat
//	soft arsize == 2;//by default 2**2=4 byte/beat
//
//}

// Constraint for AXI 4KB boundary
constraint boundary_c{
	awaddr + (2**awsize*(awlen+1));
 //(awaddr / 4096) ==( (awaddr + (awsize * awlen)) / 4096);
}


endclass : axi_tx
