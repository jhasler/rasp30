chip_number=01;
chip_numbers=string(chip_number)
board='_30'
cd ~/rasp30/prog_assembly/libs/scilab_code/characterization/all_step/DRAIN_DAC/;
path=pwd();
mkdir test;
unix_g('sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh '+path+'/drain_DAC_char '+path+'/drain_DAC_char.s43 16384 16384 16384')
mkdir test
count=0;

while count<2
counter=1;
m=0;
reset_count=0
while m<256

unix_g('> input_vector')
DRAIN_DAC_INPUT = mopen('input_vector','wb') 
m_hex=dec2hex(m);
DRAIN_CTRL=string(m_hex)

if count==0 then //  for ivdd=2.5
if m<16 then
mputl('0x0'+DRAIN_CTRL+'4e 0x0024',DRAIN_DAC_INPUT)
end
if m>15 then
mputl('0x'+DRAIN_CTRL+'4e 0x0024',DRAIN_DAC_INPUT)
end
end

if count==1 then   //  for ivdd=6
if m<16 then
mputl('0x0'+DRAIN_CTRL+'4e 0x0014',DRAIN_DAC_INPUT)
end
if m>15 then
mputl('0x'+DRAIN_CTRL+'4e 0x0014',DRAIN_DAC_INPUT)
end
end
mclose(DRAIN_DAC_INPUT)
b=1
while b==1

[a,b]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x5300 -input_file_name '+path+'/input_vector");


[a,b]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -device /dev/ttyUSB1/ -speed 115200 '+path+'/drain_DAC_char.elf')

end

unix_w("sleep 2");
if count==0 then

unix_g('sudo dwfcmd connect watch=2s analogin record channel=1 enable=1 range=1V offset=0 frequency=1k run=0.01s start save='+ path +'/test/test'+DRAIN_CTRL+'.csv')
end
if count==1 then

unix_g('sudo dwfcmd connect watch=2s analogin record channel=1 enable=1 range=2.5V offset=0 frequency=1k run=0.01s start save='+ path +'/test/test'+DRAIN_CTRL+'.csv')
end


M = csvRead(path+'/test/test'+DRAIN_CTRL+'.csv');
M=mean(M(3:10));
M=string(M)
if count==0 then
drain_dac_ivdd25V(counter,1) =DRAIN_CTRL;
drain_dac_ivdd25V(counter,2) =M;
end

if count==1 then
drain_dac_ivdd60V(counter,1) =DRAIN_CTRL;    
drain_dac_ivdd60V(counter,2) =M;    
end

if reset_count==10 then
   unix_s('/home/ubuntu/rasp30/sci2blif/usbreset');
   reset_count=0;
end


m=m+5;
counter=counter+1;
reset_count=reset_count+1;
end

count=count+1;
end

mkdir DRAIN_DAC
file_name_cal = path+'/DRAIN_DAC/DRAIN_DAC'+chip_numbers+board

csvWrite(drain_dac_ivdd25V,file_name_cal+'_25V')
csvWrite(drain_dac_ivdd60V,file_name_cal+'_60V')


