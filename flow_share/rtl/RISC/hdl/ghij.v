



















































































`include "../include/lxr_symbols.vh" 

module lx1 










( 
SYSCLK, 

SYSCLKF, SL_SLEEPSYS_C2_R, SL_SLEEPSYS_C3_R, 




BUSCLK, 

BUSCLKF, SL_SLEEPBUS_C2_BR, SL_SLEEPBUS_C3_BR, 




ResetN, RESET_PWRON_N, 

RESET_D1_R_N, 








JTAG_TDO_NR, 
JTAG_TDI, 
JTAG_TMS, 
JTAG_CLOCK, 
JTAG_TRST_N, 
JTAG_RST_N, 




CFG_EJDIS, 



JPT_PCST_DR, 
JPT_TPC_DR, 
EJT_DCLK, 



LAddrO, LDataO, LDataI, LIrdy, LFrame, LSel, LTrdy, LCmd, LUc, LId, LReq, 
LFrameI, LIrdyI, LCoe, LToe, LXoe, LDoe, LGnt, LAbort, 




CFG_ICOFF, 
EXT_ICREQRAM_R, IC_GNTRAM_R, 



IC_TAGINDEX, ICR_TAGRD0, IC_TAGWR0, 
ICR_TAGMASK, 
IC_TAG0WE, IC_TAG0WEN, 
IC_TAG0RE, IC_TAG0REN, IC_TAG0CS, IC_TAG0CSN, 
IC_INSTINDEX, IC_INSTWR, 
ICR_INST0RD, IC_INST0WE, IC_INST0WEN, 
IC_INST0RE, IC_INST0REN, IC_INST0CS, IC_INST0CSN, 






IW_VALIDINDEX, IWR_VALIDRD, IW_VALIDWR, IW_VALIDWE, IW_VALIDWEN, 
IW_VALIDRE, IW_VALIDREN, IW_VALIDCS, IW_VALIDCSN, 
IW_INSTINDEX, IWR_INSTRD, IW_INSTWR, IW_INSTWE, IW_INSTWEN, 
IW_INSTRE, IW_INSTREN, IW_INSTCS, IW_INSTCSN, 
EXT_IWREQRAM_R, IW_GNTRAM_R, 


CFG_DCOFF, 
EXT_DCREQRAM_R, DC_GNTRAM_R, 



DC_TAGINDEX, DCR_TAGRD, DC_TAGWR, DC_TAGWE, DC_TAGWEN, DCC_TAGMASK, 
DC_TAGRE, DC_TAGREN, DC_TAGCS, DC_TAGCSN, 
DC_DATAINDEX, DCR_DATARD, DC_DATAWR, DC_DATAWE, DC_DATAWEN, 
DC_DATARE, DC_DATAREN, DC_DATACS, DC_DATACSN, 




DW_DATAINDEX, DWR_DATARD, DW_DATAWR, DW_DATAWE, DW_DATAWEN, CFG_DWDISW, 
DW_DATARE, DW_DATAREN, DW_DATACS, DW_DATACSN, 
EXT_DWREQRAM_R, DW_GNTRAM_R, 




CFG_DWBASE, CFG_DWTOP, 


CFG_IWBASE, CFG_IWTOP, 






Cond_in1, 
C1rd_addr, C1rhold, C1rd_gen, C1rd_con, C1rd_data, 
C1wr_addr, C1wr_gen, C1wr_con, C1wr_data, 





Cond_in2, 
C2rd_addr, C2rhold, C2rd_gen, C2rd_con, C2rd_data, 
C2wr_addr, C2wr_gen, C2wr_con, C2wr_data, 





Cond_in3, 
C3rd_addr, C3rhold, C3rd_gen, C3rd_con, C3rd_data, 
C3wr_addr, C3wr_gen, C3wr_con, C3wr_data, 
C3cnt_inst, C3cnt_imiss, C3cnt_istall, C3cnt_dmiss, C3cnt_dstall, C3cnt_dload, C3cnt_dstore, 





CE1_RES_E, 
CEI_CE1HOLD, 
CE1_SEL_E_R, 
CE1_HALT_E_R, 
CEI_CE1OP_S_R, 
CEI_INSTM32_S_R_N, 
CEI_CE1AOP_E_R, 
CEI_CE1BOP_E_R, 
CEI_XCPN_M_C1, 



EXT_SLEEPREQ_R, 



CFG_SLEEPENABLE, 



CFG_MEMSEQUENTIAL, 



CFG_MEMZEROFIRST, 



CFG_MEMFULLWORD, 







CFG_LBCSYNCMODE, 



CFG_LBCWBDISABLE, 



CFG_EJTNMINUS1, 



CFG_EJTMLOG2, 



CFG_EJTBIT0M16, 


IntreqN 

); 






input SYSCLK; 

input SYSCLKF; 
output SL_SLEEPSYS_C2_R; 
output SL_SLEEPSYS_C3_R; 






input BUSCLK; 

input BUSCLKF; 
output SL_SLEEPBUS_C2_BR; 
output SL_SLEEPBUS_C3_BR; 




input ResetN; 
input RESET_PWRON_N; 

output RESET_D1_R_N; 







wire [7:0] NC_SCAN; 








output JTAG_TDO_NR; 
input JTAG_TDI; 
input JTAG_TMS; 
input JTAG_CLOCK; 
input JTAG_TRST_N; 
input JTAG_RST_N; 




output [11:0] JPT_PCST_DR; 
output [8:2] JPT_TPC_DR; 
output EJT_DCLK; 



input CFG_EJDIS; 



output [31:0] LAddrO; 
output [31:0] LDataO; 
input [31:0] LDataI; 
output LIrdy; 
input LIrdyI; 
output LFrame; 
input LFrameI; 
input LSel; 
input LAbort; 
input LTrdy; 
output [6:0] LCmd; 
output LId; 
output LUc; 
output [`LBC_COE-1:0] LCoe; 
output [`LBC_TOE-1:0] LToe; 
output [`LBC_XOE-1:0] LXoe; 
output [`LBC_DOE-1:0] LDoe; 
output LReq; 
input LGnt; 




input CFG_ICOFF; 
input EXT_ICREQRAM_R; 
output IC_GNTRAM_R; 


output [`IC_ADDR_HI:`LINE_ADDR_HI+1] IC_TAGINDEX; 
input [32:`IC_ADDR_HI+1-`IC_TAG_EXTRA_SIZE] ICR_TAGRD0; 
output [32:`IC_ADDR_HI+1-`IC_TAG_EXTRA_SIZE] IC_TAGWR0; 
output IC_TAG0WE; 
output IC_TAG0WEN; 
output IC_TAG0RE; 
output IC_TAG0REN; 
output IC_TAG0CS; 
output IC_TAG0CSN; 
input [`IC_TAG_EXTRA_SIZE-1:0] ICR_TAGMASK; 
output [`IC_ADDR_HI:2] IC_INSTINDEX; 
output [31:0] IC_INSTWR; 
input [31:0] ICR_INST0RD; 
output IC_INST0WE; 
output IC_INST0WEN; 
output IC_INST0RE; 
output IC_INST0REN; 
output IC_INST0CS; 
output IC_INST0CSN; 






output [`IW_ADDR_HI:9] IW_VALIDINDEX; 
input [31:0] IWR_VALIDRD; 
output [31:0] IW_VALIDWR; 
output IW_VALIDWE; 
output IW_VALIDWEN; 
output IW_VALIDRE; 
output IW_VALIDREN; 
output IW_VALIDCS; 
output IW_VALIDCSN; 
output [`IW_ADDR_HI:2] IW_INSTINDEX; 
input [31:0] IWR_INSTRD; 
output [31:0] IW_INSTWR; 
output IW_INSTWE; 
output IW_INSTWEN; 
output IW_INSTRE; 
output IW_INSTREN; 
output IW_INSTCS; 
output IW_INSTCSN; 
input EXT_IWREQRAM_R; 
output IW_GNTRAM_R; 


input CFG_DCOFF; 
input EXT_DCREQRAM_R; 
output DC_GNTRAM_R; 



output [`DC_ADDR_HI:`LINE_ADDR_HI+1] DC_TAGINDEX; 
input [32:`DC_ADDR_HI+1-`DC_TAG_EXTRA_SIZE] DCR_TAGRD; 
output [32:`DC_ADDR_HI+1-`DC_TAG_EXTRA_SIZE] DC_TAGWR; 
output DC_TAGWE; 
output DC_TAGWEN; 
output DC_TAGRE; 
output DC_TAGREN; 
output DC_TAGCS; 
output DC_TAGCSN; 
input [`DC_TAG_EXTRA_SIZE-1:0] DCC_TAGMASK; 
output [`DC_ADDR_HI:2] DC_DATAINDEX; 
input [31:0] DCR_DATARD; 
output [31:0] DC_DATAWR; 
output DC_DATAWE; 
output DC_DATAWEN; 
output DC_DATARE; 
output DC_DATAREN; 
output DC_DATACS; 
output DC_DATACSN; 




output [`DW_ADDR_HI:2] DW_DATAINDEX; 
input [31:0] DWR_DATARD; 
output [31:0] DW_DATAWR; 
output DW_DATAWE; 
output DW_DATAWEN; 
output DW_DATARE; 
output DW_DATAREN; 
output DW_DATACS; 
output DW_DATACSN; 
input CFG_DWDISW; 
input EXT_DWREQRAM_R; 
output DW_GNTRAM_R; 




