clear Output
clear Output_dec
clear New_output
clear Input
clear y

[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;
//*************for remote
if chip_num==string(13)|chip_num=='01'|chip_num=='014' then
y = mopen(path+"output_vector','rt')
Output=mgetl(y);

m=1
i=3
length_out=length(myVariable)
while m<length_out+1;
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
if brdtype=='' then
    ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_'+chip_num+'.csv')
else
ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_30a_04.csv')

end
ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_'+chip_num+'.csv')
[p_ramp_adc,S_ramp_adc]=polyfit(ramp_adc_char(:,2),ramp_adc_char(:,1),1); 
RAMP_ADC_Output_voltage=polyval(p_ramp_adc,Output_dec,S_ramp_adc);

//RAMP_ADC_Output_voltage=interp1(ramp_adc_char(:,2),ramp_adc_char(:,1),Output_dec,'nearest')


//figure();
//plot(Input,Output_dec);
//figure();
//plot(RAMP_ADC_Output_voltage);
//rm_results=RAMP_ADC_Output_voltage

//csvWrite(RAMP_ADC_Output_voltage,path + fname +'.data')

fprintfMat(fname+'.data',RAMP_ADC_Output_voltage, "%5.15f");
 

disp('here')
mclose('all')
else

disp('Using RAMP ADC to measure')
//***********************
global sftreg_check
global RAMP_ADC_check
if (RAMP_ADC_check==1)&(sftreg_check==1) then
unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh '+path+'adc_int ~/rasp30/prog_assembly/libs/asm_code/sftreg_adc.s43 16384 16384 16384")
end

if (sftreg_check==1) then
unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh '+path+'adc_int ~/rasp30/prog_assembly/libs/asm_code/sftreg_GPIO.s43 16384 16384 16384")
end

//[a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name "+hid_dir+"/input_vector");
if (RAMP_ADC_check==1) then
unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh '+path+'adc_int ~/rasp30/prog_assembly/libs/asm_code/Ramp_ADC_DAC.s43 16384 16384 16384")
end


//if noDAC==1 then
//unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh '+path+'adc_int ~/rasp30/prog_assembly/libs/asm_code/Ramp_ADC_noDAC.s43 16384 16384 16384")
//end


[a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name '+hid_dir+'/input_vector");
  

//[y,err]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/DACwrite.tcl -input_file_name ./input_vector");

y=1;
while y==1 
[y,err]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl '+path+'/adc_int.elf');
end

xpause(100);

unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 1 -output_file_name "+path+"output_vector.txt");
y = mopen(path+'output_vector.txt','rt')
Output=mgetl(y);
New_output(1,1) = part(Output(1,1),3:7);
Output_dec(1,:) = msscanf(New_output(1,:),'%x'); //scan with hexadecimal format

length_out= Output_dec(1) - 24576;
length_out=length_out/2;
unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6000 -length "+string(length_out)+" -output_file_name "+path+"output_vector.txt");
y = mopen(path+"output_vector.txt','rt')
Output=mgetl(y);

disp('Length of your data is:')
disp(string(length_out))

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
chip_number=string(chip_num)

global board_num
select board_num
case 2 then

ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_'+chip_num+'.csv')

case 3 then
ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_30a_'+chip_num+'.csv')
end


//ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_'+chip_num+'.csv')


[p_ramp_adc,S_ramp_adc]=polyfit(ramp_adc_char(:,2),ramp_adc_char(:,1),1); 
RAMP_ADC_Output_voltage=polyval(p_ramp_adc,Output_dec,S_ramp_adc);

//RAMP_ADC_Output_voltage=interp1(ramp_adc_char(:,2),ramp_adc_char(:,1),Output_dec,'nearest')
figure();
plot(Output_dec);
figure();
plot(RAMP_ADC_Output_voltage);

csvWrite(RAMP_ADC_Output_voltage,'Results.csv')
csvWrite(Output_dec,'Results_dec.csv') 
mclose('all')
disp('Results saved in Results.csv ')
unix_g('mv '+path+'adc_int.elf '+hid_dir)

end
