module exec_stg(
  input  logic                          clk,
  input  logic                          resetn,
  input  logic                          dec_exec_vld,
  output logic                          dec_exec_rdy,
  input  dec_exec_pkg::dec_exec_pkt_t   dec_exec_pkt,
  output logic                          exec_mem_vld,
  input  logic                          exec_mem_rdy,
  output exec_mem_pkg::exec_mem_pkt_t   exec_mem_pkt,
  input  haz_pkg::haz_exec_pkt_t        haz_exec_pkt,
  output haz_pkg::exec_haz_pkt_t        exec_haz_pkt
);
  import mips_pkg::*;
  import dec_exec_pkg::*;
  import alu_pkg::*;

  logic             in_pkt_vld, in_pkt_vld_nxt;
  dec_exec_pkt_t    in_pkt_q, in_pkt_nxt;

  /* =============================================== */
  /* IN_PKT LOGIC */
  /* =============================================== */

  assign dec_exec_rdy = (exec_mem_vld & exec_mem_rdy) | haz_exec_pkt.bubble | ~in_pkt_vld;

  always_comb begin : comb_in_pkt
    in_pkt_vld_nxt = in_pkt_vld;
    in_pkt_nxt     = in_pkt_q;

    if (dec_exec_vld && dec_exec_rdy) begin
      in_pkt_vld_nxt = 1;
      in_pkt_nxt     = dec_exec_pkt;
    end else if (exec_mem_vld && exec_mem_rdy || haz_exec_pkt.bubble) begin
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
  /* ALU */
  /* =============================================== */

  alu_in_pkt_t  alu_in_pkt;
  alu_out_pkt_t alu_out_pkt;

  assign alu_in_pkt.op      = in_pkt_q.alu_op;
  assign alu_in_pkt.s0      = in_pkt_q.s0;
  assign alu_in_pkt.s1      = in_pkt_q.s1;
  assign alu_in_pkt.sgnd    = in_pkt_q.sgnd;

  alu i_alu(
    .*
  );
  
  /* =============================================== */

  /* =============================================== */
  /* HAZ_PKT */
  /* =============================================== */

  assign exec_haz_pkt.dst_vld = in_pkt_q.dst_vld;
  assign exec_haz_pkt.dst_reg = in_pkt_q.dst_reg;
  
  /* =============================================== */

  /* =============================================== */
  /* EXECUTE */
  /* =============================================== */

  logic     lt;
  logic     jmp_vld;
  word_t    addr;
  mem_op_e  mem_op;
  mem_sz_e  mem_sz;
  logic     sgnd;
  logic     dst_vld;
  reg_t     dst_reg;
  word_t    data;

  assign lt         = alu_out_pkt.flags.n ^ alu_out_pkt.flags.v ^ (~alu_in_pkt.sgnd & (alu_in_pkt.s0[31] ^ alu_in_pkt.s1[31]));
  assign mem_op     = in_pkt_q.mem_op;
  assign mem_sz     = in_pkt_q.mem_sz;
  assign sgnd       = in_pkt_q.sgnd;
  assign dst_vld    = in_pkt_q.dst_vld;
  assign dst_reg    = in_pkt_q.dst_reg;

  always_comb begin : comb_exec_mem
    jmp_vld = 0;
    addr    = alu_out_pkt.res;
    data    = alu_out_pkt.res;

    if (in_pkt_q.slt) begin
      data = {31'b0, lt};
    end
    if (in_pkt_q.br_jmp_op != NO_BR_JMP) begin
      case (in_pkt_q.br_jmp_op)
        BR_EQ:  jmp_vld = alu_out_pkt.flags.z;
        BR_NE:  jmp_vld = ~alu_out_pkt.flags.z;
        BR_LE:  jmp_vld = lt | alu_out_pkt.flags.z;
        BR_GT:  jmp_vld = ~lt;
        JR,
        J:      jmp_vld = 1;
      endcase

      case (in_pkt_q.br_jmp_op)
        BR_EQ,
        BR_NE,
        BR_LE,
        BR_GT,
        JR:     addr = in_pkt_q.s2;
        J:      addr = {in_pkt_q.s0[31:28], in_pkt_q.s2[25:0], 2'b00};
      endcase
    end
  end


  /* =============================================== */

  /* =============================================== */
  /* EXEC_MEM */
  /* =============================================== */
  
  assign exec_mem_vld         = in_pkt_vld & ~haz_exec_pkt.bubble;
  assign exec_mem_pkt.jmp_vld = jmp_vld;
  assign exec_mem_pkt.addr    = addr;
  assign exec_mem_pkt.mem_op  = mem_op;
  assign exec_mem_pkt.mem_sz  = mem_sz;
  assign exec_mem_pkt.sgnd    = sgnd;
  assign exec_mem_pkt.dst_vld = dst_vld;
  assign exec_mem_pkt.dst_reg = dst_reg;
  assign exec_mem_pkt.data    = data;

  /* =============================================== */

endmodule : exec_stg
