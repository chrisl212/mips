module cpu(
  input  logic                          clk,
  input  logic                          resetn,
  output logic                          cpu_imem_vld,
  output cpu_imem_pkg::cpu_imem_pkt_t   cpu_imem_pkt,
  input  logic                          imem_cpu_vld,
  input  cpu_imem_pkg::imem_cpu_pkt_t   imem_cpu_pkt,
  output logic                          cpu_dmem_vld,
  output cpu_dmem_pkg::cpu_dmem_pkt_t   cpu_dmem_pkt,
  input  logic                          dmem_cpu_vld,
  input  cpu_dmem_pkg::dmem_cpu_pkt_t   dmem_cpu_pkt
);

  logic                          ftch_imem_vld;
  ftch_imem_pkg::ftch_imem_pkt_t ftch_imem_pkt;
  logic                          imem_ftch_vld;
  ftch_imem_pkg::imem_ftch_pkt_t imem_ftch_pkt;
  logic                          ftch_dec_vld;
  logic                          ftch_dec_rdy;
  ftch_dec_pkg::ftch_dec_pkt_t   ftch_dec_pkt;
  logic                          mem_ftch_vld;
  mem_ftch_pkg::mem_ftch_pkt_t   mem_ftch_pkt;
  logic                          dec_exec_vld;
  logic                          dec_exec_rdy;
  dec_exec_pkg::dec_exec_pkt_t   dec_exec_pkt;
  haz_pkg::dec_haz_pkt_t         dec_haz_pkt;
  haz_pkg::haz_dec_pkt_t         haz_dec_pkt;
  logic                          exec_mem_vld;
  logic                          exec_mem_rdy;
  exec_mem_pkg::exec_mem_pkt_t   exec_mem_pkt;
  haz_pkg::haz_exec_pkt_t        haz_exec_pkt;
  haz_pkg::exec_haz_pkt_t        exec_haz_pkt;
  haz_pkg::mem_haz_pkt_t         mem_haz_pkt;
  logic                          mem_dmem_vld;
  mem_dmem_pkg::mem_dmem_pkt_t   mem_dmem_pkt;
  logic                          dmem_mem_vld;
  mem_dmem_pkg::dmem_mem_pkt_t   dmem_mem_pkt;
  logic                          mem_wrb_vld;
  mem_wrb_pkg::mem_wrb_pkt_t     mem_wrb_pkt;
  logic                          wrb_dec_vld;
  wrb_dec_pkg::wrb_dec_pkt_t     wrb_dec_pkt;

  /* =============================================== */
  /* MEM */
  /* =============================================== */

  assign cpu_imem_vld   = ftch_imem_vld;
  assign cpu_imem_pkt   = ftch_imem_pkt;
  assign imem_ftch_vld  = imem_cpu_vld;
  assign imem_ftch_pkt  = imem_cpu_pkt;
  
  assign cpu_dmem_vld   = mem_dmem_vld;
  assign cpu_dmem_pkt   = mem_dmem_pkt;
  assign dmem_mem_vld   = dmem_cpu_vld;
  assign dmem_mem_pkt   = dmem_cpu_pkt;

  /* =============================================== */

  /* =============================================== */
  /* PIPELINE */
  /* =============================================== */

  ftch_stg  i_ftch(.*);
  dec_stg   i_dec(.*);
  exec_stg  i_exec(.*);
  mem_stg   i_mem(.*);
  wrb_stg   i_wrb(.*);
  haz       i_haz(.*);

  /* =============================================== */

endmodule : cpu
