
module abc(input a, input b, input clk, output c, output reg d);

assign c = a & b;

always @(posedge clk)
    d <= c;
endmodule

