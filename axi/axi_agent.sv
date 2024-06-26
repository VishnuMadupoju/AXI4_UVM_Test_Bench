//////////////////////////////////////////////////////////////////////
//
// File Name :axi_agent.sv
// version   :0.1 
//  ------------axi_agent.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef AXI_AGENT
`define AXI_AGENT

 
  class axi_agent extends uvm_agent;
   
    `uvm_component_utils(axi_agent);

    axi_monitor monitor;
   
    axi_driver driver;

    axi_sequencer sequencer;
    
    axi_sequence sequence_1;

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name ,uvm_component parent =null);
      super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase (phase);
      monitor = axi_monitor:: type_id:: create("monitor",this);
      if(get_is_active()) begin
        sequence_1 = axi_sequence  :: type_id :: create("sequence_1");
        sequencer  = axi_sequencer:: type_id:: create("sequencer",this);
	driver     = axi_driver:: type_id:: create("driver",this);
      end

    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(get_is_active()) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
      end
    endfunction 
    
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      `uvm_info("AGENT",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
    endfunction 
     
     
     
  endclass  





`endif  // YAPP_TX_AGENT