input [`LM_BASE_RANGE] CFG_DWBASE ; 
input [`LM_TOP_RANGE ] CFG_DWTOP ; 


input [`LM_BASE_RANGE] CFG_IWBASE ; 
input [`LM_TOP_RANGE ] CFG_IWTOP ; 





input Cond_in1; 
output [4:0] C1rd_addr; 
output C1rhold; 
output C1rd_gen; 
output C1rd_con; 
output [4:0] C1wr_addr; 
output C1wr_gen; 
output C1wr_con; 
output [31:0] C1wr_data; 
input [31:0] C1rd_data; 



input Cond_in2; 
output [4:0] C2rd_addr; 
output C2rhold; 
output C2rd_gen; 
output C2rd_con; 
output [4:0] C2wr_addr; 
output C2wr_gen; 
output C2wr_con; 
output [31:0] C2wr_data; 
input [31:0] C2rd_data; 



input Cond_in3; 
output [4:0] C3rd_addr; 
output C3rhold; 
output C3rd_gen; 
output C3rd_con; 
output [4:0] C3wr_addr; 
output C3wr_gen; 
output C3wr_con; 
output [31:0] C3wr_data; 
input [31:0] C3rd_data; 

output C3cnt_inst; 
output C3cnt_imiss; 
output C3cnt_istall; 
output C3cnt_dmiss; 
output C3cnt_dstall; 
output C3cnt_dload; 
output C3cnt_dstore; 



