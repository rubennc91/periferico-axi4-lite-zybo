# Copia los VHDL con la logica de usuario dentro del IP y lo reempaqueta
# (equivale a Edit in IP Packager > Merge changes > Re-Package IP)
set raiz [file normalize [file dirname [info script]]/../..]
set ipdir $raiz/ip_repo/axi_mi_periferico_1.0
foreach f {axi_mi_periferico_v1_0.vhd axi_mi_periferico_v1_0_S00_AXI.vhd} {
  file copy -force $raiz/hw/src/$f $ipdir/hdl/$f
}
set tmp $raiz/build/edit_ip
file delete -force $tmp
create_project -in_memory -part xc7z010clg400-1
ipx::edit_ip_in_project -upgrade true -name edit_axi_mi_periferico -directory $tmp $ipdir/component.xml
update_compile_order -fileset sources_1
set core [ipx::current_core]
ipx::merge_project_changes files $core
ipx::merge_project_changes hdl_parameters $core
ipx::merge_project_changes ports $core
set_property core_revision [expr {[get_property core_revision $core] + 1}] $core
ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::check_integrity $core
ipx::save_core $core
puts "PUERTOS DEL IP: [lsort [get_property NAME [ipx::get_ports -of_objects $core]]]"
close_project -delete
