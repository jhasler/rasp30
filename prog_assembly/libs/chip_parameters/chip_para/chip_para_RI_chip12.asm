/* RI (Recover Injection Above & Sub threshold) parameters */
.set RI_GATE_S_SWC, 0x0040 /* Gate(SWC) = gnd */
.set RI_VC1_SWC, 5062 /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */
.set RI_VC2_SWC, 4952 /* Ivfg*2/5 @Vgm=0V */
.set RI_VC3_SWC, 4621 /* Ivfg*1/10 @Vgm=0V */
.set RI_VC4_SWC, 3959 /* Ivfg=1nA @Vgm=0V */
.set RI_VD1_SWC, 0xea0e /* Vd @ final stage */
.set RI_VD2_SWC, 0xfe0e /* Vd @ pre-final stage */
.set RI_INJ_T_SWC, 1 /* Injection time unit (*10us) */
.set RI_NUM_SWC, 300 /* # of Recover Injection */

.set RI_GATE_S_OTA, 0x0040 /* Gate(OTA) = gnd */
.set RI_VC1_OTA, 5740 /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */
.set RI_VC2_OTA, 5561 /* Ivfg*2/5 @Vgm=0V */
.set RI_VC3_OTA, 5027 /* Ivfg*1/10 @Vgm=0V */
.set RI_VC4_OTA, 3959 /* Ivfg=1nA @Vgm=0V */
.set RI_VD1_OTA, 0x0026 /* Vd @ final stage */
.set RI_VD2_OTA, 0x0026 /* Vd @ pre-final stage */
.set RI_INJ_T_OTA, 100 /* Injection time unit (*10us) */
.set RI_NUM_OTA, 300 /* # of Recover Injection */

.set RI_GATE_S_OTAREF, 0x0040 /* Gate(OTAREF) = gnd */
.set RI_VC1_OTAREF, 5293 /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */
.set RI_VC2_OTAREF, 5160 /* Ivfg*2/5 @Vgm=0V */
.set RI_VC3_OTAREF, 4760 /* Ivfg*1/10 @Vgm=0V */
.set RI_VC4_OTAREF, 3959 /* Ivfg=1nA @Vgm=0V */
.set RI_VD1_OTAREF, 0xea0e /* Vd @ final stage */
.set RI_VD2_OTAREF, 0xfe0e /* Vd @ pre-final stage */
.set RI_INJ_T_OTAREF, 1 /* Injection time unit (*10us) */
.set RI_NUM_OTAREF, 300 /* # of Recover Injection */

.set RI_GATE_S_MITE, 0x0000 /* Gate(MITE) = 2.5V */
.set RI_VC1_MITE, 6034 /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */
.set RI_VC2_MITE, 5827 /* Ivfg*2/5 @Vgm=0V */
.set RI_VC3_MITE, 5204 /* Ivfg*1/10 @Vgm=0V */
.set RI_VC4_MITE, 3959 /* Ivfg=1nA @Vgm=0V */
.set RI_VD1_MITE, 0x0026 /* Vd @ final stage */
.set RI_VD2_MITE, 0x0026 /* Vd @ pre-final stage */
.set RI_INJ_T_MITE, 1 /* Injection time unit (*10us) */
.set RI_NUM_MITE, 1000 /* # of Recover Injection */

.set RI_GATE_S_DIRSWC, 0x0040 /* Gate(DIRSWC) = gnd */
.set RI_VC1_DIRSWC, 5143 /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */
.set RI_VC2_DIRSWC, 5025 /* Ivfg*2/5 @Vgm=0V */
.set RI_VC3_DIRSWC, 4670 /* Ivfg*1/10 @Vgm=0V */
.set RI_VC4_DIRSWC, 3959 /* Ivfg=1nA @Vgm=0V */
.set RI_VD1_DIRSWC, 0x0026 /* Vd @ final stage */
.set RI_VD2_DIRSWC, 0x0026 /* Vd @ pre-final stage */
.set RI_INJ_T_DIRSWC, 1 /* Injection time unit (*10us) */
.set RI_NUM_DIRSWC, 1000 /* # of Recover Injection */

/* RIL (Recover Injection low sub threshold) parameters */
.set RIL_GATE_S_SWC, 0x0040 /* Gate(SWC) = gnd */
.set RIL_VC1_SWC, 3959 /* Ivfg=1n A@Vgm=0V */
.set RIL_VC2_SWC, 3933 /* Ivfg=lowest current @Vgm=0V */
.set RIL_VD1_SWC, 0xfe0e /* Vd @ final stage */
.set RIL_INJ_T_SWC, 1 /* Injection time unit (*10us) */
.set RIL_NUM_SWC, 300 /* # of Recover Injection */

.set RIL_GATE_S_OTA, 0x0040 /* Gate(OTA) = gnd */
.set RIL_VC1_OTA, 3959 /* Ivfg=1n A@Vgm=0V */
.set RIL_VC2_OTA, 3931 /* Ivfg=lowest current @Vgm=0V */
.set RIL_VD1_OTA, 0x0026 /* Vd @ final stage */
.set RIL_INJ_T_OTA, 100 /* Injection time unit (*10us) */
.set RIL_NUM_OTA, 300 /* # of Recover Injection */

.set RIL_GATE_S_OTAREF, 0x0040 /* Gate(OTAREF) = gnd */
.set RIL_VC1_OTAREF, 3959 /* Ivfg=1n A@Vgm=0V */
.set RIL_VC2_OTAREF, 3925 /* Ivfg=lowest current @Vgm=0V */
.set RIL_VD1_OTAREF, 0x0026 /* Vd @ final stage */
.set RIL_INJ_T_OTAREF, 1 /* Injection time unit (*10us) */
.set RIL_NUM_OTAREF, 300 /* # of Recover Injection */

.set RIL_GATE_S_MITE, 0x0000 /* Gate(MITE) = gnd */
.set RIL_VC1_MITE, 3959 /* Ivfg=1n A@Vgm=0V */
.set RIL_VC2_MITE, 3933 /* Ivfg=lowest current @Vgm=0V */
.set RIL_VD1_MITE, 0x0026 /* Vd @ final stage */
.set RIL_INJ_T_MITE, 1 /* Injection time unit (*10us) */
.set RIL_NUM_MITE, 300 /* # of Recover Injection */

.set RIL_GATE_S_DIRSWC, 0x0040 /* Gate(DIRSWC) = gnd */
.set RIL_VC1_DIRSWC, 3959 /* Ivfg=1n A@Vgm=0V */
.set RIL_VC2_DIRSWC, 3934 /* Ivfg=lowest current @Vgm=0V */
.set RIL_VD1_DIRSWC, 0x0026 /* Vd @ final stage */
.set RIL_INJ_T_DIRSWC, 1 /* Injection time unit (*10us) */
.set RIL_NUM_DIRSWC, 300 /* # of Recover Injection */

