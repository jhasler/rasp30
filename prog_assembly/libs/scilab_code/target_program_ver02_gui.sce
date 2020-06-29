global file_name showprog;
//get filename, path and extension
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;
//exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_diodeADC.sce",-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2i.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_i2v.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2h.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_h2v.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/read_tar_pgm_result.sce',-1);

target_list_info=fscanfMat(hid_dir+'/target_list');
n_target_tunnel_revtun=target_list_info(1,1);
n_target_highaboveVt_swc=target_list_info(2,1);
n_target_highaboveVt_ota=target_list_info(3,1);
n_target_aboveVt_swc=target_list_info(4,1);
n_target_aboveVt_ota=target_list_info(5,1);
n_target_aboveVt_otaref=target_list_info(6,1);
n_target_aboveVt_mite=target_list_info(7,1);
n_target_aboveVt_dirswc=target_list_info(8,1);
n_target_subVt_swc=target_list_info(9,1);
n_target_subVt_ota=target_list_info(10,1);
n_target_subVt_otaref=target_list_info(11,1);
n_target_subVt_mite=target_list_info(12,1);
n_target_subVt_dirswc=target_list_info(13,1);
n_target_lowsubVt_swc=target_list_info(14,1);
n_target_lowsubVt_ota=target_list_info(15,1);
n_target_lowsubVt_otaref=target_list_info(16,1);
n_target_lowsubVt_mite=target_list_info(17,1);
n_target_lowsubVt_dirswc=target_list_info(18,1);
kappa_constant=target_list_info(19,1);

// Execute Assembly codes
//if n_target_tunnel_revtun ~= 0 then
//    unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_tunnel_revtun");
//    unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/tunnel_revtun_CAB.elf");
//    unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_tunnel_revtun.hex");
//    disp("tun, rev tun");
//end
unix_w("sudo chmod 777 /dev/rasp30");

if n_target_highaboveVt_swc ~= 0 then
    disp("target_highaboveVt_swc");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_highaboveVt_swc");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_swc");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_highaboveVt_SWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_highaboveVt_swc_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_highaboveVt_swc");
//    unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name /home/ubuntu/rasp30/prog_assembly/libs/lookup_tables/pulse_width_table_offset_d1o4");  // temp. should be corrected later!!!!!!!!!!!!!!!
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_highaboveVt_SWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_highaboveVt_swc_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_highaboveVt_swc");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_highaboveVt_SWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_highaboveVt_swc_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_highaboveVt_swc");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_highaboveVt_m_ave_04_SWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_highaboveVt_swc_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_highaboveVt_swc=fscanfMat(hid_dir+'/target_list_highaboveVt_swc');
    info_name = "_highaboveVt_swc_"; info_win_num1 = 60; info_win_num2 = 61; info_win_num3 = 62; n_graph=n_target_highaboveVt_swc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_highaboveVt_swc;kapa_constant_or_not=1/kappa_constant;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_aboveVt_swc ~= 0 then
    disp("target_aboveVt_swc");
    // Check the size of switches and divide files
    n_temp = n_target_aboveVt_swc;
    maximum_swc_number = 100;
    number_of_switchfiles = int(n_target_aboveVt_swc/maximum_swc_number);
    if number_of_switchfiles < n_target_aboveVt_swc/maximum_swc_number then
        number_of_switchfiles = number_of_switchfiles + 1;
    end
    fd = mopen(hid_dir+'/target_info_aboveVt_swc','r'); clear switch_info_data; switch_info_data = [1:3];
    str_temp = mgetstr(7,fd);
    for i=1:n_target_aboveVt_swc
        switch_info_data(i,1) = msscanf(mgetstr(7,fd),"%x"); switch_info_data(i,2) = msscanf(mgetstr(7,fd),"%x"); switch_info_data(i,3) = msscanf(mgetstr(7,fd),"%x");
        dummy_scan = msscanf(mgetstr(7,fd),"%x"); dummy_scan = msscanf(mgetstr(7,fd),"%x");
    end
    mclose(fd);
   
    k=1;
    for j=1:number_of_switchfiles
        if n_temp < maximum_swc_number then
            temp = ''; temp = temp + '0x' + string(sprintf('%4.4x', n_temp)) + ' ';
            for i=1:n_temp
                temp = temp + '0x' + string(sprintf('%4.4x', switch_info_data(k,1))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,2))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,3))) + ' 0x0000' + ' 0xffff ';
                k=k+1;
            end
        fd = mopen('target_info_aboveVt_swc_'+string(j),'wt'); mputl(temp, fd); mclose(fd);
        else
            temp = ''; temp = temp + '0x' + string(sprintf('%4.4x', maximum_swc_number)) + ' ';
            for i=1:maximum_swc_number
                temp = temp + '0x' + string(sprintf('%4.4x', switch_info_data(k,1))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,2))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,3))) + ' 0x0000' + ' 0xffff ';
                k=k+1;
            end
            fd = mopen('target_info_aboveVt_swc_'+string(j),'wt'); mputl(temp, fd); mclose(fd);
        end
        n_temp = n_temp - maximum_swc_number;
    end

    unix_g(' mv target_info_aboveVt_swc_* ' + hid_dir);
    
