class instr extends uvm_object;
  word_t            bits;
  rand instr_type_e instr_type;
  rand opcode_e     opcode;
  rand reg_t        rd;
  rand reg_t        rs;
  rand reg_t        rt;
  rand shamt_t      shamt;
  rand func_e       func;
  rand imm_t        imm;
  rand jmp_addr_t   jmp_addr;

  `uvm_object_utils_begin(instr)
    `uvm_field_int(bits, UVM_DEFAULT)
    `uvm_field_enum(instr_type_e, instr_type, UVM_DEFAULT)
    `uvm_field_enum(opcode_e, opcode, UVM_DEFAULT)
    `uvm_field_int(rd, UVM_DEFAULT)
    `uvm_field_int(rs, UVM_DEFAULT)
    `uvm_field_int(rt, UVM_DEFAULT)
    `uvm_field_int(shamt, UVM_DEFAULT)
    `uvm_field_enum(func_e, func, UVM_DEFAULT)
    `uvm_field_int(imm, UVM_DEFAULT)
    `uvm_field_int(jmp_addr, UVM_DEFAULT)
  `uvm_object_utils_end

  constraint c_func {
    func inside {
      FUNC_SLL, FUNC_SRL, FUNC_SRA, FUNC_SLLV,
      FUNC_SRLV, FUNC_SRAV, FUNC_JR, FUNC_JALR,
      FUNC_ADD, FUNC_ADDU, FUNC_SUB, FUNC_SUBU,
      FUNC_AND, FUNC_OR, FUNC_XOR, FUNC_NOR,
      FUNC_SLT, FUNC_SLTU
    };
  }

  constraint c_instr_type_opcode {
    solve instr_type before opcode;
    instr_type dist {
      INSTR_RTYPE := 40,
      INSTR_JTYPE := 20,
      INSTR_ITYPE := 40
    };

    instr_type == INSTR_RTYPE -> opcode == OPCODE_RTYPE;
    instr_type == INSTR_ITYPE -> opcode inside {
      OPCODE_BEQ, OPCODE_BNE, OPCODE_BLEZ, OPCODE_BGTZ,
      OPCODE_ADDI, OPCODE_ADDIU, OPCODE_SLTI,
      OPCODE_SLTIU, OPCODE_ANDI, OPCODE_ORI, OPCODE_XORI,
      OPCODE_LUI, OPCODE_LB, OPCODE_LH, OPCODE_LW,
      OPCODE_SB, OPCODE_SH, OPCODE_SW
    };
    instr_type == INSTR_JTYPE -> opcode inside {
      OPCODE_J, OPCODE_JAL
    };
  }

  extern function               new(string name="instr");
  extern function void          init(word_t bits);
  extern function void          post_randomize();
  extern function bit           is_ldst();
  extern function br_jmp_op_e   br_jmp_op();
  extern function mem_op_e      mem_op();
  extern function mem_sz_e      mem_sz();
  extern function alu_op_e      alu_op();
  extern function bit           sgnd();
  extern function bit           slt();
  extern function bit           dst_vld();
endclass : instr

function instr::new(string name="instr");
  super.new(name);
endfunction : new

function void instr::init(word_t bits);
  bits       = bits;
  instr_type = get_instr_type(bits);

  case (instr_type)
    INSTR_RTYPE:
      begin
        rtype_instr_t rtype = rtype_instr_t'(bits);

        opcode  = rtype.opcode;
        rd      = rtype.rd;
        rs      = rtype.rs;
        rt      = rtype.rt;
        shamt   = rtype.shamt;
        func    = rtype.func;
      end
    INSTR_ITYPE:
      begin
        itype_instr_t itype = itype_instr_t'(bits);

        opcode  = itype.opcode;
        rs      = itype.rs;
        rt      = itype.rt;
        imm     = itype.imm;
      end
    INSTR_JTYPE:
      begin
        jtype_instr_t jtype = jtype_instr_t'(bits);

        opcode  = jtype.opcode;
        jmp_addr= jtype.jmp_addr;
      end
  endcase
endfunction : init

