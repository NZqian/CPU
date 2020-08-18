module mux2(data0, data1, data_out, op);
     input [31:0] data0, data1;
     input op;
     output [31:0] data_out;
     assign data_out = op ? data1 : data0;
endmodule