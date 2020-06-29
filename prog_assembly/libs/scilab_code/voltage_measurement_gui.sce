global file_name chip_num board_num;
global RAMP_ADC_check sftreg_check Signal_DAC_check GPIO_IN_check MITE_ADC_check;
global dac_array dac_array_map gpin_array gpin_array_map number_samples period;

//get filename, path and extension
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;

select board_num 
case 2 then brdtype = '';
case 3 then brdtype = '_30a';
case 4 then brdtype = '_30n';
case 5 then brdtype = '_30h';
else messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort;
end

exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC.sce",-1);

// read output_info to array and mite characterization file to get information
fd = mopen(hid_dir+"/output_info",'r');str_temp = mgetstr(7,fd);No_of_mite = msscanf(str_temp,"%x"); clear mite_info_array;
if No_of_mite ~= 0 then
    for i=1:No_of_mite
        str_temp = mgetstr(7,fd); mite_info_array(i,1) = msscanf(str_temp,"%x");
        str_temp = mgetstr(7,fd); mite_info_array(i,2) = msscanf(str_temp,"%x");
    end
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC.sce",-1);
end
mclose(fd);

// Read switch file to get the number of swithes.
target_list = fscanfMat(path+fname+'.swcs');
temp_size= size(target_list); n=temp_size(1,1);

// Execute run mode scripts (loading vector files to SRAM and execute .elf coed which was uploaded at the end of the program. And generates output vector by reading SRAM)
if GPIO_IN_check==0 then
   while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name "+hid_dir+"/input_vector");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4200 -input_file_name "+hid_dir+"/output_info");
        if (b1==0) & (b2==0) then
            //[a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run_without_uploading.tcl -speed 115200");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl -speed 115200 "+hid_dir+"/voltage_meas.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6000 -length 1000 -output_file_name output_vector");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
end

if GPIO_IN_check==1 then
   while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name "+hid_dir+"/input_vector");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4200 -input_file_name "+hid_dir+"/output_info");
        [a5,b5]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x5500 -input_file_name "+hid_dir+"/gpin_vector");
        if (b1==0) & (b2==0) & (b5==0) then
            //[a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run_without_uploading.tcl -speed 115200");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl -speed 115200 "+hid_dir+"/voltage_meas.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6000 -length 1000 -output_file_name output_vector");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) & (b5==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) | (b5==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
end

// Read DAC_mapping_info 
fd= mopen(hid_dir+"/DAC_mapping_info"); str_temp = mgetl(fd); DAC_map_information_temp = strsplit(str_temp," "); mclose(fd);
DAC_map_information=[""];

