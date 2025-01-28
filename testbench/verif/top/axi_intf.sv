//------------------------------------------------------------------------//
// Title       : AXI Interface Definition                                 //
// Class Name  : axi_intf                                                 //
// Description :                                                          //
//               - This interface defines the AXI communication protocol  //
//               signals for Master(VIP) and Slave(DUT) communication.    //
//               - It includes write, read, and response channels.        //
//                                                                        //
// Author      : [ASICraft technologies Pvt Ltd.]                         //
// Created On  : [Date]                                                   //
// Last Updated: [Date]                                                   //
//------------------------------------------------------------------------//

//import uvm_pkg::*;
interface axi_intf (input logic clk);

  //Write Address Channel 
  logic reset;
  logic [7:0]  AWID; 
  logic [`ADDR_WIDTH-1:0] AWADDR; 
  logic [7:0]  AWLEN; 
  logic [2:0]  AWSIZE; 
  logic [1:0]  AWBURST;
  logic        AWLOCK;
  logic [3:0]  AWCACHE;
  logic [2:0]  AWPROT; 
  logic        AWVALID; 
  logic        AWREADY;

  //Write Data Channel
  logic [3:0]  WID;
  logic [`DATA_WIDTH-1:0] WDATA;
  logic [`DATA_WIDTH/8-1:0] WSTRB;
  logic        WLAST; 
  logic        WVALID; 
  logic        WREADY;

  //Write Response channel
  logic [7:0]  BID;
  logic [1:0]  BRESP; 
  logic        BVALID; 
  logic        BREADY;
  
 //Read Address Channel 
  logic [7:0]  ARID; 
  logic [`ADDR_WIDTH-1:0] ARADDR; 
  logic [7:0]  ARLEN; 
  logic [2:0]  ARSIZE; 
  logic [1:0]  ARBURST; 
  logic        ARLOCK;
  logic [3:0]  ARCACHE;
  logic [2:0]  ARPROT; 
  logic        ARVALID; 
  logic        ARREADY;

  //Read Data Channel
  logic [7:0]  RID;
  logic [`DATA_WIDTH-1:0] RDATA;
  logic [1:0]  RRESP;
  logic        RLAST; 
  logic        RVALID; 
  logic        RREADY;

//Clocking block for Driver Block
clocking drv_cb@(posedge clk);
  default input #1 output #1;
  output AWID, AWADDR, AWLEN, AWSIZE, AWBURST,  AWLOCK, AWCACHE, AWPROT, AWVALID;
  input  AWREADY;

  output WID, WDATA, WSTRB, WLAST, WVALID;
  input  WREADY;
  
  output BREADY;
  input  BID, BRESP, BVALID;

  output ARID, ARADDR, ARLEN, ARSIZE, ARBURST,  ARLOCK, ARCACHE, ARPROT, ARVALID;
  input  ARREADY;
  
  output  RREADY;
  input  RID, RDATA,RRESP, RLAST, RVALID;
endclocking

//Clocking block for Monitor Block
clocking mon_cb@(posedge clk);
  default input #0 output #0;
  input AWID, AWADDR, AWLEN, AWSIZE, AWBURST,  AWLOCK, AWCACHE, AWPROT, AWVALID;
  input  AWREADY;

  input WID, WDATA, WSTRB, WLAST, WVALID;
  input  WREADY;
  
  input BREADY;
  input  BID, BRESP, BVALID;

  input ARID, ARADDR, ARLEN, ARSIZE, ARBURST,  ARLOCK, ARCACHE, ARPROT, ARVALID;
  input  ARREADY;
  
  input RID, RDATA, RLAST, RVALID, RRESP;
  input  RREADY;
endclocking

//---------------------------------------------------------------------------//
//  Write Address Handshaking                                                 // 
//---------------------------------------------------------------------------//
property Write_addr_handshaking;
       @(posedge clk)  AWVALID |-> ##[0:2]AWREADY;
endproperty

WRITE_HANDSHAKING : assert property (Write_addr_handshaking) begin
           `uvm_info("*** ASSERTION PASSED *** - AWREADY && AWVALID","",UVM_HIGH)
            end 
            else begin
              `uvm_info("ASSERTION FAILED - AWREADY && AWVALID","",UVM_NONE)
            end
         
//---------------------------------------------------------------------------//
//  Write Data Handshaking                                                   // 
//---------------------------------------------------------------------------//
property Write_data_handshaking;
       @(posedge clk)  WVALID |-> ##[0:2] WREADY;
endproperty

WRITE_DATA_HANDSHAKING : assert property (Write_data_handshaking) begin
           `uvm_info("Write_data_handshaking", "ASSERTION PASSED ", UVM_MEDIUM)
            end 
            else begin
           `uvm_info("Write_data_handshaking", "ASSERTION FAILED", UVM_MEDIUM)
            end

//---------------------------------------------------------------------------//
//  Write Response Handshaking                                               // 
//---------------------------------------------------------------------------//
property Write_resp_handshaking;
       @(posedge clk)  BVALID |-> ##[0:2] BREADY;
endproperty

WRITE_RESPONSE_HANDSHAKING : assert property (Write_resp_handshaking) begin
           `uvm_info("*** ASSERTION PASSED *** - BVALID && BREADY","",UVM_HIGH)
            end 
            else 
              `uvm_info("ASSERTION FAILED - BVALID && BREADY","",UVM_NONE)

              
//---------------------------------------------------------------------------//
// Read Address Handshaking                                                  // 
//---------------------------------------------------------------------------//
property Read_addr_handshaking;
       @(posedge clk)  ARVALID |-> ##[0:2]ARREADY;
endproperty

READ_HANDSHAKING : assert property (Read_addr_handshaking) begin
           `uvm_info("*** ASSERTION PASSED *** - ARREADY && ARVALID","",UVM_HIGH)
            end 
            else begin
              `uvm_info("ASSERTION FAILED - ARREADY && ARVALID","",UVM_NONE)
            end
 
//---------------------------------------------------------------------------//
//  Read Data Handshaking                                                    // 
//---------------------------------------------------------------------------//
property Read_data_handshaking;
       @(posedge clk)  WVALID |-> ##[0:2] WREADY;
endproperty

READ_DATA_HANDSHAKING : assert property (Read_data_handshaking) begin
           `uvm_info("*** ASSERTION PASSED *** - RREADY && RVALID","",UVM_HIGH)
            end 
            else begin
              `uvm_info("ASSERTION FAILED - RREADY && RVALID","",UVM_NONE)
            end

//---------------------------------------------------------------------------//
//  Reset and Awvalid on same posedge                                        // 
//---------------------------------------------------------------------------//
property reset_p;
  @(posedge clk)reset |=> AWVALID;
endproperty
ASSERT_RESET_P: assert property(reset_p)begin
              `uvm_info("*** ASSERTION PASSED *** Reset and Awvalid same posedge","",UVM_HIGH)
           end
           else
           `uvm_info("*** ASSERTION FAILED *** Reset and Awvalid same posedge","",UVM_HIGH)

//---------------------------------------------------------------------------//
// Low Reset and Awvalid, Wvalid & Arvalid low                               // 
//---------------------------------------------------------------------------//
//property low_reset_p;
//  @(posedge clk) !reset |->  AWVALID==0 && WVALID == 0 && ARVALID == 0;
//endproperty
//ASSERT_LOW_RESET_P: assert property(low_reset_p)begin
//           `uvm_info("*** ASSERTION PASSED *** Low Reset and Awvalid,Wvalid & Arvalid low","",UVM_HIGH)
//         end
//          else
//           `uvm_info("*** ASSERTION FAILED *** Low Reset and Awvalid,Wvalid & Arvalid low","",UVM_HIGH)
//
//---------------------------------------------------------------------------//
// Awvalid duration High and same duration AWID and AWLEN High               //
//---------------------------------------------------------------------------//
//property valid_info_p;
//  @(posedge clk) AWVALID |-> $stable(AWID) && $stable(AWLEN); 
//endproperty
//ASSERT_VALID_INFO_P: assert property(valid_info_p) begin
//           `uvm_info("*** ASSERTION PASSED *** High Awvalid and Awid and Awlen stable","",UVM_HIGH)
//         end
//           else
//           `uvm_info("*** ASSERTION FAILED*** High Awvalid and Awid and Awlen stable","",UVM_HIGH)


endinterface
