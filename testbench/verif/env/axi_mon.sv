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
			tx.awaddr = vif.mon_cb.AWADDR;
			tx.wr_rd = 1'b1;
			tx.awid = vif.mon_cb.AWID;
			tx.awlen = vif.mon_cb.AWLEN;
			tx.awsize = vif.mon_cb.AWSIZE;
			tx.burst_type = vif.mon_cb.AWBURST;
    `uvm_info("Monitor_Write_addr_tx",$sformatf("\n wr_rd=%0d, \n awaddr=%h,\n Awlen=%h,\n burst_type=%h,\n Awsize=%h,\n Awid=%0d",tx.wr_rd, tx.awaddr, tx.awlen, tx.burst_type, tx.awsize, tx.awid), UVM_MEDIUM)
		end

    //write_data_phase
		if(vif.mon_cb.WVALID && vif.mon_cb.WREADY)begin
			`uvm_info("axi_mon", "write_data", UVM_MEDIUM)
			tx.wdataQ.push_back(vif.mon_cb.WDATA);
			tx.wstrbQ.push_back(vif.mon_cb.WSTRB);
      `uvm_info("Monitor_write_data_tx", $sformatf(" Wdata= %p, Wstrb = %p", tx.wdataQ, tx.wstrbQ), UVM_MEDIUM)
		end

    //write_response_phase
		if(vif.mon_cb.BVALID && vif.mon_cb.BVALID)begin
			`uvm_info("axi_mon", "write_response", UVM_MEDIUM)
			tx.bresp = vif.mon_cb.BRESP;
     // if (tx == null) begin
     //     `uvm_error("Monitor", "Transaction handle is null!")
     // end else begin
     //     `uvm_info("Monitor_Write_transaction", tx.sprint(), UVM_HIGH)
     // end
     //  tx.print();
      `uvm_info("MOnitor_Write_transaction", tx.sprint(), UVM_HIGH)
			ap_port.write(tx);//put write_tx to analysis_port by write method
      `uvm_info("Monitor_Write_resp_tx",$sformatf("\n BRESP=%0d",tx.bresp), UVM_MEDIUM)
		end

    //Read_address_phase
    `uvm_info("Monitor_Read_addr_tx",$sformatf("\n ARVALID=%0d, ARREADY=%0d",vif.mon_cb.ARVALID, vif.mon_cb.ARREADY), UVM_MEDIUM)
		if(vif.mon_cb.ARVALID && vif.mon_cb.ARREADY)begin
			`uvm_info("axi_mon", "Read_address", UVM_MEDIUM)
		  tx = axi_tx::type_id::create("tx");
			tx.wr_rd = 1'b0;
			tx.araddr = vif.mon_cb.ARADDR;
			tx.rid = vif.mon_cb.ARID;
			tx.arlen= vif.mon_cb.ARLEN;
			tx.arsize = vif.mon_cb.ARSIZE;
			tx.burst_type = vif.mon_cb.ARBURST;
    `uvm_info("Monitor_Read_addr_tx",$sformatf("\n #### ARVALID=%0d, ARREADY=%0d",vif.mon_cb.ARVALID, vif.mon_cb.ARREADY), UVM_MEDIUM)
    `uvm_info("Monitor_Read_addr_tx",$sformatf("\n #### wr_rd=%0d, \n araddr=%h,\n Arlen=%h,\n burst_type=%h,\n Arsize=%h,\n Arid=%0d",tx.wr_rd, tx.araddr, tx.arlen, tx.burst_type, tx.arsize, tx.arid), UVM_MEDIUM)
    end

    //read_data/resp_phase
		if(vif.mon_cb.RVALID && vif.mon_cb.RREADY)begin
			`uvm_info("axi_mon", "read_data/resp", UVM_MEDIUM)
			tx.rdataQ.push_back(vif.mon_cb.RDATA);
      `uvm_info("MONITOR_tx", $sformatf(" vif.Rdata= %p", vif.mon_cb.RDATA), UVM_MEDIUM)
			if(vif.mon_cb.RLAST == 1)begin//this indicate the end of read tx
				tx.rresp = vif.mon_cb.RRESP;
      `uvm_info("MOnitor_Read_transaction", tx.sprint(), UVM_HIGH)
				ap_port.write(tx);//put read_tx to analysis_port by write method
        tx.print();
      `uvm_info("Monitor_Read_Data_tx",$sformatf("\n RLAST=%0d, \n RRESP=%0d",vif.mon_cb.RLAST, tx.rresp), UVM_MEDIUM)
      end
      `uvm_info("Monitor_Read_Data_tx",$sformatf("\n RLAST=%0d, \n RRESP=%0d",vif.mon_cb.RLAST, tx.rresp), UVM_MEDIUM)
   end
end
endtask
endclass
