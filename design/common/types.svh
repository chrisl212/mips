typedef logic[`WORD_BITS-1:0]       word_t;
typedef logic[`REG_BITS-1:0]        reg_t;
typedef logic[`SHAMT_BITS-1:0]      shamt_t;
typedef logic[`IMM_BITS-1:0]        imm_t;
typedef logic[`JMP_ADDR_BITS-1:0]   jmp_addr_t;

typedef enum logic[5:0] {
  OPCODE_RTYPE  =  0,
  OPCODE_J      =  2,
  OPCODE_JAL    =  3,
  OPCODE_BEQ    =  4,
  OPCODE_BNE    =  5,
  OPCODE_BLEZ   =  6,
  OPCODE_BGTZ   =  7,
  OPCODE_ADDI   =  8,
  OPCODE_ADDIU  =  9,
  OPCODE_SLTI   = 10,
  OPCODE_SLTIU  = 11,
  OPCODE_ANDI   = 12,
  OPCODE_ORI    = 13,
  OPCODE_XORI   = 14,
  OPCODE_LUI    = 15,
  OPCODE_LB     = 32,
  OPCODE_LH     = 33,
  OPCODE_LW     = 34,
  OPCODE_LBU    = 35,
  OPCODE_LHU    = 36,
  OPCODE_SB     = 40,
  OPCODE_SH     = 41,
  OPCODE_SW     = 43
} opcode_e;

typedef enum logic[5:0] {
  FUNC_SLL      =  0,
  FUNC_SRL      =  2,
  FUNC_SRA      =  3,
  FUNC_SLLV     =  4,
  FUNC_SRLV     =  6,
  FUNC_SRAV     =  7,
  FUNC_JR       =  8,
  FUNC_JALR     =  9,
  // FUNC_SYSCALL  = 12,
  // FUNC_MFHI     = 16,
  // FUNC_MTHI     = 17,
  // FUNC_MFLO     = 18,
  // FUNC_MTLO     = 19,
  // FUNC_MULT     = 24,
  // FUNC_MULTU    = 25,
  // FUNC_DIV      = 26,
  // FUNC_DIVU     = 27,
  FUNC_ADD      = 32,
  FUNC_ADDU     = 33,
  FUNC_SUB      = 34,
  FUNC_SUBU     = 35,
  FUNC_AND      = 36,
  FUNC_OR       = 37,
  FUNC_XOR      = 38,
  FUNC_NOR      = 39,
  FUNC_SLT      = 42,
  FUNC_SLTU     = 43
} func_e;

typedef struct packed {
  opcode_e      opcode;
  reg_t         rs;
  reg_t         rt;
  reg_t         rd;
  shamt_t       shamt;
  func_e        func;
} rtype_instr_t;

typedef struct packed {
  opcode_e      opcode;
  reg_t         rs;
  reg_t         rt;
  imm_t         imm;
} itype_instr_t;

typedef struct packed {
  opcode_e      opcode;
  jmp_addr_t    jmp_addr;
} jtype_instr_t;

typedef enum logic[1:0] {
  INSTR_RTYPE,
  INSTR_ITYPE,
  INSTR_JTYPE
} instr_type_e;

typedef enum logic[2:0] {
  NO_BR_JMP,
  BR_EQ,
  BR_NE,
  BR_LE,
  BR_GT,
  J,
  JR
} br_jmp_op_e;;

typedef enum logic[1:0] {
  MEM_NONE,
  MEM_ST,
  MEM_LD
} mem_op_e;

typedef enum logic[1:0] {
  SZ_B,
  SZ_H,
  SZ_W
} mem_sz_e;

typedef enum logic[2:0] {
  ALU_ADD,
  ALU_SUB,
  ALU_AND,
  ALU_OR,
  ALU_XOR,
  ALU_NOR,
  ALU_SL,
  ALU_SR
} alu_op_e;
