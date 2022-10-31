
# requried by RTL_PATH
#set bench_root $env(RTL_DIR)

# A dummy path
set bench_root "" 
set design $env(MY_DESIGN)

# set design_name
source $env(RTL_PATH) 

set DC_DIR $env(DC_DIR)
set TECH_DIR $env(TECH_DIR)

puts "${DC_DIR}"
puts "${TECH_DIR}"
setDesignMode -process 45

#-------------------------------------------------------------------------------
# Setting Design name and effort level for various stages
#-------------------------------------------------------------------------------
set startTime [clock seconds]
set top_module    ${design_name}   ;# Top design name
set DC_VERILOG    "${DC_DIR}/${design}/results/${top_module}.mapped.v"
set DC_SDC        "${DC_DIR}/${design}/results/${top_module}.mapped.sdc"

# set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set _OUTPUTS_PATH ./pnr_out            ;# Setting directory name for output
set _OUTPUTS_SAVE ./pnr_save            ;# Setting directory name for output
set _REPORTS_PATH ./pnr_reports        ;# Setting directory name for reports
set _LOG_PATH     ./pnr_logs           ;# Setting directory name for logs

setDesignMode -process 45
# Floorplan parameters
set ASPECT_RATIO 1
set TARGET_UTIL 0.5
#set TARGET_UTIL 0.3
#set TARGET_UTIL 0.2

#-------------------------------------------------------------------------------
# Creating the directory for logs, reports and outputs 
#-------------------------------------------------------------------------------
if {![file exists ${_LOG_PATH}]} {
    file delete -force ${_LOG_PATH}
}
if {![file exists ${_OUTPUTS_PATH}]} {
    file delete -force ${_OUTPUTS_PATH}
}
if {![file exists ${_REPORTS_PATH}]} {
    file delete -force ${_REPORTS_PATH}
}

puts "Creating directories: ${_LOG_PATH}, ${_OUTPUTS_PATH}, ${_REPORTS_PATH}"
file mkdir ${_LOG_PATH}
file mkdir ${_OUTPUTS_PATH}
file mkdir ${_OUTPUTS_SAVE}
file mkdir ${_REPORTS_PATH}


#-------------------------------------------------------------------------------
# Import the design
#-------------------------------------------------------------------------------
source ${TECH_DIR}/tech.tcl
set target_library $all_libs
create_library_set -name default -timing $target_library
#create_rc_corner -name default -qx_tech_file $qx_tech_file
create_rc_corner -name default -cap_table $cap_tbl_file
create_delay_corner -name default -library_set default -rc_corner default -opcond_library PVT_0P7V_25C
create_constraint_mode -name default -sdc_files ${DC_SDC}
create_analysis_view -name default -constraint_mode default -delay_corner default 

set init_lef_file $lef_files
set init_verilog ${DC_VERILOG}
set init_design_settop 0

source ../pnr.globals
init_design -setup default -hold default
source ${TECH_DIR}/set_dont_use.tcl

puts "YaoLog: The Loading end time is [expr [clock seconds] - $startTime] sec"

#-------------------------------------------------------------------------------
# Planning the design
#-------------------------------------------------------------------------------
set startTime [clock seconds]

clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -module {}
globalNetConnect VSS -type pgpin -pin VSS -inst * -module {}
globalNetConnect VDD -type tiehi -pin VDD -inst * -module {}
globalNetConnect VSS -type tielo -pin VSS -inst * -module {}

#getIoFlowFlag
setIoFlowFlag 1

floorPlan -site FreePDK45_38x28_10R_NP_162NW_34O -r ${ASPECT_RATIO} ${TARGET_UTIL}
changeFloorplan -coreToBottom 1.008

###########

pinAlignment -newLayer M6 \
             -pinNames [get_attribute [get_ports -filter "is_clock_used_as_clock==false"] full_name] \
             -ptnInst ${top_module} \
             -refObj {} \
             -legalizePin
pinAlignment -newLayer M6 \
             -pinNames [get_attribute [get_ports -filter "is_clock_used_as_clock==true"]  full_name] \
             -ptnInst ${top_module} \
             -refObj {} \
             -legalizePin

# Input pins are located on the left side of the die
editPin -fixOverlap 1 -spreadDirection clockwise -layer 6 -spreadType side -side LEFT \
        -pin [get_attribute [get_ports -filter "is_clock_used_as_clock==false && direction==in"] full_name]

# Output pins are located on the right side of the die
editPin -fixOverlap 1 -spreadDirection clockwise -layer 6 -spreadType side -side RIGHT \
        -pin [get_attribute [get_ports -filter "is_clock_used_as_clock==false && direction==out"] full_name]

# Clock pins are located on top of the die
editPin -fixOverlap 1 -spreadDirection clockwise -layer 5 -spreadType CENTER -side TOP \
        -pin [get_attribute [get_ports -filter "is_clock_used_as_clock==true"] full_name] \
        -use CLOCK

###########

#setAddStripeMode -use_exact_spacing 1
setAddStripeMode -use_exact_spacing 1 -extend_to_closest_target area_boundary -extend_to_first_ring 1

