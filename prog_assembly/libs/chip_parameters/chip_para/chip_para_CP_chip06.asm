/**********************************/
/* CP (Coarse Program) parameters */
/**********************************/
.set    ADC_1nA,    3200          /* 1nA ADC value */

/* above & sub threshold */
.set CP_GATE_S_SWC, 0x5200 /* Gate(SWC) = 3.0V @ IVDD 6.0V */
.set CP_INJ_T_SWC, 1 /* Injection time (*10us) */
.set CP_NUM_SWC, 20 /* # of Measured Coarse Progrm */
.set CP_GATE_S_OTA, 0x4600 /* Gate(OTA) = 3.0V @ IVDD 6.0V */
.set CP_INJ_T_OTA, 3 /* Injection time (*10us) */
.set CP_NUM_OTA, 20 /* # of Measured Coarse Progrm */
.set CP_GATE_S_OTAREF, 0x4800 /* Gate(OTAREF) = 3.0V @ IVDD 6.0V */
.set CP_INJ_T_OTAREF, 6 /* Injection time (*10us) */
.set CP_NUM_OTAREF, 20 /* # of Measured Coarse Progrm */
.set CP_GATE_S_MITE, 0x4600 /* Gate(MITE) = 3.0V @ IVDD 6.0V */
.set CP_INJ_T_MITE, 3 /* Injection time (*10us) */
.set CP_NUM_MITE, 20 /* # of Measured Coarse Progrm */
.set CP_GATE_S_DIRSWC, 0x5200 /* Gate(DIRSWC) = 3.0V @ IVDD 6.0V */
.set CP_INJ_T_DIRSWC, 1 /* Injection time (*10us) */
.set CP_NUM_DIRSWC, 20 /* # of Measured Coarse Progrm */

/* low sub threshold */
.set CPL_GATE_S_SWC, 0x4400 /* Gate(SWC) = gnd */
.set CPL_INJ_T_SWC, 1 /* Injection time (*10us) */
.set CPL_NUM_SWC, 20 /* # of Measured Coarse Progrm */
.set CPL_GATE_S_OTA, 0x3000 /* Gate(OTA) = 2.5V */
.set CPL_INJ_T_OTA, 3 /* Injection time (*10us) */
.set CPL_NUM_OTA, 20 /* # of Measured Coarse Progrm */
.set CPL_GATE_S_OTAREF, 0x3000 /* Gate(OTAREF) = gnd */
.set CPL_INJ_T_OTAREF, 6 /* Injection time (*10us) */
.set CPL_NUM_OTAREF, 20 /* # of Measured Coarse Progrm */
.set CPL_GATE_S_MITE, 0x3000 /* Gate(MITE) = 2.0V */
.set CPL_INJ_T_MITE, 3 /* Injection time (*10us) */
.set CPL_NUM_MITE, 20 /* # of Measured Coarse Progrm */
.set CPL_GATE_S_DIRSWC, 0x4400 /* Gate(DIRSWC) = 1.4V */
.set CPL_INJ_T_DIRSWC, 1 /* Injection time (*10us) */
.set CPL_NUM_DIRSWC, 20 /* # of Measured Coarse Progrm */

/* high above threshold */
.set CPH_GATE_S_SWC, 0x5200 /* Gate(SWC) = gnd */
.set CPH_INJ_T_SWC, 1 /* Injection time (*10us) */
.set CPH_NUM_SWC, 20 /* # of Measured Coarse Progrm */
.set CPH_GATE_S_OTA, 0x4600 /* Gate(OTA) = 2.5V */
.set CPH_INJ_T_OTA, 3 /* Injection time (*10us) */
.set CPH_NUM_OTA, 20 /* # of Measured Coarse Progrm */

