///////////////////////////////////////////////////////////////////////
// File Name : axi_scoreboard.sv
// version   : 0.1
// -----------------axi_scoreboard.sv-------------------------------
//
/////////////////////////////////////////////////////////////////////

 `ifndef AXI_SCOREBOARD

 `define AXI_SCOREBOARD

   class axi_scoreboard extends uvm_scoreboard;
     `uvm_component_utils(axi_scoreboard);
     
     function new(string name , uvm_component parent =null);
       super.new(name, parent);
     endfunction    
     
     uvm_analysis_imp #(axi_packet, axi_scoreboard) m_sc_imp;
     uvm_analysis_imp #(axi_packet, axi_scoreboard) m_sc_imp_write;

        // bit [7:0] mem[(2**ADDR_WIDTH)-1:0];
     bit [7:0] mem[201-1:0];


/  / Write Address memories
   
     bit  [ID_WIDTH-1:0]    s_axi_awid_reg;
     bit  [ADDR_WIDTH-1:0]  s_axi_awaddr_reg;
     bit  [7:0]             s_axi_awlen_reg;
     bit  [2:0]             s_axi_awsize_reg;
     bit  [1:0]             s_axi_awburst_reg;
     bit                    s_axi_awlock_reg;
     bit  [3:0]             s_axi_awcache_reg;
     bit  [2:0]             s_axi_awprot_reg;
     bit                    s_axi_awready_reg;
     bit                    s_axi_awvalid_reg;

/  / Read Address memories
     bit  [ID_WIDTH-1:0]    s_axi_arid_reg;
     bit  [ADDR_WIDTH-1:0]  s_axi_araddr_reg;
     bit  [7:0]             s_axi_arlen_reg;
     bit  [2:0]             s_axi_arsize_reg;
     bit  [1:0]             s_axi_arburst_reg;
     bit                    s_axi_arlock_reg;
     bit  [3:0]             s_axi_arcache_reg;
     bit  [2:0]             s_axi_arprot_reg;
     bit                    s_axi_arvalid_reg;
     bit                    s_axi_arready_reg;
   
   
     extern virtual function void build_phase (uvm_phase phase)
     extern virtual function void write(axi_packet pkt);
     extern function write_addres (input axi_packet pkt); 
     extern function write_data(input axi_packet pkt);
     extern function write_data_strb(input axi_packet pkt);

// Write Response
     function write_resp(input axi_packet pkt);
       if(pkt.s_axi_bvalid && pkt.s_axi_bready)
       begin
         if((s_axi_awid_reg == pkt.s_axi_bid ) && (pkt.s_axi_bresp == 2'b00))
         begin
           `uvm_info("SCO","Data written successfully ",UVM_NONE);
         end
         else
         begin
           `uvm_info("SCO","Data written Failed ",UVM_NONE);
         end
       end
     endfunction  



// Read address
     function read_address(input axi_packet pkt);
       if(pkt.s_axi_arvalid && pkt.s_axi_arready)
       begin
         s_axi_arid_reg     = pkt.s_axi_arid; 
         s_axi_araddr_reg   = pkt.s_axi_araddr; 
         s_axi_arlen_reg    = pkt.s_axi_arlen;
         s_axi_arsize_reg   = pkt.s_axi_arsize; 
         s_axi_arburst_reg  = pkt.s_axi_arburst;
         s_axi_arlock_reg   = pkt.s_axi_arlock;
         s_axi_arcache_reg  = pkt.s_axi_arcache;
         s_axi_arprot_reg   = pkt.s_axi_arprot;
         s_axi_arvalid_reg  = pkt.s_axi_arvalid;
         s_axi_arready_reg  = pkt.s_axi_arready;
         `uvm_info("SCO",$sformatf(" Read address at %0b ",s_axi_araddr_reg),UVM_NONE);
       end
     endfunction



