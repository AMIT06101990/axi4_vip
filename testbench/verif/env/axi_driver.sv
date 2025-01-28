//---------------------------------------------------------------------------//
// Title       : AXI Driver Class                                            //
// Class Name  : axi_driver                                                  //
// Description :                                                             //
//              -  This class models the AXI driver responsible for driving  //
//                 AXI transactions.                                         //
//              -  It handles address, data, and response phases for both    //
//                 read and write operations.                                //
//              -  It Convert  transaction in to Signal level and Drive all  //
//                 signal using virtual interface.                           //                            
//                                                                           //
// Author      : [ASICraft technologies Pvt Ltd.]                            //
// Created On  : [Date]                                                      //
// Last Updated: [Date]                                                      //
//---------------------------------------------------------------------------//
class axi_driver extends uvm_driver#(axi_tx);
// Component Registration
`uvm_component_utils(axi_driver)

// Create Virtual interface handle
virtual axi_intf vif; 

// Create Sequence item class handle
axi_tx tx;

// Default Constructor
function new(string name = "axi_driver", uvm_component parent = null);
  super.new (name, parent);
endfunction

// Get Interface handle using Configdb/resourcedb in build_phase
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tx = axi_tx :: type_id :: create("tx");
  if(!uvm_config_db#(virtual axi_intf)::get(this,"", "VIF", vif))
    `uvm_fatal(get_type_name(), "Interface Handle not get from config_db")
  //if(!uvm_resource_db#(virtual axi_intf)::read_by_name("GLOBAL","VIF", vif,this))
  //  `uvm_fatal(get_type_name(), "Interface Handle not get from config_db")
endfunction

task run_phase(uvm_phase phase);
  forever begin 
    // Driver and Sequencer Handshaking 
    seq_item_port.get_next_item(req);

       if(vif.reset == 1)
          reset();
        drive(req); // Drive Required Signal 
    
    seq_item_port.item_done;
  
  end
endtask

//Reset Siganl Task
task reset();
  vif.drv_cb.AWVALID <=0;
  vif.drv_cb.AWADDR <= 0;
  vif.drv_cb.AWLEN <= 0; 
  vif.drv_cb.AWSIZE <= 0; 
  vif.drv_cb.AWBURST <= 0;
  vif.drv_cb.AWID<= 0;
  vif.drv_cb.WDATA <= 0;
  vif.drv_cb.WSTRB <= 0;
  vif.drv_cb.WID <= 0;
  vif.drv_cb.WVALID <= 0;
  vif.drv_cb.WLAST <= 0;
  vif.drv_cb.BREADY <=  0;
  vif.drv_cb.ARVALID <= 0;
  vif.drv_cb.ARADDR <= 0;
  vif.drv_cb.ARLEN <= 0; 
  vif.drv_cb.ARSIZE <= 0; 
  vif.drv_cb.ARBURST <= 0;
  vif.drv_cb.ARID<= 0;
  vif.drv_cb.RREADY <=  0;
endtask

task drive(axi_tx req);
  `uvm_info("Driver", "task_driver", UVM_MEDIUM)
fork
  if(req.wr_rd == 1)begin
     write_address_phase(req);
     write_data_phase(req);
     write_response_phase(req);
  end
  else begin
    read_address_phase(req);
    read_data_phase(req);
  end
join
endtask

//--------------------------------------------------------------------------------//
//TASK: Ready_wait for Wait Ready from slave(DUT) by Certain time step Limit      //
//--------------------------------------------------------------------------------//
task Ready_wait(ref logic wait_signal, input int timeout_cycles);
int cycles_waited=0;
  fork
    begin 
    // Wait for AWREADY signal to assert
      wait(wait_signal == 1);
    end

    begin
      // Timeout logic: Count clock cycles and exit after timeout
      while (cycles_waited < timeout_cycles) begin
        @(vif.drv_cb); // Wait for one clock cycle
        cycles_waited++;
      end
    end
  join_any
  disable fork;
endtask : Ready_wait

//--------------------------------------------------------------------------------//
//TASK: Write Address Phase for Addressing issue in AXI bus for write operation   //
//--------------------------------------------------------------------------------//
task write_address_phase(axi_tx tx);
  `uvm_info("Driver_tx", "Write_address_phase", UVM_MEDIUM)
  @(vif.drv_cb);
  vif.drv_cb.AWVALID <= 1'b1;
  vif.drv_cb.AWADDR <= tx.addr;
  vif.drv_cb.AWLEN <= tx.burst_len;
  vif.drv_cb.AWSIZE <= tx.burst_size;
  vif.drv_cb.AWBURST <= tx.burst_type;
  vif.drv_cb.AWID <= tx.awid;