#addRing -skip_via_on_wire_shape Noshape -use_wire_group_bits 2 -use_interleaving_wire_group 1 -skip_via_on_pin Standardcell -use_wire_group 1 -type core_rings -jog_distance 0.095 -threshold 0.095 -nets {VDD VSS} -follow core -layer {bottom metal7 top metal7 right metal8 left metal8} -width 3 -spacing 2 -offset 0.095
addRing -skip_via_on_wire_shape Noshape -use_wire_group_bits 2 -use_interleaving_wire_group 1 -skip_via_on_pin Standardcell -use_wire_group 1 -type core_rings -jog_distance 0.095 -threshold 0.095 -nets {VDD VSS} -follow io -layer {bottom metal7 top metal7 right metal8 left metal8} -width 3 -spacing 2 -offset 0.095

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit metal9 -max_same_layer_jog_length 1.6 -padcore_ring_bottom_layer_limit metal3 -number_of_sets 5 -split_vias 1 -skip_via_on_pin Standardcell -same_sized_stack_vias 1 -stacked_via_top_layer metal9 -padcore_ring_top_layer_limit metal3 -spacing 2 -xleft_offset 20 -switch_layer_over_obs 1 -xright_offset 20 -merge_stripes_value 0.095 -layer metal7 -block_ring_bottom_layer_limit metal3 -width 1 -nets {VDD} -stacked_via_bottom_layer metal1 -break_stripes_at_block_rings 1

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit metal9 -max_same_layer_jog_length 1.6 -padcore_ring_bottom_layer_limit metal3 -number_of_sets 5 -ybottom_offset 20 -split_vias 1 -skip_via_on_pin Standardcell -same_sized_stack_vias 1 -stacked_via_top_layer metal9 -padcore_ring_top_layer_limit metal9 -spacing 2 -switch_layer_over_obs 1 -merge_stripes_value 0.095 -direction horizontal -layer metal8 -block_ring_bottom_layer_limit metal3 -ytop_offset 20 -width 1 -nets {VSS} -stacked_via_bottom_layer metal1 -break_stripes_at_block_rings 1

sroute -connect { corePin } -layerChangeRange { metal1 metal10 } -blockPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -allowJogging 1 -crossoverViaLayerRange { metal1 metal10 } -nets { VDD VSS } -allowLayerChange 1 -targetViaLayerRange { metal1 metal10 }

setEndCapMode -reset
setEndCapMode -boundary_tap false

puts "YaoLog: The floorplan end time is [expr [clock seconds] - $startTime] sec"

checkFPlan > ${_REPORTS_PATH}/init.check.rpt
defOut ${_OUTPUTS_PATH}/init.def
saveDesign ${_OUTPUTS_SAVE}/floorplan.enc
summaryReport -outfile ${_REPORTS_PATH}/floorplan_summary.rpt

#-------------------------------------------------------------------------------
# Placement
#-------------------------------------------------------------------------------
set startTime [clock seconds]

setPlaceMode -activity_power_driven false -place_global_timing_effort medium -place_global_cong_effort high 
placeDesign
refinePlace
place_opt_design -incremental

timeDesign -preCTS -outDir ${_REPORTS_PATH}/place.timing.rpt
checkPlace > ${_REPORTS_PATH}/place.check.rpt
puts "YaoLog: The placement end time is [expr [clock seconds] - $startTime] sec"

defOut ${_OUTPUTS_PATH}/place.def
saveDesign ${_OUTPUTS_SAVE}/placement.enc
summaryReport -outfile ${_REPORTS_PATH}/placement_summary.rpt



#-------------------------------------------------------------------------------
# Clock tree synthesis
#-------------------------------------------------------------------------------

set startTime [clock seconds]
setNanoRouteMode -routeWithTimingDriven false -routeDesignFixClockNets true
ccopt_design -cts
ccopt_design
refinePlace

report_ccopt_clock_trees -file ${_REPORTS_PATH}/clock_trees.rpt
report_ccopt_skew_groups -file ${_REPORTS_PATH}/skew_groups.rpt
timeDesign -postCTS -outDir ${_REPORTS_PATH}/cts.timing.rpt
optDesign -postCTS -outDir ${_REPORTS_PATH}/cts.timing.rpt
puts "YaoLog: The CTS end time is [expr [clock seconds] - $startTime] sec"

