// File Name : top.sv
// Version   : 0.1
//-------------------top.dv-------------------------------------------------------------
//
//////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns
`ifndef TOP
`define TOP
  import uvm_pkg ::* ;
  import pkg_axi::*;
  `include "uvm_macros.svh"
  `include "axi.svh"
  `include  "axi_test_lib.sv"
  `include "interface.sv"
 
  module top();
    base_test test;
    intf_axi vif ();
    axi_ram #( 32, 16,(DATA_WIDTH/8),8,0) dut (
     .clk(vif.clk),
     .rst(vif.rst),
     .s_axi_awid(vif.s_axi_awid),
     .s_axi_awaddr(vif.s_axi_awaddr),
     .s_axi_awlen(vif.s_axi_awlen),
     .s_axi_awsize(vif.s_axi_awsize),
     .s_axi_awburst(vif.s_axi_awburst),
     .s_axi_awlock(vif.s_axi_awlock),
     .s_axi_awcache(vif.s_axi_awcache),
     .s_axi_awprot(vif.s_axi_awprot),
     .s_axi_awvalid(vif.s_axi_awvalid),
     .s_axi_awready(vif.s_axi_awready),
     .s_axi_wdata(vif.s_axi_wdata),
     .s_axi_wstrb(vif.s_axi_wstrb),
     .s_axi_wlast(vif.s_axi_wlast),
     .s_axi_wvalid(vif.s_axi_wvalid),
     .s_axi_wready(vif.s_axi_wready),
     .s_axi_bid(vif.s_axi_bid),
     .s_axi_bresp(vif.s_axi_bresp),
     .s_axi_bvalid(vif.s_axi_bvalid),
     .s_axi_bready(vif.s_axi_bready),
     .s_axi_arid(vif.s_axi_arid),
     .s_axi_araddr(vif.s_axi_araddr),
     .s_axi_arlen(vif.s_axi_arlen),
     .s_axi_arsize(vif.s_axi_arsize),
     .s_axi_arburst(vif.s_axi_arburst),
     .s_axi_arlock(vif.s_axi_arlock),
     .s_axi_arcache(vif.s_axi_arcache),
     .s_axi_arprot(vif.s_axi_arprot),
     .s_axi_arvalid(vif.s_axi_arvalid),
     .s_axi_arready(vif.s_axi_arready),
     .s_axi_rid(vif.s_axi_rid),
     .s_axi_rdata(vif.s_axi_rdata),
     .s_axi_rresp(vif.s_axi_rresp),
     .s_axi_rlast(vif.s_axi_rlast),
     .s_axi_rvalid(vif.s_axi_rvalid),
     .s_axi_rready(vif.s_axi_rready)
    );


   initial begin
     vif.rst=1'b0;
     vif.clk=1'b0;
   end

   always #5 vif. clk = !vif.clk;
  

   initial begin 
     test = base_test::type_id::create("test",null);
     uvm_config_db #(virtual intf_axi):: set(null,"*","vif",vif);
     run_test();
   end
  

  endmodule  

`endif //TOP
