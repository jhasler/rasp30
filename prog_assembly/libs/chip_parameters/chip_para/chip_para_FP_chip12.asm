/**********************************/
/* FP (Fine Program) parameters */
/**********************************/
.set ADC_1nA, 3959 /* 1nA ADC value */

/* sub threshold */
.set FPS_GATE_S_SWC, 0x4B00 /* Gate(SWC) = 3.5V @ IVDD 6.0V */
.set FPS_INJ_T_SWC, 1 /* Injection time (*10us) */
.set FPS_NUM_SWC, 50 /* # of Fine Progrm */
.set FPS_VD_A_SWC, 9 /* Vd constant A */
.set FPS_VD_B_SWC, 5 /* Vd constant B */
.set FPS_VD_OS_SWC, 36 /* Vd table offset */
.set FPS_VD_SA_SWC, 0 /* 0:Subtraction 1:Add */
.set FPS_VD_GND_SWC, 0 /* 0:Vd table 1:GND */
.set FPS_GATE_S_OTA, 0x4B00
.set FPS_INJ_T_OTA, 1
.set FPS_NUM_OTA, 50 /* # of Fine Progrm */
.set FPS_VD_A_OTA, 9 /* Vd constant A */
.set FPS_VD_B_OTA, 5 /* Vd constant B */
.set FPS_VD_OS_OTA, 44 /* Vd table offset */
.set FPS_VD_SA_OTA, 0 /* 0:Subtraction 1:Add */
.set FPS_VD_GND_OTA, 0 /* 0:Vd table 1:GND */
.set FPS_GATE_S_OTAREF, 0x4B00
.set FPS_INJ_T_OTAREF, 1
.set FPS_NUM_OTAREF, 50 /* # of Fine Progrm */
.set FPS_VD_A_OTAREF, 9 /* Vd constant A */
.set FPS_VD_B_OTAREF, 5 /* Vd constant B */
.set FPS_VD_OS_OTAREF, 48
.set FPS_VD_SA_OTAREF, 0 /* 0:Subtraction 1:Add */
.set FPS_VD_GND_OTAREF, 0 /* 0:Vd table 1:GND */
.set FPS_GATE_S_MITE, 0x4B00
.set FPS_INJ_T_MITE, 1
.set FPS_NUM_MITE, 50 /* # of Fine Progrm */
.set FPS_VD_A_MITE, 9 /* Vd constant A */
.set FPS_VD_B_MITE, 5 /* Vd constant B */
.set FPS_VD_OS_MITE, 48
.set FPS_VD_SA_MITE, 0 /* 0:Subtraction 1:Add */
.set FPS_VD_GND_MITE, 0 /* 0:Vd table 1:GND */
.set FPS_GATE_S_DIRSWC, 0x4B00
.set FPS_INJ_T_DIRSWC, 1
.set FPS_NUM_DIRSWC, 50 /* # of Fine Progrm */
.set FPS_VD_A_DIRSWC, 9 /* Vd constant A */
.set FPS_VD_B_DIRSWC, 5 /* Vd constant B */
.set FPS_VD_OS_DIRSWC, 40
.set FPS_VD_SA_DIRSWC, 0 /* 0:Subtraction 1:Add */
.set FPS_VD_GND_DIRSWC, 0 /* 0:Vd table 1:GND */

