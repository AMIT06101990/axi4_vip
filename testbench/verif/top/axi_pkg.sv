//--------------------------------------------------------------------------//
// Title       : AXI Testbench Package                                      //
// Class Name  : axi_tb_pkg                                                 //
// Description :                                                            //
//              - This package contains various UVM components for the AXI  //
//               testbench and uvm Package / uvm macros.                    //
//                                                                          //
// Author      : [ASICraft technologies Pvt Ltd.]                           //
// Created On  : [Date]                                                     //
// Last Updated: [Date]                                                     //
//--------------------------------------------------------------------------//
package axi_tb_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "comman.sv"
//`include "axi_intf.sv"
`include "axi_tx.sv"
`include "../test/axi_seq.sv"
`include "../test/axi_seqr.sv"
`include "../env/axi_cov.sv"
`include "../env/axi_mon.sv"
`include "../env/axi_driver.sv"
`include "../env/axi_agent.sv"
`include "../env/axi_env.sv"
`include "../test/test_lib.sv"
//`include "top_tb.sv"

endpackage
