##############################################################################
# 1. set synthesize environment
###############################################################################
source ../script/syn_set.tcl
source ../script/env.tcl

###############################################################################
# 2. Read design
###############################################################################
source ../script/read_design.scr > ../rep/read_design.rep

###############################################################################
# 3. Define variable for input/output delay constraints
###############################################################################
source ../script/ahb_timing.tcl

###############################################################################
# 4. Set current design
###############################################################################
current_design dma_top
check_design > ../rep/check_design.rep

remove_license HDL-Compiler

###############################################################################
# 5. Set operation condition
###############################################################################
current_design dma_top
#set_operating_conditions -library $lib_name $op_cond

set_wire_load_mode enclosed

###############################################################################
# 6. Set wire load model for each module                              
###############################################################################
#set_wire_load_model -library $lib_name -name G30K [find design *]
current_design dma_top
#set_wire_load_model -library $lib_name -name $wlm

###############################################################################
# 8. Create clock
###############################################################################
create_clock -name hclk -period $Tclk -waveform "0 [expr $Tclk / 2.0]" \
             [find port HCLK]

###############################################################################
# 9. Set clock uncertainy
###############################################################################
set_clock_uncertainty 0.3 [find port HCLK]

###############################################################################
# 10. Set input delay
###############################################################################
# for AHB0 master
set_output_delay -max [expr $Tclk - $Tovadr] -clock hclk [find port h0addr*]
set_output_delay -min $Tohadr -clock hclk [find port h0addr*]

set_output_delay -max [expr $Tclk - $Tovtr] -clock hclk [find port h0trans*]
set_output_delay -min $Tohtr -clock hclk [find port h0trans*]

set_output_delay -max [expr $Tclk - $Tovctl] -clock hclk [find port h0write*]
set_output_delay -min $Tohctl -clock hclk [find port h0write*]

set_output_delay -max [expr $Tclk - $Tovctl] -clock hclk [find port h0size*]
set_output_delay -min $Tohctl -clock hclk [find port h0size*]

set_output_delay -max [expr $Tclk - $Tovprt] -clock hclk [find port h0prot*]
set_output_delay -min $Tohprt -clock hclk [find port h0prot*]

set_output_delay -max [expr $Tclk - $Tovlck] -clock hclk [find port h0lock*]
set_output_delay -min $Tohlck -clock hclk [find port h0lock*]

set_output_delay -max [expr $Tclk - $Tovctl] -clock hclk [find port h0burst*]
set_output_delay -min $Tohctl -clock hclk [find port h0burst*]

set_output_delay -max [expr $Tclk - $Tovwd] -clock hclk [find port h0wdata*]
set_output_delay -min $Tohwd -clock hclk [find port h0wdata*]

set_input_delay -max [expr $Tclk - $Tisrd] -clock hclk [find port h0rdata*]
set_input_delay -min $Tihrd -clock hclk [find port h0rdata*]

set_input_delay -max [expr $Tclk - $Tisrdy] -clock hclk [find port h0readyin]
set_input_delay -min $Tihrdy -clock hclk [find port h0readyin]

set_input_delay -max [expr $Tclk - $Tisrsp] -clock hclk [find port h0resp*]
set_input_delay -min $Tihrsp -clock hclk [find port h0resp*]

# for AHB1 master
set find_port [sizeof_collection [find port h1addr*]]
if { $find_port != 0} {
set_output_delay -max [expr $Tclk - $Tovadr] -clock hclk [find port h1addr*] 
set_output_delay -min $Tohadr -clock hclk [find port h1addr*] 
}

set find_port [sizeof_collection [find port h1trans*]]
if { $find_port != 0} {
set_output_delay -max [expr $Tclk - $Tovtr] -clock hclk [find port h1trans*]
set_output_delay -min $Tohtr -clock hclk [find port h1trans*]
}

set find_port [sizeof_collection [find port h1write*]]
if { $find_port != 0} {
set_output_delay -max [expr $Tclk - $Tovctl] -clock hclk [find port h1write*]
set_output_delay -min $Tohctl -clock hclk [find port h1write*]
}

set find_port [sizeof_collection [find port h1size*]]
if { $find_port != 0} {
set_output_delay -max [expr $Tclk - $Tovctl] -clock hclk [find port h1size*]
set_output_delay -min $Tohctl -clock hclk [find port h1size*]
}

