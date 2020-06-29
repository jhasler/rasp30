		#O/PS        
		li_sm = ['gnd'             ,[0,  0],     #inputs from CAB and device outputs
			'vcc'              ,[0,  1],#y
			'cab.I[0:12]'        ,[0, range( 2, 15)],#y to be shifted for the decoder
			'vmm4x4_dummy[0:3]'	,[0,range(19,23)], #middle LI for VMM turn
			#O/PS OF CAB DEVICES
			'fgota[0:1].out[0]' ,[0, [15,16]],#y
			'ota_buf[0].out[0]' ,[0, 17],#y
			'ota[0:1].out[0]'      ,[0, [17,18]],#y
			'cap[0:3].out[0]'    ,[0, range(19, 23)],#y                                
			'nfet[0:1].out[0]'   ,[0, range(24, 22, -1)],#y numbering chnge for nFET0(24) and nFET1(23), needs to be verified
			'pfet[0:1].out[0]'   ,[0, range(26, 24,-1)],#y numbering chnge for pFETt0(26) and pFET1(23)
			'tgate[0:3].out[0]'  ,[0, range(27, 31)],#y
			'nmirror[0:1].out[0]',[0, range(31, 33)],#y
			'TIA_blk[0].out[0]'	 ,[0,17],
			'ichar_nfet[0].out[0]',[0,25],
			'c4_sp[0].out[0]'	 ,[0,15],# c4 with floating gates
			'gnd_out[0].out[0]',[0,24],
			'vdd_out[0].out[0]',[0,24],
			'in2in_x1[0].out[0]',[0,24],
			'in2in_x6[0].out[0]',[0,24],
			'ichar_nfet[0].in[0:1]' ,[[19,30],0],#vg,vd
			'lpf[0].out[0]',[0, 17],
			'nfet_i2v[0].out[0]',[0, 17], #ota0 output
			'pfet_i2v[0].out[0]',[0, 17], #ota0 output
			'i2v_pfet_gatefgota[0].out[0]',[0,17], #ota0 output
			'mismatch_meas[0].out[0]',[0,16], #fgota1 output
			'mmap_local_swc[0].out[0]'   ,[0,18+15], #chose col-18
			'ramp_fe[0].out[0:3]' , [0,[18,20,21,22]], #26
			'volswc[0:1].out[0]',[0, range(33, 35)],
			'hhneuron[0].out[0:2]',[0,[18,15,16]],#Vmem,VNa,VK
			'tgate_so[0].out[0]',[0,19],
			'ota_vmm[0].out[0]'      	,[0, 18],#y
			'vmm4x4_SR[0].out[0]'  ,[0,34], #19+15--->15 is offset for middle LI
			'vmm4x4_SR2[0].out[0]'  ,[0,34], #19+15--->15 is offset for middle LI
			'vmm8x4_SR[0].out[0]'  ,[0,34], #19+15--->15 is offset for middle LI
			'SR4[0].out[0:4]',	[0,[19,20,21,22,18+15]],#cap--ops+15, and the 18+15
			'vmm4x4[0].out[0:3]',	[0,range(19,23)],
			'vmm8x4[0].out[0]',	[0,0], #dummy output
			'vmm8inx8in[0].out[0]',	[0,19], #dummy output cap0's output
			'vmm8x4_in[0].out[0]',	[0,0], #dummy output
			'vmm12x1[0].out[0]',	[0,18], #wta output
			'sftreg[0].out[0]'   ,[0,18+15], #chose col-18
			'DAC_sftreg[0].out[0]'   ,[0,18+15], #chose col-18
			'sftreg2[0].out[0]'   ,[0,18+15], #chose col-18
			'sftreg3[0].out[0]'   ,[0,33], #chose col-18
			'sftreg4[0].out[0]'   ,[0,27], #tgate0's output
			'vmm12x1_wowta[0].out[0]',	[0,19], #vmm on cap out
			'Hyst_diff[0].out[0]',[0,18],
			'Max_detect[0].out[0]',[0,23],
			'Min_detect[0].out[0]',[0,25],
			'hhn[0].out[0]',[0,18],
			'fgswitch[0].out[0]',[0,19],
			'common_drain[0].out[0]',[0,25],
			'common_drain_nfet[0].out[0]',[0,23],
			'hhn_debug[0].out[0:2]',[0,[18,16,15]],
			'wta_new[0].out[0]',[0,17],
			'common_source[0].out[0]',[0,23],
			'VolDivide1[0].out[0]',[0,17],
			'I_SenseAmp[0].out[0]',[0,17],
			'nmirror_w_bias[0].out[0]',[0,31],
			'SubbandArray[0].out[0:1]',[0,[18,15]],
			'HH_RG[0].out[0:1]',[0,[17,23]],
			'HH_RG_2s[0].out[0:1]',[0,[17,23]],
			'HH_RG_3s[0].out[0:1]',[0,[17,23]],
			'SOSLPF[0].out[0]',[0,18],
			'MSOS02[0].out[0]',[0,18],
			'vmm_offc[0].out[0:1]',[0,[17,18]],
