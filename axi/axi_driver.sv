/////////////////////////////////////////////////////////////////////////
//
// File Name :axi_driver.sv
// version   :0.1 
// ------------axi_driver.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef AXI_DRIVER
`define AXI_DRIVER


  class axi_driver extends uvm_driver#(axi_packet);
   
    `uvm_component_utils(axi_driver);
   
    virtual  intf_axi vif;
   
    bit [ADDR_WIDTH-1:0] temp_addr ;
    bit [2:0]            temp_size ; 
    bit [1:0]            temp_burst_type;
    function new(string name ,uvm_component parent =null);
      super.new(name,parent);
    endfunction
   
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      `uvm_info("DRIVER",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
    endfunction 
  
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_db #(virtual intf_axi)::get(this,"","vif",vif);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      forever begin
          seq_item_port.get_next_item(req);
         // `uvm_info("Driver Data",$sformatf("data pkt \n",req.sprint()),UVM_NONE);
          @(posedge vif.clk);
          fork
            write_address();
            write_data ();
            read_address();
            read_data();
          join
          seq_item_port.item_done();
      end
    endtask
 
// Write Address

   task write_address();
     if(req.opr == WRITE)
     begin
      // $info("Write address");
       vif.s_axi_awid    = req.s_axi_awid;
       vif.s_axi_awaddr  = req.s_axi_awaddr;
       vif.s_axi_awlen   = req.s_axi_awlen;
       vif.s_axi_awsize  = req.s_axi_awsize;
       vif.s_axi_awburst = req.s_axi_awburst;
       vif.s_axi_awlock  = 'b0;
       vif.s_axi_awcache = 'b0;
       vif.s_axi_awprot  = 'b0;
       vif.s_axi_awvalid = 'b1;
       while (!vif.s_axi_wready) @(posedge  vif.clk); 
       vif.s_axi_awvalid = 'b0;
     end
   endtask

// Write Data 

   task write_data();
     if(req.opr == WRITE)    
     begin
       @(posedge vif.clk);
       //$info("Write Data ");
       vif.s_axi_wlast   = 'b0;
       vif.s_axi_wvalid  = 'b1;
       vif.s_axi_bready  = 'b1;
       temp_addr         = vif.s_axi_awaddr;
       temp_size         = vif.s_axi_awsize;
       temp_burst_type   = vif.s_axi_awburst;
      for(int i=0; i< req.s_axi_awlen +1; i++)
       begin
         vif.s_axi_wdata   = req.s_axi_wdata[i];
         vif.s_axi_wstrb   = strobe(temp_addr,temp_size);
         if(i == req.s_axi_awlen)
         begin
           vif.s_axi_wlast   = 'b1;
         end
         if(!(temp_addr % (2** temp_size) == 0))  // unaligned 
         begin
           if(temp_burst_type == FIXED)
             temp_addr = temp_addr;
           else
           begin 
             temp_addr =temp_addr+((2**temp_size)-temp_addr[1:0]);
             $display("Address Values not else =%0d",temp_addr);
           end
         end
         else
         begin
           if(temp_burst_type == FIXED)
             temp_addr = temp_addr;
           else
           begin
             temp_addr =temp_addr+(2**temp_size);
             $display("Address Values else  =%0d",temp_addr);
           end
         end
         @(posedge vif.clk);
       end
        while (!vif.s_axi_wready) @(posedge vif.clk);
          vif.s_axi_wlast   = 'b0;
          vif.s_axi_wvalid  = 'b0;
     end
   endtask



// task Strobe Calculation from the master side 

   function bit[STRB_WIDTH-1:0] strobe( input [ADDR_WIDTH-1:0]addr,input [2:0] size);
     bit [STRB_WIDTH-1:0] s_axi_wstrb;
     int value_count;
     for(int i=addr[1:0];i< STRB_WIDTH;i++)
     begin
       value_count ++;
       s_axi_wstrb[i] = 1'b1; 
       if(value_count == (2**temp_size))
         break;
     end 
    // $display("strobe =%0b",s_axi_wstrb);
     return s_axi_wstrb;
   endfunction



 
// Read address
   task read_address();
     if(req.opr == READ)  begin  
      // $info("Read address");
       vif.s_axi_arid     = req.s_axi_arid;
       vif.s_axi_araddr   = req.s_axi_araddr;  
       vif.s_axi_arlen    = req.s_axi_arlen;
       vif.s_axi_arsize   = req.s_axi_arsize;
       vif.s_axi_arsize   = 'b10;
       vif.s_axi_arburst  = req.s_axi_arburst;
       vif.s_axi_arlock   = 'b0;       
       vif.s_axi_arcache  = 'b0;     
       vif.s_axi_arprot   = 'b0;
       vif.s_axi_arvalid  = 'b1;
       @(posedge vif.clk);
       vif.s_axi_arvalid  = 'b0;
     end
   endtask

   task read_data ();
     if(req.opr == READ)begin
       vif.s_axi_rready   = 'b1;
       wait((vif.s_axi_rlast));
       @(posedge vif.clk);
       vif.s_axi_rready   = 'b0;
     end
   endtask 

  endclass  

`endif  // AXI
 
