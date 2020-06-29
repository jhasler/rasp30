function arb_compile = genarb_compile(x,y,z,regen)
        global dac_array dac_array_map number_samples period chip_num board_num;
        
        select board_num 
        case 2 then brdtype = '';
        case 3 then brdtype = '_30a';
        case 4 then brdtype = '_30n';
        case 5 brdtype = '_30h';
        else messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort;
        end
        
        exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC.sce",-1);
        DAC00_char_table_copy=DAC00_char_table;
        DAC01_char_table_copy=DAC01_char_table;
        DAC02_char_table_copy=DAC02_char_table;
        DAC03_char_table_copy=DAC03_char_table;
        DAC04_char_table_copy=DAC04_char_table;
        DAC05_char_table_copy=DAC05_char_table;
        DAC06_char_table_copy=DAC06_char_table;
        DAC07_char_table_copy=DAC07_char_table;
        DAC08_char_table_copy=DAC08_char_table;
        DAC09_char_table_copy=DAC09_char_table;
        temp_size_DAC00=size(DAC00_char_table_copy); n2_DAC00=temp_size_DAC00(1,1);
        temp_size_DAC01=size(DAC01_char_table_copy); n2_DAC01=temp_size_DAC01(1,1);
        temp_size_DAC02=size(DAC02_char_table_copy); n2_DAC02=temp_size_DAC02(1,1);
        temp_size_DAC03=size(DAC03_char_table_copy); n2_DAC03=temp_size_DAC03(1,1);
        temp_size_DAC04=size(DAC04_char_table_copy); n2_DAC04=temp_size_DAC04(1,1);
        temp_size_DAC05=size(DAC05_char_table_copy); n2_DAC05=temp_size_DAC05(1,1);
        temp_size_DAC06=size(DAC06_char_table_copy); n2_DAC06=temp_size_DAC06(1,1);
        temp_size_DAC07=size(DAC07_char_table_copy); n2_DAC07=temp_size_DAC07(1,1);
        temp_size_DAC08=size(DAC08_char_table_copy); n2_DAC08=temp_size_DAC08(1,1);
        temp_size_DAC09=size(DAC09_char_table_copy); n2_DAC09=temp_size_DAC09(1,1);
        
        mat_sz = size(evstr(x));
        m = mat_sz(1,2);
        var=evstr(x);
        number_samples=m;
        //disp(evstr(x))
        mat_sz2 = size(z);  // z : DAC information matrix
        l = mat_sz2(1,2);
        temp_dac_info=0;
        j=1;
        for i=1:l
            dac_array(z(i)+1,1) = 1; dac_array(z(i)+1,2) = 1; 
            if regen == 0 then dac_array_map(z(i)+1)=x+'_'+string(j); end
            if regen == 1 then dac_array_map(z(i)+1)=x; end
            if z(i) == 0 then
                for k=1:m
                    DAC00_char_table_copy(:,3)=abs(DAC00_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC00_char_table_copy(:,3));
                    for h=1:n2_DAC00
                        if DAC00_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC00_char_table_copy(h,1);
                        end
                    end
                end
            end
            if z(i) == 1 then
                for k=1:m
                    DAC01_char_table_copy(:,3)=abs(DAC01_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC01_char_table_copy(:,3));
                    for h=1:n2_DAC01
                        if DAC01_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC01_char_table_copy(h,1);
                        end
                    end
                end
            end
            if z(i) == 2 then
                for k=1:m
                    DAC02_char_table_copy(:,3)=abs(DAC02_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC02_char_table_copy(:,3));
                    for h=1:n2_DAC02
                        if DAC02_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC02_char_table_copy(h,1);
                        end
                    end
                end
            end
            if z(i) == 3 then
                for k=1:m
                    DAC03_char_table_copy(:,3)=abs(DAC03_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC03_char_table_copy(:,3));
                    for h=1:n2_DAC03
                        if DAC03_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC03_char_table_copy(h,1);
                        end
                    end
                end
            end
            if z(i) == 4 then
                for k=1:m
                    DAC04_char_table_copy(:,3)=abs(DAC04_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC04_char_table_copy(:,3));
                    for h=1:n2_DAC04
                        if DAC04_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC04_char_table_copy(h,1);
                        end
                    end
                end
            end
            if z(i) == 5 then
                for k=1:m
                    DAC05_char_table_copy(:,3)=abs(DAC05_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC05_char_table_copy(:,3));
                    for h=1:n2_DAC05
                        if DAC05_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC05_char_table_copy(h,1);
                        end
                    end
                end
            end
            if z(i) == 6 then
                for k=1:m
                    DAC06_char_table_copy(:,3)=abs(DAC06_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC06_char_table_copy(:,3));
                    for h=1:n2_DAC06
                        if DAC06_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC06_char_table_copy(h,1);
                        end
                    end
                end
            end
            if z(i) == 7 then
                for k=1:m
                    DAC07_char_table_copy(:,3)=abs(DAC07_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC07_char_table_copy(:,3));
                    for h=1:n2_DAC07
                        if DAC07_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC07_char_table_copy(h,1);
                        end
                    end
                end
            end
            if z(i) == 8 then
                for k=1:m
                    DAC08_char_table_copy(:,3)=abs(DAC08_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC08_char_table_copy(:,3));
                    for h=1:n2_DAC08
                        if DAC08_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC08_char_table_copy(h,1);
                        end
                    end
                end
            end
            if z(i) == 9 then
                for k=1:m
                    DAC09_char_table_copy(:,3)=abs(DAC09_char_table_copy(:,2)-var(j,k));
                    min_value = min(DAC09_char_table_copy(:,3));
                    for h=1:n2_DAC09
                        if DAC09_char_table_copy(h,3) == min_value then
                            dac_array(z(i)+1,k+2) = DAC09_char_table_copy(h,1);
                        end
                    end
                end
            end
            j=j+1;
        end
        
        period = '0x'+ string(sprintf('%4.4x', (1/y)*1E05));
        
arb_compile = 1;
    
endfunction
