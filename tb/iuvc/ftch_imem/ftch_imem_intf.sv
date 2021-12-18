interface ftch_imem_intf(
  input  logic          clk,
  input  logic          resetn
);
  import ftch_imem_pkg::*;

  logic           ftch_imem_vld;
  ftch_imem_pkt_t ftch_imem_pkt;

  clocking cb @(posedge clk);
    inout ftch_imem_vld;
    inout ftch_imem_pkt;
  endclocking : cb

endinterface : ftch_imem_intf

