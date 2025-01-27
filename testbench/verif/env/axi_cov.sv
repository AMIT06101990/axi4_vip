class axi_cov extends uvm_subscriber#(axi_tx);
`uvm_component_utils(axi_cov)
uvm_analysis_export#(axi_tx) ax_port;
 
  covergroup axi_cg;

  endgroup

function new(string name = "axi_cov", uvm_component parent);
  super.new (name, parent);
  axi_cg = new();
endfunction
  
function void write(axi_tx t);

endfunction
endclass
