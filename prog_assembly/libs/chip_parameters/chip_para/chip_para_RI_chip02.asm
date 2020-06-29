/* RI (Recover Injection Above & Sub threshold) parameters */
.set RI_GATE_S_SWC, 0x0040 /* Gate(SWC) = gnd */
.set    RI_VC1_SWC,     0x177f          /* Verify Current 1 for SWC recover injection = 30nA @ Vgm=0V -> 1nA @ Vgm = 0.6V */
.set    RI_VC2_SWC,     0x16c6          /* Verify Current 1 for SWC recover injection = 20nA @ Vgm=0V */
.set    RI_VC3_SWC,     0x145c           /* Verify Current 1 for SWC recover injection = 5nA @ Vgm=0V */
.set    RI_VC4_SWC,     0x1190           /* Verify Current 1 for SWC recover injection = 1nA @ Vgm=0V */
.set RI_VD1_SWC, 0xea0e /* Vd @ final stage */
.set RI_VD2_SWC, 0xfe0e /* Vd @ pre-final stage */
.set RI_INJ_T_SWC, 1 /* Injection time unit (*10us) */
.set RI_NUM_SWC, 300 /* # of Recover Injection */

.set RI_GATE_S_OTA, 0x0000 /* Gate(OTA) = 2.5V */
.set    RI_VC1_OTA,     0x1a2f           /* Verify Current 1 for OTA recover injection = 129nA @ Vgm=0V -> 1nA @ Vgm = 0.6V */
.set    RI_VC2_OTA,     0x1976          /* Verify Current 1 for OTA recover injection =  88nA @ Vgm=0V */
.set    RI_VC3_OTA,     0x170c           /* Verify Current 1 for OTA recover injection = 23nA @ Vgm=0V */
.set    RI_VC4_OTA,     0x1440           /* Verify Current 1 for OTA recover injection = 5nA @ Vgm=0V */
.set RI_VD1_OTA, 0xea0e /* Vd @ final stage */
.set RI_VD2_OTA, 0xfe0e /* Vd @ pre-final stage */
.set RI_INJ_T_OTA, 1 /* Injection time unit (*10us) */
.set RI_NUM_OTA, 300 /* # of Recover Injection */

.set RI_GATE_S_OTAREF, 0x0040 /* Gate(OTAREF) = gnd */
.set    RI_VC1_OTAREF,  0x177f              /* Verify Current 1 for OTAREF recover injection = 30nA @ Vgm=0V -> 1nA @ Vgm = 0.6V */
.set    RI_VC2_OTAREF,  0x16c6             /* Verify Current 1 for OTAREF recover injection = 20nA @ Vgm=0V */
.set    RI_VC3_OTAREF,  0x145c              /* Verify Current 1 for OTAREF recover injection = 5nA @ Vgm=0V */
.set    RI_VC4_OTAREF,  0x1190              /* Verify Current 1 for OTAREF recover injection = 1nA @ Vgm=0V */
.set RI_VD1_OTAREF, 0xea0e /* Vd @ final stage */
.set RI_VD2_OTAREF, 0xfe0e /* Vd @ pre-final stage */
.set RI_INJ_T_OTAREF, 1 /* Injection time unit (*10us) */
.set RI_NUM_OTAREF, 300 /* # of Recover Injection */

.set    RI_GATE_S_MITE,    0x0000          /* Gate_S voltage for MITE recover injection = 2.5V @ IVDD 6.0V */
.set    RI_VC1_MITE,    0x1b2f           /* Verify Current 1 for MITE recover injection = 215nA @ Vgm=0V -> 1nA @ Vgm = 0.6V */
.set    RI_VC2_MITE,    0x1a76           /* Verify Current 1 for MITE recover injection =  149nA @ Vgm=0V */
.set    RI_VC3_MITE,    0x180c            /* Verify Current 1 for MITE recover injection = 41nA @ Vgm=0V */
.set    RI_VC4_MITE,    0x1540            /* Verify Current 1 for MITE recover injection = 8nA @ Vgm=0V */
.set RI_VD1_MITE, 0xea0e /* Vd @ final stage */
.set RI_VD2_MITE, 0xfe0e /* Vd @ pre-final stage */
.set RI_INJ_T_MITE, 1 /* Injection time unit (*10us) */
.set RI_NUM_MITE, 300 /* # of Recover Injection */