set inp   [all_inputs -no_clocks]
set outp  [all_outputs]
set mems  [all_registers -macros ]
set icgs  [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
set regs  [remove_from_collection [all_registers -edge_triggered] $icgs]
set allregs  [all_registers]
group_path   -name Reg2Reg      -from $regs -to $regs

report_timing -max_paths 100 -path_group Reg2Reg > ${_REPORTS_PATH}/postCTS_timing.txt

report_ccopt_clock_tree_structure -file ${_REPORTS_PATH}/ccopt.txt
defOut ${_OUTPUTS_PATH}/clock.def

saveDesign ${_OUTPUTS_SAVE}/cts.enc

#-------------------------------------------------------------------------------
# Routing
#-------------------------------------------------------------------------------
setNanoRouteMode -routeWithTimingDriven false -routeDesignFixClockNets true

set startTime [clock seconds]
globalRoute
puts "YaoLog: The GlobalRoute end time is [expr [clock seconds] - $startTime] sec"

setNanoRouteMode -routeWithTimingDriven false -routeDesignFixClockNets true
set startTime [clock seconds]
dumpCongestArea -all ${_REPORTS_PATH}/congestion.rpt
detailRoute
puts "YaoLog: The DetailRoute end time is [expr [clock seconds] - $startTime] sec"

puts "\n\n\n---------------------------------------- route ---------------------------------------------\n\n\n"

setAnalysisMode -analysisType onChipVariation
timeDesign -postRoute -outDir ${_REPORTS_PATH}/route.timing.rpt
verify_drc -limit 1000 -report ${_REPORTS_PATH}/route.drc0.rpt

setExtractRCMode -effortLevel low -coupled true -total_c_th 0.0
extractRC
rcOut -spef ${_OUTPUTS_PATH}/RC.spef

setDelayCalMode -SIAware True
timeDesign -postRoute -outDir ${_REPORTS_PATH}/route_SI.timing.rpt
set startTime [clock seconds]
optDesign -postRoute -outDir ${_REPORTS_PATH}/route_SI.timing.rpt
optDesign -postRoute -drv 
puts "YaoLog: The RouteOpt end time is [expr [clock seconds] - $startTime] sec"

saveNetlist ${_OUTPUTS_PATH}/Pre_final_netlist.v

saveDesign ${_OUTPUTS_SAVE}/route.enc
verify_drc -limit 1000 -report ${_REPORTS_PATH}/route.drc1.rpt
verifyConnectivity -report ${_REPORTS_PATH}/route.connect.rpt
verifyConnectivity -useNewOpenVio -removeOldOpenVio -allPGPinPort  -report ${_REPORTS_PATH}/route.connect_pg.rpt
verifyConnectivity -useNewOpenVio -removeOldOpenVio -allPGPinPort  -report ${_REPORTS_PATH}/route.connect_pg1.rpt

verifyConnectivity -type all \
-nets [dbGet [dbGet -p1 top.nets.isPhysOnly 0].name] \
-report ${_REPORTS_PATH}/[dbGet top.name].signal.conn.rpt

# read verifyConnectivity report to get unique list of nets with dangling or floating metal errors:
editTrim -nets {VDD VSS}
editDeleteTrimMetal -all

ecoRoute
editDeleteViolations
routeDesign
verify_drc -limit 1000 -report ${_REPORTS_PATH}/route.drc2.rpt
verifyGeometry -report ${_REPORTS_PATH}/route.geometry2.rpt


report_timing -max_paths 100 -path_group Reg2Reg > ${_REPORTS_PATH}/postROUTE_timing.txt

defOut ${_OUTPUTS_PATH}/route.def -routing
fit
createSnapshot -dir ${_OUTPUTS_PATH} -name pnr_result
#saveDesign -verilog -def -libs ${_OUTPUTS_PATH}/pnr_result
saveDesign ${_OUTPUTS_SAVE}/route2.enc

summaryReport -outfile ${_REPORTS_PATH}/route_summary.rpt
report_constraint > ${_REPORTS_PATH}/constraint.txt

write_lef_abstract ${_OUTPUTS_PATH}/${top_module}.pnr.lef
write_lef_library ${_OUTPUTS_PATH}/${top_module}.lib.lef
do_extract_model -view default ${_OUTPUTS_PATH}/${top_module}.pnr.lib

#streamOut  ${_OUTPUTS_PATH}/${top_module}.pnr_map2.gds  -mapFile /home/zx52/cadence_course/NCSU/FreePDK45/osu_soc/ref_design/Encounter/gds2_encounter.map  -units 10000 -mode ALL
#streamOut  ${_OUTPUTS_PATH}/${top_module}.pnr_map1.gds  -mapFile /home/zx52/cadence_course/NCSU/FreePDK45/osu_soc/ref_design/Encounter/gds2_encounter.map  
#streamOut  ${_OUTPUTS_PATH}/${top_module}.pnr_map1.gds  -mapFile /home/zx52/cadence_course/NCSU/FreePDK45/osu_soc/ref_design/Encounter/gds2_encounter.map  -merge /home/zx52/NAS_EDA/NanGate45_1/NangateOpenCellLibrary_PDKv1_3_v2010_12/Back_End/gds/*gds -units 2000 -mode ALL
#streamOut  ${_OUTPUTS_PATH}/${top_module}.pnr_map.gds  -mapFile /home/zx52/cadence_course/NCSU/FreePDK45/osu_soc/ref_design/Encounter/gds2_encounter.map  -merge /home/zx52/NAS_EDA/NanGate45_1/NangateOpenCellLibrary_PDKv1_3_v2010_12/Back_End/gds/*gds -units 10000 -mode ALL

saveNetlist ${_OUTPUTS_PATH}/Final_netlist.v
saveNetlist -flat ${_OUTPUTS_PATH}/Final_netlist_flat.v

exit


