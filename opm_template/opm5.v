
module opm5
  #(parameter B = 6,
              n = 5,
              outsize = 10)
   (input                clk, 
    input        [n-1:0] sigs , 
    output reg [outsize-1:0] out);

    integer i;
    reg sigs_r[n-1:0];
    reg sigs_k[n-1:0];
    reg sigs_tog[n-1:0];
    reg [outsize-1:0] sum;
    reg [B-1:0]mul [n-1:0];
    wire [B-1:0]Ws [n-1:0];

    assign Ws[0] = 6'b010111;
    assign Ws[1] = 6'b011001;
    assign Ws[2] = 6'b011000;
    assign Ws[3] = 6'b001011;
    assign Ws[4] = 6'b101101;


    //// initial interface
    always @(posedge clk) 
      for (i = 0; i < n; i = i + 1) 
        sigs_r[i] <= sigs[i];

    //// toggle detectors - output: sigs_tog
    always @(posedge clk) 
      for (i = 0; i < n; i = i + 1) 
        sigs_k[i] <= sigs_r[i];

    always @(*)
        for (i = 0; i < n; i = i + 1) 
            sigs_tog[i] = sigs_r[i] ^ sigs_k[i];

    //// OR for bus signals (not bus now)

    ///// AND with weights - output: mul
    always @(*)
        begin
        for (i = 0; i < n; i = i + 1) 
            mul[i] = Ws[i] & {B{sigs_tog[i]}};
        end

    ///// ADD all anded weights
    always @(*)
        begin
            sum = {outsize{1'b0}};
            for (i = 0; i < n; i = i + 1) 
                sum = sum + mul[i];
        end

    // reg per-cycle power
    always @(posedge clk)
        out <= sum;

endmodule



