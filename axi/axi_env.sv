//////////////////////////////////////////////////////////////////////
//
// File Name :axi_env.sv
// version   :0.1 
//  ------------axi_env.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef AXI_ENV
`define AXI_ENV
  

  
  class axi_env extends uvm_env;
   
    `uvm_component_utils(axi_env);

    axi_agent agent;
    axi_scoreboard scoreboard;

    function new(string name ,uvm_component parent =null);
      super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase (phase);
      agent     = axi_agent :: type_id:: create("agent",this);
      scoreboard = axi_scoreboard :: type_id ::create("scoreboard",this);
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      `uvm_info("ENV",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.monitor.mon_analysis_port_1.connect(scoreboard.m_sc_imp);
      agent.monitor.mon_analysis_port_write.connect(scoreboard.m_sc_imp_write);
    endfunction 
   
  endclass  

`endif  // AXI_ENV
