
// https://www.cs.utexas.edu/users/fussell/courses/cs352h/handouts/verilog/vcs_tut.html

`timescale 1ns/10ps

module and_power_testbench ();

wire out;
reg i1, i2, i3, i4, clk;

and_power dut (.i1(i1),
               .i2(i2),
               .i3(i3),
               .i4(i4),
               .clk(clk),
               .out(out));

initial begin
    i1 = 1'b1;
    i2 = 1'b1;
    i3 = 1'b1;
    i4 = 1'b1;
    clk = 1'b0;

    #30;
    i1 = 1'b0;

    #20;

    i1 = 1'b1;

    #40;
    i1 = 1'b0;

    #20;
    $finish;
end

always
    #5 clk=~clk;

initial begin
  $dumpfile("and_power.vcd");
  $dumpvars(0, and_power_testbench);
end

endmodule


