 cd ~/RASP_Workspace/RASP_Workspace/DAC_calibration1
  path =  pwd();
 dirpwd = pwd()+'/';
 chip_number=17;
chip_number=string(chip_number);
 DAC_numbers=0;
clear DAC_cal_table
clear m
clear M
clear h
clear T
mkdir('DAC_cal'+chip_number)
mkdir('DAC_cal')

while DAC_numbers<9
 
 DAC_number =string(DAC_numbers);
 file_name=path+'/DAC.pads'
 [path,fname,extension]=fileparts(file_name);
 
DAC_blif = mopen(path+'/DAC.blif','wb')
mputl('.model DAC01',DAC_blif)
mputl('.inputs net1_1 net3_1',DAC_blif)
mputl('.outputs net2_1 net3_1',DAC_blif)
mputl('#LPF',DAC_blif)
mputl('.subckt ota in[0]=net1_1 in[1]=net2_1 out[0]=net2_1 ',DAC_blif)
mputl('.end',DAC_blif)
mclose(DAC_blif)

DAC_pads = mopen(path+'/DAC.pads','wb')
if DAC_numbers==0 then
mputl('net3_1 9 0 1 #int[1]',DAC_pads)
end
if DAC_numbers==1 then
mputl('net3_1 9 0 2 #int[2]',DAC_pads)
end
if DAC_numbers==2 then
mputl('net3_1 8 0 5 #int[5]',DAC_pads)
end
if DAC_numbers==3 then
mputl('net3_1 9 0 3 #int[3]',DAC_pads)
end
if DAC_numbers==4 then
mputl('net3_1 9 0 4 #int[4]',DAC_pads)
end
if DAC_numbers==5 then
mputl('net3_1 9 0 5 #int[5]',DAC_pads)
end
if DAC_numbers==6 then
mputl('net3_1 10 0 0 #int[0]',DAC_pads)
end
if DAC_numbers==7 then
mputl('net3_1 10 0 1 #int[1]',DAC_pads)
end
if DAC_numbers==8 then
mputl('net3_1 10 0 2 #int[2]',DAC_pads)
end

mputl('net1_1 11 0 0 #tgate[0]',DAC_pads)
mputl('out:net2_1 12 0 0 #tgate[0]',DAC_pads)
mputl('out:net3_1 9 0 0 #tgate[0]',DAC_pads)
mclose(DAC_pads)

unix_g('python ~/rasp30/vpr2swcs/genswcs.py -c '+path+'/DAC -d '+path)

path=pwd()
file_name= path + '/DAC.swcs'
[path,fname,extension]=fileparts(file_name);

unix_g('> input_vector')
DAC_INPUT = mopen('input_vector','wb') 
mputl('0x0001 0x0004 0x03e8 0x0001 0xFFFF',DAC_INPUT)
mclose(DAC_INPUT)

Program_SwcList_callback




//DAC calibration *******************************

path = pwd()
file_name = path + '/.DAC';
DAC_file = path+'/DAC_cal' ;
DAC_file1 = path+'/DAC_cal'+chip_number ;

m=01
count=1
m_bar=128
while m<128
    
T=dec2hex(m);
T_bar=dec2hex(m_bar);
h= string(T);
h_bar= string(T_bar);
y = mopen(file_name + '/input_vector','wb')


if m<10 then  
mputl('0x0001 0x03fd 0x03e8 0x'+h_bar+'0'+ h +' 0x'+h_bar+'0'+ h +' 0x'+h_bar+'0'+ h +' 0x'+h_bar+'0'+ h +' 0x'+h_bar+'0'+ h +' 0xFFFF',y)
mclose(y)
end

if m>10 then
mputl('0x0001 0x03fd 0x03e8 0x'+h_bar + h +' 0x'+h_bar + h +' 0x'+h_bar + h +' 0x'+h_bar + h +' 0x'+h_bar + h +' 0xFFFF',y)
mclose(y)
end



//DC setup steps****************
unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name '+path+'/.DAC/input_vector");

unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4200 -input_file_name '+path+'/.DAC/output_info");

unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl -device /dev/ttyUSB1/ -speed 115200 '+path+'/.DAC/voltage_meas.elf");
//***************


disp('DC setup done');
unix_g('sudo dwfcmd connect watch=2s analogin record channel=1 enable=1 range=2.5 offset=0 frequency=1k run=0.01s start save='+ DAC_file +'/test'+h+'.csv')

M = csvRead(DAC_file+'/test'+h+'.csv');
M=mean(M(2:10));
if DAC_numbers==0 | DAC_numbers==2 | DAC_numbers==4 | DAC_numbers==6 | DAC_numbers==8 then
if m<10 then
DAC_cal_table(count,1) =string(0)+h;    
end
if m>10 then
DAC_cal_table(count,1) =h;
disp('here')
end
end
if DAC_numbers==1 | DAC_numbers==3 | DAC_numbers==5 | DAC_numbers==7 | DAC_numbers==9 then
if m<10 then
DAC_cal_table(count,1) =string(0)+h_bar;    
end
if m>10 then
DAC_cal_table(count,1) =h_bar;   
end
end


M=string(M)
DAC_cal_table(count,2) =M;
count=count+1;
m=m+15;
m_bar=m_bar+15;
end
//********************************

file_name_cal = DAC_file1 + '/DAC' +  DAC_number +'.csv'
csvWrite(DAC_cal_table,file_name_cal)











DAC_numbers=DAC_numbers+1;
end
