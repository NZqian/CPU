module gpr(a,b,clock,reset,reg_write,num_write,rs,rt,data_write,op);
    output [31:0] a;  
    output [31:0] b;
    input clock;
    input reset;
    input reg_write;
    input [4:0] rs; //读寄存器1
    input [4:0] rt; //读寄存器2
    input [4:0] num_write; 
    input [31:0] data_write; //写数据
    input [5:0] op;

    reg [31:0] gp_registers[31:0];  //32个寄存器

    always @(posedge clock)
        begin
            if(reg_write & reset)begin
                gp_registers[num_write] <= data_write;
            end
        end
    assign a = rs ? gp_registers[rs] : 0;
    assign b = rt ? gp_registers[rt] : 0;
endmodule