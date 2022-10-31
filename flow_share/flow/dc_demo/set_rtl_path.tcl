#!/usr/bin/tclsh
#------------------------------------------------------------------------------------------
# set_rtl_path.tcl
# RTL path setup for Synopsys Reference Methodologies
# Author:    Jinwook Jung
# Last modified: 2018/08/01
#------------------------------------------------------------------------------------------
if     { [string equal $design "ac97_ctrl"] } { set rtl_path "${bench_root}/ac97_ctrl";  set design_name "ac97_top"; set clock_name "clk_i"; set file_format "verilog" } \
elseif { [string equal $design "aes_core"] }  { set rtl_path "${bench_root}/aes_core";   set design_name "aes_cipher_top"; set clock_name "clk"; set file_format "verilog" } \
elseif { [string equal $design "des"] }       { set rtl_path "${bench_root}/des";        set design_name "des3"; set clock_name "clk"; set file_format "verilog" } \
elseif { [string equal $design "ethernet"] }  { set rtl_path "${bench_root}/ethernet";   set design_name "eth_top"; set clock_name "wb_clk_i"; set file_format "verilog" }  \
elseif { [string equal $design "fpu"] }       { set rtl_path "${bench_root}/fpu";        set design_name "fpu"; set clock_name "clk"; set file_format "verilog" } \
elseif { [string equal $design "i2c"] }       { set rtl_path "${bench_root}/i2c";        set design_name "i2c_master_top"; set clock_name "wb_clk_i"; set file_format "verilog" } \
elseif { [string equal $design "mem_ctrl"] }  { set rtl_path "${bench_root}/mem_ctrl";   set design_name "mc_top"; set clock_name "clk_i"; set file_format "verilog" } \
elseif { [string equal $design "spi"] }       { set rtl_path "${bench_root}/spi";        set design_name "spi_top"; set clock_name "wb_clk_i"; set file_format "verilog" } \
elseif { [string equal $design "simple_spi"] } { set rtl_path "${bench_root}/simple_spi"; set design_name "simple_spi_top"; set clock_name "clk_i"; set file_format "verilog" } \
elseif { [string equal $design "pci"] }       { set rtl_path "${bench_root}/pci";        set design_name "pci_bridge32"; set clock_name "wb_clk_i"; set file_format "verilog" } \
elseif { [string equal $design "sasc"] }      { set rtl_path "${bench_root}/sasc";       set design_name "sasc_top"; set clock_name "clk"; set file_format "verilog" } \
elseif { [string equal $design "ss_pcm"] }    { set rtl_path "${bench_root}/ss_pcm";     set design_name "pcm_slv_top"; set clock_name "clk"; set file_format "verilog" } \
elseif { [string equal $design "systemcaes"]} { set rtl_path "${bench_root}/systemcaes"; set design_name "aes"; set clock_name "clk"; set file_format "verilog" } \
elseif { [string equal $design "systemcdes"]} { set rtl_path "${bench_root}/systemcdes"; set design_name "des"; set clock_name "clk"; set file_format "verilog" } \
elseif { [string equal $design "tv80"] }      { set rtl_path "${bench_root}/tv80";       set design_name "tv80s"; set clock_name "clk"; set file_format "verilog" } \
elseif { [string equal $design "usb_funct"] } { set rtl_path "${bench_root}/usb_funct";  set design_name "usbf_top"; set clock_name "clk_i"; set file_format "verilog" } \
elseif { [string equal $design "usb_phy"] }   { set rtl_path "${bench_root}/usb_phy";    set design_name "usb_phy"; set clock_name "clk"; set file_format "verilog" } \
elseif { [string equal $design "vga_lcd"] }   { set rtl_path "${bench_root}/vga_lcd";    set design_name "vga_enh_top"; set clock_name "wb_clk_i"; set file_format "verilog" } \
elseif { [string equal $design "wb_conmax"] } { set rtl_path "${bench_root}/wb_conmax";  set design_name "wb_conmax_top"; set clock_name "clk_i"; set file_format "verilog" } \
elseif { [string equal $design "wb_dma"] }    { set rtl_path "${bench_root}/wb_dma";     set design_name "wb_dma_top"; set clock_name "clk_i"; set file_format "verilog" } \
elseif { [string equal $design "b14"] }       { set rtl_path "${bench_root}/b14";        set design_name "b14"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b14_1"] }     { set rtl_path "${bench_root}/b14_1";      set design_name "b14_1"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b15"] }       { set rtl_path "${bench_root}/b15";        set design_name "b15"; set clock_name "CLOCK"; set file_format "vhdl" } \
elseif { [string equal $design "b15_1"] }     { set rtl_path "${bench_root}/b15_1";      set design_name "b15_1"; set clock_name "CLOCK"; set file_format "vhdl" } \
elseif { [string equal $design "b17"] }       { set rtl_path "${bench_root}/b17";        set design_name "b17"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b17_1"] }     { set rtl_path "${bench_root}/b17_1";      set design_name "b17_1"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b18"] }       { set rtl_path "${bench_root}/b18";        set design_name "b18"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b18_1"] }     { set rtl_path "${bench_root}/b18_1";      set design_name "b18_1"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b19"] }       { set rtl_path "${bench_root}/b19";        set design_name "b19"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b19_1"] }     { set rtl_path "${bench_root}/b19_1";      set design_name "b19_1"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b20"] }       { set rtl_path "${bench_root}/b20";        set design_name "b20"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b20_1"] }     { set rtl_path "${bench_root}/b20_1";      set design_name "b20_1"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b21"] }       { set rtl_path "${bench_root}/b21";        set design_name "b21"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b21_1"] }     { set rtl_path "${bench_root}/b21_1";      set design_name "b21_1"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b22"] }       { set rtl_path "${bench_root}/b22";        set design_name "b22"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b22_1"] }     { set rtl_path "${bench_root}/b22_1";      set design_name "b22_1"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "b30"] }       { set rtl_path "${bench_root}/b30";        set design_name "b30"; set clock_name "clock"; set file_format "vhdl" } \
elseif { [string equal $design "leon2"] }     { set rtl_path "${bench_root}/leon2";      set design_name "leon"; set clock_name "clk"; set file_format "vhdl" } \
elseif { [string equal $design "leon3-avnet-3s1500"] }  { set rtl_path "${bench_root}/leon3-avnet-3s1500";   set design_name "leon3mp"; set clock_name "clk_66mhz"; set file_format "vhdl" } \
elseif { [string equal $design "leon3mp"] }   { set rtl_path "${bench_root}/leon3mp";    set design_name "leon3mp"; set clock_name "clk"; set file_format "vhdl" } \
elseif { [string equal $design "netcard"] }   { set rtl_path "${bench_root}/netcard";    set design_name "netcard"; set clock_name "clk"; set file_format "vhdl" } \
elseif { [string equal $design "DMA"] }       { set rtl_path "${bench_root}/DMA";        set design_name "dma_top"; set clock_name "HCLK"; set file_format "verilog" } \
elseif { [string equal $design "DSP"] }       { set rtl_path "${bench_root}/DSP";        set design_name "DSP_CORE";   set clock_name "T_CLKI_PLL"; set file_format "verilog" } \
elseif { [string equal $design "RISC"] }      { set rtl_path "${bench_root}/RISC";       set design_name "frisc";    set clock_name "SYSCLK"; set file_format "verilog" } \
elseif { [string equal $design "s1196"] }     { set rtl_path "${bench_root}/s1196";      set design_name "s1196_bench";    set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s1238"] }     { set rtl_path "${bench_root}/s1238";      set design_name "s1238_bench";    set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s13207"] }    { set rtl_path "${bench_root}/s13207";     set design_name "s13207_bench";   set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s1423"] }     { set rtl_path "${bench_root}/s1423";      set design_name "s1423_bench";    set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s1488"] }     { set rtl_path "${bench_root}/s1488";      set design_name "s1488_bench";    set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s15850"] }    { set rtl_path "${bench_root}/s15850";     set design_name "s15850_bench";   set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s208_1"] }    { set rtl_path "${bench_root}/s208_1";     set design_name "s208_1_bench";   set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s27"] }       { set rtl_path "${bench_root}/s27";        set design_name "s27_bench";      set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s298"] }      { set rtl_path "${bench_root}/s298";       set design_name "s298_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s344"] }      { set rtl_path "${bench_root}/s344";       set design_name "s344_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s349"] }      { set rtl_path "${bench_root}/s349";       set design_name "s349_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s35932"] }    { set rtl_path "${bench_root}/s35932";     set design_name "s35932_bench";   set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s382"] }      { set rtl_path "${bench_root}/s382";       set design_name "s382_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s38417"] }    { set rtl_path "${bench_root}/s38417";     set design_name "s38417_bench";   set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s38584"] }    { set rtl_path "${bench_root}/s38584";     set design_name "s38584_bench";   set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s386"] }      { set rtl_path "${bench_root}/s386";       set design_name "s386_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s400"] }      { set rtl_path "${bench_root}/s400";       set design_name "s400_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s420_1"] }    { set rtl_path "${bench_root}/s420_1";     set design_name "s420_1_bench";   set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s444"] }      { set rtl_path "${bench_root}/s444";       set design_name "s444_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s510"] }      { set rtl_path "${bench_root}/s510";       set design_name "s510_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s526n"] }     { set rtl_path "${bench_root}/s526n";      set design_name "s526n_bench";    set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s526"] }      { set rtl_path "${bench_root}/s526";       set design_name "s526_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s5378"] }     { set rtl_path "${bench_root}/s5378";      set design_name "s5378_bench";    set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s641"] }      { set rtl_path "${bench_root}/s641";       set design_name "s641_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s713"] }      { set rtl_path "${bench_root}/s713";       set design_name "s713_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s820"] }      { set rtl_path "${bench_root}/s820";       set design_name "s820_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s832"] }      { set rtl_path "${bench_root}/s832";       set design_name "s832_bench";     set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s838_1"] }    { set rtl_path "${bench_root}/s838_1";     set design_name "s838_1_bench";   set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s9234_1"] }   { set rtl_path "${bench_root}/s9234_1";    set design_name "s9234_1_bench";  set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "s1494"] }     { set rtl_path "${bench_root}/s1494";      set design_name "s1494_bench";    set clock_name "blif_clk_net"; set file_format "verilog" } \
elseif { [string equal $design "new_verilog"] }     { set rtl_path "${bench_root}/new_verilog";      set design_name "abc";    set clock_name "clk"; set file_format "verilog" }\
elseif { [string equal $design "Dffgate7"] }     { set rtl_path "${bench_root}/Dffgate7";      set design_name "top_module";    set clock_name "clk"; set file_format "verilog" }\
elseif { [string equal $design "Dffgate"] }     { set rtl_path "${bench_root}/Dffgate";      set design_name "top_module";    set clock_name "clk"; set file_format "verilog" }\
elseif { [string equal $design "comlog"] }     { set rtl_path "${bench_root}/comlog";      set design_name "combo";    set clock_name "clk"; set file_format "verilog" }\
elseif { [string equal $design "s344"] }     { set rtl_path "${bench_root}/s344";      set design_name "s344_bench";    set clock_name "clk"; set file_format "verilog" }\
elseif { [string equal $design "s349"] }     { set rtl_path "${bench_root}/s349";      set design_name "s349_bench";    set clock_name "clk"; set file_format "verilog" }

