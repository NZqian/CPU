`include "instruction_def.v"
`include "aluop_def.v"
module ctrl(reg_write,aluop,extop,RegDst,ALUSrc,MemtoReg,mem_write,s,op,funct);
    output reg reg_write;
    output reg [4:0] aluop;
    output reg extop, ALUSrc, mem_write;
    output reg [1:0] RegDst, MemtoReg, s;
    input [5:0] op;
    input [5:0] funct; 

    always @(*)begin
        if(op == 6'b000000)begin    //R type
            case(funct)
                `INSTR_ADD_FUNCT : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b0, 2'b01, 1'b0, 2'b01, 1'b0, 2'b00, `ALUOp_ADD};
                `INSTR_ADDU_FUNCT: {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b0, 2'b01, 1'b0, 2'b01, 1'b0, 2'b00, `ALUOp_ADDU};
                `INSTR_SUBU_FUNCT: {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b0, 2'b01, 1'b0, 2'b01, 1'b0, 2'b00, `ALUOp_SUBU};
                `INSTR_AND_FUNCT : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b0, 2'b01, 1'b0, 2'b01, 1'b0, 2'b00, `ALUOp_AND};
                `INSTR_OR_FUNCT  : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b0, 2'b01, 1'b0, 2'b01, 1'b0, 2'b00, `ALUOp_OR};
                `INSTR_SLT_FUNCT : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b0, 2'b01, 1'b0, 2'b01, 1'b0, 2'b00, `ALUOp_SLT};

                `INSTR_JR_FUNCT  : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b0, 1'b0, 2'b01, 1'b0, 2'b01, 1'b0, 2'b11, `ALUOp_SLT};
            endcase
        end
        else begin
            case(op)
                 `INSTR_ADDI_OP  : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b1, 2'b00, 1'b1, 2'b01, 1'b0, 2'b00, `ALUOp_ADD};
                 `INSTR_ADDIU_OP : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b1, 2'b00, 1'b1, 2'b01, 1'b0, 2'b00, `ALUOp_ADDU};
                 `INSTR_ANDI_OP  : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b0, 2'b00, 1'b1, 2'b01, 1'b0, 2'b00, `ALUOp_AND};
                 `INSTR_ORI_OP   : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b0, 2'b00, 1'b1, 2'b01, 1'b0, 2'b00, `ALUOp_OR};
                 `INSTR_LUI_OP   : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b1, 2'b00, 1'b1, 2'b01, 1'b0, 2'b00, `ALUOp_LUI};

                 `INSTR_SW_OP    : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b0, 1'b1, 2'b00, 1'b1, 2'b01, 1'b1, 2'b00, `ALUOp_ADD};
                 `INSTR_LW_OP    : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b1, 2'b00, 1'b1, 2'b10, 1'b0, 2'b00, `ALUOp_ADD};

                 `INSTR_BEQ_OP   : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b0, 1'b1, 2'b00, 1'b0, 2'b01, 1'b0, 2'b01, `ALUOp_SUBU};
                 `INSTR_J_OP     : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b0, 1'b1, 2'b00, 1'b1, 2'b01, 1'b1, 2'b10, `ALUOp_ADD};
                 `INSTR_JAL_OP   : {reg_write, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, aluop} = {1'b1, 1'b1, 2'b10, 1'b1, 2'b00, 1'b1, 2'b10, `ALUOp_ADD};
            endcase
        end
    end


endmodule