// Check which and how many DACs were used
clear data; data = [1:2]; 
j=1; fd = mopen(hid_dir+"/input_vector_for_graph",'r');
str_temp = mgetstr(7,fd);length_input = msscanf(str_temp,"%x");
str_temp = mgetstr(7,fd);x_ori = msscanf(str_temp,"%x");
No_of_DACs=0; 
DAC15=floor(x_ori/(2^15));x_ori=x_ori-floor(x_ori/(2^15))*2^15;
DAC14=floor(x_ori/(2^14));x_ori=x_ori-floor(x_ori/(2^14))*2^14;
DAC13=floor(x_ori/(2^13));x_ori=x_ori-floor(x_ori/(2^13))*2^13;
DAC12=floor(x_ori/(2^12));x_ori=x_ori-floor(x_ori/(2^12))*2^12;
DAC11=floor(x_ori/(2^11));x_ori=x_ori-floor(x_ori/(2^11))*2^11;
DAC10=floor(x_ori/(2^10));x_ori=x_ori-floor(x_ori/(2^10))*2^10;
DAC09=floor(x_ori/(2^9));x_ori=x_ori-floor(x_ori/(2^9))*2^9;
DAC08=floor(x_ori/(2^8));x_ori=x_ori-floor(x_ori/(2^8))*2^8;
DAC07=floor(x_ori/(2^7));x_ori=x_ori-floor(x_ori/(2^7))*2^7;
DAC06=floor(x_ori/(2^6));x_ori=x_ori-floor(x_ori/(2^6))*2^6;
DAC05=floor(x_ori/(2^5));x_ori=x_ori-floor(x_ori/(2^5))*2^5;
DAC04=floor(x_ori/(2^4));x_ori=x_ori-floor(x_ori/(2^4))*2^4;
DAC03=floor(x_ori/(2^3));x_ori=x_ori-floor(x_ori/(2^3))*2^3;
DAC02=floor(x_ori/(2^2));x_ori=x_ori-floor(x_ori/(2^2))*2^2;
DAC01=floor(x_ori/(2^1));x_ori=x_ori-floor(x_ori/(2^1))*2^1;
DAC00=floor(x_ori/(2^0));x_ori=x_ori-floor(x_ori/(2^0))*2^0;
No_of_DACs=DAC00+DAC01+DAC02+DAC03+DAC04+DAC05+DAC06+DAC07+DAC08+DAC09+DAC10+DAC11+DAC12+DAC13+DAC14+DAC15;
str_temp = mgetstr(7,fd);period_graph = msscanf(str_temp,"%x");
str_temp = mgetstr(7,fd);
for j=1:length_input
    data(j,1)= period_graph * (j-1);
    for i=1:No_of_DACs
        data(j,i+1) = msscanf(str_temp,"%x");
        str_temp = mgetstr(7,fd);
    end
end
mclose(fd);

// Read output_vectors (voltage_measure block)
if No_of_mite ~= 0 then
    j=1; fd = mopen('output_vector','r');
    str_temp = mgetstr(7,fd);
    for j=1:length_input
        for i=1:No_of_mite
            data(j,i+1+No_of_DACs) = msscanf(str_temp,"%x");
            str_temp = mgetstr(7,fd);
        end
    end
    mclose(fd);
end

data(:,1)=data(:,1)*1E-05;  // 10us

// Converts Input hex values to voltages based on the onchip DAC calibration file
i=2;
if DAC00 == 1 then data(:,i)=polyval(p_onchip_dac00,data(:,i),S_onchip_dac00); DAC_map_information(i-1)=DAC_map_information_temp(1); i=i+1; end
if DAC01 == 1 then data(:,i)=polyval(p_onchip_dac01,data(:,i),S_onchip_dac01); DAC_map_information(i-1)=DAC_map_information_temp(2); i=i+1; end
if DAC02 == 1 then data(:,i)=polyval(p_onchip_dac02,data(:,i),S_onchip_dac02); DAC_map_information(i-1)=DAC_map_information_temp(3); i=i+1; end
if DAC03 == 1 then data(:,i)=polyval(p_onchip_dac03,data(:,i),S_onchip_dac03); DAC_map_information(i-1)=DAC_map_information_temp(4); i=i+1; end
if DAC04 == 1 then data(:,i)=polyval(p_onchip_dac04,data(:,i),S_onchip_dac04); DAC_map_information(i-1)=DAC_map_information_temp(5); i=i+1; end
if DAC05 == 1 then data(:,i)=polyval(p_onchip_dac05,data(:,i),S_onchip_dac05); DAC_map_information(i-1)=DAC_map_information_temp(6); i=i+1; end
if DAC06 == 1 then data(:,i)=polyval(p_onchip_dac06,data(:,i),S_onchip_dac06); DAC_map_information(i-1)=DAC_map_information_temp(7); i=i+1; end
if DAC07 == 1 then data(:,i)=polyval(p_onchip_dac07,data(:,i),S_onchip_dac07); DAC_map_information(i-1)=DAC_map_information_temp(8); i=i+1; end
if DAC08 == 1 then data(:,i)=polyval(p_onchip_dac08,data(:,i),S_onchip_dac08); DAC_map_information(i-1)=DAC_map_information_temp(9); i=i+1; end
if DAC09 == 1 then data(:,i)=polyval(p_onchip_dac09,data(:,i),S_onchip_dac09); DAC_map_information(i-1)=DAC_map_information_temp(10); i=i+1; end

