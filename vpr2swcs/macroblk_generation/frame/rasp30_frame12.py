								self.swcs.append(swcx)
								if isinstance(swc2[0],int): break

class cab2(complexBlock):
	def __init__(self, name):
		self.name = name
		self.type = 'CAB2'
		self.stats = cab2Stats()     
		self.array_stats = arrayStats()
		self.subblocks = []

		#CAB ports
		self.inputs = ['open']*self.stats.num_inputs
		self.outputs = ['open']*self.stats.num_outputs

		#CAB Devices
		dev_types = self.stats.dev_types
		dev_pins = self.stats.dev_pins    
		self.addSubs(dev_types, dev_pins)

	def genLI(self, *var):
		self.swcs = []
		verbose = 0
		if len(var) == 1: verbose = 0
		# inputs to local interconnect--
		# inputs to CAB + outputs from DEVs
		self.li_in_in = ['gnd','vcc']+self.inputs
		self.li_in_dev = []
		for i in range(len(self.subblocks)):
			if isinstance(self.getSub(i).outputs,str):
				self.getSub(i).outputs= self.getSub(i).outputs.split()
			for j in range(len(self.getSub(i).outputs)):
				self.li_in_dev.append(self.getSub(i).outputs[j])
		self.li_in_dev.reverse()
		self.li_in = self.li_in_in + self.li_in_dev

		# outputs from local interconnect--
		# inputs to DEVs + outputs from CAB
		self.li_out_out = self.outputs
		self.li_out_dev = []
		for i in range(len(self.subblocks)):
			for j in range(len(self.getSub(i).inputs)):
				self.li_out_dev.append(self.getSub(i).inputs[j])      
		self.li_out = self.li_out_dev+self.li_out_out 
		self.li = [[0]*len(self.li_in) for x in self.li_out]
		#printing connectivity matrix and filling the local interconnect matrix
		x = 2
		for i in range(len(self.li_in)):
			if verbose: print '%s'%str(i).ljust(2),
		if verbose: print "Hallelujah!"
		for i in range(len(self.li_in)):
			if self.li_in[i] != 'open':
				if verbose: print '%s'%self.li_in[i].ljust(x),
			else:
				if verbose: print ''.ljust(x),
		if verbose: print
		for i in range(len(self.li_out_dev)):
			if self.li_out[i] != 'open':
				for j in range(len(self.li_in)):
					if self.li_out[i] == self.li_in[j]:
						if verbose: print str('X').ljust(x),
						self.li[i][j] = 1
					else:
						if verbose: print str('.').ljust(x),
				if verbose: 
					print self.li_out[i].ljust(2), 
					print str(i).ljust(2)
			else:
				for j in range(len(self.li_in)):
					if verbose: print str('.').ljust(x),
				if verbose: print '%s%s'%(''.ljust(3), str(i).ljust(2))
		for i in range(len(self.li_out_out)):
			for j in range(len(self.li_in_in)):
				if verbose: print ''.ljust(x),
			for j in range(len(self.li_in_dev)):
				if self.li_out_out[i] == self.li_in_dev[j] and self.li_out_out[i] != 'open':
					if verbose: print 'X'.ljust(x),
					self.li[i+len(self.li_out_dev)][j+len(self.li_in_in)] = 1
				else:
					if verbose: print '.'.ljust(x),
			if self.li_out_out[i] == 'open':
				if verbose: print self.li_out_out[i]
			else:
				if verbose: print self.li_out_out[i]

		#actually generating the switches addresses here  
		self.swcsFromLi()    

	def dispLI(self):
		self.genLI('verbose')

	def genDevFgs(self):
		print "getting here!"
		verbose = 1
		for i in range(len(self.subblocks)):
			sb = self.getSub(i)
			if sb.outputs != 'open':
				swc_name0 = sb.name
				if sb.ex_fgs:
					ex_fg=sb.ex_fgs.split("&")
					for s in range(len(ex_fg)):
						print "ok here too22"
						for j in ex_fg[s].split()[::2]:
							swc_name1 = j+'['+sb.name.split('[')[1]
							swc0 = self.stats.dev_fgs[swc_name0]
							swc2 = self.stats.dev_fgs[swc_name1]
							for n in range(len(swc2)):
								if isinstance(swc2[0],int):
									swc1=swc2
								else:
									swc1=swc2[n]
								swc = [swc0[0]+swc1[0], swc0[1]+swc1[1]]
								swcx = self.array_stats.getTileOffset(swc, self.grid_loc)
								if verbose: print '%s %s -> (%g %g) -> (%g %g)'%(swc_name0, swc_name1, swc[0], swc[1], swcx[0], swcx[1])
								if n==0 and swc_name1 not in ['translinear_fg1[0]','translinear_fg2[0]']:
									swcx.append(ex_fg[s].split('=')[1])
								if sb.name.split('[')[0] == 'meas_volt_mite' and n==0:
									swcx.append(4)
								elif swc_name1 in ['meas_fg[0]','mite_fg0[0]','mite2_fg[0]','current_ref_bias1[0]','current_ref_bias2[0]'] and n==0:
									swcx.append(4)
								elif sb.name.split('[')[0] == 'signalmult' and n==0:
									swcx.append(1)
								elif swc_name1 in 'ota2_bias[0]' and n==0:
									swcx.append(2)					    
								elif swc_name1 in ['mite_cmirror[0]']:
									swcx.append(0)
								self.swcs.append(swcx)
								if isinstance(swc2[0],int): break

