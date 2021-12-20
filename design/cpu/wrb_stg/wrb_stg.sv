module wrb_stg(
  input  logic                      clk,
  input  logic                      resetn,
  input  logic                      mem_wrb_vld,
  input  mem_wrb_pkg::mem_wrb_pkt_t mem_wrb_pkt,
  output logic                      wrb_dec_vld,
  output wrb_dec_pkg::wrb_dec_pkt_t wrb_dec_pkt
);
  import mips_pkg::*;
  import mem_wrb_pkg::*;
  
  logic             in_pkt_vld, in_pkt_vld_nxt;
  mem_wrb_pkt_t     in_pkt_q, in_pkt_nxt;

  /* =============================================== */
  /* IN_PKT LOGIC */
  /* =============================================== */

  always_comb begin : comb_in_pkt
    in_pkt_vld_nxt = 0;
    in_pkt_nxt     = 0;

    if (mem_wrb_vld) begin
      in_pkt_vld_nxt = 1;
      in_pkt_nxt     = mem_wrb_pkt;
    end
  end

  always_ff @(posedge clk, negedge resetn) begin : ff_in_pkt
    if (resetn == 0) begin
      in_pkt_vld <= 0;
      in_pkt_q   <= 0;
    end else begin
      in_pkt_vld <= in_pkt_vld_nxt;
      in_pkt_q   <= in_pkt_nxt;
    end
  end

  /* =============================================== */

  /* =============================================== */
  /* WRB_DEC LOGIC */
  /* =============================================== */

  assign wrb_dec_vld       = in_pkt_q.dst_vld;
  assign wrb_dec_pkt.addr  = in_pkt_q.dst_reg;
  assign wrb_dec_pkt.data  = in_pkt_q.data;

  /* =============================================== */

endmodule : wrb_stg
