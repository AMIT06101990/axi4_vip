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
    @(posedge vif.clk);
	  fork
      begin  
        begin   //write_address_phase
          @(posedge vif.clk);
	        while(vif.AWVALID == 0 || vif.AWREADY == 0)begin
            @(posedge vif.clk);
          end
          `uvm_info("###Monitor_Write_addr_tx",$sformatf("\n wr_rd=%0d, awvalid=%0d,awready=%0d, \n awaddr=%h,\n Awlen=%h,\n awburst=%h,\n Awsize=%h,\n Awid=%0d", wr_tx.wr_rd, vif.AWVALID,  vif.AWREADY, vif.AWADDR, vif.AWLEN, vif.AWBURST, vif.AWSIZE, vif.AWID), UVM_MEDIUM)
	        	`uvm_info("axi_mon", "write_address", UVM_MEDIUM)
	        	wr_tx.wr_rd = 1'b1;
            wr_tx.awvalid = vif.AWVALID;
            wr_tx.awready = vif.AWREADY;
	        	wr_tx.awaddr = vif.AWADDR;
	        	wr_tx.awid = vif.AWID;
	        	wr_tx.awlen = vif.AWLEN;
	        	wr_tx.awsize = vif.AWSIZE;
	        	wr_tx.awburst = vif.AWBURST;
          `uvm_info("Monitor_Write_addr_tx",$sformatf("\n wr_rd=%0d, \n awaddr=%h,\n Awlen=%h,\n awburst=%h,\n Awsize=%h,\n Awid=%0d",wr_tx.wr_rd, wr_tx.awaddr, wr_tx.awlen, wr_tx.awburst, wr_tx.awsize, wr_tx.awid), UVM_MEDIUM)
	        	sema.put(1);//put write_tx to analysis_port by write method
          `uvm_info("AFTER PUT Monitor_Write_addr_tx",$sformatf("\n wr_rd=%0d, \n awaddr=%h,\n Awlen=%h,\n awburst=%h,\n Awsize=%h,\n Awid=%0d",wr_tx.wr_rd, wr_tx.awaddr, wr_tx.awlen, wr_tx.awburst, wr_tx.awsize, wr_tx.awid), UVM_MEDIUM)
        end

        begin // Write Data Phase
          int transfer_id = 0; // Track transfer count
          
          while (transfer_id <= wr_tx.awlen) begin
            @(posedge vif.clk);
            
            // Wait for WVALID and WREADY
            while (vif.WVALID == 0 || vif.WREADY == 0) begin
              @(posedge vif.clk);
            end
            
            // Capture data
            wr_tx.wvalid = vif.WVALID;
            wr_tx.wready = vif.WREADY;
            wr_tx.wdataQ.push_back(vif.WDATA);
            wr_tx.wstrbQ.push_back(vif.WSTRB);
            
            `uvm_info("Monitor_Write_Data_tx", $sformatf("Transfer[%0d]: WDATA = %h, WSTRB = %h", transfer_id, vif.WDATA, vif.WSTRB), UVM_MEDIUM)
            transfer_id++;
          end
        
          sema.put(1); // Indicate transaction completion
        end

        begin //write_response_phase
	        while (vif.BVALID == 0 || vif.BREADY == 0)begin
            @(posedge vif.clk);
          end
	        	`uvm_info("axi_mon", "write_response", UVM_MEDIUM)
            wr_tx.bvalid = vif.BVALID;
            wr_tx.bready = vif.BREADY;
	        	wr_tx.bresp = vif.BRESP;
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
	       while (vif.ARVALID == 0 || vif.ARREADY == 0)begin
            @(posedge vif.clk);
         end
	       	`uvm_info("axi_mon", "Read_address", UVM_MEDIUM)
	       	rd_tx.wr_rd = 1'b0;
          rd_tx.arvalid = vif.ARVALID;
          rd_tx.arready = vif.ARREADY;
	       	rd_tx.araddr = vif.ARADDR;
	       	rd_tx.rid = vif.ARID;
	       	rd_tx.arlen= vif.ARLEN;
	       	rd_tx.arsize = vif.ARSIZE;
	       	rd_tx.arburst = vif.ARBURST;
	       	sema.put(1);//put write_tx to analysis_port by write method
         `uvm_info("Monitor_Read_addr_tx",$sformatf("\n #### ARVALID=%0d, ARREADY=%0d",vif.ARVALID, vif.ARREADY), UVM_MEDIUM)
         `uvm_info("Monitor_Read_addr_tx",$sformatf("\n #### wr_rd=%0d, \n araddr=%h,\n Arlen=%h,\n arburst=%h,\n Arsize=%h,\n Arid=%0d",rd_tx.wr_rd, rd_tx.araddr, rd_tx.arlen, rd_tx.arburst, rd_tx.arsize, rd_tx.arid), UVM_MEDIUM)
      end

      begin //read_data/resp_phase
         int transfer_ids = 0; // Track transfer count
         
         while (transfer_ids <= rd_tx.arlen) begin
           @(posedge vif.clk);
           
           // Wait for WVALID and WREADY
           while (vif.RVALID == 0 || vif.RREADY == 0) begin
             @(posedge vif.clk);
           end
           
           // Capture data
           rd_tx.rvalid = vif.RVALID;
           rd_tx.rready = vif.RREADY;
           rd_tx.rdataQ.push_back(vif.RDATA);
	      	 rd_tx.rlast = vif.RLAST;
           
           `uvm_info("Monitor_Read_Data_tx", $sformatf("Transfer[%0d]: RDATA = %h, RVALID = %h, RREADY =%h", transfer_ids, vif.RDATA, vif.RVALID, vif.RREADY), UVM_MEDIUM)
           transfer_ids++;
         end
	   
         if(vif.RLAST == 1)begin//this indicate the end of read tx
           `uvm_info("Monitor_read_data_tx","Last Transfer in Burst",UVM_HIGH);
	      	 rd_tx.rresp = vif.RRESP;
         end
       `uvm_info("Monitor_Read_data_transaction", rd_tx.sprint(), UVM_HIGH)
       `uvm_info("Monitor_Read11_Data_tx", $sformatf("\n RLAST=%0d, \n RRESP=%0d", vif.RLAST, rd_tx.rresp), UVM_MEDIUM)
         sema.put(1); // Indicate transaction completion
      end
          
      begin
         sema.get(5);
         ap_port.write(wr_tx);
         `uvm_info("WRITE_MONITOR_PACKETS_SENT",$sformatf("%0s",wr_tx.sprint),UVM_HIGH);
         `uvm_info("WRITE_ADDR_DATA_CHECK",$sformatf("\n\n awaddr == %p \n WDATA== %p \n WDATA_SIZE =%0d ",wr_tx.awaddr, wr_tx.wdataQ, wr_tx.wdataQ.size),UVM_NONE);
         ap_port.write(rd_tx);
         `uvm_info("READ_MONITOR_PACKETS_SENT",$sformatf("%0s",rd_tx.sprint),UVM_HIGH);
         `uvm_info("READ_ADDR_DATA_CHECK",$sformatf("\n\n araddr == %p \n RDATA== %p \n RDATA_SIZE =%0d ",rd_tx.araddr, rd_tx.rdataQ, rd_tx.rdataQ.size),UVM_NONE);
      end
    end
   join_none
  wait fork;
 end
endtask
endclass
