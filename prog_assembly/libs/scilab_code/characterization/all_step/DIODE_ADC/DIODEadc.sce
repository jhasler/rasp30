clc;
cd ~/rasp30/prog_assembly/libs/scilab_code/characterization/all_step/DIODE_ADC/;
chip_number=01;
chip_numbers=string(chip_number)
board='_30'
clear current
clear DIODE_ADC
clear ADC_meas
path=pwd();
mkdir test;
mkdir ADC_value;
unix_g('sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh '+path+'/diode_char '+path+'/diode_char.s43 16384 16384 16384')
h=openserial("/dev/ttyUSB0, "9600,n,8,1"); //please make sure all the tty values are correct before starting the program.
writeserial(h,"++addr 15"+ascii(10));
unix_w("sleep 1");
writeserial(h,"++auto 1"+ascii(10));
unix_w("sleep 1");
writeserial(h,"SYST:ZCH 0"+ascii(10));
m=1;
i=2;
while m<25


unix_g('sudo dwfcmd connect target=analogout channel=0 enable=1 function=dc offset="+string(i)+"V run=0 start finish');

b=1;
while b==1


[a,b]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -device /dev/ttyUSB1/ -speed 115200 '+path+'/diode_char.elf')

[a,b]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -device /dev/ttyUSB1/ -start_address 0x5000 -length 1 -output_file_name '+path+'/ADC_value/ADC_value.hex');

if b==1 then
    disp('Connecting')
end
end

writeserial(h,"READ?"+ascii(10));
xpause(500000);
temp_a=readserial(h);
temp_b=part(temp_a,1:14);
current(1,1)=msscanf(temp_b,"%lg")
//writeserial(h,"SYST:LOC"+ascii(10));

while current ==[] 
writeserial(h,"READ?"+ascii(10));
xpause(500000);
temp_a=readserial(h);
temp_b=part(temp_a,1:14);
current(1,1)=msscanf(temp_b,"%lg")    
end

while current >=9.900D+37 
writeserial(h,"READ?"+ascii(10));
xpause(500000);
temp_a=readserial(h);
temp_b=part(temp_a,1:14);
current(1,1)=msscanf(temp_b,"%lg")    
end


unix_g('sudo dwfcmd connect target=analogout channel=0 enable=1 function=dc offset="+string(i)+"V run=0 start watch=2s analogin record channel=1 enable=1 range=2V offset=0 frequency=1k run=0.01s start save='+ path +'/test/test.csv')


DIODE_ADC(m,1)=string(i);

DIODE_ADC(m,2)=string(current);

ADC_meas=csvRead(path+'/test/test.csv');
ADC_meas=mean(ADC_meas(2:10))
DIODE_ADC(m,3)=string(ADC_meas);

ADC_value=mopen(path+'/ADC_value/ADC_value.hex','rt')
ADC_hex_value=mgetl(ADC_value);
mclose(ADC_value);
DIODE_ADC(m,4)=string(ADC_hex_value);



m=m+1;
i=i+0.05;
end

mkdir DIODE_ADC
file_name_cal = path+'/DIODE_ADC/DIODE_ADC'+chip_numbers+board

csvWrite(DIODE_ADC,file_name_cal)
writeserial(h,"SYST:ZCH 1"+ascii(10));
closeserial(h)
