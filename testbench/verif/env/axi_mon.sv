//-------------------------------------------------------------------------------//
// Title       : AXI Monitor Class                                               //
// Class Name  : axi_mon                                                         //
// Description :                                                                 //
//              - AXI Monitor observes AXI transactions on the virtual interface //
//                and convert signal to transaction level                        //
//              - sends transaction  using the analysis port to Scoreboard       //
//                and Coverage component.                                        //
//                                                                               //
// Author      : [ASICraft technologies Pvt Ltd.]                                //
// Created On  : [Date]                                                          //
// Last Updated: [Date]                                                          //
//-------------------------------------------------------------------------------//



class axi_mon extends uvm_monitor;
// Component Registration
`uvm_component_utils(axi_mon)

// Create TLM analysis port Handle
uvm_analysis_port#(axi_tx) ap_port;

// Create Virtual interface handle
virtual axi_intf vif; 

// Create Sequence item class handle
axi_tx tx;

// Default Constrauctor
function new(string name = "axi_mon", uvm_component parent);
  super.new (name, parent);
endfunction

// Get Interface handle using Configdb/resourcedb in build_phase
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap_port = new("ap_port",this); 
  if(!uvm_config_db#(virtual axi_intf)::get(this,"", "VIF", vif))
    `uvm_fatal(get_type_name(), "Interface Handle not get from config_db")
  //if(!uvm_resource_db#(virtual axi_intf)::read_by_name("GLOBAL","VIF", vif,this))
  //  `uvm_fatal(get_type_name(), "Interface Handle not get from config_db")
endfunction

task run_phase(uvm_phase phase);
  forever begin 
    @(vif.mon_cb);
		
    //write_address_phase
		if(vif.mon_cb.AWVALID && vif.mon_cb.AWREADY)begin
			`uvm_info("axi_mon", "write_address", UVM_MEDIUM)
	  	tx = axi_tx::type_id::create("tx");
			tx.addr = vif.mon_cb.AWADDR;
			tx.wr_rd = 1'b1;
			tx.awid = vif.mon_cb.AWID;
			tx.burst_len = vif.mon_cb.AWLEN;
			tx.burst_size = vif.mon_cb.AWSIZE;
			tx.burst_type = vif.mon_cb.AWBURST;
    `uvm_info("Monitor_Write_addr_tx",$sformatf("\n wr_rd=%0d, \n awaddr=%h,\n burst_len=%h,\n burst_type=%h,\n burst_size=%h,\n Awid=%0d",tx.wr_rd, tx.addr, tx.burst_len, tx.burst_type, tx.burst_size, tx.awid), UVM_MEDIUM)
		end

    //write_data_phase
		if(vif.mon_cb.WVALID && vif.mon_cb.WREADY)begin
			`uvm_info("axi_mon", "write_data", UVM_MEDIUM)
			tx.dataQ.push_back(vif.mon_cb.WDATA);
			tx.wstrbQ.push_back(vif.mon_cb.WSTRB);
      `uvm_info("Monitor_write_data_tx", $sformatf(" vif.Wdata= %p, Wstrb = %p", tx.dataQ, tx.wstrbQ), UVM_MEDIUM)
		end

    //write_response_phase
		if(vif.mon_cb.BVALID && vif.mon_cb.BVALID)begin
			`uvm_info("axi_mon", "write_response", UVM_MEDIUM)
			tx.resp = vif.mon_cb.BRESP;
			//this is the last phase of write tx==>write tx is completed
			//so we have to give these tx to coverage and sbd
      tx.print();
			ap_port.write(tx);//put write_tx to analysis_port by write method
      `uvm_info("Monitor_Write_resp_tx",$sformatf("\n BRESP=%0d",tx.resp), UVM_MEDIUM)
		end

    //Read_address_phase
    `uvm_info("Monitor_Read_addr_tx",$sformatf("\n ARVALID=%0d, ARREADY=%0d",vif.mon_cb.ARVALID, vif.mon_cb.ARREADY), UVM_MEDIUM)
		if(vif.mon_cb.ARVALID && vif.mon_cb.ARREADY)begin
			`uvm_info("axi_mon", "Read_address", UVM_MEDIUM)
		  tx = axi_tx::type_id::create("tx");
			tx.wr_rd = 1'b1;
			tx.addr = vif.mon_cb.ARADDR;
			tx.rid = vif.mon_cb.ARID;
			tx.burst_len = vif.mon_cb.ARLEN;
			tx.burst_size = vif.mon_cb.ARSIZE;
			tx.burst_type = vif.mon_cb.ARBURST;
    `uvm_info("Monitor_Read_addr_tx",$sformatf("\n #### ARVALID=%0d, ARREADY=%0d",vif.mon_cb.ARVALID, vif.mon_cb.ARREADY), UVM_MEDIUM)
    `uvm_info("Monitor_Read_addr_tx",$sformatf("\n #### wr_rd=%0d, \n awaddr=%h,\n burst_len=%h,\n burst_type=%h,\n burst_size=%h,\n Arid=%0d",tx.wr_rd, tx.addr, tx.burst_len, tx.burst_type, tx.burst_size, tx.arid), UVM_MEDIUM)
    end

    //read_data/resp_phase
		if(vif.mon_cb.RVALID && vif.mon_cb.RREADY)begin
			`uvm_info("axi_mon", "read_data/resp", UVM_MEDIUM)
			tx.dataQ.push_back(vif.mon_cb.RDATA);
      `uvm_info("MONITOR_tx", $sformatf(" vif.Rdata= %p", vif.mon_cb.RDATA), UVM_MEDIUM)
			if(vif.mon_cb.RLAST == 1)begin//this indicate the end of read tx
				tx.resp = vif.mon_cb.RRESP;
				ap_port.write(tx);//put read_tx to analysis_port by write method
        tx.print();
      `uvm_info("Monitor_Read_Data_tx",$sformatf("\n RLAST=%0d, \n RRESP=%0d",vif.mon_cb.RLAST, tx.resp), UVM_MEDIUM)
      end
   end
end
endtask
endclass
