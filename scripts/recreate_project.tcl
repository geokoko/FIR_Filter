# ====================================================================
# recreate_project.tcl — Fully automated Vivado project build script
# ====================================================================

# ---------- Settings ------------------------------------------------
set proj_name   "FIR_Zybo"
set part        "xc7z010clg400-1"
set script_dir  [file dirname [info script]]
set ip_script   "[file normalize $script_dir/package_myip.tcl]"
set bd_script   "[file normalize $script_dir/create_bd.tcl]"
set build_dir   "[pwd]/build"
file mkdir $build_dir

# ---------- Step 0: Package custom IP ------------------------------
puts "\n=== Step 0: Packaging custom IP ==="
source $ip_script

# ---------- Step 1: Create Vivado project --------------------------
puts "\n=== Step 1: Creating project $proj_name ==="
create_project $proj_name $build_dir -part $part -force
set_property target_language VHDL [current_project]

# ---------- Step 1.5: Set IP repo and refresh catalog --------------
set_property ip_repo_paths "[file normalize ./ip_repo]" [current_project]
update_ip_catalog

# ---------- Step 2: Add sources and constraints --------------------
puts "\n=== Step 2: Adding sources and constraints ==="
add_files -norecurse [glob ./ip_src/*.vhd]
add_files -fileset constrs_1 [glob ./constraints/*.xdc]

# ---------- Step 3: Create block design ----------------------------
puts "\n=== Step 3: Creating block design ==="
source $bd_script

# ---------- Step 4: Generate HDL wrapper ---------------------------
puts "\n=== Step 4: Generating HDL wrapper ==="
make_wrapper -files [get_files design_1.bd] -top -import
add_files -norecurse $build_dir/$proj_name.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.vhd
update_compile_order -fileset sources_1

# ---------- Step 5: Project ready for user ----------------------------
puts "\n=== Step 5: Project ready! ==="
puts "Project created successfully. You can now:"
puts "  • Run synthesis: launch_runs synth_1"
puts "  • Run implementation: launch_runs impl_1"
puts "  • Generate bitstream: launch_runs impl_1 -to_step write_bitstream"

# ---------- Completion message --------------------------------------
puts ""
puts "********************************************************************************"
puts "*                                                                              *"
puts "*                    PROJECT GENERATION COMPLETE!                              *"
puts "*                                                                              *"
puts "*  ✅ IP packaged successfully                                                 *"
puts "*  ✅ Vivado project created: $build_dir/$proj_name.xpr                        *"
puts "*  ✅ Block design created (from exported TCL)                                 *"
puts "*  ✅ HDL wrapper generated                                                    *"
puts "*                                                                              *"
puts "*  Next steps:                                                                 *"
puts "*  1. Open project: vivado $build_dir/$proj_name.xpr                           *"
puts "*  2. Run synthesis/implementation/bitstream as needed                          *"
puts "*  3. Program your board!                                                      *"
puts "*                                                                              *"
puts "********************************************************************************"
puts ""
quit 