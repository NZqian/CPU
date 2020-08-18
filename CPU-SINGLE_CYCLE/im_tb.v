`timescale 10ns/10ns 
module im_tb;
reg [31:0] instruction;
wire [31:0] pc;
reg clock;
im IM(instruction, pc);
initial
    begin
        $readmemh("memory.txt", IM.ins_memory);
        instruction = 32'h00003000;
    end
always
    #10 clock = ~clock;

always @(posedge clock) begin
    instruction = instruction + 4;
end

endmodule