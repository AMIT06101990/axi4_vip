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

semaphore sema = new(5);

// Create Sequence item class handle
axi_tx wr_tx, rd_tx;

// Default Constrauctor
function new(string name = "axi_mon", uvm_component parent);
  super.new (name, parent);
endfunction

// Get Interface handle using Configdb/resourcedb in build_phase
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  wr_tx = axi_tx :: type_id :: create("wr_tx");
  rd_tx = axi_tx :: type_id :: create("rd_tx");
  ap_port = new("ap_port",this); 
  if(!uvm_config_db#(virtual axi_intf)::get(this,"", "VIF", vif))
    `uvm_fatal(get_type_name(), "Interface Handle not get from config_db")
  //if(!uvm_resource_db#(virtual axi_intf)::read_by_name("GLOBAL","VIF", vif,this))
  //  `uvm_fatal(get_type_name(), "Interface Handle not get from config_db")
endfunction

task run_phase(uvm_phase phase);
`uvm_info(get_full_name(), "mon_run_phase", UVM_MEDIUM)
  forever begin
    @(vif.clk);
	  fork
      begin  
        begin   //write_address_phase
          @(vif.clk);
	        while(vif.AWVALID == 0 && vif.AWREADY == 0)begin
            @(vif.clk);
          end
	        	`uvm_info("axi_mon", "write_address", UVM_MEDIUM)
	        	wr_tx.wr_rd = 1'b1;
            wr_tx.awvalid = vif.mon_cb.AWVALID;
            wr_tx.awready = vif.mon_cb.AWREADY;
	        	wr_tx.awaddr = vif.mon_cb.AWADDR;
	        	wr_tx.awid = vif.mon_cb.AWID;
	        	wr_tx.awlen = vif.mon_cb.AWLEN;
	        	wr_tx.awsize = vif.mon_cb.AWSIZE;
	        	wr_tx.awburst = vif.mon_cb.AWBURST;
	        	sema.put(1);//put write_tx to analysis_port by write method
          `uvm_info("Monitor_Write_addr_tx",$sformatf("\n wr_rd=%0d, \n awaddr=%h,\n Awlen=%h,\n awburst=%h,\n Awsize=%h,\n Awid=%0d",wr_tx.wr_rd, wr_tx.awaddr, wr_tx.awlen, wr_tx.awburst, wr_tx.awsize, wr_tx.awid), UVM_MEDIUM)
        end

        begin //write_data_phase
          while (vif.WVALID == 0 && vif.WREADY == 0)begin
            @(vif.clk);
          end
	        	`uvm_info("axi_mon", "write_data", UVM_MEDIUM)
            wr_tx.wvalid = vif.mon_cb.WVALID;
            wr_tx.wready = vif.mon_cb.WREADY;
	        	wr_tx.wdataQ.push_back(vif.mon_cb.WDATA);
	        	wr_tx.wstrbQ.push_back(vif.mon_cb.WSTRB);
	        	sema.put(1);//put write_tx to analysis_port by write method
            `uvm_info("Monitor_write_data_tx", $sformatf(" Wdata= %p, Wstrb = %p", wr_tx.wdataQ, wr_tx.wstrbQ), UVM_MEDIUM)
        end

        begin //write_response_phase
	        while (vif.BVALID == 0 && vif.BREADY == 0)begin
            @(vif.clk);
          end
	        	`uvm_info("axi_mon", "write_response", UVM_MEDIUM)
            wr_tx.bvalid = vif.mon_cb.BVALID;
            wr_tx.bready = vif.mon_cb.BREADY;
	        	wr_tx.bresp = vif.mon_cb.BRESP;
            if (wr_tx == null) begin
              `uvm_error("Monitor", "Transaction handle is null!")
            end
            else begin
              `uvm_info("Monitor_Write_transaction\n", wr_tx.sprint(), UVM_MEDIUM)
            end
	        	sema.put(1);//put write_tx to analysis_port by write method
            `uvm_info("Monitor_Write_resp_tx",$sformatf("\n BRESP=%0d",wr_tx.bresp), UVM_MEDIUM)
        end

       begin//Read_address_phase
         //`uvm_info("Monitor_Read_addr_tx",$sformatf("\n ARVALID=%0d, ARREADY=%0d",vif.mon_cb.ARVALID, vif.mon_cb.ARREADY), UVM_MEDIUM)
	       while (vif.ARVALID == 0 && vif.ARREADY == 0)begin
            @(vif.clk);
         end
	       	`uvm_info("axi_mon", "Read_address", UVM_MEDIUM)
	       	rd_tx.wr_rd = 1'b0;
          rd_tx.arvalid = vif.mon_cb.ARVALID;
          rd_tx.arready = vif.mon_cb.ARREADY;
	       	rd_tx.araddr = vif.mon_cb.ARADDR;
	       	rd_tx.rid = vif.mon_cb.ARID;
	       	rd_tx.arlen= vif.mon_cb.ARLEN;
	       	rd_tx.arsize = vif.mon_cb.ARSIZE;
	       	rd_tx.arburst = vif.mon_cb.ARBURST;
	       	sema.put(1);//put write_tx to analysis_port by write method
         `uvm_info("Monitor_Read_addr_tx",$sformatf("\n #### ARVALID=%0d, ARREADY=%0d",vif.mon_cb.ARVALID, vif.mon_cb.ARREADY), UVM_MEDIUM)
         `uvm_info("Monitor_Read_addr_tx",$sformatf("\n #### wr_rd=%0d, \n araddr=%h,\n Arlen=%h,\n arburst=%h,\n Arsize=%h,\n Arid=%0d",rd_tx.wr_rd, rd_tx.araddr, rd_tx.arlen, rd_tx.arburst, rd_tx.arsize, rd_tx.arid), UVM_MEDIUM)
      end

       begin //read_data/resp_phase
	       while (vif.RVALID == 0 && vif.RREADY == 0)begin
            @(vif.clk);
         end
	       	`uvm_info("axi_mon", "read_data/resp", UVM_MEDIUM)
          rd_tx.rvalid = vif.mon_cb.RVALID;
          rd_tx.rready = vif.mon_cb.RREADY;
	       	rd_tx.rdataQ.push_back(vif.mon_cb.RDATA);
          `uvm_info("MONITOR_tx", $sformatf(" vif.mon_cb.Rdata= %p", vif.mon_cb.RDATA), UVM_MEDIUM)
	          if(vif.mon_cb.RLAST == 1)begin//this indicate the end of read tx
	       	   rd_tx.rresp = vif.mon_cb.RRESP;
             `uvm_info("MOnitor_Read_transaction", rd_tx.sprint(), UVM_HIGH)
              rd_tx.print();
             `uvm_info("Monitor_Read11_Data_tx",$sformatf("\n RLAST=%0d, \n RRESP=%0d",vif.mon_cb.RLAST, rd_tx.rresp), UVM_MEDIUM)
            end
	       	sema.put(1);//put write_tx to analysis_port by write method
          `uvm_info("Monitor_Read_Data_tx",$sformatf("\n RLAST=%0d, \n RRESP=%0d",vif.mon_cb.RLAST, rd_tx.rresp), UVM_MEDIUM)
       end

      begin
         sema.get(5);
         ap_port.write(wr_tx);
         `uvm_info("WRITE_MONITOR_PACKETS_SENT",$sformatf("%0s",wr_tx.sprint),UVM_HIGH);
         `uvm_info("WRITE_ADDR_DATA_CHECK",$sformatf("\n\n awaddr == %p \n WDATA== %p \n WDATA_SIZE =%0d ",wr_tx.awaddr, wr_tx.wdataQ, wr_tx.wdataQ.size),UVM_NONE);
         ap_port.write(rd_tx);
         `uvm_info("WRITE_MONITOR_PACKETS_SENT",$sformatf("%0s",rd_tx.sprint),UVM_HIGH);
         `uvm_info("WRITE_ADDR_DATA_CHECK",$sformatf("\n\n araddr == %p \n RDATA== %p \n RDATA_SIZE =%0d ",rd_tx.araddr, rd_tx.rdataQ, wr_tx.rdataQ.size),UVM_NONE);
      end
    end
   join_none
  wait fork;
 end
endtask
endclass
