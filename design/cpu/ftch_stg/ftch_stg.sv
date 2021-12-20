module ftch_stg(
  input logic clk,
  input logic resetn,
  output logic                          ftch_imem_vld,
  output ftch_imem_pkg::ftch_imem_pkt_t ftch_imem_pkt,
  input  logic                          imem_ftch_vld,
  input  ftch_imem_pkg::imem_ftch_pkt_t imem_ftch_pkt,
  output logic                          ftch_dec_vld,
  input  logic                          ftch_dec_rdy,
  output ftch_dec_pkg::ftch_dec_pkt_t   ftch_dec_pkt,
  input  logic                          mem_ftch_vld,
  input  mem_ftch_pkg::mem_ftch_pkt_t   mem_ftch_pkt
);
  import mips_pkg::*;
  import ftch_dec_pkg::*;

  word_t        pc_q, pc_nxt, pc_inc, pc_br, pc_jmp;
  logic         pc_advance, pc_change;
  logic         ftch_dec_vld_q, ftch_dec_vld_nxt;
  logic         ftch_imem_vld_rdy;
  word_t        instr_q, instr_nxt;

  assign pc_advance         = ftch_dec_vld & ftch_dec_rdy; // INCREMENT PC WHEN DEC ACCEPTS INSTR
  assign pc_change          = mem_ftch_vld | pc_advance;
  assign pc_inc             = pc_q + 'd4;
  assign pc_nxt             = (mem_ftch_vld)  ?  mem_ftch_pkt.addr  :
                              (pc_advance)    ?  pc_inc :
                                                 pc_q;

  assign ftch_imem_vld      = ~mem_ftch_vld & ~ftch_dec_vld_q; // STOP MEM REQ ONCE WE'VE GOTTEN RSP
  assign ftch_imem_pkt.addr = pc_q;
  
  assign ftch_dec_vld       = (ftch_imem_vld_rdy | ftch_dec_vld_q)              // SEND TO DEC IF MEM RESPONDS
                              & ~mem_ftch_vld;                                  // OR WE ALREADY HAVE PREV RSP
                                                                                // BUT NOT IF A JMP/BR IN THIS CYC
  assign ftch_dec_pkt.pc    = pc_inc;
  assign ftch_dec_pkt.instr = (ftch_imem_vld_rdy) ? instr_nxt : // IF WE RECEIVE RSP IN THIS CYC, SEND STRAIGHT FROM MEM
                                                    instr_q;    // ELSE FLOPPED VAL


  assign ftch_imem_vld_rdy  = ftch_imem_vld & imem_ftch_vld;
  assign ftch_dec_vld_nxt   = (ftch_imem_vld_rdy | ftch_dec_vld_q) & ~pc_change;
  assign instr_nxt          = (ftch_imem_vld_rdy) ? imem_ftch_pkt.data :
                                                    instr_q;

  always_ff @(posedge clk, negedge resetn) begin : ff_pc
    if (resetn == 0) begin
      pc_q <= 0;
    end else begin
      pc_q <= pc_nxt;
    end
  end

  always_ff @(posedge clk, negedge resetn) begin : ff_ftch_dec_vld
    if (resetn == 0) begin
      ftch_dec_vld_q <= 0;
    end else begin
      ftch_dec_vld_q <= ftch_dec_vld_nxt;
    end
  end

  always_ff @(posedge clk, negedge resetn) begin : ff_instr
    if (resetn == 0) begin
      instr_q <= 0;
    end else begin
      instr_q <= instr_nxt;
    end
  end

endmodule : ftch_stg
