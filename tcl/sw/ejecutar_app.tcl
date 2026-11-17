# xsct sw/ejecutar_app.tcl -> programa FPGA, carga y ejecuta prueba_axi.elf
set raiz [file normalize [file dirname [info script]]/..]
set hw $raiz/sw/workspace/zybo_axi/hw
connect
targets -set -nocase -filter {name =~ "*Cortex-A9 MPCore #0*"}
rst -system
after 500
targets -set -nocase -filter {name =~ "*xc7z010*"}
fpga -file $raiz/proyecto/ejemplo_axi.runs/impl_1/design_1_wrapper.bit
targets -set -nocase -filter {name =~ "*Cortex-A9 MPCore #0*"}
loadhw -hw $hw/design_1_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}]
source $hw/ps7_init.tcl
ps7_init
ps7_post_config
dow $raiz/sw/workspace/prueba_axi/Debug/prueba_axi.elf
con
puts "APP EN MARCHA"
