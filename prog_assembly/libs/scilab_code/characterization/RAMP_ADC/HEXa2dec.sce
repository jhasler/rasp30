clear Output
clear Output_dec
clear New_output
clear Input
clear y
//myVariable=linspace(0.2,1.7,100);
noDAC=0;     //if you are using external voltages set it to 1
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;
//chip_number=string(06)
[y,err]=unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh '+path+'adc_int ~/rasp30/prog_assembly/libs/asm_code/Ramp_ADC_DAC.s43 16384 16384 16384")

if noDAC==1 then
unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh '+path+'adc_int ~/rasp30/prog_assembly/libs/asm_code/Ramp_ADC_noDAC.s43 16384 16384 16384")
end

if noDAC==0 then
[a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name '+hid_dir+'/input_vector");
end  


[y,err]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl -device /dev/ttyUSB1 '+path+'/adc_int.elf');

xpause(100);
err=1;
while err==1

[y,err]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -device /dev/ttyUSB1/ -start_address 0x5000 -length 1 -output_file_name "+path+"output_vector.txt");
end
y = mopen(path+'output_vector.txt','rt')
Output=mgetl(y);
New_output(1,1) = part(Output(1,1),3:7);
Output_dec(1,:) = msscanf(New_output(1,:),'%x'); //scan with hexadecimal format

length_out= Output_dec(1) - 24576;
length_out=length_out/2;
unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -device /dev/ttyUSB1/ -start_address 0x6000 -length "+string(length_out)+" -output_file_name "+path+"output_vector.txt");
y = mopen(path+"output_vector.txt','rt')
Output=mgetl(y);


m=1
i=3
while m<length_out+1
New_output(m,1) = part(Output(1,1),i:i+3);
m=m+1;
i=i+7;
end
clear Output_dec
m=1
while m<length_out+1
Output_dec(m,:) = msscanf(New_output(m,:),'%x'); //scan with hexadecimal format   
m=m+1;
end
m=1


figure();
plot(Output_dec);

//abort
global board_num
char_adc=1 //set it to 0 if you have characterized you adc 
if char_adc==1 then
    figure();
plot(Output_dec);
clear char
char(:,1)=myVariable;
char(:,2)=Output_dec;
chip_number=string(chip_num)
select board_num
case 2 then
csvWrite(char,'./Ramp_ADC_char_'+chip_number+'.csv')
unix_g('sudo cp ./Ramp_ADC_char_'+chip_number+'.csv ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/')
case 3 then
csvWrite(char,'./Ramp_ADC_char_30a_'+chip_number+'.csv')
unix_g('sudo cp ./Ramp_ADC_char_30a_'+chip_number+'.csv ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/')
end
//unix_g('sudo cp ./Ramp_ADC_char_'+chip_number+'.csv ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/')
end

convert=1;//set it to 1 if you want to convert to voltage if there exists a char file

if convert==1 then

select board_num
case 2 then
ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_'+chip_num+'.csv')
case 3 then
ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_30a_'+chip_num+'.csv')
end

RAMP_ADC_Output_voltage=interp1(ramp_adc_char(:,2),ramp_adc_char(:,1),Output_dec,'nearest')
//figure();
//plot(Input,Output_dec);
figure();
plot(RAMP_ADC_Output_voltage);
mclose('all')
csvWrite(RAMP_ADC_Output_voltage,'RAMP_ADC_Output_voltage.csv')
 
unix_g('mv '+path+'adc_int.elf '+hid_dir)


unix_g('mv '+path+'adc_int.elf '+hid_dir)
//csvWrite(Output_dec,'triangle1.csv')
end

 
mclose('all')
