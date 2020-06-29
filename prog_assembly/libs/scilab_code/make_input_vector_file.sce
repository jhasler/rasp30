function make_in_ve_file = make_input_vector_file()
    global dac_array dac_array_map gpin_array gpin_array_map number_samples period;
    
    size_dac_array = size(dac_array);
    size_dac_array_row = size_dac_array(1,1);
    size_dac_array_col = size_dac_array(1,2);
    
    temp_dac_info=0;
    for i = 1:size_dac_array_row 
        temp_dac_info = temp_dac_info + (2^(i-1))*dac_array(i,1);
    end
    
    for i = 1:size_dac_array_row
        if dac_array(i,1) == 1 & dac_array(i,2) == 0 then
            for j=4:size_dac_array_col
                dac_array(i,j)=dac_array(i,3);
            end
        end
    end
    
    dac_info = '0x'+ string(sprintf('%4.4x', temp_dac_info));
    temp_number_samples = '0x'+ string(sprintf('%4.4x', number_samples));
    
    temp_string = temp_number_samples + ' ' + dac_info + ' ' + period + ' ';
    for i = 1:number_samples
        temp_DAC01_DAC00=0;temp_DAC03_DAC02=0;temp_DAC05_DAC04=0;temp_DAC07_DAC06=0;temp_DAC09_DAC08=0;
        index_DAC01_DAC00=0;index_DAC03_DAC02=0;index_DAC05_DAC04=0;index_DAC07_DAC06=0;index_DAC09_DAC08=0;
        for j = 1:size_dac_array_row
            if dac_array(j,1) == 1 then
                if j== 1 then temp_DAC01_DAC00 = temp_DAC01_DAC00 + dac_array(j,i+2); index_DAC01_DAC00=1; end
                if j== 2 then temp_DAC01_DAC00 = temp_DAC01_DAC00 + dac_array(j,i+2)*2^9; index_DAC01_DAC00=1; end
                if j== 3 then temp_DAC03_DAC02 = temp_DAC03_DAC02 + dac_array(j,i+2); index_DAC03_DAC02=1; end
                if j== 4 then temp_DAC03_DAC02 = temp_DAC03_DAC02 + dac_array(j,i+2)*2^9; index_DAC03_DAC02=1; end
                if j== 5 then temp_DAC05_DAC04 = temp_DAC05_DAC04 + dac_array(j,i+2); index_DAC05_DAC04=1; end
                if j== 6 then temp_DAC05_DAC04 = temp_DAC05_DAC04 + dac_array(j,i+2)*2^9; index_DAC05_DAC04=1; end
                if j== 7 then temp_DAC07_DAC06 = temp_DAC07_DAC06 + dac_array(j,i+2); index_DAC07_DAC06=1; end
                if j== 8 then temp_DAC07_DAC06 = temp_DAC07_DAC06 + dac_array(j,i+2)*2^9; index_DAC07_DAC06=1; end
                if j== 9 then temp_DAC09_DAC08 = temp_DAC09_DAC08 + dac_array(j,i+2); index_DAC09_DAC08=1; end
                if j==10 then temp_DAC09_DAC08 = temp_DAC09_DAC08 + dac_array(j,i+2)*2^9; index_DAC09_DAC08=1; end
            end
        end
        if index_DAC01_DAC00 == 1 then temp_string = temp_string + '0x'+ string(sprintf('%4.4x', temp_DAC01_DAC00)) + ' '; end
        if index_DAC03_DAC02 == 1 then temp_string = temp_string + '0x'+ string(sprintf('%4.4x', temp_DAC03_DAC02)) + ' '; end
        if index_DAC05_DAC04 == 1 then temp_string = temp_string + '0x'+ string(sprintf('%4.4x', temp_DAC05_DAC04)) + ' '; end
        if index_DAC07_DAC06 == 1 then temp_string = temp_string + '0x'+ string(sprintf('%4.4x', temp_DAC07_DAC06)) + ' '; end
        if index_DAC09_DAC08 == 1 then temp_string = temp_string + '0x'+ string(sprintf('%4.4x', temp_DAC09_DAC08)) + ' '; end
    end
    temp_string = temp_string + '0xffff ';
    fd = mopen('input_vector','wt'); mputl(temp_string, fd); mclose(fd);
    
    disp(temp_string);
    
    temp_string = temp_number_samples + ' ' + dac_info + ' ' + period + ' ';
    for i = 1:number_samples
        for j = 1:size_dac_array_row
            if dac_array(j,1) == 1 then
                temp_string = temp_string + '0x'+ string(sprintf('%4.4x', dac_array(j,i+2))) + ' ';
            end
        end
    end
    temp_string = temp_string + '0xffff ';
    fd = mopen('input_vector_for_graph','wt'); mputl(temp_string, fd); mclose(fd);
            
    temp_string = '';
    for i=1:size_dac_array_row
        if dac_array_map(i) == "" then
            temp_string = temp_string + "No_use "
        end
        if dac_array_map(i) ~= "" then
            temp_string = temp_string + dac_array_map(i) + " ";
        end
    end
    fd = mopen('DAC_mapping_info','wt'); mputl(temp_string, fd); mclose(fd);
    disp(temp_string);
    
    
    
    
    // ------ GPIO In vector generation
    size_gpin_array = size(gpin_array);
    size_gpin_array_row = size_gpin_array(1,1);
    size_gpin_array_col = size_gpin_array(1,2);
    
    temp_gpin_info=0;
    for i = 1:size_gpin_array_row 
        temp_gpin_info = temp_gpin_info + (2^(i-1))*gpin_array(i,1);
    end
    
    for i = 1:size_gpin_array_row
        if gpin_array(i,1) == 1 & gpin_array(i,2) == 0 then
            for j=4:size_gpin_array_col
                gpin_array(i,j)=gpin_array(i,3);
            end
        end
    end
    
    gpin_info = '0x'+ string(sprintf('%4.4x', temp_gpin_info));
    temp_number_samples = '0x'+ string(sprintf('%4.4x', number_samples));
    
    temp_string = temp_number_samples + ' ' + gpin_info + ' ' + period + ' ';
    for i = 1:number_samples
        temp_gpin=0;
        for j = 1:size_gpin_array_row
            if gpin_array(j,1) == 1 then
                temp_gpin = temp_gpin + gpin_array(j,i+2)*(2^(j-1));
            end
        end
        temp_string = temp_string + '0x'+ string(sprintf('%4.4x', temp_gpin)) + ' ';
    end
    temp_string = temp_string + '0xffff';
    fd = mopen('gpin_vector','wt'); mputl(temp_string, fd); mclose(fd);
    
    disp(temp_string);
    
    temp_string = '';
    for i=1:size_gpin_array_row
        if gpin_array_map(i) == "" then
            temp_string = temp_string + "No_use "
        end
        if gpin_array_map(i) ~= "" then
            temp_string = temp_string + gpin_array_map(i) + " ";
        end
    end
    fd = mopen('gpin_mapping_info','wt'); mputl(temp_string, fd); mclose(fd);
    disp(temp_string);
    
    make_in_ve_file = 1;

endfunction
