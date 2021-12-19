interface dmem_mem_intf(
  input  logic          clk,
  input  logic          resetn
);
  import mem_dmem_pkg::*;

  logic          dmem_mem_vld;
  dmem_mem_pkt_t dmem_mem_pkt;

  clocking cb @(posedge clk);
    inout dmem_mem_vld;
    inout dmem_mem_pkt;
  endclocking : cb

endinterface : dmem_mem_intf

