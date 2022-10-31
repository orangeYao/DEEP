/*******************************************************************************

    (C) Copyright 2002,2003 Faraday Technology Corp. All Rights Reserved.
    This source code is an unpublished work belongs to Faraday Technology
    Corp.  It is considered a trade secret and is not to be divulged or
    used by parties who have not received written authorization from
    Faraday Technology Corp.

 |-----------------------------------------------------------------------------|
                Verilog Behavior Simulation Model

                   Synchronous 2-Port SRAM

                Module Name      : SW10201A
                Words            : 32
                Bits             : 26
                Byte-Write       : 1
                Output Loading   : 0.1
                
 |-----------------------------------------------------------------------------|

   Notice on usage: Fixed delay or timing data are given in this model.
                    It supports SDF back-annotation, please generate SDF file
                    by EDA tools to get the accurate timing.

 |-----------------------------------------------------------------------------|

                Library          : FS90A_B
                Memaker          : v4.5.1
                Compiler         : swmemgen 1.0
                Template revison : 1.1
                Date             : Tue Jul 29 09:57:06 CST 2003
                Editor           : Jony

 *******************************************************************************/



module SW10201A (A0,A1,A2,A3,A4,B0,B1,B2,B3,
                 B4,DO0,DO1,DO2,DO3,DO4,DO5,DO6,DO7,DO8,
                 DO9,DO10,DO11,DO12,DO13,DO14,DO15,DO16,DO17,DO18,
                 DO19,DO20,DO21,DO22,DO23,DO24,DO25,DI0,DI1,DI2,
                 DI3,DI4,DI5,DI6,DI7,DI8,DI9,DI10,DI11,DI12,
                 DI13,DI14,DI15,DI16,DI17,DI18,DI19,DI20,DI21,DI22,
                 DI23,DI24,DI25,CKA,CKB,WEB,CSA,CSB,OE);

  output     DO0,DO1,DO2,DO3,DO4,DO5,DO6,DO7,DO8,
             DO9,DO10,DO11,DO12,DO13,DO14,DO15,DO16,DO17,DO18,
             DO19,DO20,DO21,DO22,DO23,DO24,DO25;
  input      DI0,DI1,DI2,DI3,DI4,DI5,DI6,DI7,DI8,
             DI9,DI10,DI11,DI12,DI13,DI14,DI15,DI16,DI17,DI18,
             DI19,DI20,DI21,DI22,DI23,DI24,DI25;
  input      A0,A1,A2,A3,A4;
  input      B0,B1,B2,B3,B4;
  input      OE;                                      
  input      WEB;                                     
  input      CKA;                                     
  input      CKB;                                     
  input      CSA;                                     
  input      CSB;                                     
endmodule