// Execute Assembly codes
    for j=1:number_of_switchfiles
        while 1==1,
            [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_swc_"+string(j));
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_swc");
            if (b1==0) & (b2==0) then
                [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_SWC.elf");
                [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_swc_2_"+string(j)+".hex");
            end
            if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
            if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
        end
        disp("recover inj");
        while 1==1,
            [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_swc_"+string(j));
            if (b1==0) then
                [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_aboveVt_SWC.elf");
                [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_swc_3_"+string(j)+".hex");
            end
            if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
            if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
        end
        disp("first coarse inj");
        while 1==1,
            [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_swc_"+string(j));
            if (b1==0) then
                [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_aboveVt_SWC.elf");
                [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_swc_4_"+string(j)+".hex");
            end
            if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
            if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
        end
        disp("measured coarse inj");
        while 1==1,
            [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_swc_"+string(j));
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
            if (b1==0) & (b2==0) then
                [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_aboveVt_m_ave_04_SWC.elf");
                [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_swc_5_"+string(j)+".hex");
            end
            if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
            if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
        end
        //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
        //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    end
    
    // Read each file and make one file
    m=n_target_aboveVt_swc+2;
    n_temp = n_target_aboveVt_swc; k=3;; clear data; data = [1:m];
    for l=1:number_of_switchfiles
        fd = mopen('data_aboveVt_swc_2_'+string(l)+'.hex','r');
        str_temp = mgetstr(7,fd);
        j=1;
        while str_temp ~= "0xffff ",
            data(j,1) = msscanf(str_temp,"%x");
            data(j,2) = data(j,2) + msscanf(mgetstr(7,fd),"%x");
            k_temp=k;
            if n_temp < maximum_swc_number then
                for i=1:n_temp
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            else
                for i=1:maximum_swc_number
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            end
            str_temp = mgetstr(7,fd);
            j=j+1;
        end
        mclose(fd);
        k=k+maximum_swc_number;
        n_temp = n_temp - maximum_swc_number;
    end
    
    j=j-1;
    clear temp2_aboveVt_swc; temp2_aboveVt_swc='';
    for i=1:j
        for k=1:m
            temp2_aboveVt_swc = temp2_aboveVt_swc + '0x' + string(sprintf('%4.4x', data(i,k))) + ' ';
        end
    end
    temp2_aboveVt_swc = temp2_aboveVt_swc + '0xffff '
    fd = mopen('data_aboveVt_swc_2.hex','wt'); mputl(temp2_aboveVt_swc, fd); mclose(fd);

    m=n_target_aboveVt_swc+2;
    n_temp = n_target_aboveVt_swc; k=3;; clear data; data = [1:m];
    for l=1:number_of_switchfiles
        fd = mopen('data_aboveVt_swc_3_'+string(l)+'.hex','r');
        str_temp = mgetstr(7,fd);
        j=1;
        while str_temp ~= "0xffff ",
            data(j,1) = msscanf(str_temp,"%x");
            data(j,2) = data(j,2) + msscanf(mgetstr(7,fd),"%x");
            k_temp=k;
            if n_temp < maximum_swc_number then
                for i=1:n_temp
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            else
                for i=1:maximum_swc_number
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            end
            str_temp = mgetstr(7,fd);
            j=j+1;
        end
        mclose(fd);
        k=k+maximum_swc_number;
        n_temp = n_temp - maximum_swc_number;
    end

    j=j-1;
    clear temp2_aboveVt_swc; temp2_aboveVt_swc='';
    for i=1:j
        for k=1:m
            temp2_aboveVt_swc = temp2_aboveVt_swc + '0x' + string(sprintf('%4.4x', data(i,k))) + ' ';
        end
    end
    temp2_aboveVt_swc = temp2_aboveVt_swc + '0xffff '
    fd = mopen('data_aboveVt_swc_3.hex','wt'); mputl(temp2_aboveVt_swc, fd); mclose(fd);

    m=n_target_aboveVt_swc+2;
    n_temp = n_target_aboveVt_swc; k=3;; clear data; data = [1:m];
    for l=1:number_of_switchfiles
        fd = mopen('data_aboveVt_swc_4_'+string(l)+'.hex','r');
        str_temp = mgetstr(7,fd);
        j=1;
        while str_temp ~= "0xffff ",
            data(j,1) = msscanf(str_temp,"%x");
            data(j,2) = data(j,2) + msscanf(mgetstr(7,fd),"%x");
            k_temp=k;
            if n_temp < maximum_swc_number then
                for i=1:n_temp
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            else
                for i=1:maximum_swc_number
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            end
            str_temp = mgetstr(7,fd);
            j=j+1;
        end
        mclose(fd);
        k=k+maximum_swc_number;
        n_temp = n_temp - maximum_swc_number;
    end

    j=j-1;
    clear temp2_aboveVt_swc; temp2_aboveVt_swc='';
    for i=1:j
        for k=1:m
            temp2_aboveVt_swc = temp2_aboveVt_swc + '0x' + string(sprintf('%4.4x', data(i,k))) + ' ';
        end
    end
    temp2_aboveVt_swc = temp2_aboveVt_swc + '0xffff '
    fd = mopen('data_aboveVt_swc_4.hex','wt'); mputl(temp2_aboveVt_swc, fd); mclose(fd);

    m=n_target_aboveVt_swc+2;
    n_temp = n_target_aboveVt_swc; k=3;; clear data; data = [1:m];
    for l=1:number_of_switchfiles
        fd = mopen('data_aboveVt_swc_5_'+string(l)+'.hex','r');
        str_temp = mgetstr(7,fd);
        j=1;
        while str_temp ~= "0xffff ",
            data(j,1) = msscanf(str_temp,"%x");
            data(j,2) = data(j,2) + msscanf(mgetstr(7,fd),"%x");
            k_temp=k;
            if n_temp < maximum_swc_number then
                for i=1:n_temp
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            else
                for i=1:maximum_swc_number
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            end
            str_temp = mgetstr(7,fd);
            j=j+1;
        end
        mclose(fd);
        k=k+maximum_swc_number;
        n_temp = n_temp - maximum_swc_number;
    end

    j=j-1;
    clear temp2_aboveVt_swc; temp2_aboveVt_swc='';
    for i=1:j
        for k=1:m
            temp2_aboveVt_swc = temp2_aboveVt_swc + '0x' + string(sprintf('%4.4x', data(i,k))) + ' ';
        end
    end
    temp2_aboveVt_swc = temp2_aboveVt_swc + '0xffff '
    fd = mopen('data_aboveVt_swc_5.hex','wt'); mputl(temp2_aboveVt_swc, fd); mclose(fd);
    
    disp("fine inj");
    target_l_aboveVt_swc=fscanfMat(hid_dir+'/target_list_aboveVt_swc');
    info_name = "_aboveVt_swc_"; info_win_num1 = 10; info_win_num2 = 11; info_win_num3 = 12; n_graph=n_target_aboveVt_swc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_swc;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_subVt_swc ~= 0 then
    disp("target_subVt_swc");
    // Check the size of switches and divide files
    n_temp = n_target_subVt_swc;
    maximum_swc_number = 100;
    number_of_switchfiles = int(n_target_subVt_swc/maximum_swc_number);
    if number_of_switchfiles < n_target_subVt_swc/maximum_swc_number then
        number_of_switchfiles = number_of_switchfiles + 1;
    end
    fd = mopen(hid_dir+'/target_info_subVt_swc','r'); clear switch_info_data; switch_info_data = [1:3];
    str_temp = mgetstr(7,fd);
    for i=1:n_target_subVt_swc
        switch_info_data(i,1) = msscanf(mgetstr(7,fd),"%x"); switch_info_data(i,2) = msscanf(mgetstr(7,fd),"%x"); switch_info_data(i,3) = msscanf(mgetstr(7,fd),"%x");
        dummy_scan = msscanf(mgetstr(7,fd),"%x"); dummy_scan = msscanf(mgetstr(7,fd),"%x");
    end
    mclose(fd);

    k=1;
    for j=1:number_of_switchfiles
        if n_temp < maximum_swc_number then
            temp = ''; temp = temp + '0x' + string(sprintf('%4.4x', n_temp)) + ' ';
            for i=1:n_temp
                temp = temp + '0x' + string(sprintf('%4.4x', switch_info_data(k,1))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,2))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,3))) + ' 0x0000' + ' 0xffff ';
                k=k+1;
            end
        fd = mopen('target_info_subVt_swc_'+string(j),'wt'); mputl(temp, fd); mclose(fd);
        else
            temp = ''; temp = temp + '0x' + string(sprintf('%4.4x', maximum_swc_number)) + ' ';
            for i=1:maximum_swc_number
                temp = temp + '0x' + string(sprintf('%4.4x', switch_info_data(k,1))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,2))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,3))) + ' 0x0000' + ' 0xffff ';
                k=k+1;
            end
            fd = mopen('target_info_subVt_swc_'+string(j),'wt'); mputl(temp, fd); mclose(fd);
        end
        n_temp = n_temp - maximum_swc_number;
    end

    unix_g(' mv target_info_subVt_swc_* ' + hid_dir);

// Execute Assembly codes
    for j=1:number_of_switchfiles
        while 1==1,
            [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_swc_"+string(j));
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_swc");
            if (b1==0) & (b2==0) then
                [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_subVt_SWC.elf");
                [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_swc_2_"+string(j)+".hex");
            end
            if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
            if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
        end
        disp("recover inj");
        while 1==1,
            [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_swc_"+string(j));
            if (b1==0) then
                [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_subVt_SWC.elf");
                [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_swc_3_"+string(j)+".hex");
            end
            if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
            if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
        end
        disp("first coarse inj");
        while 1==1,
            [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_swc_"+string(j));
            if (b1==0) then
                [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_subVt_SWC.elf");
                [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_swc_4_"+string(j)+".hex");
            end
            if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
            if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
        end
        disp("measured coarse inj");
        while 1==1,
            [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_swc_"+string(j));
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
            if (b1==0) & (b2==0) then
                [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_subVt_m_ave_04_SWC.elf");
                [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_swc_5_"+string(j)+".hex");
            end
            if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
            if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
        end
        //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
        //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    end
    
    // Read each file and make one file
    m=n_target_subVt_swc+2;
    n_temp = n_target_subVt_swc; k=3;; clear data; data = [1:m];
    for l=1:number_of_switchfiles
        fd = mopen('data_subVt_swc_2_'+string(l)+'.hex','r');
        str_temp = mgetstr(7,fd);
        j=1;
        while str_temp ~= "0xffff ",
            data(j,1) = msscanf(str_temp,"%x");
            data(j,2) = data(j,2) + msscanf(mgetstr(7,fd),"%x");
            k_temp=k;
            if n_temp < maximum_swc_number then
                for i=1:n_temp
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            else
                for i=1:maximum_swc_number
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            end
            str_temp = mgetstr(7,fd);
            j=j+1;
        end
        mclose(fd);
        k=k+maximum_swc_number;
        n_temp = n_temp - maximum_swc_number;
    end
    
    j=j-1;
    clear temp2_subVt_swc; temp2_subVt_swc='';
    for i=1:j
        for k=1:m
            temp2_subVt_swc = temp2_subVt_swc + '0x' + string(sprintf('%4.4x', data(i,k))) + ' ';
        end
    end
    temp2_subVt_swc = temp2_subVt_swc + '0xffff '
    fd = mopen('data_subVt_swc_2.hex','wt'); mputl(temp2_subVt_swc, fd); mclose(fd);

    m=n_target_subVt_swc+2;
    n_temp = n_target_subVt_swc; k=3;; clear data; data = [1:m];
    for l=1:number_of_switchfiles
        fd = mopen('data_subVt_swc_3_'+string(l)+'.hex','r');
        str_temp = mgetstr(7,fd);
        j=1;
        while str_temp ~= "0xffff ",
            data(j,1) = msscanf(str_temp,"%x");
            data(j,2) = data(j,2) + msscanf(mgetstr(7,fd),"%x");
            k_temp=k;
            if n_temp < maximum_swc_number then
                for i=1:n_temp
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            else
                for i=1:maximum_swc_number
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            end
            str_temp = mgetstr(7,fd);
            j=j+1;
        end
        mclose(fd);
        k=k+maximum_swc_number;
        n_temp = n_temp - maximum_swc_number;
    end

    j=j-1;
    clear temp2_subVt_swc; temp2_subVt_swc='';
    for i=1:j
        for k=1:m
            temp2_subVt_swc = temp2_subVt_swc + '0x' + string(sprintf('%4.4x', data(i,k))) + ' ';
        end
    end
    temp2_subVt_swc = temp2_subVt_swc + '0xffff '
    fd = mopen('data_subVt_swc_3.hex','wt'); mputl(temp2_subVt_swc, fd); mclose(fd);

    m=n_target_subVt_swc+2;
    n_temp = n_target_subVt_swc; k=3;; clear data; data = [1:m];
    for l=1:number_of_switchfiles
        fd = mopen('data_subVt_swc_4_'+string(l)+'.hex','r');
        str_temp = mgetstr(7,fd);
        j=1;
        while str_temp ~= "0xffff ",
            data(j,1) = msscanf(str_temp,"%x");
            data(j,2) = data(j,2) + msscanf(mgetstr(7,fd),"%x");
            k_temp=k;
            if n_temp < maximum_swc_number then
                for i=1:n_temp
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            else
                for i=1:maximum_swc_number
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            end
            str_temp = mgetstr(7,fd);
            j=j+1;
        end
        mclose(fd);
        k=k+maximum_swc_number;
        n_temp = n_temp - maximum_swc_number;
    end

    j=j-1;
    clear temp2_subVt_swc; temp2_subVt_swc='';
    for i=1:j
        for k=1:m
            temp2_subVt_swc = temp2_subVt_swc + '0x' + string(sprintf('%4.4x', data(i,k))) + ' ';
        end
    end
    temp2_subVt_swc = temp2_subVt_swc + '0xffff '
    fd = mopen('data_subVt_swc_4.hex','wt'); mputl(temp2_subVt_swc, fd); mclose(fd);

    m=n_target_subVt_swc+2;
    n_temp = n_target_subVt_swc; k=3;; clear data; data = [1:m];
    for l=1:number_of_switchfiles
        fd = mopen('data_subVt_swc_5_'+string(l)+'.hex','r');
        str_temp = mgetstr(7,fd);
        j=1;
        while str_temp ~= "0xffff ",
            data(j,1) = msscanf(str_temp,"%x");
            data(j,2) = data(j,2) + msscanf(mgetstr(7,fd),"%x");
            k_temp=k;
            if n_temp < maximum_swc_number then
                for i=1:n_temp
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            else
                for i=1:maximum_swc_number
                    data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                    k_temp=k_temp+1;
                end
            end
            str_temp = mgetstr(7,fd);
            j=j+1;
        end
        mclose(fd);
        k=k+maximum_swc_number;
        n_temp = n_temp - maximum_swc_number;
    end

    j=j-1;
    clear temp2_subVt_swc; temp2_subVt_swc='';
    for i=1:j
        for k=1:m
            temp2_subVt_swc = temp2_subVt_swc + '0x' + string(sprintf('%4.4x', data(i,k))) + ' ';
        end
    end
    temp2_subVt_swc = temp2_subVt_swc + '0xffff '
    fd = mopen('data_subVt_swc_5.hex','wt'); mputl(temp2_subVt_swc, fd); mclose(fd);

    disp("fine inj");
    target_l_subVt_swc=fscanfMat(hid_dir+'/target_list_subVt_swc');
    info_name = "_subVt_swc_"; info_win_num1 = 13; info_win_num2 = 14; info_win_num3 = 15; n_graph=n_target_subVt_swc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_subVt_swc;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_lowsubVt_swc ~= 0 then
    disp("target_lowsubVt_swc");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_swc");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_lowsubVt_swc");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_SWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_swc_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_swc");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_lowsubVt_SWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_swc_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_swc");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_lowsubVt_SWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_swc_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_swc");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_lowsubVt_m_ave_04_SWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_swc_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_lowsubVt_swc=fscanfMat(hid_dir+'/target_list_lowsubVt_swc');
    info_name = "_lowsubVt_swc_"; info_win_num1 = 16; info_win_num2 = 17; info_win_num3 = 18; n_graph=n_target_lowsubVt_swc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_swc;kapa_constant_or_not = kappa_constant;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_highaboveVt_ota ~= 0 then
    disp("target_highaboveVt_ota");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_highaboveVt_ota");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_ota");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_highaboveVt_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_highaboveVt_ota_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_highaboveVt_ota");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_highaboveVt_CAB_ota.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_highaboveVt_ota_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_highaboveVt_ota");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_highaboveVt_CAB_ota.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_highaboveVt_ota_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_highaboveVt_ota");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_highaboveVt_m_ave_04_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_highaboveVt_ota_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_highaboveVt_ota=fscanfMat(hid_dir+'/target_list_highaboveVt_ota');
    info_name = "_highaboveVt_ota_"; info_win_num1 = 70; info_win_num2 = 71; info_win_num3 = 72; n_graph=n_target_highaboveVt_ota; m_graph=n_graph+2;
    clear target_list; target_list = target_l_highaboveVt_ota;kapa_constant_or_not = 1/kappa_constant;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_aboveVt_ota ~= 0 then
    disp("target_aboveVt_ota");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_ota");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_ota");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_ota_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_ota");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_aboveVt_CAB_ota.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_ota_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_ota");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_aboveVt_CAB_ota.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_ota_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_ota");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_aboveVt_m_ave_04_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_ota_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_aboveVt_ota=fscanfMat(hid_dir+'/target_list_aboveVt_ota');
    info_name = "_aboveVt_ota_"; info_win_num1 = 20; info_win_num2 = 21; info_win_num3 = 22; n_graph=n_target_aboveVt_ota; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_ota;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_subVt_ota ~= 0 then
    disp("target_subVt_ota");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_ota");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_ota");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_subVt_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_ota_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_ota");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_subVt_CAB_ota.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_ota_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_ota");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_subVt_CAB_ota.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_ota_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_ota");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_subVt_m_ave_04_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_ota_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_subVt_ota=fscanfMat(hid_dir+'/target_list_subVt_ota');
    info_name = "_subVt_ota_"; info_win_num1 = 23; info_win_num2 = 24; info_win_num3 = 25; n_graph=n_target_subVt_ota; m_graph=n_graph+2;
    clear target_list; target_list = target_l_subVt_ota;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_lowsubVt_ota ~= 0 then
    disp("target_lowsubVt_ota");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_ota");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_lowsubVt_ota");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_ota_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_ota");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_lowsubVt_CAB_ota.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_ota_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_ota");
    if (b1==0) then
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_lowsubVt_CAB_ota.elf");
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_ota_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_ota");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_lowsubVt_m_ave_04_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_ota_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_lowsubVt_ota=fscanfMat(hid_dir+'/target_list_lowsubVt_ota');
    info_name = "_lowsubVt_ota_"; info_win_num1 = 26; info_win_num2 = 27; info_win_num3 = 28; n_graph=n_target_lowsubVt_ota; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_ota;kapa_constant_or_not = kappa_constant;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_aboveVt_otaref ~= 0 then
    disp("target_aboveVt_otaref");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_otaref");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_otaref");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_CAB_ota_ref.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_otaref_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_otaref");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_aboveVt_CAB_ota_ref.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_otaref_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_otaref");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_aboveVt_CAB_ota_ref.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_otaref_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_otaref");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_aboveVt_m_ave_04_CAB_ota_ref.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_otaref_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_aboveVt_otaref=fscanfMat(hid_dir+'/target_list_aboveVt_otaref');
    info_name = "_aboveVt_otaref_"; info_win_num1 = 30; info_win_num2 = 31; info_win_num3 = 32; n_graph=n_target_aboveVt_otaref; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_otaref;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_subVt_otaref ~= 0 then
    disp("target_subVt_otaref");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_otaref");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_otaref");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_subVt_CAB_ota_ref.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_otaref_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_otaref");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_subVt_CAB_ota_ref.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_otaref_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_otaref");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_subVt_CAB_ota_ref.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_otaref_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_otaref");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_subVt_m_ave_04_CAB_ota_ref.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_otaref_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_subVt_otaref=fscanfMat(hid_dir+'/target_list_subVt_otaref');
    info_name = "_subVt_otaref_"; info_win_num1 = 33; info_win_num2 = 34; info_win_num3 = 35; n_graph=n_target_subVt_otaref; m_graph=n_graph+2;
    clear target_list; target_list = target_l_subVt_otaref;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_lowsubVt_otaref ~= 0 then
    disp("target_lowsubVt_otaref");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_otaref");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_lowsubVt_otaref");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_CAB_ota_ref.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_otaref_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_otaref");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_lowsubVt_CAB_ota_ref.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_otaref_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_otaref");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_lowsubVt_CAB_ota_ref.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_otaref_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_otaref");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_lowsubVt_m_ave_04_CAB_ota_ref.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_otaref_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_lowsubVt_otaref=fscanfMat(hid_dir+'/target_list_lowsubVt_otaref');
    info_name = "_lowsubVt_otaref_"; info_win_num1 = 36; info_win_num2 = 37; info_win_num3 = 38; n_graph=n_target_lowsubVt_otaref; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_otaref; kapa_constant_or_not = kappa_constant;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_aboveVt_mite ~= 0 then
    disp("target_aboveVt_mite");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_mite");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_mite");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_CAB_mite.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_mite_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_mite");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_aboveVt_CAB_mite.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_mite_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_mite");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_aboveVt_CAB_mite.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_mite_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_mite");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_aboveVt_m_ave_04_CAB_mite.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_mite_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_aboveVt_mite=fscanfMat(hid_dir+'/target_list_aboveVt_mite');
    info_name = "_aboveVt_mite_"; info_win_num1 = 40; info_win_num2 = 41; info_win_num3 = 42; n_graph=n_target_aboveVt_mite; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_mite;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_subVt_mite ~= 0 then
    disp("target_subVt_mite");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_mite");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_mite");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_subVt_CAB_mite.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_mite_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
     disp("recover inj");
     while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_mite");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_subVt_CAB_mite.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_mite_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_mite");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_subVt_CAB_mite.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_mite_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_mite");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_subVt_m_ave_04_CAB_mite.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_mite_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_subVt_mite=fscanfMat(hid_dir+'/target_list_subVt_mite');
    info_name = "_subVt_mite_"; info_win_num1 = 43; info_win_num2 = 44; info_win_num3 = 45; n_graph=n_target_subVt_mite; m_graph=n_graph+2;
    clear target_list; target_list = target_l_subVt_mite;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_lowsubVt_mite ~= 0 then
    disp("target_lowsubVt_mite");
    while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_mite");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_lowsubVt_mite");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_CAB_mite.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_mite_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_mite");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_lowsubVt_CAB_mite.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_mite_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_mite");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_lowsubVt_CAB_mite.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_mite_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_mite");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_lowsubVt_m_ave_04_CAB_mite.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_mite_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_lowsubVt_mite=fscanfMat(hid_dir+'/target_list_lowsubVt_mite');
    info_name = "_lowsubVt_mite_"; info_win_num1 = 46; info_win_num2 = 47; info_win_num3 = 48; n_graph=n_target_lowsubVt_mite; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_mite;kapa_constant_or_not = kappa_constant;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_aboveVt_dirswc ~= 0 then
    disp("target_aboveVt_dirswc");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_dirswc");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_dirswc");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_DIRSWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_dirswc_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_dirswc");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_aboveVt_DIRSWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_dirswc_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_dirswc");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_aboveVt_DIRSWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_dirswc_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_dirswc");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_aboveVt_m_ave_04_DIRSWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_dirswc_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_aboveVt_dirswc=fscanfMat(hid_dir+'/target_list_aboveVt_dirswc');
    info_name = "_aboveVt_dirswc_"; info_win_num1 = 50; info_win_num2 = 51; info_win_num3 = 52; n_graph=n_target_aboveVt_dirswc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_dirswc;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_subVt_dirswc ~= 0 then
    disp("target_subVt_dirswc");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_dirswc");
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_dirswc");
        if (b1==0) & (b2==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_subVt_DIRSWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_dirswc_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_dirswc");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_subVt_DIRSWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_dirswc_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_dirswc");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_subVt_DIRSWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_dirswc_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_subVt_dirswc");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_subVt_m_ave_04_DIRSWC.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_subVt_dirswc_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_subVt_dirswc=fscanfMat(hid_dir+'/target_list_subVt_dirswc');
    info_name = "_subVt_dirswc_"; info_win_num1 = 53; info_win_num2 = 54; info_win_num3 = 55; n_graph=n_target_subVt_dirswc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_subVt_dirswc;kapa_constant_or_not=1;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

