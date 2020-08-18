module pc(pc,clock,reset,npc);
    output reg [31:0] pc;
    input clock;
    input reset;
    input [31:0] npc;

    always @(posedge clock, negedge reset)
        begin
            if(!reset)
                pc = 32'h00003000;
            else
                pc = npc;
        end
endmodule