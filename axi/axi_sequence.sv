////////////////////////////////////////////////////////////////////////////////////////////////
// File Name : axi_sequence.sv
// version   : 0.1
// -------------axi_sequence---------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////



`ifndef AXI_SEQUENCE
`define AXI_SEQUENCE

  
  class axi_sequence extends uvm_sequence#(axi_packet);

    `uvm_object_utils(axi_sequence);
     
    function new (string name = "axi_sequence");
      super.new(name);  
    endfunction
   
    // Declaration of tasks and function as extern   
    extern task body();
 
  endclass :axi_sequence 

    // UVM sequence  body
    task axi_sequence ::body();
      if(starting_phase != null) starting_phase.raise_objection(this);
       for (int i=0;i< 100;i++)
       begin
    // Randomize and send to the Values to the sequencer
        `uvm_do(req);
       end
       #400;
      if(starting_phase != null) starting_phase.drop_objection(this);
    endtask :body


`endif //AXI_SEQUENCE

