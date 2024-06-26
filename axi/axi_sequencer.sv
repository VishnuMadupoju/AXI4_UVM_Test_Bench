//////////////////////////////////////////////////////////////////////
//
// File Name :AXI_sequencer.sv
// version   :0.1 
//  ------------AXI_sequencer.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef AXI_SEQUENCER
`define AXI_SEQUENCER


 
  class axi_sequencer extends uvm_sequencer#(axi_packet);
   
    `uvm_component_utils(axi_sequencer);
   
     function new(string name ,uvm_component parent =null);
       super.new(name,parent);
     endfunction
  
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      `uvm_info("SEQUENCER",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
    endfunction

 
  endclass  




`endif  // AXI_sequencer
