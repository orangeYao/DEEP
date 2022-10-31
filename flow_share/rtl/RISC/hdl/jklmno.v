



















































































module rf_if 
































( 
SYSCLK, TMODE, RESET_D1_R_N, 
CLMI_RHOLD, CP0_XCPN_M_C1, 
REGAADDR_S, REGBADDR_S, 
REGCADDR_M_R, 
REGCWRITE_M_R, 
READA_S, 
READB_S, 
WRITEC_W_R 
); 

`include "../include/lxr_symbols.vh" 
`include "../include/core_symbols.vh" 


input SYSCLK; 
input TMODE; 
input RESET_D1_R_N; 
input CLMI_RHOLD; 
input CP0_XCPN_M_C1; 

input [4:0] REGAADDR_S; 
input [4:0] REGBADDR_S; 

input [4:0] REGCADDR_M_R; 
input REGCWRITE_M_R; 

output [31:1] WRITEC_W_R; 

output [9:0] READA_S; 
output [9:0] READB_S; 





reg [9:0] READA_S; 
reg [9:0] READB_S; 
reg [31:1] WRITEC_W_R; 



reg [31:1] WRITEC_P; 


wire RESET_D2_R_N; 




wire NC_FOO = TMODE; 















always @(REGAADDR_S) begin 
READA_S[0] = (REGAADDR_S[2:0] == 0); 
READA_S[1] = (REGAADDR_S[2:0] == 1); 
READA_S[2] = (REGAADDR_S[2:0] == 2); 
READA_S[3] = (REGAADDR_S[2:0] == 3); 
READA_S[4] = (REGAADDR_S[2:0] == 4); 
READA_S[5] = (REGAADDR_S[2:0] == 5); 
READA_S[6] = (REGAADDR_S[2:0] == 6); 
READA_S[7] = (REGAADDR_S[2:0] == 7); 

READA_S[8] = REGAADDR_S[3]; 
READA_S[9] = REGAADDR_S[4]; 
end 



always @(REGBADDR_S) begin 
READB_S[0] = (REGBADDR_S[2:0] == 0); 
READB_S[1] = (REGBADDR_S[2:0] == 1); 
READB_S[2] = (REGBADDR_S[2:0] == 2); 
READB_S[3] = (REGBADDR_S[2:0] == 3); 
READB_S[4] = (REGBADDR_S[2:0] == 4); 
READB_S[5] = (REGBADDR_S[2:0] == 5); 
READB_S[6] = (REGBADDR_S[2:0] == 6); 
READB_S[7] = (REGBADDR_S[2:0] == 7); 

READB_S[8] = REGBADDR_S[3]; 
READB_S[9] = REGBADDR_S[4]; 
end 



always @(REGCWRITE_M_R or REGCADDR_M_R ) begin 


WRITEC_P[1] = REGCWRITE_M_R & (REGCADDR_M_R == 1); 
WRITEC_P[2] = REGCWRITE_M_R & (REGCADDR_M_R == 2); 
WRITEC_P[3] = REGCWRITE_M_R & (REGCADDR_M_R == 3); 
WRITEC_P[4] = REGCWRITE_M_R & (REGCADDR_M_R == 4); 
WRITEC_P[5] = REGCWRITE_M_R & (REGCADDR_M_R == 5); 
WRITEC_P[6] = REGCWRITE_M_R & (REGCADDR_M_R == 6); 
WRITEC_P[7] = REGCWRITE_M_R & (REGCADDR_M_R == 7); 
WRITEC_P[8] = REGCWRITE_M_R & (REGCADDR_M_R == 8); 
WRITEC_P[9] = REGCWRITE_M_R & (REGCADDR_M_R == 9); 

WRITEC_P[10] = REGCWRITE_M_R & (REGCADDR_M_R == 10); 
WRITEC_P[11] = REGCWRITE_M_R & (REGCADDR_M_R == 11); 
WRITEC_P[12] = REGCWRITE_M_R & (REGCADDR_M_R == 12); 
WRITEC_P[13] = REGCWRITE_M_R & (REGCADDR_M_R == 13); 
WRITEC_P[14] = REGCWRITE_M_R & (REGCADDR_M_R == 14); 
WRITEC_P[15] = REGCWRITE_M_R & (REGCADDR_M_R == 15); 
WRITEC_P[16] = REGCWRITE_M_R & (REGCADDR_M_R == 16); 
WRITEC_P[17] = REGCWRITE_M_R & (REGCADDR_M_R == 17); 
WRITEC_P[18] = REGCWRITE_M_R & (REGCADDR_M_R == 18); 
WRITEC_P[19] = REGCWRITE_M_R & (REGCADDR_M_R == 19); 

WRITEC_P[20] = REGCWRITE_M_R & (REGCADDR_M_R == 20); 
WRITEC_P[21] = REGCWRITE_M_R & (REGCADDR_M_R == 21); 
WRITEC_P[22] = REGCWRITE_M_R & (REGCADDR_M_R == 22); 
WRITEC_P[23] = REGCWRITE_M_R & (REGCADDR_M_R == 23); 
WRITEC_P[24] = REGCWRITE_M_R & (REGCADDR_M_R == 24); 
WRITEC_P[25] = REGCWRITE_M_R & (REGCADDR_M_R == 25); 
WRITEC_P[26] = REGCWRITE_M_R & (REGCADDR_M_R == 26); 
WRITEC_P[27] = REGCWRITE_M_R & (REGCADDR_M_R == 27); 
WRITEC_P[28] = REGCWRITE_M_R & (REGCADDR_M_R == 28); 
WRITEC_P[29] = REGCWRITE_M_R & (REGCADDR_M_R == 29); 

WRITEC_P[30] = REGCWRITE_M_R & (REGCADDR_M_R == 30); 
WRITEC_P[31] = REGCWRITE_M_R & (REGCADDR_M_R == 31); 

end 












reg RESET_X_R_N; 
always @ (posedge SYSCLK) 
RESET_X_R_N <= RESET_D1_R_N; 
assign RESET_D2_R_N = RESET_X_R_N | TMODE; 






always @(posedge SYSCLK `negedge_RESET_D2_R_N_) 


if (!`RESET_D2_R_N_ ) 
WRITEC_W_R <= 31'd0; 
else if (!CLMI_RHOLD) 
WRITEC_W_R <= CP0_XCPN_M_C1 ? 31'd0 : WRITEC_P; 



endmodule 
