# Regenera TODO el hardware desde cero (Vivado 2019.2):
#   cd hw/tcl ; vivado -mode batch -source run_all.tcl
# 1) plantilla AXI4-Lite oficial  2) copia hw/src/*.vhd (cambios de usuario) y reempaqueta  4) proyecto + bitstream + .xsa
set d [file dirname [file normalize [info script]]]
source $d/01_crear_ip.tcl
source $d/02_editar_empaquetar_ip.tcl
source $d/03_proyecto_bd.tcl
