module haz(
  input  haz_pkg::exec_haz_pkt_t    exec_haz_pkt,
  input  haz_pkg::mem_haz_pkt_t     mem_haz_pkt,
  input  haz_pkg::dec_haz_pkt_t     dec_haz_pkt,
  output haz_pkg::haz_dec_pkt_t     haz_dec_pkt,
  output haz_pkg::haz_exec_pkt_t    haz_exec_pkt
);

  logic stall;
  logic bubble;

  assign bubble = mem_haz_pkt.jmp_vld;

  always_comb begin : comb_stall
    stall = 0;

    if (dec_haz_pkt.rs_vld) begin
      stall |= dec_haz_pkt.rs_reg == exec_haz_pkt.dst_reg && exec_haz_pkt.dst_vld;
      stall |= dec_haz_pkt.rs_reg == mem_haz_pkt.dst_reg && mem_haz_pkt.dst_vld;
    end
    if (dec_haz_pkt.rt_vld) begin
      stall |= dec_haz_pkt.rt_reg == exec_haz_pkt.dst_reg && exec_haz_pkt.dst_vld;
      stall |= dec_haz_pkt.rt_reg == mem_haz_pkt.dst_reg && mem_haz_pkt.dst_vld;
    end
  end

  assign haz_dec_pkt.stall      = stall & ~bubble;
  assign haz_dec_pkt.bubble     = bubble;
  assign haz_exec_pkt.bubble    = bubble;

endmodule : haz
