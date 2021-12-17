module mem_stg(
  input  logic                          clk,
  input  logic                          resetn,
  input  logic                          exec_mem_vld,
  output logic                          exec_mem_rdy,
  input  exec_mem_pkg::exec_mem_pkt_t   exec_mem_pkt,
  output haz_pkg::mem_haz_pkt_t         mem_haz_pkt,
  output logic                          mem_ftch_vld,
  output mem_ftch_pkg::mem_ftch_pkt_t   mem_ftch_pkt,
  output logic                          mem_dmem_vld,
  output mem_dmem_pkg::mem_dmem_pkt_t   mem_dmem_pkt,
  input  logic                          dmem_mem_vld,
  input  mem_dmem_pkg::dmem_mem_pkt_t   dmem_mem_pkt,
  output logic                          mem_wrb_vld,
  output mem_wrb_pkg::mem_wrb_pkt_t     mem_wrb_pkt
);
  import mips_pkg::*;
  import exec_mem_pkg::*;
  
  logic             in_pkt_vld, in_pkt_nxt;
  exec_mem_pkt_t    in_pkt_q, in_pkt_nxt;

  /* =============================================== */
  /* IN_PKT LOGIC */
  /* =============================================== */

  assign exec_mem_rdy = mem_wrb_vld | ~in_pkt_vld;

  always_comb begin : comb_in_pkt
    in_pkt_vld_nxt = in_pkt_vld;
    in_pkt_nxt     = in_pkt_q;

    if (exec_mem_vld && exec_mem_rdy) begin
      in_pkt_vld_nxt = 1;
      in_pkt_nxt     = exec_mem_pkt;
    end else if (mem_wrb_vld) begin
      in_pkt_vld_nxt = 0;
      in_pkt_nxt     = 0;
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
  /* MEM_HAZ LOGIC */
  /* =============================================== */

  assign mem_haz_pkt.jmp_vld = in_pkt_q.jmp_vld;
  assign mem_haz_pkt.dst_vld = in_pkt_q.dst_vld;
  assign mem_haz_pkt.dst_reg = in_pkt_q.dst_reg;

  /* =============================================== */

  /* =============================================== */
  /* MEM_FTCH LOGIC */
  /* =============================================== */

  assign mem_ftch_vld       = in_pkt_q.jmp_vld;
  assign mem_ftch_pkt.addr  = in_pkt_q.addr;

  /* =============================================== */

  /* =============================================== */
  /* MEM_DMEM LOGIC */
  /* =============================================== */

  word_t wr_data;
  word_t rd_data;

  assign mem_dmem_vld       = in_pkt_vld & (in_pkt_q.mem_op != MEM_NONE);
  assign mem_dmem_pkt.rnw   = in_pkt_q.mem_op == MEM_LD;
  assign mem_dmem_pkt.addr  = in_pkt_q.addr;
  assign mem_dmem_pkt.data  = wr_data;

  always_comb begin : comb_rd_wr_data
    wr_data = in_pkt_q.data;
    rd_data = dmem_mem_pkt.data;

    if (in_pkt_q.mem_sz == SZ_B) begin
      wr_data = {24'b0, in_pkt_q.data[7:0]};
      if (in_pkt_q.sgnd) begin
        rd_data = {{24{dmem_mem_pkt.data[7]}}, dmem_mem_pkt.data[7:0]};
      end else begin
        rd_data = {24'b0, dmem_mem_pkt.data[7:0]};
      end
    end else if (in_pkt_q.mem_sz == SZ_H) begin
      wr_data = {16'b0, in_pkt_q.data[15:0]};
      if (in_pkt_q.sgnd) begin
        rd_data = {{16{dmem_mem_pkt.data[15]}}, dmem_mem_pkt.data[15:0]};
      end else begin
        rd_data = {16'b0, dmem_mem_pkt.data[15:0]};
      end
    end
  end

  /* =============================================== */

  /* =============================================== */
  /* MEM_WRB LOGIC */
  /* =============================================== */

  assign mem_wrb_vld            = ~(mem_dmem_vld & ~dmem_mem_vld) & in_pkt_vld;
  assign mem_wrb_pkt.dst_vld    = in_pkt_q.dst_vld;
  assign mem_wrb_pkt.dst_reg    = in_pkt_q.dst_reg;
  assign mem_wrb_pkt.data       = (mem_dmem_vld & mem_dmem_pkt.rnw) ? rd_data:
                                                                      in_pkt_q.data;

  /* =============================================== */

endmodule : mem_stg
