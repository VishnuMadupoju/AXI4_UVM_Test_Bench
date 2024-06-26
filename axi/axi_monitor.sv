//////////////////////////////////////////////////////////////////////
//
// File Name :axi_monitor.sv
// version   :0.1 
//  ------------axi_monitor.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef AXI_MONITOR
`define AXI_MONITOR

 
  class axi_monitor extends uvm_monitor;
     
    virtual  intf_axi vif;
    axi_packet pkt,pkt_read;
    `uvm_component_utils(axi_monitor); 
   
    uvm_analysis_port #(axi_packet) mon_analysis_port_1;// declaring the analysis port to get the data from the intereface
    uvm_analysis_port #(axi_packet) mon_analysis_port_write;
     
    function new(string name ,uvm_component parent =null);
      super.new(name,parent);
    endfunction

// Building the  analysis port and (vif to get from the test) 

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_analysis_port_1 = new("mon_analysis_port_1", this);
      mon_analysis_port_write = new("mon_analysis_port_write", this);
      uvm_config_db #(virtual intf_axi)::get(this,"","vif",vif);
    endfunction 

    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      `uvm_info("MONITOR",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
    endfunction

    virtual task run_phase(uvm_phase phase);
      forever begin
      pkt        = axi_packet::type_id ::create ("pkt");
      pkt_read   = axi_packet::type_id ::create ("pkt_read");
        fork
          write_address();
          write_data();
          write_resp();
          read_address();
          read_data();
        join
        #1;
      end  
    endtask   

//sample the data from the write address channel to pass to the scoreboard 
      
    task write_address();
      if (vif.s_axi_awvalid && vif.s_axi_awready)
      begin
        pkt.s_axi_awid    = vif.s_axi_awid;
        pkt.s_axi_awaddr  = vif.s_axi_awaddr;
        pkt.s_axi_awlen   = vif.s_axi_awlen;
        pkt.s_axi_awsize  = vif.s_axi_awsize;
        pkt.s_axi_awburst = vif.s_axi_awburst;
        pkt.s_axi_awlock  = vif.s_axi_awlock;
        pkt.s_axi_awcache = vif.s_axi_awcache;
        pkt.s_axi_awprot  = vif.s_axi_awprot;
        pkt.s_axi_awready = vif.s_axi_awready;
        pkt.s_axi_awvalid = vif.s_axi_awready;
        @(posedge vif.clk);
        mon_analysis_port_write.write(pkt);
        `uvm_info("MON-> WRITE_ADDRESS",  $sformatf("Value od awaddr is %0d",pkt.s_axi_awaddr),UVM_NONE);
      end
    endtask

// Write Data sampling

    task write_data();
      if(vif.s_axi_wvalid && vif.s_axi_wready)
      begin
        pkt.s_axi_wdata_m = vif.s_axi_wdata;
        pkt.s_axi_wstrb = vif.s_axi_wstrb;
        pkt.s_axi_wlast = vif.s_axi_wlast;
        pkt.s_axi_wready= vif.s_axi_wready;
        pkt.s_axi_wvalid= vif.s_axi_wvalid;
        @(posedge vif.clk);
        `uvm_info("MON->WRITE_DATA",  $sformatf("Value od wadata is %0d",pkt.s_axi_wdata_m),UVM_NONE);
        mon_analysis_port_write.write(pkt);
        end
    endtask

// write response
    
    task write_resp ();
      if(vif.s_axi_bvalid && vif.s_axi_bready)
      begin
        pkt.s_axi_bid    = vif.s_axi_bid; 
        pkt.s_axi_bresp  = vif.s_axi_bresp;
        pkt.s_axi_bvalid = vif.s_axi_bvalid;
        pkt.s_axi_bready = vif.s_axi_bready;
        @(posedge vif.clk);
        `uvm_info("MON->WRITE_RESP",  $sformatf("Value of wresp is %0d",pkt.s_axi_bresp),UVM_NONE);
        mon_analysis_port_write.write(pkt);
      end
    endtask


// read_address for sampling of the read address
    task read_address();
      if(vif.s_axi_arvalid && vif.s_axi_arready)
      begin
        pkt_read.s_axi_arid    = vif.s_axi_arid; 
        pkt_read.s_axi_araddr  = vif.s_axi_araddr;
        pkt_read.s_axi_arlen   = vif.s_axi_arlen;
        pkt_read.s_axi_arsize  = vif.s_axi_arsize;
        pkt_read.s_axi_arburst = vif.s_axi_arburst;
        pkt_read.s_axi_arlock  = vif.s_axi_arlock;
        pkt_read.s_axi_arcache = vif.s_axi_arcache;
        pkt_read.s_axi_arprot  = vif.s_axi_arprot;
        pkt_read.s_axi_arvalid = vif.s_axi_arvalid;
        pkt_read.s_axi_arready = vif.s_axi_arready;
        @(posedge vif.clk);
        `uvm_info("MON->READ_ADDRESS",  $sformatf("Value of readaddress is %0d",pkt_read.s_axi_araddr),UVM_NONE);
        mon_analysis_port_1.write(pkt_read);
      end
    endtask
   
//read_data is for the sampling of the read data

    task read_data ();
      if(vif.s_axi_rvalid && vif.s_axi_rready)
      begin
        pkt_read.s_axi_rid     = vif.s_axi_rid;
        pkt_read.s_axi_rdata   = vif.s_axi_rdata;
        pkt_read.s_axi_rresp   = vif.s_axi_rresp;
        pkt_read.s_axi_rlast   = vif.s_axi_rlast;
        pkt_read.s_axi_rvalid  = vif.s_axi_rvalid;
        pkt_read.s_axi_rready  = vif.s_axi_rready;
        @(posedge vif.clk);
        `uvm_info("MON->READ_DATA",  $sformatf("Value of read data is %0d",pkt_read.s_axi_rdata),UVM_NONE);
        mon_analysis_port_1.write(pkt_read);
      end
    endtask
   
  endclass 

    
   


`endif  // AXI_MONITOR
