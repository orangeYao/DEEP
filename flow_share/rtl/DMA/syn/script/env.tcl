# Setup Directory Needed For Synthesis

# Set project path. The user should modify the following line to match
# the physical directory of project location.

set proj_path "../../."

# Cell Libraray Information

set search_path ". $lib_path"
set link_library "* $lib_file"
set target_library "$lib_file"

#set op_cond  "WCCOM"
#set wlm      "G100K"

# Set Target Speed Of Design
set speed  140.0
set Tclk  [expr 1000 / $speed]


# Verilog Pre-Processor Directory
set hdlin_enable_vpp  true
set hdlin_vpp_temporary_directory  ./vpp/
set hdlin_preserve_vpp_files  false

set status [expr [file exist vpp] & [file isdirectory vpp]]
if {$status != 1} {
  echo "Directory \"vpp\" needed for verilog pre-processor does not exist!"
  echo "Create it as \"vpp\" "
  exec mkdir vpp
} 

# Design Compiler Working Library
set status [expr [file exist ../work] & [file isdirectory ../work]]
if {$status != 1} {
  echo "Directory \"work\" needed for Design Compiler does not exist!"
  echo "Create it as \"work\" "
  exec mkdir ../work
}  

# Log File Directory
set status [expr [file exist ../rep] & [file isdirectory ../rep]]
if {$status != 1} {
  echo "Directory \"rep\" needed for log file does not exist!"
  echo "Create it as \"rep\" "
  exec mkdir ../rep
}

# db File Directory
set status [expr [file exist ../db] & [file isdirectory ../db]]
if {$status != 1} {
  echo "Directory \"db\" needed for rep file does not exist!"
  echo "Create it as \"db\" "
  exec mkdir ../db
}

# netlist File Directory
set status [expr [file exist ../../netlist] & [file isdirectory ../../netlist]]
if {$status != 1} {
  echo "Directory \"netlist\" needed for netlist file does not exist!"
  echo "Create it as \"netlist\" "
  exec mkdir ../netlist
}

# Set the search path 
set hdl_path      "$proj_path/hdl"
#set work_lib_path "$proj_path/syn/work_lib"
set work_lib_path "../work"

set search_path "$search_path $hdl_path $work_lib_path"

# Other Setting 
set template_naming_style "%s"

