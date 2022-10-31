
`include "../include/x_def.v"
						
module EM_ARRAY(/* IN */
		Cin_E, MRb_E, MRa_E,
		P0_E,  P1_E,   P2_E,
		P3_E,  P4_E,   P5_E,
		P6_E, P7_E,  P8_E,

		/* OUT */
		MLSB_E, SUM_E, CRY_E);
						
/*----------------------------------------------*/
input [16:0]  Cin_E;
input [39:14] MRb_E;
input [15:0]  MRa_E;
input [17:0]  P0_E;
input [19:2]  P1_E;
input [21:4]  P2_E;
input [23:6]  P3_E;
input [25:8]  P4_E;
input [27:10] P5_E;
input [29:12] P6_E;
input [31:14] P7_E;
input [32:16] P8_E;
						
/*----------------------------------------------*/
output [2:0]  MLSB_E;
output [39:3] SUM_E;
output [39:3] CRY_E;

wire [39:0] CSA10_i0 = {23'b0, Cin_E[16:0]};
wire [39:0] CSA10_i1 = {24'b0, MRa_E[15:0]};
wire [39:0] CSA10_i2 = {{22{P0_E[17]}}, P0_E[17:0]};
wire [39:0] S1_0;
wire [39:1] C1_0;

assign S1_0[39:0] = CSA10_i0[39:0] ^ CSA10_i1[39:0] ^ CSA10_i2[39:0];
assign C1_0[39:1] = CSA10_i0[38:0] & CSA10_i1[38:0]
		  | CSA10_i1[38:0] & CSA10_i2[38:0]
		  | CSA10_i2[38:0] & CSA10_i0[38:0];

wire [39:2] CSA11_i0 = {{20{P1_E[19]}}, P1_E[19:2]};
wire [39:2] CSA11_i1 = {{18{P2_E[21]}}, P2_E[21:4], 2'b0};
wire [39:2] CSA11_i2 = {{16{P3_E[23]}}, P3_E[23:6], 4'b0};
wire [39:2] S1_1;
wire [39:3] C1_1;

assign S1_1[39:2] = CSA11_i0[39:2] ^ CSA11_i1[39:2] ^ CSA11_i2[39:2];
assign C1_1[39:3] = CSA11_i0[38:2] & CSA11_i1[38:2]
		  | CSA11_i1[38:2] & CSA11_i2[38:2]
		  | CSA11_i2[38:2] & CSA11_i0[38:2];

wire [39:8] CSA12_i0 = {{14{P4_E[25]}}, P4_E[25:8]};
wire [39:8] CSA12_i1 = {{12{P5_E[27]}}, P5_E[27:10], 2'b0};
wire [39:8] CSA12_i2 = {{10{P6_E[29]}}, P6_E[29:12], 4'b0};
wire [39:8] S1_2;
wire [39:9] C1_2;

assign S1_2[39:8] = CSA12_i0[39:8] ^ CSA12_i1[39:8] ^ CSA12_i2[39:8];
assign C1_2[39:9] = CSA12_i0[38:8] & CSA12_i1[38:8]
		  | CSA12_i1[38:8] & CSA12_i2[38:8]
		  | CSA12_i2[38:8] & CSA12_i0[38:8];

wire [39:14] CSA13_i0 = {{8{P7_E[31]}}, P7_E[31:14]};
wire [39:14] CSA13_i1 = {{7{P8_E[32]}}, P8_E[32:16], 2'b0};
wire [39:14] CSA13_i2 = MRb_E[39:14];
wire [39:14] S1_3;
wire [39:15] C1_3;

assign S1_3[39:14] = CSA13_i0[39:14] ^ CSA13_i1[39:14] ^ CSA13_i2[39:14];
assign C1_3[39:15] = CSA13_i0[38:14] & CSA13_i1[38:14]
                   | CSA13_i1[38:14] & CSA13_i2[38:14]
		   | CSA13_i2[38:14] & CSA13_i0[38:14];

wire [39:1] CSA20_i0 = S1_0[39:1];
wire [39:1] CSA20_i1 = C1_0[39:1];
wire [39:1] CSA20_i2 = {S1_1[39:2], 1'b0};
wire [39:1] CSA20_i3 = {C1_1[39:3], 2'b0};

wire [39:1] G2_0;
wire [39:1] H2_0;
wire [39:1] P2_0;
wire [39:1] S2_0;
wire [39:2] C2_0;

assign G2_0[39:1] = ((CSA20_i0[39:1] | CSA20_i1[39:1]) 
                  &  (CSA20_i2[39:1] | CSA20_i3[39:1]));

assign H2_0[39:1] = ~((CSA20_i0[39:1] & CSA20_i1[39:1])
		  |   (CSA20_i2[39:1] & CSA20_i3[39:1]));

assign P2_0[39:1] = CSA20_i0[39:1] ^ CSA20_i1[39:1] 
		  ^ CSA20_i2[39:1] ^ CSA20_i3[39:1];

assign S2_0[39:1] = ~((P2_0[39:1] &  {G2_0[38:1], 1'b0})
		  |  (~P2_0[39:1] & ~{G2_0[38:1], 1'b0}));

assign C2_0[39:2] = ~((P2_0[38:1] & ~{G2_0[37:1], 1'b0})
		  |  (~P2_0[38:1] &  H2_0[38:1]));


wire [39:8] CSA21_i0 = S1_2[39:8];
wire [39:8] CSA21_i1 = {C1_2[39:9],  1'b0};
wire [39:8] CSA21_i2 = {S1_3[39:14], 6'b0};
wire [39:8] CSA21_i3 = {C1_3[39:15], 7'b0};
wire [39:8] G2_1;
wire [39:8] H2_1;
wire [39:8] P2_1;
wire [39:8] S2_1;
wire [39:9] C2_1;

assign G2_1[39:8] = ((CSA21_i0[39:8] | CSA21_i1[39:8])
		  &  (CSA21_i2[39:8] | CSA21_i3[39:8]));

assign H2_1[39:8] = ~((CSA21_i0[39:8] & CSA21_i1[39:8])
		  |   (CSA21_i2[39:8] & CSA21_i3[39:8]));

assign P2_1[39:8] = CSA21_i0[39:8] ^ CSA21_i1[39:8]
		  ^ CSA21_i2[39:8] ^ CSA21_i3[39:8];

assign S2_1[39:8] = ~((P2_1[39:8] &  {G2_1[38:8], 1'b0})
		  |  (~P2_1[39:8] & ~{G2_1[38:8], 1'b0}));

assign C2_1[39:9] = ~((P2_1[38:8] & ~{G2_1[37:8], 1'b0})
		  |  (~P2_1[38:8] & H2_1[38:8]));


wire [39:2] CSA30_i0 = S2_0[39:2];
wire [39:2] CSA30_i1 = C2_0[39:2];
wire [39:2] CSA30_i2 = {S2_1[39:8], 6'b0};
wire [39:2] CSA30_i3 = {C2_1[39:9], 7'b0};
wire [39:2] G3_0;
wire [39:2] H3_0;
wire [39:2] P3_0;
wire [39:2] S3_0;
wire [39:3] C3_0;

assign G3_0[39:2] = ((CSA30_i0[39:2] | CSA30_i1[39:2])
		  &  (CSA30_i2[39:2] | CSA30_i3[39:2]));

assign H3_0[39:2] = ~((CSA30_i0[39:2] & CSA30_i1[39:2])
		  |   (CSA30_i2[39:2] & CSA30_i3[39:2]));

assign P3_0[39:2] = CSA30_i0[39:2] ^ CSA30_i1[39:2]
		  ^ CSA30_i2[39:2] ^ CSA30_i3[39:2];

assign S3_0[39:2] = ~((P3_0[39:2] &  {G3_0[38:2], 1'b0})
		  |  (~P3_0[39:2] & ~{G3_0[38:2], 1'b0}));

assign C3_0[39:3] = ~((P3_0[38:2] & ~{G3_0[37:2], 1'b0})
		  |  (~P3_0[38:2] &  H3_0[38:2]));

wire [2:0]  MLSB_E;
wire [39:3] SUM_E;
wire [39:3] CRY_E;

assign #`da MLSB_E[2:0] = {S3_0[2], S2_0[1], S1_0[0]};
assign #`da SUM_E[39:3] = S3_0[39:3];
assign #`da CRY_E[39:3] = C3_0[39:3]; 

endmodule