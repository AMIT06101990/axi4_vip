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

//Field Declaration 
rand bit[7:0]addr;
rand bit[31:0]dataQ[$];
rand bit[7:0]wstrbQ[$];
rand bit wr_rd;
rand bit[7:0] awid;
rand bit[7:0] wid;
rand bit[7:0] bid;
rand bit[7:0] arid;
rand bit[7:0] rid;
rand bit[7:0] burst_len;
rand bit[2:0] burst_size;
rand bit resp;
rand burst_type_t burst_type; 

//Field registration 
`uvm_object_utils_begin(axi_tx)
   `uvm_field_int(addr, UVM_ALL_ON) //Integer/bit field registration macro 
   `uvm_field_queue_int(dataQ, UVM_ALL_ON) //Queue field registration macro
   `uvm_field_queue_int(wstrbQ, UVM_ALL_ON)//Queue field registration macro
   `uvm_field_int(wr_rd, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(awid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(wid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(bid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(arid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(rid, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(burst_len, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_int(burst_size, UVM_ALL_ON) //Integer/bit field registration macro
   `uvm_field_enum(burst_type_t, burst_type, UVM_ALL_ON) //Enum variable registration macro
`uvm_object_utils_end

//Constraint for Max Burst legth 
constraint max_burst_len{
	burst_len inside {[0:255]};
}

//Constraint for AWID and ARID generation
constraint id_c{awid inside {[1:15]};
                arid inside {[1:15]};             
}
  
//Constraint for Same Write and Read ID 
constraint awid_wid_c {
                awid == wid && wid == bid && awid == bid;
                arid == rid;
}

//Constraint for Data size & Burst legth
constraint  burst_len_c{
  dataQ.size() == burst_len+1;
}

// Constraint for defaul burst_type & burst_size
constraint  soft_c{
	soft burst_type == INCR;
	soft burst_size == 2;//by default 2**2=4 byte/beat

}

// Constraint for AXI 4KB boundary
constraint boundary_c{
	addr + (2**burst_size*(burst_len+1));
}


endclass : axi_tx