// Converts Output hex values to voltages based on the Measure_Voltage block calibration file
if No_of_mite ~= 0 then
    j=1;
    i_start = No_of_DACs+1;
    i_end= No_of_DACs+No_of_mite;
    for i=i_start:i_end
        data(:,i+1)=polyval(p_mite_977_10uA,data(:,i+1),S_mite_977_10uA);
//        if mite_info_array(j,2) == 977 then data(:,i+1)=polyval(p_mite_977_10uA,data(:,i+1),S_mite_977_10uA); end
//        if mite_info_array(j,2) == 978 then data(:,i+1)=polyval(p_mite_978_10uA,data(:,i+1),S_mite_978_10uA); end
//        if mite_info_array(j,2) == 979 then data(:,i+1)=polyval(p_mite_979_10uA,data(:,i+1),S_mite_979_10uA); end
//        if mite_info_array(j,2) == 980 then data(:,i+1)=polyval(p_mite_980_10uA,data(:,i+1),S_mite_980_10uA); end
//        if mite_info_array(j,2) == 981 then data(:,i+1)=polyval(p_mite_981_10uA,data(:,i+1),S_mite_981_10uA); end
//        if mite_info_array(j,2) == 982 then data(:,i+1)=polyval(p_mite_982_10uA,data(:,i+1),S_mite_982_10uA); end
//        if mite_info_array(j,2) == 983 then data(:,i+1)=polyval(p_mite_983_10uA,data(:,i+1),S_mite_983_10uA); end
//        if mite_info_array(j,2) == 984 then data(:,i+1)=polyval(p_mite_984_10uA,data(:,i+1),S_mite_984_10uA); end
//        if mite_info_array(j,2) == 985 then data(:,i+1)=polyval(p_mite_985_10uA,data(:,i+1),S_mite_985_10uA); end
//        if mite_info_array(j,2) == 986 then data(:,i+1)=polyval(p_mite_986_10uA,data(:,i+1),S_mite_986_10uA); end
//        if mite_info_array(j,2) == 1009 then data(:,i+1)=polyval(p_mite_1009_10uA,data(:,i+1),S_mite_1009_10uA); end
//        if mite_info_array(j,2) == 1010 then data(:,i+1)=polyval(p_mite_1010_10uA,data(:,i+1),S_mite_1010_10uA); end
//        if mite_info_array(j,2) == 1011 then data(:,i+1)=polyval(p_mite_1011_10uA,data(:,i+1),S_mite_1011_10uA); end
//        if mite_info_array(j,2) == 1012 then data(:,i+1)=polyval(p_mite_1012_10uA,data(:,i+1),S_mite_1012_10uA); end
//        if mite_info_array(j,2) == 1013 then data(:,i+1)=polyval(p_mite_1013_10uA,data(:,i+1),S_mite_1013_10uA); end
//        if mite_info_array(j,2) == 1014 then data(:,i+1)=polyval(p_mite_1014_10uA,data(:,i+1),S_mite_1014_10uA); end
//        if mite_info_array(j,2) == 1015 then data(:,i+1)=polyval(p_mite_1015_10uA,data(:,i+1),S_mite_1015_10uA); end
//        if mite_info_array(j,2) == 1016 then data(:,i+1)=polyval(p_mite_1016_10uA,data(:,i+1),S_mite_1016_10uA); end
//        if mite_info_array(j,2) == 1017 then data(:,i+1)=polyval(p_mite_1017_10uA,data(:,i+1),S_mite_1017_10uA); end
//        if mite_info_array(j,2) == 1018 then data(:,i+1)=polyval(p_mite_1018_10uA,data(:,i+1),S_mite_1018_10uA); end
    end
