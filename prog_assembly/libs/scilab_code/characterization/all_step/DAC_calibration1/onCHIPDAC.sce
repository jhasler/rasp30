  path =  pwd();
 dirpwd = pwd()+'/';
 DAC_numbers=0;
clear DAC_cal_table
clear m
clear M
clear h
clear T
 
while DAC_numbers<1
 
 DAC_number =string(DAC_numbers);
 file_name='~/RASP_Workspace/RASP_Workspace/DAC_calibration1/DAC.pads'
 [path,fname,extension]=fileparts(file_name);

DAC_pads = mopen('~/RASP_Workspace/RASP_Workspace/DAC_calibration1/DAC.pads','wb')
if DAC_numbers==0 then
mputl('net3_1 9 0 1 #int[1]',DAC_pads)
end
if DAC_numbers==1 then
mputl('net3_1 9 0 2 #int[2]',DAC_pads)
end
if DAC_numbers==2 then
mputl('net3_1 8 0 5 #int[5]',DAC_pads)
end
if DAC_number==3 then
mputl('net3_1 9 0 3 #int[3]',DAC_pads)
end
if DAC_numbers==4 then
mputl('net3_1 9 0 4 #int[4]',DAC_pads)
end
if DAC_number==5 then
mputl('net3_1 9 0 5 #int[5]',DAC_pads)
end
if DAC_numbers==6 then
mputl('net3_1 10 0 0 #int[0]',DAC_pads)
end
if DAC_number==7 then
mputl('net3_1 10 0 1 #int[1]',DAC_pads)
end
if DAC_numbers==8 then
mputl('net3_1 10 0 2 #int[2]',DAC_pads)
end

mputl('net1_1 11 0 0 #tgate[0]',DAC_pads)
mputl('out:net2_1 12 0 0 #tgate[0]',DAC_pads)
mputl('out:net3_1 9 0 0 #tgate[0]',DAC_pads)
mclose(DAC_pads)

unix_g('python ~/rasp30/vpr2swcs/genswcs.py -c ~/RASP_Workspace/RASP_Workspace/DAC_calibration1/DAC -d ~/RASP_Workspace/RASP_Workspace/DAC_calibration1/ ')

file_name='~/RASP_Workspace/RASP_Workspace/DAC_calibration1/DAC.swcs'
[path,fname,extension]=fileparts(file_name);

unix_g('> input_vector')
DAC_INPUT = mopen('input_vector','wb') 
mputl('0x0001 0x0004 0x03e8 0x0001 0xFFFF',DAC_INPUT)
mclose(DAC_INPUT)

Program_SwcList_callback
DAC_numbers=DAC_numbers+1;
end
