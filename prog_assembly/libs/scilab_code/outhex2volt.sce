function [voltage_vector]=outhex2volt (chip_num, board_num, hex_vector)
    
    select board_num 
    case 2 then
        brdtype = '';
    case 3 then
        brdtype = '_30a';
    case 4 then
        brdtype = '_30n';
    case 5 
        brdtype = '_30h';
    else
        messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error");
        abort
    end
    temp_size= size(hex_vector); No_of_mite=temp_size(1,2);
    clear voltage_vector;voltage_vector=hex_vector;
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC.sce",-1);

    // Converts Output hex values to voltages based on the Measure_Voltage block calibration file
    if No_of_mite ~= 0 then
        j=1;
        i_start = 1;
        i_end= No_of_mite;
        for i=i_start:i_end
            if mite_info_array(j,2) == 977 then voltage_vector(:,i)=polyval(p_mite_977_10uA,voltage_vector(:,i),S_mite_977_10uA); end
            if mite_info_array(j,2) == 978 then voltage_vector(:,i)=polyval(p_mite_978_10uA,voltage_vector(:,i),S_mite_978_10uA); end
            if mite_info_array(j,2) == 979 then voltage_vector(:,i)=polyval(p_mite_979_10uA,voltage_vector(:,i),S_mite_979_10uA); end
            if mite_info_array(j,2) == 980 then voltage_vector(:,i)=polyval(p_mite_980_10uA,voltage_vector(:,i),S_mite_980_10uA); end
            if mite_info_array(j,2) == 981 then voltage_vector(:,i)=polyval(p_mite_981_10uA,voltage_vector(:,i),S_mite_981_10uA); end
            if mite_info_array(j,2) == 982 then voltage_vector(:,i)=polyval(p_mite_982_10uA,voltage_vector(:,i),S_mite_982_10uA); end
            if mite_info_array(j,2) == 983 then voltage_vector(:,i)=polyval(p_mite_983_10uA,voltage_vector(:,i),S_mite_983_10uA); end
            if mite_info_array(j,2) == 984 then voltage_vector(:,i)=polyval(p_mite_984_10uA,voltage_vector(:,i),S_mite_984_10uA); end
            if mite_info_array(j,2) == 985 then voltage_vector(:,i)=polyval(p_mite_985_10uA,voltage_vector(:,i),S_mite_985_10uA); end
            if mite_info_array(j,2) == 986 then voltage_vector(:,i)=polyval(p_mite_986_10uA,voltage_vector(:,i),S_mite_986_10uA); end
            if mite_info_array(j,2) == 1009 then voltage_vector(:,i)=polyval(p_mite_1009_10uA,voltage_vector(:,i),S_mite_1009_10uA); end
            if mite_info_array(j,2) == 1010 then voltage_vector(:,i)=polyval(p_mite_1010_10uA,voltage_vector(:,i),S_mite_1010_10uA); end
            if mite_info_array(j,2) == 1011 then voltage_vector(:,i)=polyval(p_mite_1011_10uA,voltage_vector(:,i),S_mite_1011_10uA); end
            if mite_info_array(j,2) == 1012 then voltage_vector(:,i)=polyval(p_mite_1012_10uA,voltage_vector(:,i),S_mite_1012_10uA); end
            if mite_info_array(j,2) == 1013 then voltage_vector(:,i)=polyval(p_mite_1013_10uA,voltage_vector(:,i),S_mite_1013_10uA); end
            if mite_info_array(j,2) == 1014 then voltage_vector(:,i)=polyval(p_mite_1014_10uA,voltage_vector(:,i),S_mite_1014_10uA); end
            if mite_info_array(j,2) == 1015 then voltage_vector(:,i)=polyval(p_mite_1015_10uA,voltage_vector(:,i),S_mite_1015_10uA); end
            if mite_info_array(j,2) == 1016 then voltage_vector(:,i)=polyval(p_mite_1016_10uA,voltage_vector(:,i),S_mite_1016_10uA); end
            if mite_info_array(j,2) == 1017 then voltage_vector(:,i)=polyval(p_mite_1017_10uA,voltage_vector(:,i),S_mite_1017_10uA); end
            if mite_info_array(j,2) == 1018 then voltage_vector(:,i)=polyval(p_mite_1018_10uA,voltage_vector(:,i),S_mite_1018_10uA); end
        end
    end
    
    //disp(voltage_vector)
endfunction
