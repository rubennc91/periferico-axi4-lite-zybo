# xsct sw/build.tcl  -> plataforma + app standalone con main.c
set raiz [file normalize [file dirname [info script]]/..]
set ws $raiz/sw/workspace
file delete -force $ws
setws $ws
# El .xsa de este proyecto (IP creado por script) NO lleva el driver, asi que aqui si se anade el repositorio.
# Con un .xsa de un IP creado desde la GUI de Vivado el driver viaja dentro y no hace falta (ni conviene).
repo -set $raiz/ip_repo
platform create -name zybo_axi -hw $raiz/proyecto/design_1_wrapper.xsa -proc ps7_cortexa9_0 -os standalone
platform generate
app create -name prueba_axi -platform zybo_axi -domain standalone_domain -template {Empty Application}
importsources -name prueba_axi -path $raiz/sw/src
app build -name prueba_axi
puts "ELF: [glob -nocomplain $ws/prueba_axi/Debug/*.elf]"
