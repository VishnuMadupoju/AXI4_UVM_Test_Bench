///////////////////////////////////////////////////////////
// File Name : axi_packet.sv
// version   :0.1
//  -----axi_packet-----------
////////////////////////////////////////////////////////////

  
`ifndef AXI_PACKET
`define AXI_PACKET

  // Enamuration  decleared to randomize the type of transction combination ex : fixed write, inc read etc... 
  typedef enum  {WRITE,READ,NO_OPER} opr_t; 
  typedef enum  {FIXED,INC,WRAP} burst_t; 
  
  class axi_packet extends uvm_sequence_item;
    
    function new(string name ="axi_packet");
      super.new(name);
    endfunction
   
   // Write address channel signals 
    rand opr_t                  opr;
    rand burst_t                bust;
    rand bit  [ID_WIDTH-1:0]    s_axi_awid;
    rand bit  [ADDR_WIDTH-1:0]  s_axi_awaddr;
    rand bit  [7:0]             s_axi_awlen;
    rand bit  [2:0]             s_axi_awsize;
    rand bit  [1:0]             s_axi_awburst;
    rand bit                    s_axi_awlock;
    rand bit  [3:0]             s_axi_awcache;
    rand bit  [2:0]             s_axi_awprot;
         bit                    s_axi_awready;
         bit                    s_axi_awvalid;
     
   // Write Data Channel signals 
    rand bit  [DATA_WIDTH-1:0]  s_axi_wdata[];
         bit  [STRB_WIDTH-1:0]  s_axi_wstrb;
         bit                    s_axi_wlast;
         bit                    s_axi_wready;
         bit  [DATA_WIDTH-1:0]  s_axi_wdata_m;
         bit                    s_axi_wvalid;


   // Write response Channel signals
         bit  [ID_WIDTH-1:0]    s_axi_bid;
         bit  [1:0]             s_axi_bresp;
         bit                    s_axi_bvalid;
         bit                    s_axi_bready;

   // Read Address Channel signals

    rand bit  [ID_WIDTH-1:0]    s_axi_arid;
    rand bit  [ADDR_WIDTH-1:0]  s_axi_araddr;
    rand bit  [7:0]             s_axi_arlen;
    rand bit  [2:0]             s_axi_arsize;
    rand bit  [1:0]             s_axi_arburst;
    rand bit                    s_axi_arlock;
    rand bit  [3:0]             s_axi_arcache;
    rand bit  [2:0]             s_axi_arprot;
    rand bit                    s_axi_arvalid;
         bit                    s_axi_arready;

   // Read data Channel signals
         bit  [ID_WIDTH-1:0]    s_axi_rid;
         bit  [DATA_WIDTH-1:0]  s_axi_rdata;
         bit  [1:0]             s_axi_rresp;
         bit                    s_axi_rlast;
         bit                    s_axi_rvalid;
    rand bit                    s_axi_rready;

 // Field Macros to know the packet randomization Values 

   `uvm_object_utils_begin(axi_packet)
      `uvm_field_enum(opr_t,opr,UVM_ALL_ON)
      `uvm_field_enum(burst_t,bust,UVM_ALL_ON)
      `uvm_field_int(s_axi_awid,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awid,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awaddr,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awlen,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awsize,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awburst,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awlock,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awcache,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awprot,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awvalid,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_awready,UVM_ALL_ON|UVM_BIN)
      `uvm_field_array_int(s_axi_wdata,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_wdata_m,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_wstrb,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_wvalid,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_wready,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_bid,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_bresp,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_bvalid,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_bready,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_arid,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_araddr,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_arlen,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_arsize,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_arburst,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_arlock,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_arcache,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_arprot,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_arvalid,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_arready,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_rvalid,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_rready,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_rdata,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_rresp,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_rlast,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(s_axi_rresp,UVM_ALL_ON|UVM_BIN)
     
    `uvm_object_utils_end
 
    
    // Constraint to limit the burst type to fixed and inc and avoid the wrap
    constraint limit_burst_type_to_incr { soft 
                                          s_axi_awburst == INC;
                                          s_axi_arburst == INC;
                                        }

    // Constraint to limit the range of address to get the non zero randomized values form the DUT
    constraint  limited_range_address { soft 
                                        s_axi_awaddr inside {[1:200]};
                                        s_axi_araddr inside {[1:200]};
                                      }
   
    // constrait to limit the range from lenth to 0:127 for axi 4
    constraint  limited_range_awlen { soft
				//	s_axi_awlen inside {[0:127]};
					s_axi_awlen inside {2,4};
                                   //     s_axi_arlen inside {[0:127]};
                                        s_axi_arlen inside {2,4};
                                    }
      
   // constraint to limit the Axsize to the DATA_WIDTH 

    constraint limited_size  { soft 
                                s_axi_arsize inside {0,1,2} ;
                                s_axi_awsize inside {0,1,2} ;
                             }       

   // constraint to put the packet size of the wdata to the array of length +1  
    constraint  link_wdata_lenth { soft  
                                    s_axi_wdata.size() == s_axi_awlen +1 ;                       
                                 }
  endclass :axi_packet
     
`endif //AXI_PACKET







