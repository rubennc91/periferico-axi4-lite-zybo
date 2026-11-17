# Periférico AXI4-Lite en la Zybo Z7-10

Ficheros de apoyo de la serie de vídeos *Periférico AXI4-Lite en la Zybo Z7-10* (Vivado y Vitis **2019.2**).
Se construye un periférico propio conectado al procesador de la Zynq: se crea en Vivado, se conecta en un Block Design y se prueba desde un programa en C en Vitis con el driver que genera Vivado.

Autor: Rubén Nieto (Universidad Rey Juan Carlos).

## Contenido

| Carpeta / fichero | Para qué |
|---|---|
| `vivado/axi_mi_periferico_v1_0_S00_AXI.vhd` | Lógica del periférico (registros, escritura y lectura), ya modificada |
| `vivado/axi_mi_periferico_v1_0.vhd` | Top del IP con los puertos añadidos (leds, entradas) |
| `vivado/zybo_z7_10.xdc` | Restricciones: LEDs, switches y botones de la placa |
| `vitis/main.c` | Programa de prueba que usa el driver del IP (`AXI_MI_PERIFERICO_mReadReg` / `mWriteReg`) |
| `vitis/design_1_wrapper_ejemplo.xsa` | Hardware de ejemplo ya exportado (bitstream + driver del IP), por si no llegáis a generar el vuestro |
| `vitis/Makefile_corregido_Vitis_2020.2` | **Solo Vitis 2020.2**: ver más abajo |
| `tcl/` | Scripts Tcl con los que se regenera todo el flujo por línea de comandos (referencia; **no son necesarios** para seguir los vídeos) |

## Avisos

- **Workspace de Vitis en una ruta corta**, por ejemplo `C:\ws`. Windows no admite rutas de más de 260 caracteres y la compilación falla.
- **Vitis 2020.2**: la compilación del driver falla con `arm-none-eabi-ar: *.o: Invalid argument`. Hay que sustituir, en los tres `Makefile` del driver dentro de la plataforma, las líneas

  ```make
  INCLUDEFILES=*.h
  LIBSOURCES=*.c
  OUTS = *.o
  ```

  por

  ```make
  INCLUDEFILES=$(wildcard *.h)
  LIBSOURCES=$(wildcard *.c)
  OUTS=$(addsuffix .o, $(basename $(wildcard *.c)))
  ```

  Los tres ficheros están (dentro de la carpeta de la plataforma, `<workspace>\<plataforma>\`) en:
  1. `hw\drivers\axi_mi_periferico_v1_0\src\Makefile`
  2. `ps7_cortexa9_0\standalone_domain\bsp\ps7_cortexa9_0\libsrc\axi_mi_periferico_v1_0\src\Makefile`
  3. `zynq_fsbl\zynq_fsbl_bsp\ps7_cortexa9_0\libsrc\axi_mi_periferico_v1_0\src\Makefile`

  Con Vitis 2019.2 no hay que cambiar nada. Después: *Project > Clean* y *Project > Build All*.
- El driver del IP viaja dentro del `.xsa`: en Vitis **no** hay que añadir ningún repositorio.
- Los scripts de `tcl/` asumen la estructura del proyecto original (`hw/src`, `ip_repo`…), que aquí no se incluye.
