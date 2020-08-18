module s_cycle_cpu(clock,reset);
    input clock;
    input reset;

    wire [31:0] pc, npc, npc_t;
    wire [31:0] instruction;
    wire [4:0] rs, rt, rd;
    wire [31:0] a, b, ALU_b, c;
    wire [5:0] op, funct;
    wire [15:0] imm16;
    wire [31:0] imm32;
    wire [4:0] num_write;
    wire [31:0] data_in;
    wire [31:0] address;
    wire [31:0] data_out;
    wire [31:0] data_write;
    wire [25:0] instr_index;

    wire [4:0] aluop;
    wire extop;
    wire [1:0] RegDst;
    wire ALUSrc;
    wire reg_write;
    wire mem_write;
    wire [1:0] MemtoReg;
    wire [1:0] s;
    wire zero;

    pc PC(pc, clock, reset, npc);
    im IM(instruction, pc);
    dm DM(data_out, clock, mem_write, c, b);
    alu ALU(c, a, ALU_b, aluop, zero);
    gpr GPR(a, b, clock, reset, reg_write, num_write, rs, rt, data_write, op);
    ctrl CTRL(reg_write, aluop, extop, RegDst, ALUSrc, MemtoReg, mem_write, s, op, funct);
    ext EXT(imm16, imm32, extop);
    npc NPC(npc, npc_t, instr_index, imm32, a, zero, s);

    mux3 REG_DST_MUX(rt, rd, 5'b11111, num_write, RegDst);
    mux2 ALU_SRC_MUX(b, imm32, ALU_b, ALUSrc);
    mux3 REG_WRITE_MUX(npc_t, c, data_out, data_write, MemtoReg);


    assign npc_t = pc + 4;
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign op = instruction[31:26];
    assign funct = instruction[5:0];
    assign imm16 = instruction[15:0];
    assign instr_index = instruction[25:0];

endmodule