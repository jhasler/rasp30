global file_name chip_num board_num;
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;

while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name "+hid_dir+"/input_vector");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4200 -input_file_name "+hid_dir+"/output_info");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl -speed 115200 "+hid_dir+"/voltage_meas.elf");
        //disp("ddd")
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6000 -length 1000 -output_file_name output_vector");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear ramp_adc_data;
ramp_adc_data(:,1)=myVariable';
fd = mopen('output_vector','r');
jjj=1;
str_temp = mgetstr(7,fd);
while str_temp ~= "0xffff "
    ramp_adc_data(jjj,2) = msscanf(str_temp,"%x");
    str_temp = mgetstr(7,fd);
    jjj=jjj+1;
end
mclose(fd);

scf(1); clf(1);
plot2d("nn", ramp_adc_data(:,1), ramp_adc_data(:,2), style=1); p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = 1;

select board_num
case 2 then
    csvWrite(ramp_adc_data,'./Ramp_ADC_char_'+chip_num+'.csv');
    unix_g('sudo cp ./Ramp_ADC_char_'+chip_num+'.csv ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/');
case 3 then
    csvWrite(ramp_adc_data,'./Ramp_ADC_char_30a_'+chip_num+'.csv');
    unix_g('sudo cp ./Ramp_ADC_char_30a_'+chip_num+'.csv ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/');
end

