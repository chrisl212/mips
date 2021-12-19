interface mem_wrb_intf(
  input  logic          clk,
  input  logic          resetn
);
  import mem_wrb_pkg::*;

  logic         mem_wrb_vld;
  mem_wrb_pkt_t mem_wrb_pkt;

  clocking cb @(posedge clk);
    inout mem_wrb_vld;
    inout mem_wrb_pkt;
  endclocking : cb

endinterface : mem_wrb_intf