function void instr::post_randomize();
  if (instr_type == INSTR_RTYPE) begin
    rtype_instr_t rtype;

    rtype.opcode    = opcode;
    rtype.rd        = rd;
    rtype.rs        = rs;
    rtype.rt        = rt;
    rtype.shamt     = shamt;
    rtype.func      = func;

    bits = rtype;
  end else if (instr_type == INSTR_ITYPE) begin
    itype_instr_t itype;

    itype.opcode    = opcode;
    itype.rs        = rs;
    itype.rt        = rt;
    itype.imm       = imm;

    bits = itype;
  end else if (instr_type == INSTR_JTYPE) begin
    jtype_instr_t jtype;

    jtype.opcode    = opcode;
    jtype.jmp_addr  = jmp_addr;

    bits = jtype;
  end

  `uvm_info("INSTR_POST_RANDOMIZE", $sformatf("generated instruction:\n%0s", this.sprint()), UVM_FULL)
endfunction : post_randomize

function bit instr::is_ldst();
  is_ldst = 0;

  is_ldst |= opcode inside {OPCODE_LB, OPCODE_LH, OPCODE_LW};
  is_ldst |= opcode inside {OPCODE_SB, OPCODE_SH, OPCODE_SW};

  return is_ldst;
endfunction : is_ldst

function br_jmp_op_e instr::br_jmp_op();
  br_jmp_op = NO_BR_JMP;

  if (instr_type == INSTR_RTYPE) begin
    case (func)
      FUNC_JR,
      FUNC_JALR:    br_jmp_op = JR;
    endcase
  end else begin
    case (opcode)
      OPCODE_BEQ:   br_jmp_op = BR_EQ;
      OPCODE_BNE:   br_jmp_op = BR_NE;
      OPCODE_BLEZ:  br_jmp_op = BR_LE;
      OPCODE_BGTZ:  br_jmp_op = BR_GT;
      OPCODE_J,
      OPCODE_JAL:   br_jmp_op = J;
    endcase
  end

  return br_jmp_op;
endfunction : br_jmp_op

function mem_op_e instr::mem_op();
  mem_op = MEM_NONE;

  case (opcode)
    OPCODE_LB,
    OPCODE_LH,
    OPCODE_LW:  mem_op = MEM_LD;
    OPCODE_SB,
    OPCODE_SH,
    OPCODE_SW:  mem_op = MEM_ST;
  endcase

  return mem_op;
endfunction : mem_op

function mem_sz_e instr::mem_sz();
  mem_sz = SZ_B;

  case (opcode)
    OPCODE_LB,
    OPCODE_SB:  mem_sz = SZ_B;
    OPCODE_LH,
    OPCODE_SH:  mem_sz = SZ_H;
    OPCODE_LW,
    OPCODE_SW:  mem_sz = SZ_W;
  endcase

  return mem_sz;
endfunction : mem_sz

function alu_op_e instr::alu_op();
  alu_op = ALU_ADD;

  if (instr_type == INSTR_RTYPE) begin
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
    endcase
  end else if (instr_type == INSTR_ITYPE) begin
    case (opcode)
      OPCODE_BEQ,
      OPCODE_BNE,
      OPCODE_BLEZ,
      OPCODE_BGTZ,
      OPCODE_SLTI,
      OPCODE_SLTIU: alu_op = ALU_SUB;
      OPCODE_ANDI:  alu_op = ALU_AND;
      OPCODE_ORI:   alu_op = ALU_OR;
      OPCODE_XORI:  alu_op = ALU_XOR;
      OPCODE_LUI:   alu_op = ALU_SL;
    endcase
  end

  return alu_op;
endfunction : alu_op

function bit instr::sgnd();
  sgnd = 0;

  sgnd |= opcode inside {OPCODE_BLEZ, OPCODE_BGTZ, OPCODE_ADDI, OPCODE_SLTI};
  sgnd |= opcode == OPCODE_RTYPE && func inside {FUNC_SRA, FUNC_SRAV, FUNC_ADD, FUNC_SUB, FUNC_SLT};

  return sgnd;
endfunction : sgnd

function bit instr::slt();
  slt = 0;

  slt |= opcode inside {OPCODE_SLTI, OPCODE_SLTIU};
  slt |= opcode == OPCODE_RTYPE && func inside {FUNC_SLT, FUNC_SLTU};

  return slt;
endfunction : slt

function bit instr::dst_vld();
  dst_vld = 1;

  if (instr_type == INSTR_RTYPE) begin
    case (func)
      FUNC_JR:      dst_vld = 0;
    endcase
  end else begin
    case (opcode)
      OPCODE_J,
      OPCODE_BEQ,
      OPCODE_BNE,
      OPCODE_BLEZ,
      OPCODE_BGTZ,
      OPCODE_SB,
      OPCODE_SH,
      OPCODE_SW:    dst_vld = 0;
    endcase
  end

  return dst_vld;
endfunction : dst_vld