class ioblock(complexBlock):
	def __init__(self, name):
		self.name = name
		self.type = 'ioblock'
		self.inputs = ['open']*12
		self.outputs= ['open']*6
		self.portorder = [0,3,6,9,12,15,1,2,4,5,7,8,10,11,13,14,16,17] ## $$
		self.num=[]
		self.swcs = []
		self.stats = iosdStats()    #$$ 
		self.array_stats = arrayStats()
		self.subblocks = []
		for i in range(6):
			self.addSub(pblock('empty', 'ioslice'))

	def genLI(self):
		#global groutes
		port_dig = ['I3','I7','I11','I15','O3','O7'] #$$
		port_ana = ['I8','I9','I13','I14','I15','O4']
		port_east = ['I4','I5','I6','I7','O2','O3']
		verbose = 1

		for i in range(len(self.subblocks)):
			csub = self.getSub(i)
			if csub.outputs != 'open':
				if(csub.grid_loc[0] in [1,4,5,8,9,12,13]):
					self.stats=iosdStats()	
					swc_name0 = port_dig[csub.number]
					swc_name1 = csub.type
				elif(csub.grid_loc[0] == 15):
					self.stats=ioeStats()
					swc_name0 = port_east[csub.number]
					swc_name1 = csub.type
				else:
					self.stats=iosaStats()		
					swc_name0 = port_ana[csub.number]
					swc_name1 = csub.type
					swc_name1 = swc_name1.strip() # strips leading and ending spaces
				if (swc_name1 == 'int[0]' or swc_name1 == '') :
					pdb.set_trace()
				if (swc_name1[1:-3] != 'int'and csub.name != 'gnd' and csub.name != 'vcc' and csub.name != 'out:gnd') :    #we'll pick these up in the devFG generation          
					print csub
					swc_name1=swc_name1[1:]
					swc0 = self.stats.li[swc_name0] #get input name
					swc1 = self.stats.li[swc_name1] #get input type
					swc = [swc0[0]+swc1[0],swc0[1]+swc1[1]]
					swcx = self.array_stats.getTileOffset(swc, self.grid_loc)
					if verbose: print '%s %s -> (%g %g) -> (%g %g)'%(swc_name0, swc_name1, swc[0], swc[1], swcx[0], swcx[1])
					self.swcs.append(swcx)

	###gendevFgs --IO BLOCK $$
	def genDevFgs(self):
		print "I/O Blocks dev FGs"
		for i in range(len(self.subblocks)):
			csub = self.getSub(i)
			if csub.outputs != 'open' and csub.type[1:-3] in ['int','tgate','ana_buff_out','ana_buff_in','dig_buff_out','dig_buff_in'] : #?? dunno why was a condition
				if(csub.grid_loc[0] in [1,4,5,8,9,12,13]):
					self.stats=iosdStats()
				elif(csub.grid_loc[0] in [15]): # IO_E case
					self.stats=ioeStats()
				else:
					self.stats=iosaStats()	
				dev_type = csub.type[1:]
				nswcs = self.stats.dev_fgs[dev_type]
				for i in range(len(nswcs)):
					swc = [nswcs[i][0],nswcs[i][1]]
					print '!!!!!!!!!!!!!!%s --> '%(dev_type),
					swcx = self.array_stats.getTileOffset(swc, self.grid_loc)
					print 'DEV FGs  -> (%g %g) -> (%g %g)'%(swc[0], swc[1], swcx[0], swcx[1])
					if csub.type[1:-3] in ['ana_buff_out','ana_buff_in'] and i==1:
						swcx.append('0.000002')
						swcx.append(2)
					self.swcs.append(swcx)