set find_port [sizeof_collection [find port h1prot*]]
if { $find_port != 0} {
set_output_delay -max [expr $Tclk - $Tovprt] -clock hclk [find port h1prot*]
set_output_delay -min $Tohprt -clock hclk [find port h1prot*]
}

set find_port [sizeof_collection [find port h1lock*]]
if { $find_port != 0} {
set_output_delay -max [expr $Tclk - $Tovlck] -clock hclk [find port h1lock*]
set_output_delay -min $Tohlck -clock hclk [find port h1lock*]
}

set find_port [sizeof_collection [find port h1burst*]]
if { $find_port != 0} {
set_output_delay -max [expr $Tclk - $Tovctl] -clock hclk [find port h1burst*]
set_output_delay -min $Tohctl -clock hclk [find port h1burst*]
}

set find_port [sizeof_collection [find port h1wdata*]]
if { $find_port != 0} {
set_output_delay -max [expr $Tclk - $Tovwd] -clock hclk [find port h1wdata*]
set_output_delay -min $Tohwd -clock hclk [find port h1wdata*]
}

set find_port [sizeof_collection [find port h1rdata*]]
if { $find_port != 0} {
set_input_delay -max [expr $Tclk - $Tisrd] -clock hclk [find port h1rdata*]
set_input_delay -min $Tihrd -clock hclk [find port h1rdata*]
}

set find_port [sizeof_collection [find port h1readyin]]
if { $find_port != 0} {
#set_output_delay -max [expr $Tclk - $Tovrdy] -clock hclk [find port h1readyin]
set_output_delay -max [expr $Tclk * 0.5] -clock hclk [find port h1readyin]
set_output_delay -min $Tohrdy -clock hclk [find port h1readyin]
}

set find_port [sizeof_collection [find port h1resp*]]
if { $find_port != 0} {
set_input_delay -max [expr $Tclk - $Tisrsp] -clock hclk [find port h1resp*]
set_input_delay -min $Tihrsp -clock hclk [find port h1resp*]
}

set find_port [sizeof_collection [find port h1sel_*]]
if { $find_port != 0} {
#set_output_delay -max [expr $Tclk - $Tovsel] -clock hclk [find port h1sel_*]
set_output_delay -max [expr $Tclk * 0.7] -clock hclk [find port h1sel_*]
set_output_delay -min $Tohsel -clock hclk [find port h1sel_*]
}

#AHB1 slave
set find_port [sizeof_collection [find port h1rdt*_*]]
if { $find_port != 0} {
set_input_delay -max [expr $Tclk - $Tisrd] -clock hclk [find port h1rdt*_*]
set_input_delay -min $Tihrd -clock hclk [find port h1rdt*_*]
}

set find_port [sizeof_collection [find port h1rp*_*]]
if { $find_port != 0} {
set_input_delay -max [expr $Tclk - $Tisrsp] -clock hclk [find port h1rp*_*]
set_input_delay -min $Tihrsp -clock hclk [find port h1rp*_*]
}

set find_port [sizeof_collection [find port h1rdy*_*]]
if { $find_port != 0} {
#set_input_delay -max [expr $Tclk - $Tisrdy] -clock hclk [find port h1rdy*_*]
set_input_delay -max [expr $Tclk * 0.2] -clock hclk [find port h1rdy*_*]
set_input_delay -min $Tihrdy -clock hclk [find port h1rdy*_*]
}

# for AHB0 slave
set_input_delay -max [expr $Tclk - $Tisa] -clock hclk [find port haddr*]
set_input_delay -min $Tiha -clock hclk [find port haddr*]

set_input_delay -max [expr $Tclk - $Tisctl] -clock hclk [find port hwrite*]
set_input_delay -min $Tihctl -clock hclk [find port hwrite*]

set_input_delay -max [expr $Tclk - $Tisctl] -clock hclk [find port hsize*]
set_input_delay -min $Tihctl -clock hclk [find port hsize*]

set_input_delay -max [expr $Tclk - $Tisctl] -clock hclk [find port hburst*]
set_input_delay -min $Tihctl -clock hclk [find port hburst*]

set_input_delay -max [expr $Tclk - $Tistr] -clock hclk [find port htrans*]
set_input_delay -min $Tihtr -clock hclk [find port htrans*]

set_input_delay -max [expr $Tclk - $Tispr] -clock hclk [find port hprot*]
set_input_delay -min $Tihpr -clock hclk [find port hprot*]

set_input_delay -max [expr $Tclk - $Tiswd] -clock hclk [find port hwdata*]
set_input_delay -min $Tihwd -clock hclk [find port hwdata*]

