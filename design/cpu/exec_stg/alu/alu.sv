module alu(
  input  alu_pkg::alu_in_pkt_t  alu_in_pkt,
  output alu_pkg::alu_out_pkt_t alu_out_pkt
);
  import mips_pkg::*;
  import alu_pkg::*;

  word_t a;
  word_t b;
  word_t dat;

  assign alu_out_pkt.res        = dat;
  assign alu_out_pkt.flags.n    = dat[31];
  assign alu_out_pkt.flags.v    = (alu_in_pkt.op == ALU_ADD)  ? (~dat[31] & a[31] & alu_in_pkt.s1[31])
                                                                 | (dat[31] & ~a[31] & ~alu_in_pkt.s1[31]) :
                                  (alu_in_pkt.op == ALU_SUB)  ? (a[31] ^ alu_in_pkt.s1[31]) & ~(dat[31] ^ alu_in_pkt.s1[31]) :
                                                                0;
  assign alu_out_pkt.flags.z    = ~(|dat);
                                        

  assign a = alu_in_pkt.s0;
  assign b = !(alu_in_pkt.op == ALU_SUB) ? alu_in_pkt.s1 :
                                           ~alu_in_pkt.s1 + 'b1;


  always_comb begin : comb_res
    dat = 0;

    case (alu_in_pkt.op)
      ALU_ADD,
      ALU_SUB: dat = a + b;
      ALU_AND: dat = a & b;
      ALU_OR:  dat = a | b;
      ALU_XOR: dat = a ^ b;
      ALU_NOR: dat = ~(a | b);
      ALU_SL:  dat = b << a;
      ALU_SR:  dat = (alu_in_pkt.sgnd) ? b >>> a : b >> a;
    endcase
  end
endmodule : alu
