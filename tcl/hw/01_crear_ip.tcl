# Crea el IP AXI4-Lite a partir de la plantilla oficial de Xilinx (equivale a
# Tools > Create and Package New IP > Create a new AXI4 peripheral)
set raiz [file normalize [file dirname [info script]]/../..]
set repo $raiz/ip_repo
file mkdir $repo
create_project -in_memory -part xc7z010clg400-1
set_property target_language VHDL [current_project]
set p [create_peripheral user.org user axi_mi_periferico 1.0 -dir $repo]
add_peripheral_interface S00_AXI -interface_mode slave -axi_type lite $p
set_property VALUE 4  [ipx::get_bus_parameters WIZ_NUM_REG  -of_objects [ipx::get_bus_interfaces S00_AXI -of_objects $p]]
set_property VALUE 32 [ipx::get_bus_parameters WIZ_DATA_WIDTH -of_objects [ipx::get_bus_interfaces S00_AXI -of_objects $p]]
generate_peripheral -force $p
write_peripheral $p
puts "IP creado en $repo/axi_mi_periferico_1.0"
close_project
