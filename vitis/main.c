/*
 * Prueba del periferico axi_mi_periferico (AXI4-Lite) usando el DRIVER que genera Vivado
 *   offset 0x00 (slv_reg0) : ESCRITURA -> LEDs (bits 3:0)
 *   offset 0x04            : LECTURA   <- botones (bits 7:4) y switches (bits 3:0)
 */
#include "xparameters.h"
#include "axi_mi_periferico.h"      /* driver del IP: macros y offsets */
#include "xil_printf.h"
#include "sleep.h"

#define BASE          XPAR_AXI_MI_PERIFERICO_0_S00_AXI_BASEADDR
#define REG_LEDS      AXI_MI_PERIFERICO_S00_AXI_SLV_REG0_OFFSET   /* 0x00 escritura */
#define REG_ENTRADAS  AXI_MI_PERIFERICO_S00_AXI_SLV_REG1_OFFSET   /* 0x04 lectura   */

int main(void)
{
    u32 anterior = 0xFFFFFFFF;
    xil_printf("Prueba axi_mi_periferico en 0x%08x\r\n", BASE);

    while (1) {
        u32 entradas = AXI_MI_PERIFERICO_mReadReg(BASE, REG_ENTRADAS);   /* lectura  */
        u32 sws  = entradas & 0xF;
        u32 btns = (entradas >> 4) & 0xF;

        AXI_MI_PERIFERICO_mWriteReg(BASE, REG_LEDS, sws ^ btns);         /* escritura */

        if (entradas != anterior) {
            xil_printf("sws=0x%x btns=0x%x -> leds=0x%x (leido 0x%x)\r\n",
                       sws, btns, sws ^ btns, AXI_MI_PERIFERICO_mReadReg(BASE, REG_LEDS));
            anterior = entradas;
        }
        usleep(20000);
    }
    return 0;
}
