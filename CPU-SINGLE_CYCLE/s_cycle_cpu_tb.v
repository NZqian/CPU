`timescale 10ns/10ns 
module s_cycle_cpu_tb;
reg clock, reset;
s_cycle_cpu SCPU(clock, reset);
initial
    begin
        $readmemh("fib.txt", SCPU.IM.ins_memory);
        $readmemh("register.txt", SCPU.GPR.gp_registers);
        clock = 0;
        #1 reset = 0;
        #12 reset = 1;
    end
always
    #10 clock = ~clock;
endmodule