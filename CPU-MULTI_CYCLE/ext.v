module ext(imm16, imm32, extop);
    input [15:0] imm16;
    input extop;
    output [31:0] imm32;

    assign imm32 = (extop == 0) ? {16'h0000, imm16} : {{16{imm16[15]}}, imm16};
endmodule