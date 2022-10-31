module top_module(
    input clk,
    input x,
    input y,
    output z,f);
    reg Q1;
    reg Q2;
    reg Q3;
    reg Q4;
    reg Q5;
    reg Q6;
    reg Q7;
    reg Q8;

    always @ (posedge clk)begin
        Q1 <= (x ^ Q1);
        Q2 <= (x & ~Q2);
        Q3 <= (x | ~Q3);
        Q4 <= (x | ~Q4);
        Q5 <= (y ^ Q5 );
        Q6 <= (y & Q6 );
        Q7 <= (y | Q7 );
        Q8 <= (y ^~ Q8 );
   end

   assign z = ~(((Q1|Q2)^(Q3&Q4))&Q5);
   assign f = ~((Q6^Q7)&Q8);

endmodule

