print_suppressed_messages

source -echo -verbose ../scripts/configuration.tcl

set transistor  	"ffg" 		; 
set voltage 		"1p155v"	;
set temperature 	"125c"		; 
set extraction  	"cworst"	; 
set stage 			".pnr"
set activity_name 	"max_power"
set sim_freq        "1GHz"

# Optionally override script variables with those passed on command line with '-x' 
if { [info exists itran]	} { set transistor  $itran  }
if { [info exists ivolt]	} { set voltage 		$ivolt  }
if { [info exists itemp]	} { set temperature $itemp  }
if { [info exists iext]		} { set extraction  $iext   }
if { [info exists istage] } { set stage 			$istage }
if { [info exists iworkload] } { set activity_name $iworkload }
if { [info exists ifeq] } { set sim_freq $ifreq }

set mode "functional" 	; # functional, etm
if { [info exists imode]  } { set mode  $imode  }

# -----------------------------------------------------------------------------
# Restore the design
# -----------------------------------------------------------------------------

set target_session "../${mode}${stage}_${transistor}_${voltage}_${temperature}_${extraction}"
restore_session $target_session

set_host_options -max_cores 16

# -----------------------------------------------------------------------------
# Setup power analysis variables
# -----------------------------------------------------------------------------

set power_enable_analysis true 
set power_clock_network_include_clock_gating_network true
set power_clock_network_include_register_clock_pin_power false
set store_save_sessions 0

# -----------------------------------------------------------------------------
# Procedure used to ensure consistant power reporting 
# -----------------------------------------------------------------------------

proc power_reports { op_prepend verbose } { 
	report_power  > ${op_prepend}.power
	report_switching_activity > ${op_prepend}.switching
		
	if { [expr $verbose == 1] } {
		report_power -hierarchy > ${op_prepend}.power.hier
		report_switching_activity -hierarchy  > ${op_prepend}.switching.hier
		report_switching_activity -list_not_annotated > ${op_prepend}.switching.na
		report_switching_activity -include_only rtl -list_not_annotated -show_pin > ${op_prepend}.switching.rtl
		
		report_power -nosplit > ${op_prepend}.nosplit
		report_power -hier -verbose -nosplit  > ${op_prepend}.hier
		report_power -hier -verbose -nosplit -groups clock_network  > ${op_prepend}-clock_network
		report_power -clocks [get_clocks -filter {defined(sources)}] -cell_power  > ${op_prepend}-clock
		report_clock_gate_savings -sequential -nosplit  > ${op_prepend}-clockgate
		report_clock_gate_savings -sequential -hier -nosplit > ${op_prepend}-clockgate.hier
		
		report_power -cell_power [filter_collection [get_cells -hier *] "is_sequential == true" ] -nosplit -sort_by name -groups register \
																				> ${op_prepend}-sequential
		report_power -cell_power [filter_collection [get_cells -hier *] "is_sequential == true" ] -nosplit -sort_by name -groups memory \
																				> ${op_prepend}-memory
		report_power -net_power  [get_nets -of_objects [filter_collection [get_cells -hier *] "is_sequential == true" ]] -nosplit \
																				> ${op_prepend}-net
	}
}

# -----------------------------------------------------------------------------------
# Create report dir
# -----------------------------------------------------------------------------------

file mkdir ../reports/power/${mode}${stage}_${extraction}

# Average power analysis mode by default, set the following for time based:
set_app_var power_analysis_mode time_based
set_power_analysis_options -waveform_format fsdb

#We focus on dynamic power
set_power_analysis_options -separate_power_waveform leakage
set_power_analysis_options -npeak 10   -npeak_out ../reports/power/peak_analysis/${transistor}_${voltage}_${temperature}_${activity_name}_${sim_freq}

#Map rtl to gate
source -echo -verbose ../data/${impl_toplevel}${stage}.saif_map

#Force ports that are not in RTL design
set_case_analysis 1 [get_ports ExamplePortA]
set_case_analysis 0 [get_ports ExamplePortB*]

read_vcd ../../power/${sim_freq}/${activity_name}64.vcd -rtl -strip_path cpu_execution_tb/u_cpu

report_vcd_hierarchy > ../reports/power/vcd-hierarchy

#Final output in 'primetime_px.fsdb'
update_power
report_power > ../reports/power/peak_analysis/${transistor}_${voltage}_${temperature}_${activity_name}_${sim_freq}.power

exit
