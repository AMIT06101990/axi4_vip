//-----------------------------------------------------------------------//
// Title       : AXI Testbench Top Module                                //
// Design Unit : top_tb                                                  //
// Description :                                                         //
//               - This is the top-level testbench module for verifying  //
//                 the AXI DUT using the UVM methodology.                //
//               - Instantiates the AXI DUT and connects it with the     //
//                 AXI interface.                                        //
//               - Initializes the clock and reset signals.              //
//               - Configures the UVM framework by setting the virtual   // 
//                 interface using uvm_config_db.                        //
//               - Starts the UVM test by calling run_test.              //
//                                                                       //
// Author      : [ASICraft technologies Pvt Ltd.]                        //
// Created On  : [Date]                                                  //
// Last Updated: [Date]                                                  //
//-----------------------------------------------------------------------//
//`timescale 1ns/1ps;
//`timescale 10ns/1ns;
//`timescale 1ns/1ns;
`include "uvm_macros.svh"
`include "axi_pkg.sv"
`include "axi_intf.sv"


module top_tb;

//Import uvm_pkg and axi_tb_pkg
import uvm_pkg::*;
import axi_tb_pkg::*;

// Variable Declaration
reg clk,reset;

// Create inteface handle
axi_intf pif(clk);

//DUT instantiation
axi_dut DUT(

     .clock(pif.clk),
     .RESETn(pif.reset),

    //Write Address Phase
    .s_axi_awid     (pif.AWID),
    .s_axi_awaddr   (pif.AWADDR),
    .s_axi_awlen    (pif.AWLEN),
    .s_axi_awsize   (pif.AWSIZE),
    .s_axi_awburst  (pif.AWBURST),
    .s_axi_awlock   (pif.AWLOCK),
    .s_axi_awcache  (pif.AWCACHE),
    .s_axi_awprot   (pif.AWPROT), 
    .s_axi_awvalid  (pif.AWVALID),
    .s_axi_awready  (pif.AWREADY),
    
   //Write Data pahse
    .s_axi_wid      (pif.WID),
    .s_axi_wdata    (pif.WDATA),
    .s_axi_wstrb    (pif.WSTRB),
    .s_axi_wlast    (pif.WLAST),
    .s_axi_wvalid   (pif.WVALID), 
    .s_axi_wready   (pif.WREADY), 
     
   //Write Response pahse
    .s_axi_bid      (pif.BID),
    .s_axi_bresp    (pif.BRESP),
    .s_axi_bvalid   (pif.BVALID),
    .s_axi_bready   (pif.BREADY),

    //Read Address Phase
    .s_axi_arid     (pif.ARID),
    .s_axi_araddr   (pif.ARADDR),
    .s_axi_arlen    (pif.ARLEN),
    .s_axi_arsize   (pif.ARSIZE),
    .s_axi_arburst  (pif.ARBURST),
    .s_axi_arlock   (pif.ARLOCK),
    .s_axi_arcache  (pif.ARCACHE),
    .s_axi_arprot   (pif.ARPROT), 
    .s_axi_arvalid  (pif.ARVALID),
    .s_axi_arready  (pif.ARREADY),

     //REad Data pahse
    .s_axi_rid      (pif.RID),
    .s_axi_rdata    (pif.RDATA),
    .s_axi_rresp    (pif.RRESP),
    .s_axi_rlast    (pif.RLAST),
    .s_axi_rvalid   (pif.RVALID), 
    .s_axi_rready   (pif.RREADY) 
  );

// 100Mhz Clock Generation
initial begin
  clk = 0;
  forever #5 clk = ~clk;
end

// Apply Reset 
initial begin
  pif.reset = 1;
  repeat(4)@(posedge clk);
  pif.reset = 0;
end

//set interface hanle by configdb and resourcedb
initial begin
   uvm_config_db#(virtual axi_intf)::set(null, "*", "VIF", pif);
   //uvm_config_db#(virtual axi_intf)::set(uvm_root::get(), "*", "VIF", pif);
  //uvm_resource_db#(virtual axi_intf)::set("GLOBAL", "VIF", pif, null);
  
  //Call run_test
  run_test("axi_base_test");
end

endmodule 