//  wait(vif.drv_cb.AWREADY == 1)
  Ready_wait(vif.drv_cb.AWREADY, 100); // Task : Wait for certain time step of AWREADY
  if (vif.drv_cb.AWREADY == 1)
    `uvm_info("Driver_tx", "AWREADY asserted within timeout", UVM_MEDIUM)
  else 
    `uvm_error("Driver_tx", "AWREADY did not assert within the timeout period")
  @(vif.drv_cb);
  vif.drv_cb.AWVALID <= 1'b0;
  vif.drv_cb.AWADDR <= 1'b0;
  vif.drv_cb.AWLEN <= 1'b0; 
  vif.drv_cb.AWSIZE <= 1'b0; 
  vif.drv_cb.AWBURST <= 1'b0;
  vif.drv_cb.AWID<= 1'b0;
  `uvm_info("Driver_tx",$sformatf("\n awaddr=%h,\n burst_len=%h,\n burst_type=%h,\n burst_size=%h,\n Awid=%0d",vif.AWADDR, vif.AWLEN, vif.AWBURST, vif.AWSIZE, vif.AWID), UVM_MEDIUM)
endtask : write_address_phase

//--------------------------------------------------------------------------------//
//TASK: Write  data Phase for data transfer in AXI bus for write operation        //
//--------------------------------------------------------------------------------//
task write_data_phase(axi_tx tx);
  tx.print();
  for(int i=0; i <= tx.burst_len; i++)begin
     @(vif.drv_cb);
     vif.drv_cb.WDATA <= tx.dataQ.pop_front();
     vif.drv_cb.WSTRB <= 4'hf;
     vif.drv_cb.WID <= tx.wid;
     vif.drv_cb.WVALID <= 1'b1;
     if(i == tx.burst_len) begin
       vif.drv_cb.WLAST <= 1;
     end
    //wait(vif.drv_cb.WREADY==1); // Task : Wait for certain time step of WREADY
    Ready_wait(vif.drv_cb.WREADY, 100); // Task : Wait for certain time step of WREADY
  if (vif.drv_cb.WREADY == 1)
    `uvm_info("Driver_tx", "WREADY asserted within timeout", UVM_MEDIUM)
  else 
    `uvm_error("Driver_tx", "WREADY did not assert within the timeout period")

   `uvm_info("Driver_tx", $sformatf(" transfer=%0d , vif.Wdata= %h",i, vif.drv_cb.WDATA), UVM_MEDIUM)
  end 
     @(vif.drv_cb);
     vif.drv_cb.WDATA <= 0;
     vif.drv_cb.WSTRB <= 0;
     vif.drv_cb.WID <= 0;
     vif.drv_cb.WVALID <= 0;
     vif.drv_cb.WLAST <= 0;
endtask : write_data_phase

//--------------------------------------------------------------------------------//
//TASK: Write  Response  Phase for Slave(DUT) response in  write operation        //
//--------------------------------------------------------------------------------//
task write_response_phase(axi_tx tx);
  `uvm_info("Driver_tx", "Write_response_phase", UVM_MEDIUM)
  while (vif.drv_cb.BVALID == 0)begin
     @(vif.drv_cb);
  end
   vif.drv_cb.BREADY <=  1'b1;
     @(vif.drv_cb);
   vif.drv_cb.BREADY <=  1'b0;
  `uvm_info("Driver_tx",$sformatf("BVALID=%0d, BREADY=%0d",vif.BVALID,vif.BREADY), UVM_MEDIUM)

endtask : write_response_phase

//--------------------------------------------------------------------------------//
//TASK: Read Address Phase for Addressing issue in AXI bus in Read operation      //
//--------------------------------------------------------------------------------//
task read_address_phase(axi_tx tx);
  `uvm_info("Driver_tx", "read_address_phase", UVM_MEDIUM)
  @(vif.drv_cb);
  vif.drv_cb.ARVALID <= 1'b1;
  vif.drv_cb.ARADDR <= tx.addr;
  vif.drv_cb.ARLEN <= tx.burst_len;
  vif.drv_cb.ARSIZE <= tx.burst_size;
  vif.drv_cb.ARBURST <= tx.burst_type;
  vif.drv_cb.ARID<= tx.arid;
   Ready_wait(vif.drv_cb.ARREADY, 100); // Task : Wait for certain time step of ARREADY
  if (vif.drv_cb.ARREADY == 1)
    `uvm_info("Driver_tx", "ARREADY asserted within timeout", UVM_MEDIUM)
  else 
    `uvm_error("Driver_tx", "ARREADY did not assert within the timeout period")
  @(vif.drv_cb);
  vif.drv_cb.ARVALID <= 0;
  vif.drv_cb.ARADDR <= 0;
  vif.drv_cb.ARLEN <= 0; 
  vif.drv_cb.ARSIZE <= 0; 
  vif.drv_cb.ARBURST <= 0;
  vif.drv_cb.ARID <= 0;
  `uvm_info("Driver_Read_addr_tx", $sformatf("\n ARVALID=%0d, ARREADY=%0d",vif.ARVALID, vif.ARREADY), UVM_MEDIUM)
  `uvm_info("Driver_tx",$sformatf("\n araddr=%h,\n burst_len=%h,\n burst_type=%h,\n burst_size=%h,\n Arid=%0d", vif.ARADDR, vif.ARLEN, vif.ARBURST, vif.ARSIZE, vif.ARID), UVM_MEDIUM)
endtask : read_address_phase

//--------------------------------------------------------------------------------//
//TASK: Read data Phase for data transfer from Slave(DUT) in Read operation       //
//--------------------------------------------------------------------------------//
task read_data_phase(axi_tx tx);
  `uvm_info("Driver_tx", "read_data_phase", UVM_MEDIUM)
   for(int i=0; i <= tx.burst_len; i++)begin
       vif.drv_cb.RREADY <=  1'b1;
      while (vif.drv_cb.RVALID == 0)begin
        @(posedge vif.clk);
      end
       @(posedge vif.clk);
       vif.drv_cb.RREADY <=  1'b0;
   end
       vif.RLAST <=  1'b0;
       
  `uvm_info("Driver_tx",$sformatf("RVALID=%0d, RREADY=%0d",vif.RVALID,vif.RREADY), UVM_MEDIUM)
endtask : read_data_phase

endclass : axi_driver 