output CEI_CE1HOLD; 
output CEI_XCPN_M_C1; 
output [11:0] CEI_CE1OP_S_R; 
output CEI_INSTM32_S_R_N; 
output [31:0] CEI_CE1AOP_E_R; 
output [31:0] CEI_CE1BOP_E_R; 
input [31:0] CE1_RES_E; 
input CE1_SEL_E_R; 
input [`HALT_DRV_RANGE] CE1_HALT_E_R; 



input EXT_SLEEPREQ_R; 



input CFG_SLEEPENABLE; 



parameter CFG_HLENABLE = `HlEnable; 



parameter CFG_MACENABLE = `MacEnable; 



input CFG_MEMSEQUENTIAL; 



input CFG_MEMZEROFIRST; 



input CFG_MEMFULLWORD; 



input CFG_LBCSYNCMODE; 



input CFG_LBCWBDISABLE; 



input [1:0] CFG_EJTNMINUS1; 



input [1:0] CFG_EJTMLOG2; 



input CFG_EJTBIT0M16; 


input [5:0] IntreqN; 





wire [31:0] LAddrO; 
wire [31:0] LDataO; 
wire [31:0] LDataI; 
wire LIrdy; 
wire LIrdyI; 
wire LFrame; 
wire LFrameI; 
wire LSel; 
wire LAbort; 
wire LTrdy; 
wire [6:0] LCmd; 
wire LUc; 
wire LId; 
wire [`LBC_COE-1:0] LCoe; 
wire [`LBC_TOE-1:0] LToe; 
wire [`LBC_XOE-1:0] LXoe; 
wire [`LBC_DOE-1:0] LDoe; 
wire LReq; 
wire LGnt; 

wire [`HALT_DRV_RANGE] CBUS_HALT_W_R; 
wire CBUS_SWBEMPTY; 
wire CBUS_DREQ; 
wire [31:0] CBUS_DADDR; 
wire CBUS_DUC; 
wire CBUS_DDM; 
wire CBUS_DRW; 
wire CBUS_DLINE; 
wire [1:0] CBUS_DSZ; 
wire [3:0] CBUS_DBE; 
wire [31:0] CBUS_DO; 
wire [31:0] CBUS_DADDR_E1; 
wire CBUS_IREQ; 
wire [31:0] CBUS_IADDR; 
wire CBUS_IUC; 
wire CBUS_IDM; 
wire CBUS_SIVAL; 
wire CBUS_SDVAL; 
wire [31:0] CBUS_SIDATA; 
wire [31:0] CBUS_SDDATA; 

wire [`LBC_EJUMBILICAL_WIDTH-1:0] LBC_EJUMBILICAL; 


wire RESET_D1_R_N; 
wire RESET_D1_BR_N; 
wire RESET_PWRON_C1_N; 
wire RESET_PWRON_D1_LR_N; 






























wire Cond_in1; 
wire [31:0] C1rd_data; 

wire [4:0] C1rd_addr; 
wire C1rhold; 
wire C1rd_gen; 
wire C1rd_con; 
wire [4:0] C1wr_addr; 
wire C1wr_gen; 
wire C1wr_con; 
wire [31:0] C1wr_data; 
wire C1cnt_inst; 
wire C1cnt_imiss; 
wire C1cnt_istall; 
wire C1cnt_dmiss; 
wire C1cnt_dstall; 
wire C1cnt_dload; 
wire C1cnt_dstore; 




wire Cond_in2; 
wire [31:0] C2rd_data; 

wire [4:0] C2rd_addr; 
wire C2rhold; 
wire C2rd_gen; 
wire C2rd_con; 
wire [4:0] C2wr_addr; 
wire C2wr_gen; 
wire C2wr_con; 
wire [31:0] C2wr_data; 
wire C2cnt_inst; 
wire C2cnt_imiss; 
wire C2cnt_istall; 
wire C2cnt_dmiss; 
wire C2cnt_dstall; 
wire C2cnt_dload; 
wire C2cnt_dstore; 




wire Cond_in3; 
wire [31:0] C3rd_data; 

wire C3rhold; 
wire [4:0] C3rd_addr; 
wire C3rd_gen; 
wire C3rd_con; 
wire [4:0] C3wr_addr; 
wire C3wr_gen; 
wire C3wr_con; 
wire [31:0] C3wr_data; 
wire C3cnt_inst; 
wire C3cnt_imiss; 
wire C3cnt_istall; 
wire C3cnt_dmiss; 
wire C3cnt_dstall; 
wire C3cnt_dload; 
wire C3cnt_dstore; 


wire [11:0] CEI_CE1OP_S_R; 
wire [11:0] CEI_CE0OP_S_R; 
wire [31:0] CEI_CE0AOP_E_R; 
wire [31:0] CEI_CE0BOP_E_R; 
wire [31:0] CEI_CE1AOP_E_R; 
wire [31:0] CEI_CE1BOP_E_R; 

wire [31:0] MAC_RES_E; 
wire MAC_SEL_E_R; 
wire [`HALT_DRV_RANGE] MAC_HALT_E_R; 

wire CEI_CE0HOLD; 
wire CEI_CE1HOLD; 
wire CEI_INSTM32_S_R_N; 






wire LW_ISAMPLE_S; 
wire [31:0] LW_IADDR_S_R; 

wire LW_DSAMPLE_W; 
wire LW_DWRITE_W_R; 
wire [3:0] LW_DBYEN_W_R; 
wire [31:0] LW_DADDR_W_R; 
wire [31:0] LW_DATA_W_R; 



wire [11:0] JPT_PCST_DR; 
wire [8:2] JPT_TPC_DR; 
wire JPT_TPC_ONE_DR; 
wire CP0_JCTRLJRST_R; 
wire CP0_JCTRLDM_I_R; 

wire PBI_EJHOLD; 
wire PBI_EJJPTHOLD; 
wire CP0_JXCPN1STIFDMBH_M_P; 
wire CP0_JXCPN1STIFNOTDMBH_M_P; 
wire CP0_DIBIFNOTDMBH_M_P; 
wire CP0_DBREAKCLR; 
wire CP0_DBRKSETIFDMBH; 
wire CP0_DDBXIFDMBH_M_P; 
wire CP0_DDBXUNCOND_M_P; 


