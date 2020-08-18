`include "aluop_def.v"
module alu(c,a,b,aluop,zero);
    output signed [31:0] c;
    input signed [31:0] a;
    input signed [31:0] b;
    input [4:0] aluop;
    output zero;

    reg [31:0] c;
    //a : rs, b : rt  
    always @(a or b or aluop) begin
        case(aluop)
            `ALUOp_ADD  : c = a + b;
            `ALUOp_ADDU : c = a + b;
            `ALUOp_SUBU : c = a - b;
            `ALUOp_AND  : c = a & b;
            `ALUOp_OR   : c = a | b;
            `ALUOp_SLT  : c = (a < b) ? 32'd1 : 32'd0;
            
            `ALUOp_LUI  : c = b << 16;
            

            default : c = 0;
        endcase
    end
    assign zero = (c == 0) ? 1 : 0; //c为0z为1

endmodule