# -----------------------------------------------------------------------------
# Vivado project recreation script (portable)
# Target: ZYBO Z7-20 PCAM5 design
# -----------------------------------------------------------------------------

# Resolve script location
set origin_dir [file dirname [file normalize [info script]]]

# Project name
set proj_name "zybo_pcam5"

# Build directory (ignored by git)
set build_dir [file normalize "$origin_dir/../build/$proj_name"]

# -----------------------------------------------------------------------------
# Board files (local, portable)
# -----------------------------------------------------------------------------
set_param board.repoPaths [list \
    [file normalize "$origin_dir/../board_files"] \
]

# -----------------------------------------------------------------------------
# Create project
# -----------------------------------------------------------------------------
create_project $proj_name $build_dir -part xc7z020clg400-1 -force
set_property board_part digilentinc.com:zybo-z7-20:part0:1.1 [current_project]
set_property target_language VHDL [current_project]
set_property simulator_language Mixed [current_project]

# -----------------------------------------------------------------------------
# IP repositories (local only)
# -----------------------------------------------------------------------------
set_property ip_repo_paths [list \
    [file normalize "$origin_dir/../ip/vivado-library"] \
    [file normalize "$origin_dir/../ip/local"] \
] [current_project]

update_ip_catalog

# -----------------------------------------------------------------------------
# Add RTL sources
# -----------------------------------------------------------------------------
add_files -norecurse [glob $origin_dir/../src/rtl/*.vhd]

# -----------------------------------------------------------------------------
# Add constraints
# -----------------------------------------------------------------------------
add_files -fileset constrs_1 -norecurse [glob $origin_dir/../src/constraints/*.xdc]

# -----------------------------------------------------------------------------
# Source all local IP Tcl scripts
# -----------------------------------------------------------------------------
foreach tcl_file [glob -nocomplain $origin_dir/../ip/local/*/*.tcl] {
    puts "Sourcing IP Tcl: $tcl_file"
    source $tcl_file
}

# -----------------------------------------------------------------------------
# Block Design recreation
# -----------------------------------------------------------------------------
# Source the BD Tcl exported from Vivado
puts "Sourcing Block Design Tcl..."
source $origin_dir/../src/bd/system_bd.tcl

# Generate BD outputs
generate_target all [get_files *.bd]

# Create wrapper and import into project (FORCE recreation)
set bd_file [get_files *.bd]
make_wrapper -files $bd_file -top -import -force

# Update compile order
update_compile_order -fileset sources_1


# -----------------------------------------------------------------------------
# Set top module
# -----------------------------------------------------------------------------
set_property top system_wrapper [current_fileset]

# -----------------------------------------------------------------------------
# Update compile order
# -----------------------------------------------------------------------------
update_compile_order -fileset sources_1

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
puts "Vivado project recreated successfully."
puts "Project directory: $build_dir"
