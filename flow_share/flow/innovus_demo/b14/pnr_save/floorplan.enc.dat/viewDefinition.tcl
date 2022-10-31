if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name default\
   -timing\
    [list ${::IMEX::libVar}/mmmc/NangateOpenCellLibrary_typical_ccs.lib]
create_rc_corner -name default\
   -cap_table ${::IMEX::libVar}/mmmc/NCSU_FreePDK_45nm.capTbl\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name default\
   -library_set default\
   -opcond_library PVT_0P7V_25C\
   -rc_corner default
create_constraint_mode -name default\
   -sdc_files\
    [list /dev/null]
create_analysis_view -name default -constraint_mode default -delay_corner default
set_analysis_view -setup [list default] -hold [list default]