wire [`EJ_LBCUMBILICAL_WIDTH-1:0] EJ_LBCUMBILICAL; 
wire EJT_DREN_R; 
wire EJC_DINT_R; 

wire EJIM_BREAKHIT_S; 
wire EJIM_TRACEHIT_S; 


wire EJDM_BREAKHIT_W; 
wire EJDM_TRACEHIT_W; 

wire EJPM_BREAKHIT_R; 
wire EJPM_TRACEHIT_R; 
wire EJC_ECRPROBEEN_R; 
wire EJC_ECRPRRST_R; 
wire EJC_DCRMINT_R; 
wire EJC_ECRPCAS_R; 
wire EJC_DCRTM_R; 
wire EJC_PCTRON_R; 
wire EJT_DCLK; 
wire EJ_STROBE; 



wire [31:0] EJIM_DATA; 


wire [31:0] EJDM_DATA; 


wire [31:0] EJPM_DATA; 

wire [31:0] EJDI_DATA; 
wire [31:0] EJDI_ADDR; 
wire EJDI_RW; 
wire EJDI_SELIBS; 
wire EJDI_SELIBRS; 
wire EJDI_SELDBS; 
wire EJDI_SELDBRS; 
wire EJDI_SELPBS; 
wire EJDI_SELPBRS; 



wire JTAG_CAPTURE; 
wire JTAG_CLOCK; 
wire JTAG_ESCANIN; 

wire JTAG_ESCANOUT; 

wire JTAG_SCANIN; 
wire [4:0] JTAG_IR; 
wire JTAG_SHIFT_DR; 
wire JTAG_SHIFT_IR; 
wire JTAG_RUNTEST; 
wire JTAG_RESET; 
wire JTAG_TDI; 
wire JTAG_TDO_NR; 
wire JTAG_TMS; 
wire JTAG_TRST_N; 
wire JTAG_RST_N; 
wire JTAG_UPDATE; 
wire JTAG_DINT; 




wire [31:0] lbc_addr; 
wire [31:0] lbc_data; 
wire lbc_frame; 
wire lbc_irdy; 
wire [6:0] lbc_cmd; 
wire [`LBC_COE-1:0] lbc_coe; 
wire [`LBC_TOE-1:0] lbc_toe; 
wire [`LBC_XOE-1:0] lbc_xoe; 
wire [`LBC_DOE-1:0] lbc_doe; 




wire CEI_XCPN_M_C0; 
wire CEI_XCPN_M_C1; 


wire SL_SLEEPSYS_C1_R; 
wire SL_SLEEPSYS_C2_R; 
wire SL_SLEEPSYS_C3_R; 

wire SL_SLEEPBUS_C1_BR; 
wire SL_SLEEPBUS_C2_BR; 
wire SL_SLEEPBUS_C3_BR; 



wire JPT_DBM2PCSTSET_P; 

wire [`LBC_EJUMBILICAL_WIDTH-1:0] NC_LBC_EJUMBILICAL; 


wire [`LBC_EJUMBILICAL_WIDTH-1:0] NC_FOO1 = NC_LBC_EJUMBILICAL; 
wire [`IC_TAG_EXTRA_SIZE-1:0] NC_FOO2 = ICR_TAGMASK; 

wire [`DC_TAG_EXTRA_SIZE-1:0] NC_FOO3 = DCC_TAGMASK; 







ejtag ejtag 
( 

.EJDI_DATA (EJDI_DATA[31:0]), 
.EJDI_ADDR (EJDI_ADDR[7:2]), 
.EJDI_RW (EJDI_RW), 
.EJDI_SELIBS (EJDI_SELIBS), 
.EJDI_SELIBRS (EJDI_SELIBRS), 
.EJDI_SELDBS (EJDI_SELDBS), 
.EJDI_SELDBRS (EJDI_SELDBRS), 
.EJC_DCRMINT_R (EJC_DCRMINT_R), 
.EJC_DCRTM_R (EJC_DCRTM_R), 
.EJC_DINT_R (EJC_DINT_R), 
.EJC_ECRPCAS_R (EJC_ECRPCAS_R), 
.EJC_ECRPROBEEN_R (EJC_ECRPROBEEN_R), 
.EJC_PCTRON_R (EJC_PCTRON_R), 
.EJC_ECRPRRST_R (EJC_ECRPRRST_R), 
.JTAG_ESCANOUT (JTAG_ESCANOUT), 
.EJT_DCLK (EJT_DCLK), 
.EJT_DREN_R (EJT_DREN_R), 



.JPT_DBM2PCSTSET_P (JPT_DBM2PCSTSET_P), 
.EJ_STROBE (EJ_STROBE), 


.EJIM_DATA (EJIM_DATA[31:0]), 


.EJDM_DATA (EJDM_DATA[31:0]), 

.EJPM_TRACEHIT_R (EJPM_TRACEHIT_R), 
.EJPM_BREAKHIT_R (EJPM_BREAKHIT_R), 

.JTAG_CAPTURE (JTAG_CAPTURE), 
.JTAG_ESCANIN (JTAG_ESCANIN), 
.JTAG_IR (JTAG_IR[4:0]), 
.JTAG_RUNTEST (JTAG_RUNTEST), 
.JTAG_SHIFT (JTAG_SHIFT_DR), 
.JTAG_UPDATE (JTAG_UPDATE), 
.JTAG_DINT (JTAG_DINT), 


.CFG_EJTNMINUS1 (CFG_EJTNMINUS1), 



.CFG_EJTMLOG2 (CFG_EJTMLOG2), 

.CFG_EJTBIT0M16 (CFG_EJTBIT0M16), 


.CORE_DOZE (SL_SLEEPSYS_C1_R), 

.CORE_HALT (1'b0), 
.CORE_RUN (1'b1), 

.CORE_CLOCK (SYSCLK), 
.JTAG_CLOCK (JTAG_CLOCK), 

.RESET_D1_R_N (`LX_RESET_D1_R_N_), 
.RESET_D1_JR_N (JTAG_RESET), 
.RESET_PWRON_N (`LX_RESET_PWRON_C1_N_), 


.TMODE (`CFG_TMODE_), 
.SEN (`CFG_SEN_), 
.RESET_DIS (`CFG_TMODE_), 
.EJ_DIS (CFG_EJDIS), 


.LBC_EJUMBILICAL (LBC_EJUMBILICAL[`LBC_EJUMBILICAL_WIDTH-1:0]), 

.EJ_LBCUMBILICAL (EJ_LBCUMBILICAL[`EJ_LBCUMBILICAL_WIDTH-1:0]) 
); 



