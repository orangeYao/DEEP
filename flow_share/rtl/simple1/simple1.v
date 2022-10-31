
module simple1 (input  [3:0] a, 
                input  [3:0] b,
                output [3:0] x,
                output [3:0] y,
                output [3:0] z);
    assign x[1:0] = a[1:0] & b[1:0];
    assign x[3:2] = ~a[3:2]; 
    assign y[1:0] = a[1:0] | b[1:0];
    assign y[3:2] = ~(a[3:2] | b[3:2]);
    assign z = a ^ b;
endmodule


