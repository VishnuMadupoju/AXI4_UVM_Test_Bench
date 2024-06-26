///////////////////////////////////////////////////////////////////////////////
// File Name : axi_test_lib.sv
// version   :0.1
//--------------yapp_test_lib--------------------
//////////////////////////////////////////////////////////////////////////////



`ifndef BASE_TEST
`define BASE_TEST 


  class base_test extends uvm_test;

    `uvm_component_utils(base_test);

    function new(string name , uvm_component parent =null);
      super.new(name, parent);
    endfunction 

    axi_env env;

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = axi_env :: type_id :: create ("env", this);
      uvm_config_wrapper::set(this, "env.agent.sequencer.run_phase","default_sequence",axi_sequence::type_id::get());    
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();

    endfunction 

  endclass

 

`endif// BASE_TEST