/* above threshold */
.set FPA_GATE_S_SWC, 0x4B00
.set FPA_INJ_T_SWC, 1
.set FPA_NUM_SWC, 50 /* # of Fine Progrm */
.set FPA_VD_A_SWC, 7
.set FPA_VD_B_SWC, 5 
.set FPA_VD_OS_SWC, 22 
.set FPA_VD_SA_SWC, 1 /* 0:Subtraction 1:Add */
.set FPA_VD_GND_SWC, 0 /* 0:Vd table 1:GND */
.set FPA_GATE_S_OTA, 0x4B00
.set FPA_INJ_T_OTA, 1
.set FPA_NUM_OTA, 50 /* # of Fine Progrm */
.set FPA_VD_A_OTA, 7
.set FPA_VD_B_OTA, 5 
.set FPA_VD_OS_OTA, 22
.set FPA_VD_SA_OTA, 1 /* 0:Subtraction 1:Add */
.set FPA_VD_GND_OTA, 0 /* 0:Vd table 1:GND */
.set FPA_GATE_S_OTAREF, 0x4B00
.set FPA_INJ_T_OTAREF, 1
.set FPA_NUM_OTAREF, 50 /* # of Fine Progrm */
.set FPA_VD_A_OTAREF, 7
.set FPA_VD_B_OTAREF, 5 
.set FPA_VD_OS_OTAREF, 26
.set FPA_VD_SA_OTAREF, 1 /* 0:Subtraction 1:Add */
.set FPA_VD_GND_OTAREF, 0 /* 0:Vd table 1:GND */
.set FPA_GATE_S_MITE, 0x4B00
.set FPA_INJ_T_MITE, 1
.set FPA_NUM_MITE, 50 /* # of Fine Progrm */
.set FPA_VD_A_MITE, 7
.set FPA_VD_B_MITE, 5 
.set FPA_VD_OS_MITE, 30
.set FPA_VD_SA_MITE, 1 /* 0:Subtraction 1:Add */
.set FPA_VD_GND_MITE, 0 /* 0:Vd table 1:GND */
.set FPA_GATE_S_DIRSWC, 0x4B00 
.set FPA_INJ_T_DIRSWC, 1
.set FPA_NUM_DIRSWC, 50 /* # of Fine Progrm */
.set FPA_VD_A_DIRSWC, 7
.set FPA_VD_B_DIRSWC, 5 
.set FPA_VD_OS_DIRSWC, 22
.set FPA_VD_SA_DIRSWC, 1 /* 0:Subtraction 1:Add */
.set FPA_VD_GND_DIRSWC, 0 /* 0:Vd table 1:GND */

/* low sub threshold */
.set FPL_GATE_S_SWC, 0x0040
.set FPL_INJ_T_SWC, 1
.set FPL_NUM_SWC, 50 /* # of Fine Progrm */
.set FPL_VD_A_SWC, 8
.set FPL_VD_B_SWC, 5 
.set FPL_VD_OS_SWC, 51
.set FPL_VD_SA_SWC, 1 /* 0:Subtraction 1:Add */
.set FPL_VD_GND_SWC, 0 /* 0:Vd table 1:GND */
.set FPL_GATE_S_OTA, 0x0040
.set FPL_INJ_T_OTA, 100
.set FPL_NUM_OTA, 50 /* # of Fine Progrm */
.set FPL_VD_A_OTA, 8
.set FPL_VD_B_OTA, 5 
.set FPL_VD_OS_OTA, 53
.set FPL_VD_SA_OTA, 1 /* 0:Subtraction 1:Add */
.set FPL_VD_GND_OTA, 1 /* 0:Vd table 1:GND */
.set FPL_GATE_S_OTAREF, 0x0040
.set FPL_INJ_T_OTAREF, 1
.set FPL_NUM_OTAREF, 50 /* # of Fine Progrm */
.set FPL_VD_A_OTAREF, 9
.set FPL_VD_B_OTAREF, 5 
.set FPL_VD_OS_OTAREF, 55
.set FPL_VD_SA_OTAREF, 1 /* 0:Subtraction 1:Add */
.set FPL_VD_GND_OTAREF, 0 /* 0:Vd table 1:GND */
.set FPL_GATE_S_MITE, 0x0000
.set FPL_INJ_T_MITE, 1
.set FPL_NUM_MITE, 50 /* # of Fine Progrm */
.set FPL_VD_A_MITE, 9
.set FPL_VD_B_MITE, 5 
.set FPL_VD_OS_MITE, 50
.set FPL_VD_SA_MITE, 1 /* 0:Subtraction 1:Add */
.set FPL_VD_GND_MITE, 0 /* 0:Vd table 1:GND */
.set FPL_GATE_S_DIRSWC, 0x0040
.set FPL_INJ_T_DIRSWC, 20
.set FPL_NUM_DIRSWC, 50 /* # of Fine Progrm */
.set FPL_VD_A_DIRSWC, 7
.set FPL_VD_B_DIRSWC, 5 
.set FPL_VD_OS_DIRSWC, 65
.set FPL_VD_SA_DIRSWC, 1 /* 0:Subtraction 1:Add */
.set FPL_VD_GND_DIRSWC, 0 /* 0:Vd table 1:GND */

/* high above threshold */
.set FPH_GATE_S_SWC, 0x0000
.set FPH_INJ_T_SWC, 1
.set FPH_VD_OS_SWC, 21
.set FPH_GATE_S_OTA, 0x0000
.set FPH_INJ_T_OTA, 20
.set FPH_VD_OS_OTA, 21

