# xsct sw/probar_placa.tcl -> programa la FPGA y prueba los registros por JTAG
set raiz [file normalize [file dirname [info script]]/..]
set hw $raiz/sw/workspace/zybo_axi/hw
connect
puts "TARGETS:\n[targets]"
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
set B 0x43C00000
puts "LECTURA 0x04 (btns&sws): [mrd -value [expr $B+4]]"
foreach v {0x5 0xA 0xF 0x0} {
  mwr $B $v
  puts "ESCRITO 0x00=$v  RELEIDO=[mrd -value $B]"
  after 700
}
mwr $B 0x5
puts "FIN"
