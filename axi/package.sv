//////////////////////////////////////////////////////////////////
// File Name : package.sv
// version   : 0.1  
//--------------------PACKAGE-----------------------------------
//
/////////////////////////////////////////////////////////////////



`ifndef PKG
`define PKG

  package pkg_axi;
  
     // Width of data bus in bits
     parameter DATA_WIDTH = 32;
     // Width of address bus in bits
     parameter ADDR_WIDTH = 16;
     // Width of wstrb (width of data bus in words)
     parameter STRB_WIDTH = (DATA_WIDTH/8);
     // Width of ID signal
     parameter ID_WIDTH = 8;
  
  endpackage 

`endif //PKG
