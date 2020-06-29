myVariable = linspace(0.2,2.5,24) ;
chip_number=17;
chip_numbers=string(chip_number)
 path =  pwd();
count=1;
m=1;
counts=string(count)
m_place=string(m);
mkdir MITE_FG_CAL
while count<15

MITE_blif = mopen(path+'/mite_FG.blif','wb')
mputl('.model mite_FG',MITE_blif)
mputl('.inputs net1_1',MITE_blif)
mputl('.outputs gnd',MITE_blif)
mputl('.subckt meas_volt_mite in[0]=net1_1 out[0]=gnd #meas_fg =0.00001 ',MITE_blif)
mputl('.end',MITE_blif)
mclose(MITE_blif)

MITE_pads = mopen(path+'/mite_FG.pads','wb')
mputl('out:gnd 7 0 2',MITE_pads)
mputl('net1_1 9 0 1 #int[1]',MITE_pads)
mclose(MITE_pads)
m_place=string(m_place);
MITE_place = mopen(path+'/mite_FG.place','w')
mputl('Netlist file: /home/ubuntu/RASP_Workspace/RASP_Workspace/Step_1/mite_FG/mite_FG.net   Architecture file: /home/ubuntu/rasp30/vpr2swcs/./arch/rasp3_arch.xml',MITE_place)
mputl('Array size: 14 x 14 logic blocks',MITE_place)
mputl(' ',MITE_place)
mputl('#block name	x	y	subblk	block number',MITE_place)
mputl('#----------	--	--	------	------------',MITE_place)
mputl('gnd  14 '+m_place+' 0 #0',MITE_place)
mputl('out:gnd  7 0 2 #1',MITE_place)
mputl('net1_1  9 0 1 #2',MITE_place)
mclose(MITE_place);
path=pwd();
python_script='python ~/rasp30/vpr2swcs/genswcs.py -c '+path+'/mite_FG -d '+path+' -route'
unix_g(python_script)

path =  pwd();
file_name= path + '/mite_FG.swcs'
[path,fname,extension]=fileparts(file_name);
 path=pwd();
unix_g('> input_vector')
DAC_INPUT = mopen('input_vector','wb') 
mputl('0x0018 0x0004 0x2710 0x007c 0x007b 0x0079 0x0078 0x0076 0x0075 0x0073 0x0072 0x0070 0x006e 0x006c 0x006a 0x0068 0x0066 0x0064 0x0061 0x005e 0x005b 0x0057 0x0053 0x004d 0x0045 0x0038 0x0029 0xFFFF',DAC_INPUT)
mclose(DAC_INPUT)


Program_SwcList_callback;

unix_w("sleep 5");

unix_g('>'+path+'/.mite_FG/input_vector_for_graph')
DAC_INPUT_graph = mopen(path+'/.mite_FG/input_vector_for_graph','wb') 
mputl('0x0018 0x0004 0x2710 0x007c 0x007b 0x0079 0x0078 0x0076 0x0075 0x0073 0x0072 0x0070 0x006e 0x006c 0x006a 0x0068 0x0066 0x0064 0x0061 0x005e 0x005b 0x0057 0x0053 0x004d 0x0045 0x0038 0x0029 0xFFFF',DAC_INPUT_graph)
mclose(DAC_INPUT_graph)


unix_g('>'+path+'/.mite_FG/DAC_mapping_info')
DAC_map=mopen(path+'/.mite_FG/DAC_mapping_info')
mputl('No_use No_use myVariable_1',DAC_map);
mclose(DAC_map);



clc;
disp('Programmer done');
Take_Data_callback

unix_w("sleep 5");


Output_data=csvRead(path+'/output_data.csv')

MITE_FG(:,2)=string(Output_data(:,2))

y=mopen(path+'/.mite_FG/output_vector')
Output_vector=mgetl(y);
i=3;
counter=1
while counter<25
New_output(counter,1) = part(Output_vector(1,1),i:i+3);
counter=counter+1;
i=i+7;
end
mclose(y)
MITE_FG(:,1)=New_output
path =pwd();
filename_cal=path+'/MITE_FG_CAL/MITE_CAL'+counts+'_'+chip_numbers;
csvWrite(MITE_FG,filename_cal)
count=count+1;
m=m+1;
m_place=string(m);
counts=string(count)
unix_g('rm '+path+'mite_FG.swcs')
unix_w("sleep 5");
mclose all;
end

