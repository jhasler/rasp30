exec('~/rasp30/prog_assembly/libs/scilab_code/read_tar_pgm_result.sce',-1);
time_scale=1e-5; // Time unit : 10us

// Tunnel & Reverse Tunnel
while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/tunnel_revtun_SWC_CAB.elf");
    if (b1==0) then break end // 0 if no error occurred, 1 if error.
    disp("connection issue -> it is trying again");
    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
    sleep(2000);
end

// Recover Injection
if n_target_aboveVt_swc ~= 0 then
    disp("target_aboveVt_swc");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_swc");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_SWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_swc_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_aboveVt_swc=fscanfMat(hid_dir+'/target_list_aboveVt_swc');
    info_name = "_aboveVt_swc_"; n_graph=n_target_aboveVt_swc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_swc;kapa_constant_or_not=1;
    
    clear data_01; data_01=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_01(:,i)=diodeADC_v2i(diodeADC_h2v(data_01(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end

    clear legend_target_list; legend_target_list = ('a');
    scf(11);clf(11);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_01(:,2), data_01(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end


if n_target_aboveVt_ota ~= 0 then
    disp("target_aboveVt_ota");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_ota");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_ota_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_aboveVt_ota=fscanfMat(hid_dir+'/target_list_aboveVt_ota');
    info_name = "_aboveVt_ota_"; n_graph=n_target_aboveVt_ota; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_ota;kapa_constant_or_not=1;
    
    clear data_02; data_02=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_02(:,i)=diodeADC_v2i(diodeADC_h2v(data_02(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end
    
    clear legend_target_list; legend_target_list = ('a');
    scf(12);clf(12);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_02(:,2), data_02(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end


if n_target_aboveVt_otaref ~= 0 then
    disp("target_aboveVt_otaref");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_otaref");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_CAB_ota_ref.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_otaref_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_aboveVt_otaref=fscanfMat(hid_dir+'/target_list_aboveVt_otaref');
    info_name = "_aboveVt_otaref_"; n_graph=n_target_aboveVt_otaref; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_otaref;kapa_constant_or_not=1;
    
    clear data_03; data_03=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_03(:,i)=diodeADC_v2i(diodeADC_h2v(data_03(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end
    
    clear legend_target_list; legend_target_list = ('a');
    scf(13);clf(13);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_03(:,2), data_03(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end


if n_target_aboveVt_mite ~= 0 then
    disp("target_aboveVt_mite");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_mite");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_CAB_mite.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_mite_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_aboveVt_mite=fscanfMat(hid_dir+'/target_list_aboveVt_mite');
    info_name = "_aboveVt_mite_"; n_graph=n_target_aboveVt_mite; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_mite;kapa_constant_or_not=1;
    
    clear data_04; data_04=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_04(:,i)=diodeADC_v2i(diodeADC_h2v(data_04(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end
    
    clear legend_target_list; legend_target_list = ('a');
    scf(14);clf(14);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_04(:,2), data_04(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end


if n_target_aboveVt_dirswc ~= 0 then
    disp("target_aboveVt_dirswc");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_dirswc");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_aboveVt_DIRSWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_aboveVt_dirswc_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_aboveVt_dirswc=fscanfMat(hid_dir+'/target_list_aboveVt_dirswc');
    info_name = "_aboveVt_dirswc_"; n_graph=n_target_aboveVt_dirswc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_aboveVt_dirswc;kapa_constant_or_not=1;
    
    clear data_05; data_05=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_05(:,i)=diodeADC_v2i(diodeADC_h2v(data_05(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end
    
    clear legend_target_list; legend_target_list = ('a');
    scf(15);clf(15);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_05(:,2), data_05(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end


if n_target_lowsubVt_swc ~= 0 then
    disp("target_lowsubVt_swc");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_swc");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_SWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_swc_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_lowsubVt_swc=fscanfMat(hid_dir+'/target_list_lowsubVt_swc');
    info_name = "_lowsubVt_swc_"; n_graph=n_target_lowsubVt_swc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_swc;kapa_constant_or_not=1;
    
    clear data_01; data_01=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_01(:,i)=diodeADC_v2i(diodeADC_h2v(data_01(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end
    
    clear legend_target_list; legend_target_list = ('a');
    scf(16);clf(16);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_01(:,2), data_01(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end


if n_target_lowsubVt_ota ~= 0 then
    disp("target_lowsubVt_ota");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_ota");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_CAB_ota.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_ota_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_lowsubVt_ota=fscanfMat(hid_dir+'/target_list_lowsubVt_ota');
    info_name = "_lowsubVt_ota_"; n_graph=n_target_lowsubVt_ota; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_ota;kapa_constant_or_not=1;
    
    clear data_02; data_02=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_02(:,i)=diodeADC_v2i(diodeADC_h2v(data_02(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end
    
    clear legend_target_list; legend_target_list = ('a');
    scf(17);clf(17);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_02(:,2), data_02(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end


if n_target_lowsubVt_otaref ~= 0 then
    disp("target_lowsubVt_otaref");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_otaref");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_CAB_ota_ref.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_otaref_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_lowsubVt_otaref=fscanfMat(hid_dir+'/target_list_lowsubVt_otaref');
    info_name = "_lowsubVt_otaref_"; n_graph=n_target_lowsubVt_otaref; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_otaref;kapa_constant_or_not=1;
    
    clear data_03; data_03=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_03(:,i)=diodeADC_v2i(diodeADC_h2v(data_03(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end
    
    clear legend_target_list; legend_target_list = ('a');
    scf(18);clf(18);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_03(:,2), data_03(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end


if n_target_lowsubVt_mite ~= 0 then
    disp("target_lowsubVt_mite");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_mite");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_CAB_mite.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_mite_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_lowsubVt_mite=fscanfMat(hid_dir+'/target_list_lowsubVt_mite');
    info_name = "_lowsubVt_mite_"; n_graph=n_target_lowsubVt_mite; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_mite;kapa_constant_or_not=1;
    
    clear data_04; data_04=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_04(:,i)=diodeADC_v2i(diodeADC_h2v(data_04(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end
    
    clear legend_target_list; legend_target_list = ('a');
    scf(19);clf(19);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_04(:,2), data_04(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end


if n_target_lowsubVt_dirswc ~= 0 then
    disp("target_lowsubVt_dirswc");
    while 1==1,
        [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_dirswc");
        if (b1==0) then
            [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/recover_inject_lowsubVt_DIRSWC.elf");
            [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name data_lowsubVt_dirswc_2.hex");
        end
        if (b1==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
    end
    disp("recover inj");
    target_l_lowsubVt_dirswc=fscanfMat(hid_dir+'/target_list_lowsubVt_dirswc');
    info_name = "_lowsubVt_dirswc_"; n_graph=n_target_lowsubVt_dirswc; m_graph=n_graph+2;
    clear target_list; target_list = target_l_lowsubVt_dirswc;kapa_constant_or_not=1;
    
    clear data_05; data_05=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
    for i=3:m_graph
        data_05(:,i)=diodeADC_v2i(diodeADC_h2v(data_05(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
    end
    
    clear legend_target_list; legend_target_list = ('a');
    scf(20);clf(20);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data_05(:,2), data_05(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
end