ejtag_imatch_4180 imatch 
( 

.EJIM_DATA (EJIM_DATA[31:0]), 
.EJIM_TRACEHIT (EJIM_TRACEHIT_S), 
.EJIM_BREAKHIT (EJIM_BREAKHIT_S), 

.EJDI_DATA (EJDI_DATA[31:0]), 
.EJDI_ADDR (EJDI_ADDR[7:2]), 
.EJDI_RW (EJDI_RW), 
.EJDI_SELIBS (EJDI_SELIBS), 
.EJDI_SELIBRS (EJDI_SELIBRS), 
.EJ_STROBE (EJ_STROBE), 
.LW_ISAMPLE_S (LW_ISAMPLE_S), 
.LW_IADDR_S_R (LW_IADDR_S_R[31:0]), 
.CP0_JCTRLDM_I_R (CP0_JCTRLDM_I_R), 

.EJDM_BREAKHIT_W (EJDM_BREAKHIT_W), 

.PBI_EJHOLD (PBI_EJHOLD), 
.CP0_JXCPN1STIFDMBH_M_P (CP0_JXCPN1STIFDMBH_M_P), 
.CP0_JXCPN1STIFNOTDMBH_M_P (CP0_JXCPN1STIFNOTDMBH_M_P), 
.CP0_DIBIFNOTDMBH_M_P (CP0_DIBIFNOTDMBH_M_P), 
.CORE_CLOCK (SYSCLK), 
.TMODE (`CFG_TMODE_), 
.SEN (`CFG_SEN_), 
.RESET_D1_R_N (`LX_RESET_D1_R_N_)); 



ejtag_dmatch_4180 dmatch 
( 

.EJDM_DATA (EJDM_DATA[31:0]), 
.EJDM_TRACEHIT (EJDM_TRACEHIT_W), 
.EJDM_BREAKHIT (EJDM_BREAKHIT_W), 

.EJDI_DATA (EJDI_DATA[31:0]), 
.EJDI_ADDR (EJDI_ADDR[7:2]), 
.EJDI_RW (EJDI_RW), 
.EJDI_SELDBS (EJDI_SELDBS), 
.EJDI_SELDBRS (EJDI_SELDBRS), 
.EJ_STROBE (EJ_STROBE), 
.LW_DSAMPLE_W (LW_DSAMPLE_W), 
.LW_DADDR_W_R (LW_DADDR_W_R[31:2]), 
.LW_DATA_W_R (LW_DATA_W_R[31:0]), 
.CP0_JXCPN1STIFDMBH_M_P (CP0_JXCPN1STIFDMBH_M_P), 
.CP0_JXCPN1STIFNOTDMBH_M_P (CP0_JXCPN1STIFNOTDMBH_M_P), 
.CP0_DBREAKCLR (CP0_DBREAKCLR), 
.CP0_DBRKSETIFDMBH (CP0_DBRKSETIFDMBH), 
.CP0_DDBXIFDMBH_M_P (CP0_DDBXIFDMBH_M_P), 
.CP0_DDBXUNCOND_M_P (CP0_DDBXUNCOND_M_P), 

.CORE_CLOCK (SYSCLK), 
.RESET_D1_R_N (`LX_RESET_D1_R_N_), 
.TMODE (`CFG_TMODE_), 
.SEN (`CFG_SEN_)); 




jtag_tap tap 
( 

.JTAG_TDO_NR (JTAG_TDO_NR), 
.JTAG_SCANIN (JTAG_SCANIN), 
.JTAG_ESCANIN (JTAG_ESCANIN), 
.JTAG_CAPTURE (JTAG_CAPTURE), 
.JTAG_UPDATE (JTAG_UPDATE), 
.JTAG_SHIFT_IR (JTAG_SHIFT_IR), 
.JTAG_SHIFT_DR (JTAG_SHIFT_DR), 
.JTAG_IR (JTAG_IR[4:0]), 
.JTAG_RUNTEST (JTAG_RUNTEST), 
.JTAG_RESET (JTAG_RESET), 
.JTAG_DINT (JTAG_DINT), 

.JTAG_TDI (JTAG_TDI), 
.JTAG_TMS (JTAG_TMS), 

.JTAG_CLOCK (JTAG_CLOCK), 

.JTAG_TRST_N (JTAG_TRST_N), 

.JTAG_SCANOUT (1'b0), 


.JTAG_ESCANOUT (JTAG_ESCANOUT), 

.JTAG_USR (3'b000), 

.EJC_PCTRON_R (EJC_PCTRON_R), 

.JPT_TPC_DR (JPT_TPC_ONE_DR), 
.CP0_JCTRLJRST_R (CP0_JCTRLJRST_R), 
.TMODE (`CFG_TMODE_), 

.RESET_PWRON_N (`LX_RESET_PWRON_C1_N_)); 










`Ce0ModuleName CE0 
( 


.CLK (SYSCLK), 

.TMODE (`CFG_TMODE_), 
.SEN (`CFG_SEN_), 
.RESET_D1_R_N (`LX_RESET_D1_R_N_), 
.CFG_CEENBL (CFG_MACENABLE), 
.CEI_CEHOLD (CEI_CE0HOLD), 
.CEI_XCPN_M (CEI_XCPN_M_C0), 
.CEI_OP_S_R (CEI_CE0OP_S_R), 
.CEI_INSTM32_S_R_N (CEI_INSTM32_S_R_N), 
.CEI_AOP_E_R (CEI_CE0AOP_E_R), 
.CEI_BOP_E_R (CEI_CE0BOP_E_R), 
.CE_RES_E (MAC_RES_E), 
.CE_SEL_E_R (MAC_SEL_E_R), 
.CE_HALT_E_R_C (MAC_HALT_E_R) 
); 





