						sub_outputs=subblock.findall("outputs")[0].findall("port")[0].text.split()
					nsb.inputs = sub_inputs	
					nsb.outputs = sub_outputs
					print nsb.outputs
					nb.addSub(nsb, sub_inst)
					if verbose: print nb.inputs
					print nb.outputs
			#now that we have all subblocks, with all of their output names
			# we can go and update the input names 
			if counter_flag == 0:
				for i in range(len(nb.subblocks)):
					cur_sub = nb.getSub(i)
					sub_inputs = cur_sub.inputs
					sub_input_names = []
					for i in range(len(sub_inputs)):
						cur_input = sub_inputs[i]                        
						if cur_input.split('.')[0] == block_type:           #input from complex block input
							in_num = int(cur_input.split('[')[-1].split(']')[0]) #cab.I[13] -> 13
							sub_input_names.append(nb.inputs[in_num])                          
						elif cur_input == 'open':                                  
							sub_input_names.append('open')
						else:     
							sub_input_names.append(nb.getSub(cur_input.split('.')[0]).outputs)
					cur_sub.inputs = sub_input_names
					if verbose: print cur_sub.inputs        
				output_net_names = outputs
				net_num=0
				for i in range(len(outputs)):
					if outputs[i] != 'open':
						from_sub_name = outputs[i].split('.')[0] #ota[0].out[0] -> ota[0]
						if from_sub_name ==['SR4[0]']:
							try:
								if i<4:
									output_net_names[i]=nb.getSub(from_sub_name).outputs[i]
								else:
									output_net_names[i]=nb.getSub(from_sub_name).outputs[i]
							except:
								pdb.set_trace()
						elif from_sub_name =='vmm4x4[0]':
							try:
								if i<5:
									output_net_names[i]=nb.getSub(from_sub_name).outputs[i]
								else:
									pdb.set_trace()
									output_net_names[i]=nb.getSub(from_sub_name).outputs[i]
							except:
								pdb.set_trace()
