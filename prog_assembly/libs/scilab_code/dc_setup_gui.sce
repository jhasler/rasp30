global file_name chip_num;

//get filename, path and extension
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;

while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name "+hid_dir+"/input_vector");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4200 -input_file_name "+hid_dir+"/output_info");
    [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl -speed 115200 "+hid_dir+"/run_mode_after_program.elf");
    //[a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl -speed 115200 "+hid_dir+"/voltage_meas.elf");
    //global RAMP_ADC_check
    //if RAMP_ADC_check==1 then
    //disp("Use Take Data to measure using RAMP ADC")
    //b3=0;
    //else
    //[a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl -speed 115200 "+hid_dir+"/voltage_meas.elf");
    //end
    if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
    disp("connection issue -> it is trying again");
    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
    sleep(2000);
end