`LX0_MODULE `LX0_MODULE 
( 


.SYSCLK ( SYSCLK ), 




.SYSCLKF ( SYSCLKF ), 

.SL_SLEEPSYS_C1_R ( SL_SLEEPSYS_C1_R ), 
.SL_SLEEPSYS_C2_R ( SL_SLEEPSYS_C2_R ), 
.SL_SLEEPSYS_C3_R ( SL_SLEEPSYS_C3_R ), 




.BUSCLK ( BUSCLK ), 







.BUSCLKF ( BUSCLKF ), 


.SL_SLEEPBUS_C1_BR ( SL_SLEEPBUS_C1_BR ), 
.SL_SLEEPBUS_C2_BR ( SL_SLEEPBUS_C2_BR ), 
.SL_SLEEPBUS_C3_BR ( SL_SLEEPBUS_C3_BR ), 




.JTAG_RST_N ( JTAG_RST_N ), 

.RESET_N ( ResetN ), 
.RESET_PWRON_N ( RESET_PWRON_N ), 
.EJC_ECRPRRST_R (`EJC_ECRPRRST_R_ ), 
.RESET_D1_R_N ( RESET_D1_R_N ), 
.RESET_D1_BR_N ( RESET_D1_BR_N ), 


.RESET_PWRON_C1_N ( RESET_PWRON_C1_N ), 
.RESET_PWRON_D1_LR_N ( RESET_PWRON_D1_LR_N ), 









.CFG_SLEEPENABLE (`CFG_SLEEPENABLE_ ), 


.CFG_HLENABLE ( CFG_HLENABLE ), 
.CFG_MEMSEQUENTIAL ( CFG_MEMSEQUENTIAL ), 
.CFG_MEMZEROFIRST ( CFG_MEMZEROFIRST ), 
.CFG_MEMFULLWORD ( CFG_MEMFULLWORD ), 
.CFG_LINEADDRFILTER(`CFG_LINEADDRFILTER_), 


.CFG_EJTMLOG2 (CFG_EJTMLOG2), 
.CFG_EJTBIT0M16 (CFG_EJTBIT0M16), 



.EJT_DREN_R (EJT_DREN_R), 
.EJC_DINT_R (EJC_DINT_R), 


.EJIM_BREAKHIT_S (EJIM_BREAKHIT_S), 
.EJIM_TRACEHIT_S (EJIM_TRACEHIT_S), 


.EJDM_BREAKHIT_W (EJDM_BREAKHIT_W), 
.EJDM_TRACEHIT_W (EJDM_TRACEHIT_W), 


.EJPM_BREAKHIT_R (EJPM_BREAKHIT_R), 
.EJPM_TRACEHIT_R (EJPM_TRACEHIT_R), 

.EJC_ECRPROBEEN_R (EJC_ECRPROBEEN_R), 
.EJC_DCRMINT_R (EJC_DCRMINT_R), 
.EJC_ECRPCAS_R (EJC_ECRPCAS_R), 
.EJC_DCRTM_R (EJC_DCRTM_R), 
.EJC_PCTRON_R (EJC_PCTRON_R), 



.JPT_PCST_DR (JPT_PCST_DR), 
.JPT_TPC_DR ({JPT_TPC_DR[8:2],JPT_TPC_ONE_DR}), 
.CP0_JCTRLJRST_R (CP0_JCTRLJRST_R), 
.CP0_JCTRLDM_I_R (CP0_JCTRLDM_I_R), 
.JPT_DBM2PCSTSET_P (JPT_DBM2PCSTSET_P), 



.CP0_JXCPN1STIFDMBH_M_P (CP0_JXCPN1STIFDMBH_M_P), 
.CP0_JXCPN1STIFNOTDMBH_M_P (CP0_JXCPN1STIFNOTDMBH_M_P), 
.CP0_DIBIFNOTDMBH_M_P (CP0_DIBIFNOTDMBH_M_P), 
.CP0_DBREAKCLR (CP0_DBREAKCLR), 
.CP0_DBRKSETIFDMBH (CP0_DBRKSETIFDMBH), 
.CP0_DDBXIFDMBH_M_P (CP0_DDBXIFDMBH_M_P), 
.CP0_DDBXUNCOND_M_P (CP0_DDBXUNCOND_M_P), 




.LW_ISAMPLE_S ( LW_ISAMPLE_S ), 
.LW_IADDR_S_R ( LW_IADDR_S_R ), 

.LW_DSAMPLE_W ( LW_DSAMPLE_W ), 
.LW_DWRITE_W_R ( LW_DWRITE_W_R ), 
.LW_DBYEN_W_R ( LW_DBYEN_W_R ), 
.LW_DADDR_W_R ( LW_DADDR_W_R ), 
.LW_DATA_W_R ( LW_DATA_W_R ), 





.Cond_in1 ( Cond_in1 ), 
.C1rd_data ( C1rd_data ), 

.C1rd_addr ( C1rd_addr ), 
.C1rhold ( C1rhold ), 
.C1rd_gen ( C1rd_gen ), 
.C1rd_con ( C1rd_con ), 
.C1wr_addr ( C1wr_addr ), 
.C1wr_gen ( C1wr_gen ), 
.C1wr_con ( C1wr_con ), 
.C1wr_data ( C1wr_data ), 
.C1cnt_inst ( C1cnt_inst ), 
.C1cnt_imiss ( C1cnt_imiss ), 
.C1cnt_istall ( C1cnt_istall ), 
.C1cnt_dmiss ( C1cnt_dmiss ), 
.C1cnt_dstall ( C1cnt_dstall ), 
.C1cnt_dload ( C1cnt_dload ), 
.C1cnt_dstore ( C1cnt_dstore ), 




.Cond_in2 ( Cond_in2 ), 
.C2rd_data ( C2rd_data ), 

.C2rd_addr ( C2rd_addr ), 
.C2rhold ( C2rhold ), 
.C2rd_gen ( C2rd_gen ), 
.C2rd_con ( C2rd_con ), 
.C2wr_addr ( C2wr_addr ), 
.C2wr_gen ( C2wr_gen ), 
.C2wr_con ( C2wr_con ), 
.C2wr_data ( C2wr_data ), 
.C2cnt_inst ( C2cnt_inst ), 
.C2cnt_imiss ( C2cnt_imiss ), 
.C2cnt_istall ( C2cnt_istall ), 
.C2cnt_dmiss ( C2cnt_dmiss ), 
.C2cnt_dstall ( C2cnt_dstall ), 
.C2cnt_dload ( C2cnt_dload ), 
.C2cnt_dstore ( C2cnt_dstore ), 




.Cond_in3 ( Cond_in3 ), 
.C3rd_data ( C3rd_data ), 

.C3rd_addr ( C3rd_addr ), 
.C3rhold ( C3rhold ), 
.C3rd_gen ( C3rd_gen ), 
.C3rd_con ( C3rd_con ), 
.C3wr_addr ( C3wr_addr ), 
.C3wr_gen ( C3wr_gen ), 
.C3wr_con ( C3wr_con ), 
.C3wr_data ( C3wr_data ), 
.C3cnt_inst ( C3cnt_inst ), 
.C3cnt_imiss ( C3cnt_imiss ), 
.C3cnt_istall ( C3cnt_istall ), 
.C3cnt_dmiss ( C3cnt_dmiss ), 
.C3cnt_dstall ( C3cnt_dstall ), 
.C3cnt_dload ( C3cnt_dload ), 
.C3cnt_dstore ( C3cnt_dstore ), 


.CEI_INSTM32_S_R_N ( CEI_INSTM32_S_R_N ), 
.MAC_RES_E ( `MAC_RES_E_ ), 
.CE1_RES_E ( `CE1_RES_E_ ), 
.CEI_CE0HOLD ( CEI_CE0HOLD ), 
.CEI_CE1HOLD ( CEI_CE1HOLD ), 
.CEI_XCPN_M_C0 ( CEI_XCPN_M_C0 ), 
.CEI_XCPN_M_C1 ( CEI_XCPN_M_C1 ), 
.MAC_SEL_E_R ( `MAC_SEL_E_R_ ), 
.CE1_SEL_E_R ( `CE1_SEL_E_R_ ), 
.MAC_HALT_E_R ( `MAC_HALT_E_R_ ), 
.CE1_HALT_E_R ( `CE1_HALT_E_R_ ), 
.CEI_CE1OP_S_R ( CEI_CE1OP_S_R ), 
.CEI_CE0OP_S_R ( CEI_CE0OP_S_R ), 
.CEI_CE0AOP_E_R ( CEI_CE0AOP_E_R), 
.CEI_CE0BOP_E_R ( CEI_CE0BOP_E_R), 
.CEI_CE1AOP_E_R ( CEI_CE1AOP_E_R), 
.CEI_CE1BOP_E_R ( CEI_CE1BOP_E_R), 




.EXT_SLEEPREQ_R ( EXT_SLEEPREQ_R ), 



.PBI_EJHOLD ( PBI_EJHOLD ), 
.PBI_EJJPTHOLD ( PBI_EJJPTHOLD ), 

.CBUS_HALT_W_R ( CBUS_HALT_W_R ), 
.CBUS_SWBEMPTY ( CBUS_SWBEMPTY ), 
.CBUS_SIVAL ( CBUS_SIVAL ), 
.CBUS_SDVAL ( CBUS_SDVAL ), 
.CBUS_SIDATA ( CBUS_SIDATA ), 
.CBUS_SDDATA ( CBUS_SDDATA ), 
.CBUS_DREQ ( CBUS_DREQ ), 
.CBUS_DADDR ( CBUS_DADDR ), 
.CBUS_DUC ( CBUS_DUC ), 
.CBUS_DRW ( CBUS_DRW ), 
.CBUS_DLINE ( CBUS_DLINE ), 
.CBUS_DSZ ( CBUS_DSZ ), 
.CBUS_DBE ( CBUS_DBE ), 
.CBUS_DO ( CBUS_DO ), 
.CBUS_DADDR_E1 ( CBUS_DADDR_E1 ), 
.CBUS_DDM ( CBUS_DDM ), 
.CBUS_IDM ( CBUS_IDM ), 
.CBUS_IREQ ( CBUS_IREQ ), 
.CBUS_IADDR ( CBUS_IADDR ), 
.CBUS_IUC ( CBUS_IUC ), 


.CFG_ICOFF ( CFG_ICOFF ), 
.EXT_ICREQRAM_R ( EXT_ICREQRAM_R ), 
.IC_GNTRAM_R ( IC_GNTRAM_R ), 



.IC_TAGINDEX ( IC_TAGINDEX ), 
.ICR_TAGRD0 ( ICR_TAGRD0 ), 
.IC_TAGWR0 ( IC_TAGWR0 ), 

.ICR_TAGMASK (`IC_TAG_MASK ), 

.IC_TAG0WE ( IC_TAG0WE ), 
.IC_TAG0WEN ( IC_TAG0WEN ), 
.IC_TAG0RE ( IC_TAG0RE ), 
.IC_TAG0REN ( IC_TAG0REN ), 
.IC_TAG0CS ( IC_TAG0CS ), 
.IC_TAG0CSN ( IC_TAG0CSN ), 

.IC_INSTINDEX ( IC_INSTINDEX ), 
.IC_INSTWR ( IC_INSTWR ), 
.ICR_INST0RD ( ICR_INST0RD ), 
.IC_INST0WE ( IC_INST0WE ), 
.IC_INST0WEN ( IC_INST0WEN ), 
.IC_INST0RE ( IC_INST0RE ), 
.IC_INST0REN ( IC_INST0REN ), 
.IC_INST0CS ( IC_INST0CS ), 
.IC_INST0CSN ( IC_INST0CSN ), 








.IW_VALIDINDEX ( IW_VALIDINDEX ), 

.IWR_VALIDRD ( IWR_VALIDRD ), 

.IW_VALIDWR ( IW_VALIDWR ), 
.IW_VALIDWE ( IW_VALIDWE ), 
.IW_VALIDWEN ( IW_VALIDWEN ), 
.IW_VALIDRE ( IW_VALIDRE ), 
.IW_VALIDREN ( IW_VALIDREN ), 
.IW_VALIDCS ( IW_VALIDCS ), 
.IW_VALIDCSN ( IW_VALIDCSN ), 

.IW_INSTINDEX ( IW_INSTINDEX ), 

.IWR_INSTRD ( IWR_INSTRD ), 

.IW_INSTWR ( IW_INSTWR ), 
.IW_INSTWE ( IW_INSTWE ), 
.IW_INSTWEN ( IW_INSTWEN ), 
.IW_INSTRE ( IW_INSTRE ), 
.IW_INSTREN ( IW_INSTREN ), 
.IW_INSTCS ( IW_INSTCS ), 
.IW_INSTCSN ( IW_INSTCSN ), 
.CFG_IRAMISROM ( `CFG_IRAMISROM_), 

.IWC_BASE ( CFG_IWBASE[`LM_BASE_RANGE] ), 
.IWC_RAMTOP ( CFG_IWTOP[`LM_TOP_RANGE] ), 

.EXT_IWREQRAM_R ( EXT_IWREQRAM_R ), 
.IW_GNTRAM_R ( IW_GNTRAM_R ), 



.CFG_DCOFF ( CFG_DCOFF ), 
.EXT_DCREQRAM_R ( EXT_DCREQRAM_R ), 
.DC_GNTRAM_R ( DC_GNTRAM_R ), 



.DC_TAGINDEX ( DC_TAGINDEX ), 
.DC_TAGWR ( DC_TAGWR ), 
.DC_TAGWE ( DC_TAGWE ), 
.DC_TAGWEN ( DC_TAGWEN ), 
.DC_TAGRE ( DC_TAGRE ), 
.DC_TAGREN ( DC_TAGREN ), 
.DC_TAGCS ( DC_TAGCS ), 
.DC_TAGCSN ( DC_TAGCSN ), 
.DCC_TAGMASK ( `DC_TAG_MASK ), 
.DC_DATAINDEX ( DC_DATAINDEX ), 
.DC_DATAWR ( DC_DATAWR ), 
.DC_DATAWE ( DC_DATAWE ), 
.DC_DATAWEN ( DC_DATAWEN ), 
.DC_DATARE ( DC_DATARE ), 
.DC_DATAREN ( DC_DATAREN ), 
.DC_DATACS ( DC_DATACS ), 
.DC_DATACSN ( DC_DATACSN ), 
.DCR_TAGRD ( DCR_TAGRD ), 
.DCR_DATARD ( DCR_DATARD ), 




.DW_DATAINDEX ( DW_DATAINDEX ), 

.DWR_DATARD ( DWR_DATARD ), 

.DW_DATAWR ( DW_DATAWR ), 
.DW_DATAWE ( DW_DATAWE ), 
.DW_DATAWEN ( DW_DATAWEN ), 
.DW_DATARE ( DW_DATARE ), 
.DW_DATAREN ( DW_DATAREN ), 
.DW_DATACS ( DW_DATACS ), 
.DW_DATACSN ( DW_DATACSN ), 

.DWC_BASE ( CFG_DWBASE[`LM_BASE_RANGE] ), 
.DWC_TOP ( CFG_DWTOP[`LM_TOP_RANGE] ), 

.CFG_DWDISW ( CFG_DWDISW ), 
.EXT_DWREQRAM_R ( EXT_DWREQRAM_R ), 
.DW_GNTRAM_R ( DW_GNTRAM_R ), 



.IntreqN ( IntreqN ) 

); 




