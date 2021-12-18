interface ftch_dec_intf(
  input  logic          clk,
  input  logic          resetn
);
  import ftch_dec_pkg::*;

  logic          ftch_dec_vld;
  logic          ftch_dec_rdy;
  ftch_dec_pkt_t ftch_dec_pkt;

  clocking cb @(posedge clk);
    inout ftch_dec_vld;
    inout ftch_dec_rdy;
    inout ftch_dec_pkt;
  endclocking : cb

endinterface : ftch_dec_intf

