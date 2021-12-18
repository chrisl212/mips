interface imem_ftch_intf(
  input  logic          clk,
  input  logic          resetn
);
  import ftch_imem_pkg::*;

  logic           imem_ftch_vld;
  imem_ftch_pkt_t imem_ftch_pkt;

  clocking cb @(posedge clk);
    inout imem_ftch_vld;
    inout imem_ftch_pkt;
  endclocking : cb

endinterface : imem_ftch_intf

