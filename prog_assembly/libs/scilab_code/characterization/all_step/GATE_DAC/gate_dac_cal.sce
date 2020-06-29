chip_number=01;
chip_numbers=string(chip_number)
board='_30'
cd ~/rasp30/prog_assembly/libs/scilab_code/characterization/all_step/GATE_DAC/;
path=pwd();
mkdir test;
unix_g('sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh '+path+'/gate_DAC_char '+path+'/gate_DAC_char.s43 16384 16384 16384')
mkdir test
count=0;
unix_g('> input_vector')
while count<2
counter=1;
m=0;
while m<256


gate_DAC_INPUT = mopen('input_vector','wb') 
m_hex=dec2hex(m);
gate_CTRL=string(m_hex)

if count==0 then //  for ivdd=2.5
if m<16 then
mputl('0x0'+gate_CTRL+'30 0x0024',gate_DAC_INPUT)
end
if m>15 then
mputl('0x'+gate_CTRL+'30 0x0024',gate_DAC_INPUT)
end
end

if count==1 then   //  for ivdd=6
if m<16 then
mputl('0x0'+gate_CTRL+'30 0x0014',gate_DAC_INPUT)
end
if m>15 then
mputl('0x'+gate_CTRL+'30 0x0014',gate_DAC_INPUT)
end
end
mclose(gate_DAC_INPUT)

sleep(10);
b=1;
while b==1
[a,b]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x5300 -input_file_name '+path+'/input_vector");

[a,b]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -device /dev/ttyUSB1/ -speed 115200 '+path+'/gate_DAC_char.elf');
end

sleep(10);
if count==0 then

unix_g('sudo dwfcmd connect watch=2s analogin record channel=2 enable=1 range=2V offset=0 frequency=1k run=0.01s start save='+ path +'/test/test'+gate_CTRL+'25.csv')
end
if count==1 then

unix_g('sudo dwfcmd connect watch=15s analogin record channel=2 enable=1 offset=0 frequency=1 run=10s start save='+ path +'/test/test'+gate_CTRL+'60.csv')
end



if count==0 then
M = csvRead(path+'/test/test'+gate_CTRL+'25.csv');
M=mean(M(3:10));
M=string(M)       
gate_dac_ivdd25V(counter,1) =gate_CTRL;
gate_dac_ivdd25V(counter,2) =M;
end

if count==1 then
M = csvRead(path+'/test/test'+gate_CTRL+'60.csv');
M=mean(M(3:10));
M=string(M)
gate_dac_ivdd60V(counter,1) =gate_CTRL;    
gate_dac_ivdd60V(counter,2) =M;    
end



if m<239 then
m=m+16;
end

if m>239 then
m=m+2;
end
   


counter=counter+1;
end

count=count+1;
end

mkdir gate_DAC
file_name_cal = path+'/gate_DAC/gate_DAC'+chip_numbers+board

csvWrite(gate_dac_ivdd25V,file_name_cal+'_25V')
csvWrite(gate_dac_ivdd60V,file_name_cal+'_60V')


