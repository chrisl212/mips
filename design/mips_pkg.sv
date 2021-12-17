package mips_pkg;
  `include "common/defines.svh"
  `include "common/types.svh"

  function automatic instr_type_e get_instr_type(word_t instr);
    jtype_instr_t instr_decode = jtype_instr_t'(instr);
    instr_type_e  instr_type;

    case (instr_decode.opcode)
      OPCODE_RTYPE:         instr_type = INSTR_RTYPE;
      OPCODE_J, OPCODE_JAL: instr_type = INSTR_JTYPE;
      default:              instr_type = INSTR_ITYPE;
    endcase

    return instr_type;
  endfunction : get_instr_type

  function automatic alu_op_e get_opcode_alu_op(opcode_e opcode);
    alu_op_e alu_op;
    case (opcode)
      OPCODE_BGTZ,
      OPCODE_BLEZ,
      OPCODE_BNE,
      OPCODE_BEQ,
      OPCODE_SLTI,
      OPCODE_SLTIU: alu_op = ALU_SUB;
      OPCODE_ANDI:  alu_op = ALU_AND;
      OPCODE_ORI:   alu_op = ALU_OR;
      OPCODE_XORI:  alu_op = ALU_XOR;
      OPCODE_LUI:   alu_op = ALU_SL;
      default:      alu_op = ALU_ADD;
    endcase
    return alu_op;
  endfunction : get_opcode_alu_op

  function automatic br_jmp_op_e get_opcode_br_jmp_op(opcode_e opcode);
    br_jmp_op_e br_jmp_op;

    case (opcode)
      OPCODE_BGTZ:  br_jmp_op = BR_GT;
      OPCODE_BLEZ:  br_jmp_op = BR_LE;
      OPCODE_BNE:   br_jmp_op = BR_NE;
      OPCODE_BEQ:   br_jmp_op = BR_EQ;
      OPCODE_J,
      OPCODE_JAL:   br_jmp_op = J;
      default:      br_jmp_op = NO_BR_JMP;
    endcase

    return br_jmp_op;
  endfunction : get_opcode_br_jmp_op

  function automatic mem_op_e get_opcode_mem_op(opcode_e opcode);
    mem_op_e mem_op;

    case (opcode)
      OPCODE_LB,
      OPCODE_LBU,
      OPCODE_LH,
      OPCODE_LHU,
      OPCODE_LW:    mem_op = MEM_LD;
      OPCODE_SB,
      OPCODE_SH,
      OPCODE_SW:    mem_op = MEM_ST;
      default:      mem_op = MEM_NONE;
    endcase

    return mem_op;
  endfunction : get_opcode_mem_op

  function automatic mem_sz_e get_opcode_mem_sz(opcode_e opcode);
    mem_sz_e mem_sz;

    case (opcode)
      OPCODE_LB,
      OPCODE_LBU,
      OPCODE_SB:    mem_sz = SZ_B;
      OPCODE_LH,
      OPCODE_LHU,
      OPCODE_SH:    mem_sz = SZ_H;
      OPCODE_LW,
      OPCODE_SW:    mem_sz = SZ_W;
      default:      mem_sz = SZ_B;
    endcase

    return mem_sz;
  endfunction : get_opcode_mem_sz

  function automatic logic get_opcode_sgnd(opcode_e opcode);
    logic sgnd;

    case (opcode)
      OPCODE_LB,
      OPCODE_LH,
      OPCODE_LW,
      OPCODE_SB,
      OPCODE_SH,
      OPCODE_SW,
      OPCODE_BLEZ,
      OPCODE_BGTZ,
      OPCODE_ADDI,
      OPCODE_SLTI:  sgnd = 1;
      default:      sgnd = 0;
    endcase

    return sgnd;
  endfunction : get_opcode_sgnd

  function automatic logic get_opcode_dst_vld(opcode_e opcode);
    logic dst_vld;
    
    case (opcode)
      OPCODE_BEQ,
      OPCODE_BNE,
      OPCODE_BLEZ,
      OPCODE_BGTZ,
      OPCODE_SB,
      OPCODE_SH,
      OPCODE_SW:    dst_vld = 0;
      default:      dst_vld = 1;
    endcase

    return dst_vld;
  endfunction : get_opcode_dst_vld

  function automatic logic get_opcode_is_br(opcode_e opcode);
    return opcode inside {OPCODE_BEQ, OPCODE_BNE, OPCODE_BLEZ, OPCODE_BGTZ};
  endfunction : get_opcode_is_br

  function automatic logic get_opcode_uses_sign_ext_imm(opcode_e opcode);
    logic uses_sign_ext_imm;

    case (opcode)
      OPCODE_BEQ,
      OPCODE_BNE,
      OPCODE_BLEZ,
      OPCODE_BGTZ,
      OPCODE_ADDI,
      OPCODE_ADDIU,
      OPCODE_SLTIU,
      OPCODE_LB,
      OPCODE_LH,
      OPCODE_LW,
      OPCODE_SB,
      OPCODE_SH,
      OPCODE_SW:    uses_sign_ext_imm = 1;
      default:      uses_sign_ext_imm = 0;
    endcase

    return uses_sign_ext_imm;
  endfunction : get_opcode_uses_sign_ext_imm

  function automatic logic get_opcode_rs_vld(opcode_e opcode);
    logic rs_vld;

    case (opcode)
      OPCODE_LUI:   rs_vld = 0;
      default:      rs_vld = 1;
    endcase

    return rs_vld;
  endfunction : get_opcode_rs_vld

  function automatic logic get_opcode_rt_vld(opcode_e opcode);
    logic rt_vld;

    case (opcode)
      OPCODE_BEQ,
      OPCODE_BNE,
      OPCODE_SB,
      OPCODE_SH,
      OPCODE_SW:    rt_vld = 1;
      default:      rt_vld = 0;
    endcase

    return rt_vld;
  endfunction : get_opcode_rt_vld

  function automatic logic get_func_uses_shamt(func_e func);
    logic uses_shamt;

    case (func)
      FUNC_SLL,
      FUNC_SRL,
      FUNC_SRA:     uses_shamt = 1;
      default:      uses_shamt = 0;
    endcase

    return uses_shamt;
  endfunction : get_func_uses_shamt

  function automatic alu_op_e get_func_alu_op(func_e func);
    alu_op_e alu_op;

    case (func)
      FUNC_SLL,
      FUNC_SLLV:    alu_op = ALU_SL;
      FUNC_SRL,
      FUNC_SRA,
      FUNC_SRLV,
      FUNC_SRAV:    alu_op = ALU_SR;
      FUNC_SUB,
      FUNC_SUBU,
      FUNC_SLT,
      FUNC_SLTU:    alu_op = ALU_SUB;
      FUNC_AND:     alu_op = ALU_AND;
      FUNC_OR:      alu_op = ALU_OR;
      FUNC_XOR:     alu_op = ALU_XOR;
      FUNC_NOR:     alu_op = ALU_NOR;
      default:      alu_op = ALU_ADD;
    endcase

    return alu_op;
  endfunction : get_func_alu_op

  function automatic logic get_func_sgnd(func_e func);
    logic sgnd;

    case (func)
      FUNC_SRA,
      FUNC_SRAV,
      FUNC_ADD,
      FUNC_SUB,
      FUNC_SLT:     sgnd = 1;
      default:      sgnd = 0;
    endcase

    return sgnd;
  endfunction : get_func_sgnd

  function automatic logic get_func_rs_vld(func_e func);
    logic rs_vld;

    case (func)
      FUNC_SLL,
      FUNC_SRL,
      FUNC_SRA:     rs_vld = 0;
      default:      rs_vld = 1;
    endcase

    return rs_vld;
  endfunction : get_func_rs_vld

  function automatic logic get_func_rt_vld(func_e func);
    logic rt_vld;

    case (func)
      FUNC_JR,
      FUNC_JALR:    rt_vld = 0;
      default:      rt_vld = 1;
    endcase

    return rt_vld;
  endfunction : get_func_rt_vld

endpackage : mips_pkg

