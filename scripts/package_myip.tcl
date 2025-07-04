# ========== constants ==========
set ip_name     "myip"
set ip_version  "1.0"
set ip_vendor   "xilinx.com"
set part        "xc7z010clg400-1"

# absolute paths, independent of CWD
set script_dir  [file dirname [info script]]
set src_dir     [file normalize "$script_dir/../ip_src"]
set out_repo    [file normalize "$script_dir/../ip_repo"]

puts "\n==> Packaging $ip_name:$ip_version from $src_dir"

# ---------- fresh temp project ----------
set temp_proj "tmp_pkg_$ip_name"
create_project $temp_proj /tmp/$temp_proj -part $part -force
set_property target_language VHDL [current_project]
set_property source_mgmt_mode None  [current_project]

# ---------- add sources ----------
set vhdl_files [concat \
        [glob -nocomplain -types f -directory $src_dir *.vhd] \
        [glob -nocomplain -types f -directory $src_dir *.vhdl] ]

if {[llength $vhdl_files] == 0} {
    puts "FATAL: No VHDL sources found under $src_dir"
    exit 1
}
foreach f $vhdl_files { add_files -norecurse $f }
puts "Added [llength $vhdl_files] files"

update_compile_order -fileset sources_1
set_property top myip [get_filesets sources_1]

# optional quick synthesis check
launch_runs synth_1
wait_on_run synth_1

# ---------- package ----------
set ip_root "$out_repo/${ip_name}_${ip_version}"
file delete -force $ip_root

ipx::package_project -root_dir $ip_root \
    -vendor $ip_vendor -library user \
    -taxonomy /UserIP -name $ip_name -version $ip_version -import_files -force

ipx::infer_bus_interfaces [ipx::current_core]
ipx::save_core [ipx::current_core]
puts "==> IP packaged to $ip_root"

# Close the temporary project but don't quit Vivado
close_project