set_input_delay -max [expr $Tclk - $Tisrdy] -clock hclk [find port hreadyin]
set_input_delay -min $Tihrdy -clock hclk [find port hreadyin]

set_input_delay -max [expr $Tclk - $Tissel] -clock hclk [find port hsel_reg]
set_input_delay -min $Tihsel -clock hclk [find port hsel_reg]

set_output_delay -max [expr $Tclk - $Tovrd] -clock hclk [find port hrdata_*]
set_output_delay -min $Tohrd -clock hclk [find port hrdata_*]

set_output_delay -max [expr $Tclk - $Tovrdy] -clock hclk [find port hreadyout_*]
set_output_delay -min $Tohrdy -clock hclk [find port hreadyout_*]

set_output_delay -max [expr $Tclk - $Tovrsp] -clock hclk [find port hresp_*]
set_output_delay -min $Tohrsp -clock hclk [find port hresp_*]

set find_port [sizeof_collection [find port hsel_br]]
if { $find_port != 0} {
set_input_delay -max [expr $Tclk - $Tissel] -clock hclk [find port hsel_br]
set_input_delay -min $Tihsel -clock hclk [find port hsel_br]
}

set_output_delay -max [expr $Tclk - $Tovreq] -clock hclk [find port h*req]
set_output_delay -min $Tohreq -clock hclk [find port h*req]

set_input_delay -max [expr $Tclk - $Tisgnt] -clock hclk [find port h*grant]
set_input_delay -min $Tihgnt -clock hclk [find port h*grant]

set_output_delay -max [expr $Tclk - $Tovdmao] -clock hclk [find port dmaint*]
set_output_delay -min $Tohdmao -clock hclk [find port dmaint*]

set_input_delay -max [expr $Tclk - $Tisdmai] -clock hclk [find port dma_req*]
set_input_delay -min $Tihdmai -clock hclk [find port dma_req*]

set_output_delay -max [expr $Tclk - $Tovdmao] -clock hclk [find port dma_ack*]
set_output_delay -min $Tohdmao -clock hclk [find port dma_ack*]

set_output_delay -max [expr $Tclk - $Tovdmao] -clock hclk [find port dma_tc*]
set_output_delay -min $Tohdmao -clock hclk [find port dma_tc*]

###############################################################################
# 13. Set cell max fanout and driving strength for all input pins
###############################################################################
# set driving strength for all input pins 
#set_driving_cell -library $lib_name -lib_cell BUF4 -pin "O" [all_inputs]

# set cell max fanout
# set_max_fanout 8 dma_top
# set_max_transition 0.5 dma_top

###############################################################################
# 14. Set driving strength for clock and reset
###############################################################################
set_drive 0 [find port HCLK]
set_drive 0 [find port HRSTn]

###############################################################################
# 15. Set don't touch for clock and reset
###############################################################################
set_dont_touch HCLK
set_dont_touch HRSTn

###############################################################################
# 16. Set max area
###############################################################################
set_max_area 0

###############################################################################
# 17. Set don't use
###############################################################################
#set_dont_use [find cell $lib_name/DEL*]

###############################################################################
# 18. Set output load
###############################################################################
#set_load [expr [load_of $lib_name/HDFF/D] * 5] [all_outputs]

set_fix_multiple_port_nets -all -buffer_constants

###############################################################################
# 19. Compile optimization
###############################################################################
#use more powerful design compiler
get_license DesignWare-Foundation

compile -map_effort medium > ../rep/compile.rep

#force design compiler optimize all critical path
set_critical_range 0.5 dma_top

#based on the previous compiler database, compile again
compile -map_effort high -incremental_mapping > ../rep/compile_inc.rep

###############################################################################
# 20. Change name
###############################################################################
change_names -rules ftc_core_rule -hierarchy > ../rep/change_name.rep
change_names -rules ftc_top_rule             >> ../rep/change_name.rep

###############################################################################
# 21. Write db file
###############################################################################
#write -f db -hierarchy -output ../db/dma_top.db
write -f verilog -h -o ../../netlist/dma_top.v

###############################################################################
# 22. Write report, violation
###############################################################################
report_design  > ../rep/fdma.rpt
report_area  >> ../rep/fdma.rpt
report_timing >> ../rep/fdma.rpt
report_timing -max_paths 50 >> ../rep/fdma.rpt
report_constraint -all_violators -verbose > ../rep/fdma.violate


exit

