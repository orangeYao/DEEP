

set_max_fanout      50      $current_design
set_max_transition    0.5      $current_design
set_max_capacitance     5      $current_design
set high_fanout_net_threshold 50
set high_fanout_net_pin_capacitance 0.01
#set_max_fanout      100      $current_design
#set_max_transition    1.0      $current_design
#set_max_capacitance     10      $current_design
#set high_fanout_net_threshold 100
#set high_fanout_net_pin_capacitance 0.02

set compile_cmd "compile -map_effort high -area_effort none -incremental_mapping"
#set compile_cmd "compile -map_effort medium "