.set    RI_GATE_S_DIRSWC,     0x0000          /* Gate_S voltage for SWC recover injection = 2.5V */
.set    RI_VC1_DIRSWC,     5970          /* Verify Current 1 for SWC recover injection = nA @ Vgm=0V -> 1nA @ Vgm = 0.6V */
.set    RI_VC2_DIRSWC,     5822          /* Verify Current 1 for SWC recover injection = nA @ Vgm=0V */
.set    RI_VC3_DIRSWC,     4779           /* Verify Current 1 for SWC recover injection = nA @ Vgm=0V */
.set    RI_VC4_DIRSWC,     4493           /* Verify Current 1 for SWC recover injection = 1nA @ Vgm=0V */
.set    RI_VD1_DIRSWC,     0xbe0e          /* Drain Voltage for recover injection final stage */
.set    RI_VD2_DIRSWC,     0xd00e          /* Drain Voltage for recover injection pre-final stage */
.set RI_INJ_T_DIRSWC, 1 /* Injection time unit (*10us) */
.set RI_NUM_DIRSWC, 300 /* # of Recover Injection */

/* RIL (Recover Injection low sub threshold) parameters */
.set    RIL_GATE_S_SWC,     0x0040          /* Gate_S voltage for SWC low sub Vth recover injection = gnd */
.set    RIL_VC1_SWC,     0x1190          /* Verify Current 1 for SWC low sub Vth recover injection = 1nA @ Vgm = 0V */   /* ???? */
.set    RIL_VC2_SWC,     0x10d0          /* Verify Current 1 for SWC low sub Vth recover injection = hundreds pA below 1nA @ Vgm=0V */
.set    RIL_VD1_SWC,     0xea0e          /* Drain Voltage for recover injection final stage */
.set RIL_INJ_T_SWC, 1 /* Injection time unit (*10us) */
.set RIL_NUM_SWC, 300 /* # of Recover Injection */

.set    RIL_GATE_S_OTA,    0x0000          /* Gate_S voltage for OTA low sub Vth recover injection = 2.5V @ IVDD 6.0V */
.set    RIL_VC1_OTA,     0x1190           /* Verify Current 1 for OTA low sub Vth recover injection = 1nA @ Vgm=0V */     /* ???? */
.set    RIL_VC2_OTA,     0x1100          /* Verify Current 1 for OTA low sub Vth recover injection =  hundreds pA below 1nA @ Vgm=0V */
.set    RIL_VD1_OTA,     0xea0e          /* Drain Voltage for recover injection final stage */
.set RIL_INJ_T_OTA, 1 /* Injection time unit (*10us) */
.set RIL_NUM_OTA, 300 /* # of Recover Injection */

.set    RIL_GATE_S_OTAREF,    0x0040          /* Gate_S voltage for OTAREF low sub Vth recover injection = gnd */
.set    RIL_VC1_OTAREF,  0x1190              /* Verify Current 1 for OTAREF low sub Vth recover injection = 1nA @ Vgm=0V */   /* ???? */
.set    RIL_VC2_OTAREF,  0x1100             /* Verify Current 1 for OTAREF low sub Vth recover injection = hundreds pA below 1nA @ Vgm=0V */
.set    RIL_VD1_OTAREF,  0xea0e          /* Drain Voltage for recover injection final stage */
.set RIL_INJ_T_OTAREF, 1 /* Injection time unit (*10us) */
.set RIL_NUM_OTAREF, 300 /* # of Recover Injection */

.set    RIL_GATE_S_MITE,    0x0000          /* Gate_S voltage for MITE low sub Vth recover injection = 2.5V @ IVDD 6.0V */
.set    RIL_VC1_MITE,    0x1190           /* Verify Current 1 for MITE low sub Vth recover injection = 1nA @ Vgm=0V */     /* ???? */
.set    RIL_VC2_MITE,    0x1100           /* Verify Current 1 for MITE rlow sub Vth ecover injection =  hundreds pA below 1nA @ Vgm=0V */
.set    RIL_VD1_MITE,    0xea0e          /* Drain Voltage for recover injection final stage */
.set RIL_INJ_T_MITE, 1 /* Injection time unit (*10us) */
.set RIL_NUM_MITE, 300 /* # of Recover Injection */

.set    RIL_GATE_S_DIRSWC,     0x0040          /* Gate_S voltage for SWC low sub Vth recover injection = gnd */
.set    RIL_VC1_DIRSWC,     4493          /* Verify Current 1 for SWC low sub Vth recover injection = 1nA @ Vgm = 0V */   /* ???? */
.set    RIL_VC2_DIRSWC,     4383          /* Verify Current 1 for SWC low sub Vth recover injection = hundreds pA below 1nA @ Vgm=0V */
.set    RIL_VD1_DIRSWC,     0xea0e          /* Drain Voltage for recover injection final stage */
.set RIL_INJ_T_DIRSWC, 1 /* Injection time unit (*10us) */
.set RIL_NUM_DIRSWC, 300 /* # of Recover Injection */

