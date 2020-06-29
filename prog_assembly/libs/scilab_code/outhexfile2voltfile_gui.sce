global file_name chip_num board_num;

//get filename, path and extension
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;

//select board_num 
//case 2 then
//    brdtype = '';
//case 3 then
//    brdtype = '_30a';
//case 4 then
//    brdtype = '_30n';
//case 5 
//    brdtype = '_30h';
//else
//    messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error");
//    abort
//end
//
//exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC_chip"+chip_num+brdtype+".sce",-1);

// read output_info to array and mite characterization file to get information
fd = mopen(hid_dir+"/output_info",'r');str_temp = mgetstr(7,fd);No_of_mite = msscanf(str_temp,"%x"); clear mite_info_array;
if No_of_mite ~= 0 then
    for i=1:No_of_mite
        str_temp = mgetstr(7,fd); mite_info_array(i,1) = msscanf(str_temp,"%x");
        str_temp = mgetstr(7,fd); mite_info_array(i,2) = msscanf(str_temp,"%x");
    end
    //disp(mite_info_array);
end
mclose(fd);

clear hex_vector; hex_vector = [1];

// Open input_vector_for_graph file and get the informatio of length of output.
j=1; fd = mopen(hid_dir+"/input_vector_for_graph",'r');str_temp = mgetstr(7,fd);length_input = msscanf(str_temp,"%x");mclose(fd);

// Read output_vectors (voltage_measure block)
if No_of_mite ~= 0 then
    j=1; fd = mopen('output_vector','r');
    str_temp = mgetstr(7,fd);
    for j=1:length_input
        for i=1:No_of_mite
            hex_vector(j,1) = msscanf(str_temp,"%x");
            str_temp = mgetstr(7,fd);
        end
    end
    mclose(fd);
end
global RAMP_ADC_check ONchip_ADC
//disp(hex_vector);
if RAMP_ADC_check==1 then

//for RAMP ADC **********
 noDAC=0;

exec("~/rasp30/prog_assembly/libs/scilab_code/Ramp_ADC_voltage.sce",-1);

//*********
end

if ONchip_ADC==1 then
exec("~/rasp30/prog_assembly/libs/scilab_code/ADC_onchip.sce",-1);
[Out_dec,out_volt] = ADC(1)
end

if RAMP_ADC_check==0&ONchip_ADC==0 then

exec("~/rasp30/prog_assembly/libs/scilab_code/outhex2volt.sce",-1);
voltage_vector=outhex2volt (chip_num,board_num,hex_vector);

// showing the voltage_vector and print it to a file
//disp(voltage_vector);

fprintfMat(fname+'.data', voltage_vector, "%5.15f");
end