if n_target_lowsubVt_dirswc ~= 0 then
    disp("target_lowsubVt_dirswc");
    while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_dirswc");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/pulse_width_table_lowsubVt_dirswc");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_DIRSWC.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_dirswc_2.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    disp("recover inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_dirswc");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/first_coarse_program_lowsubVt_DIRSWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_dirswc_3.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("first coarse inj");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_dirswc");
        if (b1==0) then
            [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/measured_coarse_program_lowsubVt_DIRSWC.elf");
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_dirswc_4.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("measured coarse inj");
    while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_dirswc");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x6800 -input_file_name "+hid_dir+"/Vd_table_30mV");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/fine_program_lowsubVt_m_ave_04_DIRSWC.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_dirswc_5.hex");
        end
        if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
     end
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x7002 -length 220 -output_file_name temp_1.txt");
    //unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6800 -length 220 -output_file_name temp_2.txt");
    disp("fine inj");
    target_l_lowsubVt_dirswc=fscanfMat(hid_dir+'/target_list_lowsubVt_dirswc');
    info_name = "_lowsubVt_dirswc_"; info_win_num1 = 56; info_win_num2 = 57; info_win_num3 = 58; n_graph=n_target_lowsubVt_dirswc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_dirswc;kapa_constant_or_not = kappa_constant;
    exec("~/rasp30/prog_assembly/libs/scilab_code/target_program_graph.sce",-1);
end

unix_g(' mv *.hex *.data ' + hid_dir);
