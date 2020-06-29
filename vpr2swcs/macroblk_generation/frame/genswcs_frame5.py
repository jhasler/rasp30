							try:
								output_net_names[i]=nb.getSub(from_sub_name).outputs[net_num]
								net_num=net_num+1 # omcrement net number
								if net_num == len(sub_outputs):
									net_num=0
							except:
								pdb.set_trace()
						else:
							output_net_names[i] = nb.getSub(from_sub_name).outputs
				nb.outputs = output_net_names
				if verbose: print nb.outputs     
		elif block_type in ['inpad', 'outpad']:
			nb.type = 'ioslice_%s'%block_type    #global pblocksblock_type
			nb.outputs = block_name
			nb.inputs[0] = block_name
		nb.portorder = range(len(nb.inputs)+len(nb.outputs))
		nblocks[nb.name] = nb
                              
def parsePlace(file_name):
	global xarray
	f = open(file_name, 'r')
	go = False
	for line in f:
		words = line.split()
		if go:
			grid_loc = [int(words[1]), int(words[2])]
			sub_num = int(words[3])
			block_name = words[0]
			new_block = nblocks[block_name]
			new_block.grid_loc = grid_loc
			#if tile is empty: xarray.addSub(grid_loc, new_block
			#if tile is not empty: xarray.getSub(grid_loc).addSub(new_block)
			if xarray.getSub(grid_loc).type == []:
				if new_block.type[:7] == 'ioslice':
					xarray.addSub(ioblock(block_name), grid_loc)
				else:
					xarray.addSub(new_block, grid_loc)
			if new_block.type[:7] == 'ioslice':
				xarray.getSub(grid_loc).addSub(new_block, sub_num)
				# $$PROBLEM: setting port numbers for ioblocks is super hardcoded here! i blame VPR!
				if new_block.type[8:] == 'inpad':
					xarray.getSub(grid_loc).setPort(sub_num*3+1, block_name) #setting output port
				else:
					xarray.getSub(grid_loc).setPort(sub_num*3+0, block_name) #setting input port
		if len(words) and words[0] == "#----------":
			go = True
            
def parsePads(file_name):
	f = open(file_name, 'r')
	for line in f:
		words = line.split()        
		if len(words) !=0:
			grid_loc = [int(words[1]), int(words[2])]
			sub_num = int(words[3])
			io_type = words[-1]
			try:
				xarray.getSub(grid_loc).getSub(sub_num).type = io_type
			except:
				print 'oops'
				print words
				pdb.set_trace()
  
#***********************************
# Pre-parse blif file for different architecture types
#***********************************      
def parseBlif(file_name):
	f = open(file_name ,'r')
	get_cover = 0
	new_lut = 0
	macroblk=0
	for line in f:
		words = line.split()
		if len(words):
			if words[0] == '.subckt':
				subckt = words[1]
				print '%s %s'%(words[0], subckt)

				#count vmm type and num
				if subckt in ['hyst_diff']: macroblk=macroblk+1
				#a = '.subckt ota in[1] = i4  out=o3 # ota_bias 0.9 ota_p_bias 0.5 ota_n_bias 0.5'
				dev_type = line.split(' ')[1]

				if len(line.split('#')) > 1:
					ex_fgs = line.split('#')[1].rstrip()
				else:
					ex_fgs = 0

				ports = []
				for i in line.split('=')[1:]:
					port = i.lstrip().split(' ')[0].rstrip()
					ports.append(port)
				print ports                
                #key = dev_type + ' ' + ' '.join(ports) # this key is type + port list
				if subckt in ['lpf_2','meas_volt_mite','cap','ota_buf','ota_buffer','lpf','nfet_i2v','pfet_i2v','i2v_pfet_gatefgota','nmirror','TIA_blk']: ## single i/ps
					key = ports[1] #this key is just output port name ## for all cases with a single i/p- o/p
				elif subckt in ['DAC_sftreg','latch_custom','sftreg2','mmap_local_swc','in2in_x1','mismatch_meas','mite']: #3 i/ps
					key=ports[3]
				elif subckt in ['gnd_out','vdd_out','ichar_nfet','ramp_fe']: #2 i/ps
					key=ports[2]
				elif subckt in ['SR4','vmm4x4','signalmult','hhneuron','sftreg3','sftreg4']: #4 i/ps
					key=ports[4]
				elif subckt in ['vmm4x4_SR']: #7 i/ps
					key=ports[7]
				elif subckt in ['vmm4x4_SR2','tgate_so']: #8 i/ps
					key=ports[8]
				elif subckt in ['vmm8inx8in']: #17 i/ps
					key=ports[17]
				elif subckt in ['vmm8x4_SR']: #11 i/ps ,
					key=ports[11]
				elif subckt in ['vmm12x1_wowta']: #12 i/ps ,
					key=ports[12]
				elif subckt in ['vmm8x4','vmm8x4_in','in2in_x6','vmm12x1']: #13 i/ps ,
					key=ports[13]
				elif subckt in ['sftreg']: #19 i/ps ,'sftreg'
					key=ports[19]
				elif subckt in ['Hyst_diff']:
					key=ports[1]
				elif subckt in ['Max_detect']:
					key=ports[1]
				elif subckt in ['Min_detect']:
					key=ports[1]
				elif subckt in ['hhn']:
					key=ports[4]
				elif subckt in ['fgswitch']:
					key=ports[1]
				elif subckt in ['common_drain']:
					key=ports[1]
				elif subckt in ['common_drain_nfet']:
					key=ports[1]
				elif subckt in ['hhn_debug']:
					key=ports[4]
				elif subckt in ['wta_new']:
					key=ports[3]
				elif subckt in ['common_source']:
					key=ports[1]
				elif subckt in ['VolDivide1']:
					key=ports[1]
				elif subckt in ['I_SenseAmp']:
					key=ports[2]
				elif subckt in ['nmirror_w_bias']:
					key=ports[2]
				elif subckt in ['SubbandArray']:
					key=ports[2]
				elif subckt in ['HH_RG']:
					key=ports[5]
				elif subckt in ['HH_RG_2s']:
					key=ports[6]
				elif subckt in ['HH_RG_3s']:
					key=ports[7]
				elif subckt in ['SOSLPF']:
					key=ports[1]
				elif subckt in ['MSOS02']:
					key=ports[1]
				elif subckt in ['vmm_offc']:
					key=ports[13]
