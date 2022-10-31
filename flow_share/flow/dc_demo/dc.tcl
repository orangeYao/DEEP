set DESIGN_NAME $design_name
set CLOCK_PORT  $clock_name
set FILE_FORMAT $file_format
set FINAL_VERILOG_OUTPUT_FILE "${design_name}.mapped.v"
set FINAL_SDC_OUTPUT_FILE     "${design_name}.mapped.sdc"

set REPORTS_DIR "report"
set RESULTS_DIR "results"

file mkdir ${REPORTS_DIR}
file mkdir ${RESULTS_DIR}

#------------------------------------------------------------------------------
# Setup the libraries
#------------------------------------------------------------------------------
    set_app_var target_library "$all_dbs"
    set_app_var link_library "$target_library"
    #set_app_var synthetic_library "dw_foundation.sldb"

#------------------------------------------------------------------------------
# Read design
#------------------------------------------------------------------------------
    define_design_lib WORK -path ./WORK
    #analyze -format verilog -recursive -autoread $rtl_path  -top ${DESIGN_NAME}
    if {${FILE_FORMAT} == "verilog"} {
        analyze -format verilog -recursive -autoread $rtl_path -top ${DESIGN_NAME}
    } else {
        analyze -format vhdl -recursive -autoread $rtl_path -top ${DESIGN_NAME}
    }
    elaborate ${DESIGN_NAME}
    ungroup -all -flatten
    create_clock -period 10 $CLOCK_PORT

#------------------------------------------------------------------------------
# Check for design errors
#------------------------------------------------------------------------------
    # Prevent assignment statements in the Verilog netlist.
    set_fix_multiple_port_nets -all -buffer_constants -feedthroughs [all_designs]

    check_design -summary
    check_design > ${REPORTS_DIR}/check_design.rpt

#------------------------------------------------------------------------------
# Set DRC constraints 
#------------------------------------------------------------------------------
    set_max_fanout      30      $current_design
    set_max_transition    2.0      $current_design
    set_max_capacitance     20      $current_design
    set high_fanout_net_threshold 200
    set high_fanout_net_pin_capacitance 0.1

#-----------------------------------------------------------------------------
# Compile the design
#-----------------------------------------------------------------------------
    #set compile_cmd "compile -map_effort high -area_effort none -incremental_mapping"
    #set compile_cmd "compile_ultra"
    set compile_cmd "compile"
    echo $compile_cmd
    eval $compile_cmd

    #ungroup -all -flatten
    change_names -rules verilog -hierarchy

#--------------------------------------------------------------------------------
# Generate final reports
#--------------------------------------------------------------------------------

    report_qor > ${REPORTS_DIR}/qor.rpt
    report_timing -transition_time -nets -attributes -nosplit > ${REPORTS_DIR}/timing.rpt

    report_area -nosplit -hierarchy > ${REPORTS_DIR}/area.rpt
    report_cell [get_cells] > ${REPORTS_DIR}/area_cell.rpt

    report_power -nosplit > ${REPORTS_DIR}/power.rpt
    report_power -cell -flat > ${REPORTS_DIR}/power_cell.rpt
    report_power -net -flat > ${REPORTS_DIR}/power_net.rpt 

    report_clock_gating -nosplit > ${REPORTS_DIR}/cg.rpt
    report_reference -nosplit > ${REPORTS_DIR}/ref.rpt

#--------------------------------------------------------------------------------
# Save the design
#--------------------------------------------------------------------------------
    write -format verilog -hierarchy -output ${RESULTS_DIR}/${FINAL_VERILOG_OUTPUT_FILE}
    write_sdc -nosplit ${RESULTS_DIR}/${FINAL_SDC_OUTPUT_FILE}
    exit
    