// Read data

     function read_data(input axi_packet pkt);
       if(pkt.s_axi_rvalid && pkt.s_axi_rready)
       begin
         if(s_axi_araddr_reg /(2**s_axi_arsize_reg )== 0) 
         begin
           for(int i=0 ;i < (2**s_axi_arsize_reg ) ;i++)
           begin
             if ((mem[s_axi_araddr_reg] == pkt.s_axi_rdata [i*8+:8]) && (s_axi_arid_reg == pkt.s_axi_rid ))
             begin 
               `uvm_info("SCO-Passed",$sformatf("Data is macheed with the data in the reference model as %0h and mem =%0h",pkt.s_axi_rdata[i*8+:8],mem[s_axi_araddr_reg]),UVM_NONE);
                if( s_axi_awburst_reg == FIXED )
                  s_axi_araddr_reg = s_axi_araddr_reg;
                else
                  s_axi_araddr_reg = s_axi_araddr_reg + 1;
             end
             else
             begin
               `uvm_info("SCO-Failed",$sformatf("Data Failed top match with the id =%0b and data from dut =%0h and the mem  =%0h addr of mem= %0h  ",pkt.s_axi_rid ,pkt.s_axi_rdata[i*8+:8],mem[s_axi_araddr_reg],s_axi_araddr_reg),UVM_NONE); 
                if(s_axi_awburst_reg == FIXED) 
                   s_axi_araddr_reg = s_axi_araddr_reg; 
                else
                   s_axi_araddr_reg = s_axi_araddr_reg + 1;
             end
           end
         end
         else begin
           for(int i=s_axi_araddr_reg[1:0]; i < (2**s_axi_arsize_reg ); i++)
           begin
             if ((mem[s_axi_araddr_reg] == pkt.s_axi_rdata [i*8+:8]) && (s_axi_arid_reg == pkt.s_axi_rid ))
             begin 
               `uvm_info("SCO-Passed",$sformatf("Data is macheed with the data in the reference model as %0h and mem =%0h",pkt.s_axi_rdata[i*8+:8],mem[s_axi_araddr_reg]),UVM_NONE);
                if (s_axi_awburst_reg == FIXED)
                  s_axi_araddr_reg =s_axi_araddr_reg;
                else 
                  s_axi_araddr_reg = s_axi_araddr_reg + 1;
             end
             else
             begin
               `uvm_info("SCO-Failed",$sformatf("Data Failed top match with the id =%0b and data from dut =%0h and the mem  =%0h addr_mem =%0d ",pkt.s_axi_rid ,pkt.s_axi_rdata[i*8+:8],mem[s_axi_araddr_reg],s_axi_araddr_reg),UVM_NONE);
                if (s_axi_awburst_reg == FIXED)
                  s_axi_araddr_reg =s_axi_araddr_reg;
                else 
                  s_axi_araddr_reg = s_axi_araddr_reg + 1;    
             end
           end
         end
       end
     endfunction 

     
  endclass



//UVM build_phase to create the objects for the TLM analysis ports 
     virtual function void axi_scoreboard ::build_phase(uvm_phase phase);
       super.build_phase(phase);
       m_sc_imp        = new("m_sc_imp",this);
       m_sc_imp_write  = new("m_sc_imp_write",this);
     endfunction :buid_phase

//Write functin of the AXI to get the values from the TLM analysis port   
     virtual function void axi_scoreboard ::write(axi_packet pkt);
       pkt.print();
       fork 
         write_address(pkt); 
         write_data(pkt);
         write_resp(pkt);
         read_address(pkt);
         read_data(pkt);
       join
     endfunction:write 
 
// Write Address function to capture into the varables of write address channel 

     function axi_scoreboard :: write_address( input axi_packet pkt);
       if(pkt.s_axi_awvalid && pkt.s_axi_awready)
       begin
          s_axi_awid_reg     = pkt.s_axi_awid;
          s_axi_awaddr_reg   = pkt.s_axi_awaddr;    
          s_axi_awlen_reg    = pkt.s_axi_awlen;    
          s_axi_awsize_reg   = pkt.s_axi_awsize;    
          s_axi_awburst_reg  = pkt.s_axi_awburst;    
          s_axi_awlock_reg   = pkt.s_axi_awlock;    
          s_axi_awcache_reg  = pkt.s_axi_awcache;    
          s_axi_awprot_reg   = pkt.s_axi_awprot; 
          `uvm_info("SCO",$sformatf(" Write address at %0b and ",s_axi_awaddr_reg),UVM_NONE);
       end
     endfunction :write_address

// Write data function to write the recieved data into the reference model

     function axi_scoreboard ::write_data(input axi_packet pkt);
       if(pkt.s_axi_wvalid && pkt.s_axi_wready)
       begin
         write_data_strb( pkt);
        `uvm_info("SCO_triggered_the_write","Entered The Dragon",UVM_NONE);
       end   
     endfunction : write_data
         
         
// Write strobe logic to write data to the reference memory similar way of the AXI slave 
         
     function axi_soreboard :: write_data_strb(input axi_packet pkt);
       for(int i= 0; i < STRB_WIDTH ; i++) 
       begin
         if(pkt.s_axi_wstrb[i]==0)
         begin
           mem[s_axi_awaddr_reg]  = mem[s_axi_awaddr_reg];
         end
         else
         begin
           mem[s_axi_awaddr_reg]= pkt.s_axi_wdata_m[i*8+:8];
           `uvm_info("SCO",$sformatf("Data written successfully  at %0h and =%0h",s_axi_awaddr_reg,mem[s_axi_awaddr_reg]),UVM_NONE);
           if( s_axi_awburst_reg == FIXED)
               s_axi_awaddr_reg =s_axi_awaddr_reg;
           else
             s_axi_awaddr_reg ++;
         end
       end
     endfunction :write_data_strb



 
`endif // AXI_SCOREBOARD