end

//disp(data); disp(mite_info_array(j,2));
fprintfMat(fname+'.data', data, "%5.15f");

// Result graphs
scf(101); clf(101);
legend_list = ('a');
j=1;
for i=1:No_of_DACs
    temp=modulo(j,7)+1;
//    plot2d("nn", data(:,1), data(:,i+1), style=temp); p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
    plot2d("nn", data(:,1), data(:,i+1), style=temp); p = get("hdl"); p = get("hdl"); p.children.line_style = 1; p.children.foreground = temp;p.children.thickness = 2;p.children.line_mode = 'on';p.children.mark_mode = 'off';
    legend_list(j,1)='Input_' + DAC_map_information(j);
    j=j+1;
end

if GPIO_IN_check == 1 then
    temp_size_gpin=size(gpin_array);
    fd= mopen(hid_dir+"/gpin_mapping_info"); str_temp = mgetl(fd); gpin_map_info_temp = strsplit(str_temp," "); mclose(fd);
    for i=1:temp_size_gpin(1)
        temp=modulo(j,7)+1;
        plot2d("nn", data(:,1), 2.5*gpin_array(i,3:temp_size_gpin(2)'), style=temp); p = get("hdl"); p = get("hdl"); p.children.line_style = 1; p.children.foreground = temp;p.children.thickness = 2;p.children.line_mode = 'on';p.children.mark_mode = 'off';
        legend_list(j,1)='GPIO_In_' + gpin_map_info_temp(i);
        j=j+1;
    end
end

if No_of_mite ~= 0 then
   for i=i_start:i_end
        temp=modulo(j,7)+1;
        plot2d("nn", data(:,1), data(:,i+1), style=temp); p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_list(j,1)='MITE_ADC_' + string(j);
        j=j+1;
    end
    csvWrite(data,'MITE_ADC_Output_voltage.csv');
end

if RAMP_ADC_check==1 then
    fd = mopen('output_vector','r');
    str_temp = mgetstr(7,fd);
    for jjj=1:length_input
        ramp_adc_data(jjj,1) = msscanf(str_temp,"%x");
        str_temp = mgetstr(7,fd);
    end
    mclose(fd);
    select board_num
    case 2 then ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_'+chip_num+'.csv');
    case 3 then ramp_adc_char=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/Ramp_ADC_char_30a_04.csv');
    end
    [p_ramp_adc,S_ramp_adc]=polyfit(ramp_adc_char(:,2),ramp_adc_char(:,1),1); 
    RAMP_ADC_Output_voltage=polyval(p_ramp_adc,ramp_adc_data,S_ramp_adc);
    temp=modulo(j,7)+1;
    plot2d("nn", data(:,1), RAMP_ADC_Output_voltage(:), style=temp); p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
    legend_list(j,1)='Ramp_ADC_' + string(j);
    j=j+1;
    csvWrite(RAMP_ADC_Output_voltage,'RAMP_ADC_Output_voltage.csv');
end

if No_of_DACs ~= 0 | No_of_mite ~= 0 | GPIO_IN_check == 1 | RAMP_ADC_check==1 then
   legend(legend_list(:,1),"in_upper_right");
   xtitle("","time [s]", "Vout [V]"); b=gca(); b.data_bounds(1,1)=0; b.data_bounds(1,2)=0; b.data_bounds(2,1)=b.data_bounds(2,1)*1.1; b.data_bounds(2,2)=3;
else
   xdel(101)
end

//***** for RAMP ADC **********
global RAMP_ADC_check;
if (Signal_DAC_check==1) & (GPIO_IN_check==0) & (RAMP_ADC_check==1) then
    noDAC=0;
    if No_of_DACs==0 then noDAC=1; end
    exec("~/rasp30/prog_assembly/libs/scilab_code/Ramp_ADC_voltage.sce",-1);
end
//********************

unix_g('mv output_vector ' + hid_dir);
