interface mem_dmem_intf(
  input  logic          clk,
  input  logic          resetn
);
  import mem_dmem_pkg::*;

  logic           mem_dmem_vld;
  mem_dmem_pkt_t mem_dmem_pkt;

  clocking cb @(posedge clk);
    inout mem_dmem_vld;
    inout mem_dmem_pkt;
  endclocking : cb

endinterface : mem_dmem_intf

