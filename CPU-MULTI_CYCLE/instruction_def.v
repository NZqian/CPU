`define INSTR_ADD_FUNCT     6'b100000
`define INSTR_ADDU_FUNCT    6'b100001
`define INSTR_SUBU_FUNCT    6'b100011
`define INSTR_AND_FUNCT     6'b100100
`define INSTR_OR_FUNCT      6'b100101
`define INSTR_SLT_FUNCT     6'b101010

`define INSTR_ADDI_OP       6'b001000
`define INSTR_ADDIU_OP      6'b001001
`define INSTR_ANDI_OP       6'b001100
`define INSTR_ORI_OP        6'b001101
`define INSTR_LUI_OP        6'b001111

`define INSTR_SW_OP         6'b101011
`define INSTR_LW_OP         6'b100011

`define INSTR_BEQ_OP        6'b000100
`define INSTR_J_OP          6'b000010
`define INSTR_JAL_OP        6'b000011

`define INSTR_JR_FUNCT      6'b001000