			'fgota[0].in[0:1]' ,[[33,32], 0],
			'fgota[1].in[0:1]' ,[[31,30], 0],
			'ota_buf[0].in[0]' ,  [29, 0],# in<0:7> y
			'ota[0].in[0:1]'     ,[[29, 28], 0],# in<0:7> y
			'cap[0:3].in[0]'     ,[range(25,21,-1), 0],# in<8:11 y
			'nfet[0:1].in[0:1]'  ,[[19, 18, 21, 20], 0],# in<12:15> y 21, 17,-1) it's flipped
			'pfet[0:1].in[0:1]'  ,[[15, 14, 17, 16], 0],# in<16:19> n---change (17, 13,-1) it;s flipped
			'tgate[0:3].in[0:1]' ,[range(13,5,-1), 0],# in<20:27> y
			'nmirror[0:1].in[0]' ,[range(5,3,-1), 0],# in<28:29> y
			'c4_sp[0].in[0:1]'   ,[[33,25],0],
			'gnd_out[0].in[0:1]'	 ,[[19,33],0],
			'vdd_out[0].in[0:1]'	 ,[[19,33],0],
			'in2in_x1[0].in[0:2]'	  ,[[19,33,33],0],
			'in2in_x6[0].in[0:12]'	  ,[[19,33,33,32,32,31,31,30,30,29,29,28,28],0],
			'lpf[0].in[0]'	 ,[29,0],
			'nfet_i2v[0].in[0]',[29,0],
			'pfet_i2v[0].in[0]',[29,0],
			'i2v_pfet_gatefgota[0].in[0]',[29,0], #ota0's in0
			'mismatch_meas[0].in[0:2]',[[12,13,11],0], #tgate0's in, s and tgate1's s
			'TIA_blk[0].in[0]'   ,[26,0],
			'ramp_fe[0].in[0:1]' , [[31,13],0],
			'hhneuron[0].in[0:3]',[[25,16,26,33],0],#Vin,ENa,EK,Vref27
			'ota_vmm[0].in[0:1]'     ,[range(27,25,-1), 0],# in<0:7> y
			'sftreg3[0].in[3]'   ,[21,0], 
			'sftreg4[0].in[3]'   ,[13,0], #tgate0's sel 
			'tgate_so[0].in[0:7]'	  ,[[12,21,10,19,8,17,6,15],0],
			'vmm4x4_SR[0].in[0:3]'	,[[33,32,31,30],0], #connection lines to turn into shift register
			'vmm4x4_SR2[0].in[0:7]'	,[[33,32,31,30,0,0,0,25],0], #connection lines to turn into shift register
			'vmm8x4_SR[0].in[0:7]'	,[[33,32,31,30,33,32,31,30],0], #connection lines to turn into shift register
			'vmm8x4[0].in[0:12]'	,[[33,32,31,30,33,32,31,30,33,32,31,30,29],0], #connection lines to turn into shift register ---check
			'vmm8inx8in[0].in[0]'	,[25,0], #dummy input cap0's input
			'vmm8x4_in[0].in[0:12]'	,[[33,32,31,30,33,32,31,30,33,32,31,30,29],0], #in[0]~[7] will be ignored by genu.py
			'vmm12x1[0].in[0:12]'	,[[19,19,19,19,19,19,19,19,19,19,19,19,21],0], #VMM_WTA INPUTS------------------------------------------------------here --------------------------------------------------
			'vmm12x1_wowta[0].in[0:11]'	,[[19,19,19,19,19,19,19,19,19,19,19,19],0], #VMM only------------------------------------------------------here --------------------------------------------------
			'SR4[0].in[0:3]'	,[[25,0,0,0],0], ## FG-OTAs input is now blocked
			'vmm4x4[0].in[0:3]'	,[[33,32,31,30],0],
			'Hyst_diff[0].in[0]',[27,0],
			'Max_detect[0].in[0]',[29,0],
			'Min_detect[0].in[0]',[29,0],
			'hhn[0].in[0:3]',[[29,16,20,31],0],
			'fgswitch[0].in[0]',[21,0],
			'common_drain[0].in[0]',[17,0],
			'common_drain_nfet[0].in[0]',[21,0],
			'hhn_debug[0].in[0:3]',[[29,16,20,31],0],
			'wta_new[0].in[0:2]',[[19,21,20],0],
			'common_source[0].in[0]',[21,0],
			'VolDivide1[0].in[0]',[29,0],
			'I_SenseAmp[0].in[0:1]',[[28,29],0],
			'nmirror_w_bias[0].in[0:1]',[[25,24],0],
			'SubbandArray[0].in[0:1]',[[33,25],0],
			'HH_RG[0].in[0:4]',[[24,16,20,31,27],0],
			'HH_RG_2s[0].in[0:5]',[[24,23,16,20,31,27],0],
			'HH_RG_3s[0].in[0:6]',[[24,23,22,16,20,31,27],0],
			'SOSLPF[0].in[0]',[33,0],
			'MSOS02[0].in[0]',[33,0],
			'vmm_offc[0].in[0:12]',[[6,7,8,9,10,11,12,13,14,15,16,17,27],0],