lbc lbc1( 

.SYSCLK (SYSCLK), 

.BUSCLK (`LX1_BUSCLK_), 

.RESET_D1_R_N (`LX_RESET_D1_R_N_), 
.RESET_D1_LR_N (`LX_RESET_D1_BR_N_), 
.SEN (`CFG_SEN), 



.EJ_LBCUMBILICAL (EJ_LBCUMBILICAL), 
.LBC_EJUMBILICAL (LBC_EJUMBILICAL), 



.LBUS_DATA (LDataI), 
.LBUS_TRDY (LTrdy), 
.LBUS_IRDY (LIrdyI), 
.LBUS_FRAME (LFrameI), 
.LBUS_SEL (LSel), 
.LBUS_ABORT (LAbort), 
.LBUS_GNT (LGnt), 
.CFG_LBCWBDISABLE (CFG_LBCWBDISABLE), 
.CFG_MEMSEQUENTIAL (CFG_MEMSEQUENTIAL), 
.CFG_LBCSYNCMODE (CFG_LBCSYNCMODE), 


.LBC_ADDR (LAddrO), 
.LBC_DATA (LDataO), 
.LBC_IRDY (LIrdy), 
.LBC_FRAME (LFrame), 
.LBC_CMD (LCmd), 
.LBC_UC (LUc), 
.LBC_ID (LId), 
.LBC_REQ (LReq), 
.LBC_COE (LCoe), 
.LBC_TOE (LToe), 
.LBC_XOE (LXoe), 
.LBC_DOE (LDoe), 


.CBUS_DREQ (CBUS_DREQ), 
.CBUS_DADDR (CBUS_DADDR[31:0]), 
.CBUS_DUC (CBUS_DUC), 
.CBUS_DRW (CBUS_DRW), 
.CBUS_DSZ (CBUS_DSZ[1:0]), 
.CBUS_DLINE (CBUS_DLINE), 
.CBUS_DO (CBUS_DO[31:0]), 
.CBUS_DADDR_E1 (CBUS_DADDR_E1[31:0]), 
.CBUS_DDM (CBUS_DDM), 
.CBUS_IDM (CBUS_IDM), 
.CBUS_IREQ (CBUS_IREQ), 
.CBUS_IADDR (CBUS_IADDR[31:0]), 
.CBUS_IUC (CBUS_IUC), 


.CBUS_HALT_W_R (CBUS_HALT_W_R), 
.CBUS_SWBEMPTY (CBUS_SWBEMPTY), 
.CBUS_SIVAL (CBUS_SIVAL), 
.CBUS_SDVAL (CBUS_SDVAL), 
.CBUS_SIDATA (CBUS_SIDATA), 
.CBUS_SDDATA (CBUS_SDDATA) 
); 











endmodule 

