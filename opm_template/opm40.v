
module opm40
  #(parameter B = 5,
              n = 40,
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


    assign Ws[0] = 5'b10010;
    assign Ws[1] = 5'b10110;
    assign Ws[2] = 5'b10011;
    assign Ws[3] = 5'b00101;
    assign Ws[4] = 5'b00101;
    assign Ws[5] = 5'b01000;
    assign Ws[6] = 5'b01000;
    assign Ws[7] = 5'b00101;
    assign Ws[8] = 5'b01000;
    assign Ws[9] = 5'b10000;
    assign Ws[10] = 5'b10110;
    assign Ws[11] = 5'b01000;
    assign Ws[12] = 5'b00111;
    assign Ws[13] = 5'b01000;
    assign Ws[14] = 5'b00110;
    assign Ws[15] = 5'b01111;
    assign Ws[16] = 5'b00110;
    assign Ws[17] = 5'b01110;
    assign Ws[18] = 5'b00111;
    assign Ws[19] = 5'b01000;
    assign Ws[20] = 5'b00110;
    assign Ws[21] = 5'b00101;
    assign Ws[22] = 5'b01100;
    assign Ws[23] = 5'b00111;
    assign Ws[24] = 5'b00011;
    assign Ws[25] = 5'b00101;
    assign Ws[26] = 5'b00110;
    assign Ws[27] = 5'b10010;
    assign Ws[28] = 5'b01111;
    assign Ws[29] = 5'b10110;
    assign Ws[30] = 5'b01010;
    assign Ws[31] = 5'b10101;
    assign Ws[32] = 5'b01000;
    assign Ws[33] = 5'b00100;
    assign Ws[34] = 5'b01110;
    assign Ws[35] = 5'b01001;
    assign Ws[36] = 5'b00101;
    assign Ws[37] = 5'b00111;
    assign Ws[38] = 5'b00100;
    assign Ws[39] = 5'b00111;


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



