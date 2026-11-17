# Proyecto Zybo Z7-10 + Block Design (Zynq PS + axi_mi_periferico) -> bitstream + .xsa
set raiz [file normalize [file dirname [info script]]/../..]
set proj_dir $raiz/proyecto
file delete -force $proj_dir
create_project ejemplo_axi $proj_dir -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo-z7-10:part0:1.2 [current_project]
set_property target_language VHDL [current_project]
set_property ip_repo_paths $raiz/ip_repo [current_project]
update_ip_catalog

create_bd_design design_1
set ps [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 \
  -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable"} $ps
create_bd_cell -type ip -vlnv user.org:user:axi_mi_periferico:1.0 axi_mi_periferico_0
apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
  -config {Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/axi_mi_periferico_0/S00_AXI} intc_ip {New AXI Interconnect} master_apm {0}} \
  [get_bd_intf_pins axi_mi_periferico_0/S00_AXI]
foreach p {leds sws btns} {
  make_bd_pins_external [get_bd_pins axi_mi_periferico_0/$p]
  set_property name $p [get_bd_ports ${p}_0]
}
assign_bd_address
puts "DIRECCION: [get_property OFFSET [get_bd_addr_segs processing_system7_0/Data/SEG_axi_mi_periferico_0_S00_AXI_reg]] RANGO: [get_property RANGE [get_bd_addr_segs processing_system7_0/Data/SEG_axi_mi_periferico_0_S00_AXI_reg]]"
validate_bd_design
save_bd_design

set bd [get_files design_1.bd]
set wrapper [make_wrapper -files $bd -top]
add_files -norecurse [file normalize $proj_dir/ejemplo_axi.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.vhd]
set_property top design_1_wrapper [current_fileset]
add_files -fileset constrs_1 -norecurse $raiz/hw/xdc/zybo_z7_10.xdc

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
puts "ESTADO IMPL: [get_property STATUS [get_runs impl_1]]"
open_run impl_1
report_timing_summary -file $proj_dir/timing.rpt
puts "WNS: [get_property SLACK [get_timing_paths -max_paths 1 -setup]]"
write_hw_platform -fixed -include_bit -force $proj_dir/design_1_wrapper.xsa
puts "XSA: $proj_dir/design_1_wrapper.xsa"
