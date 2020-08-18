module mux3(data0, data1, data2, data_out, op);
     input [31:0] data0, data1, data2;
     input [1:0]op;
     output reg [31:0] data_out;
     always @(*)begin
        case(op)
            2'b00 : data_out = data0;
            2'b01 : data_out = data1;
            2'b10 : data_out = data2;
        endcase
     end
endmodule