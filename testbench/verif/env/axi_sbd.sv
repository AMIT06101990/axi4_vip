//-------------------------------------------------------------------------//
// Title       : AXI Scoreboard class                                      //
// Class Name  : axi_sbd                                                   //
// Description :                                                           //
//               - AXI scoreboard implementation to perform data integrity //
//                 checks for write and read transactions.                 //
//               - During write operation, data will store in Array in     //
//                 form of Byte.                                           //
//               - During read operation, Write and Read data comparision  // 
//                 happend.                                                //
//                                                                         //
// Author      : [ASICraft technologies Pvt Ltd.]                          //
// Created On  : [Date]                                                    //
// Last Updated: [Date]                                                    //
//-------------------------------------------------------------------------//
`uvm_analysis_imp_decl(_master)
class axi_sbd extends uvm_scoreboard;
// Component Registration
`uvm_component_utils(axi_sbd)

// Analysis port implementation
uvm_analysis_imp_master#(axi_tx, axi_sbd) ap_imp;

// Local variables for tracking match/mismatch counts
int local_match_count;
int local_mismatch_count;

// Associative memory for storing written data
bit[7:0] mem[*];

// Default Constructor
function new(string name = "axi_sbd", uvm_component parent=null);
  super.new (name, parent);
endfunction

//Create and initialize the analysis port during the build phase 
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap_imp = new("ap_imp", this);
endfunction 

virtual function void write_master(axi_tx tx);
   int unsigned addr;
	if(tx.wr_rd == 1)begin//during write no compare
    addr = tx.awaddr;
		foreach(tx.wdataQ[i])begin
			mem[addr] = tx.wdataQ[i][7:0];
			mem[addr+1] = tx.wdataQ[i][15:8];
			mem[addr+2] = tx.wdataQ[i][23:16];
			mem[addr+3] = tx.wdataQ[i][31:24];
			addr += 4;
      
   `uvm_info("SBD_WRITE", $sformatf(" $$$ Write_Addr=%h , Write_data = %h $$$", tx.awaddr,tx.wdataQ[i]), UVM_HIGH)
		end
	end	
	else if (tx.wr_rd == 0) begin//during read compare done
  `uvm_info(get_full_name(),$sformatf("Read transaction WR_RD=%0d", tx.wr_rd),UVM_HIGH)
    addr = tx.araddr;
		local_match_count = 0;
		local_mismatch_count = 0;
		foreach(tx.rdataQ[i])begin
      if (mem[addr]   == tx.rdataQ[i][7:0] &&
		  		mem[addr+1] == tx.rdataQ[i][15:8] &&
		  		mem[addr+2] == tx.rdataQ[i][23:16] &&
		  		mem[addr+3] == tx.rdataQ[i][31:24])begin
					axi_common::num_matches++;
      `uvm_info("SBD_READ", $sformatf(" ### Read_addr=%h, Read_data = %h ###",tx.araddr, tx.rdataQ[i]), UVM_HIGH)
      `uvm_info(get_full_name, $sformatf("Comparision Pass , num_matches=%0d,",axi_common::num_matches ),UVM_HIGH)
			end
			else begin
				axi_common::num_mismatches++;
      `uvm_info(get_full_name, $sformatf("Comparision Failed , num_mismatches=%0d,",axi_common::num_mismatches),UVM_HIGH)
			end
			addr += 4;
		end//foreach end
		//whether whole tx is matching or not(not counting on each beat)
	end
endfunction	

endclass
