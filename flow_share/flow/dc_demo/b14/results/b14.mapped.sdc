###################################################################

# Created by write_sdc on Thu Oct 27 19:06:14 2022

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_max_capacitance 20 [current_design]
set_max_transition 2 [current_design]
set_max_fanout 30 [current_design]
create_clock [get_ports clock]  -period 10  -waveform {0 5}
