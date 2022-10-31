

set top_module    "sasc_top"
restoreDesign sasc/pnr_save/route2.enc.dat $top_module
restoreDesign sasc/pnr_save/route.enc.dat $top_module

####
set top_module    "des"
restoreDesign systemcdes/pnr_save/route2.enc.dat $top_module
restoreDesign systemcdes/pnr_save/route.enc.dat $top_module


####
#restoreDesign floorplan.enc.dat ss_pcm

