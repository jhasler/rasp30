global file_name chip_num board_num brdtype;
[path,fname,extension] = fileparts(file_name);
hid_dir = path + '.' + fname;

select board_num 
case 2 then brdtype = '';
case 3 then brdtype = '_30a';
case 4 then brdtype = '_30n';
case 5 then brdtype = '_30h';
else messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort;
end

unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_debug.asm "+ path+'/chip_para_debug.asm');
unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_TR_chip"+chip_num+brdtype+".asm "+ path+'/chip_para_TR.asm');
unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_SP_chip"+chip_num+brdtype+".asm "+ path+'/chip_para_SP.asm');
unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_RI_chip"+chip_num+brdtype+".asm "+ path+'/chip_para_RI.asm');
unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_CP_chip"+chip_num+brdtype+".asm "+ path+'/chip_para_CP.asm');
unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_FP_chip"+chip_num+brdtype+".asm "+ path+'/chip_para_FP.asm');
unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/Vd_table/Vd_table_30mV_chip"+chip_num+brdtype+" Vd_table_30mV');

//exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_diodeADC.sce",-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2i.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_i2v.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2h.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_h2v.sce',-1);

zip_list = ' ';

/////////////////////////////////////////
// Make programm reverse program files //
////////////////////////////////////////
unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh tunnel_revtun_SWC_CAB ~/rasp30/prog_assembly/libs/asm_code/tunnel_revtun_SWC_CAB_ver00.s43 16384 16384 16384");
zip_list = zip_list + 'tunnel_revtun_SWC_CAB.elf ';

///////////////////////////////
// Make switch program files //
//////////////////////////////
switch_list_temp = fscanfMat(path+fname+'.swcs');
    
// Make switch list (dec) which includes the information how many switches are. 
temp_size= size(switch_list_temp); n=temp_size(1,1);switch_list=[0 0 0];j=1;
for i=1:n
    if switch_list_temp(i,4) == 0 then switch_list(j,:)=[switch_list_temp(i,1) switch_list_temp(i,2) switch_list_temp(i,3)]; j=j+1; end
end
fprintfMat('switch_list', switch_list, "%5.15f");

// Make switch info (hex) which will be uploaed to the sram. 
temp_size= size(switch_list); n=temp_size(1,1);
temp = ''; temp = temp + '0x' + string(sprintf('%4.4x', n)) + ' ';
for i=1:n
    if switch_list(i,3) == 2 then temp = temp + '0x' + string(sprintf('%4.4x', switch_list(i,1))) + ' 0x' + string(sprintf('%4.4x', switch_list(i,2))) + ' 0x' + string(sprintf('%4.4x', 0)) + ' ';
    else temp = temp + '0x' + string(sprintf('%4.4x', switch_list(i,1))) + ' 0x' + string(sprintf('%4.4x', switch_list(i,2))) + ' 0x' + string(sprintf('%4.4x', switch_list(i,3))) + ' '; end
end
fd = mopen('switch_info','wt'); mputl(temp, fd); mclose(fd);
zip_list = zip_list + 'switch_info ';

unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh switch_program ~/rasp30/prog_assembly/libs/asm_code/switch_program_ver04.s43 16384 16384 16384");
zip_list = zip_list + 'switch_program.elf ';

unix_g("rm "+hid_dir+"/switch_list_ble"); unix_g("rm "+hid_dir+"/switch_info_ble");
// Make switch list (dec) for ble switches.
temp_size= size(switch_list_temp); n=temp_size(1,1);switch_list_ble=[0 0 0];j=1;
for i=1:n
    if switch_list_temp(i,4) == 0 & switch_list_temp(i,3) == 2 then switch_list_ble(j,:)=[switch_list_temp(i,1) switch_list_temp(i,2) switch_list_temp(i,3)]; j=j+1; end
end

// Make switch info for ble (hex) which will be uploaed to the sram. 
temp_size= size(switch_list_ble); n=temp_size(1,1);
temp = ''; temp = temp + '0x' + string(sprintf('%4.4x', n)) + ' ';
for i=1:n
    temp = temp + '0x' + string(sprintf('%4.4x', switch_list_ble(i,1))) + ' 0x' + string(sprintf('%4.4x', switch_list_ble(i,2))) + ' 0x' + string(sprintf('%4.4x', switch_list_ble(i,3))) + ' ';
end

if switch_list_ble ~= [0 0 0] then
    fprintfMat('switch_list_ble', switch_list_ble, "%5.15f");
    fd = mopen('switch_info_ble','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh tunnel_clb ~/rasp30/prog_assembly/libs/asm_code/tunnel_revtun_CLB_ver00.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh switch_program_ble ~/rasp30/prog_assembly/libs/asm_code/switch_program_ble_ver00.s43 16384 16384 16384");
    unix_g('mv switch_list_ble switch_info_ble ' + hid_dir);
end


///////////////////////////////
// Make target program files //
//////////////////////////////
target_list = fscanfMat(path+fname+'.swcs');
temp_size= size(target_list); n=temp_size(1,1); m=n+2;

for i=1:n
    if target_list(i,4) == 0 then target_list(i,3) = 100e-09; end // 100nA doesn't mean anything. I just put it since switches with 0 caused error. 
end

// Mismatch map compensation
[a1,b1]=unix_g('ls ~/rasp30/prog_assembly/libs/chip_parameters/mismatch_map/mismatch_map_chip'+chip_num+brdtype);
if (b1==0) then // 0 if no error occurred, 1 if error.
    mismatch_map = csvRead('~/rasp30/prog_assembly/libs/chip_parameters/mismatch_map/mismatch_map_chip'+chip_num+brdtype);
    size_mmap= size(mismatch_map); r_size_mmap=size_mmap(1,1);
    for i=1:n
        if target_list(i,4) ~= 0 then   // Switch programming:0 , Target programming:1 ~ 6
            for j=1:r_size_mmap
                if target_list(i,1) == mismatch_map(j,1) then
                    if target_list(i,2) == mismatch_map(j,2) then
                        target_list(i,3) = diodeADC_v2i(diodeADC_i2v(target_list(i,3),chip_num,brdtype) + mismatch_map(j,3),chip_num,brdtype);
                    end
                end
            end
        end
    end
    fprintfMat("mismatch_mapped_swc_list", target_list, "%5.15f");
end

k=1; mmap_cal_list=[0 0 0 0]; // Mismatch map calibration list.
for i=1:n
    if target_list(i,4) == 11 | target_list(i,4) == 12 | target_list(i,4) == 13 | target_list(i,4) == 14 | target_list(i,4) == 15 then // Generate calibration list.
        mmap_cal_list(k,:)=target_list(i,:); target_list(i,4)=target_list(i,4)-10; k=k+1;
    end
end
if mmap_cal_list ~= [0 0 0 0] then fprintfMat("mismatch_calibration_list", mmap_cal_list, "%5.15f"); end

target_list_copy = target_list;

//ADC_Current_copy = ADC_Current;
temp_size= size(target_list); n=temp_size(1,1); m=n+2;
//temp_size2=size(ADC_Current_copy); n2=temp_size2(1,1);
kappa_constant = 30; // relationship of target current between subVt and lowsubVt range.

for i=1:n
    if target_list_copy(i,3) < 1E-09 then target_list_copy(i,3) = target_list_copy(i,3)*kappa_constant; end
    if target_list_copy(i,3) > 10E-06 then target_list_copy(i,3) = target_list_copy(i,3)/kappa_constant; end
end
//disp(target_list_copy)

//for i=1:n
//    if target_list(i,4) ~= 0 then   // Switch programming:0 , Target programming:1 ~ 6
//        ADC_Current_copy(:,3)=abs(ADC_Current_copy(:,2)-target_list_copy(i,3));
//        min_value = min(ADC_Current_copy(:,3));
//        for j=1:n2
//            if ADC_Current_copy(j,3) == min_value then
//                target_list(i,5) = ADC_Current_copy(j,1);
//            end
//        end
//    end
//end

target_list(:,5)=diodeADC_v2h(diodeADC_i2v(target_list_copy(:,3),chip_num,brdtype),chip_num,brdtype);
//disp(target_list);

temp2_tunnel_revtun=' '; 
temp2_highaboveVt_swc=' ';temp2_highaboveVt_ota=' ';
temp2_aboveVt_swc=' '; temp2_aboveVt_ota=' '; temp2_aboveVt_otaref=' '; temp2_aboveVt_mite=' '; temp2_aboveVt_dirswc=' ';
temp2_subVt_swc=' '; temp2_subVt_ota=' '; temp2_subVt_otaref=' '; temp2_subVt_mite=' '; temp2_subVt_dirswc=' ';
temp2_lowsubVt_swc=' ';temp2_lowsubVt_ota=' ';temp2_lowsubVt_otaref=' ';temp2_lowsubVt_mite=' ';temp2_lowsubVt_dirswc=' ';
n_target_tunnel_revtun=0;
n_target_highaboveVt_swc=0;n_target_highaboveVt_ota=0;
n_target_aboveVt_swc=0;n_target_aboveVt_ota=0;n_target_aboveVt_otaref=0;n_target_aboveVt_mite=0;n_target_aboveVt_dirswc=0;
n_target_subVt_swc=0;n_target_subVt_ota=0;n_target_subVt_otaref=0;n_target_subVt_mite=0;n_target_subVt_dirswc=0;
n_target_lowsubVt_swc=0;n_target_lowsubVt_ota=0;n_target_lowsubVt_otaref=0;n_target_lowsubVt_mite=0;n_target_lowsubVt_dirswc=0;
target_l_highaboveVt_swc=[0 0 0];target_l_highaboveVt_ota=[0 0 0];
target_l_aboveVt_swc=[0 0 0];target_l_aboveVt_ota=[0 0 0];target_l_aboveVt_otaref=[0 0 0];target_l_aboveVt_mite=[0 0 0];target_l_aboveVt_dirswc=[0 0 0];
target_l_subVt_swc=[0 0 0];target_l_subVt_ota=[0 0 0];target_l_subVt_otaref=[0 0 0];target_l_subVt_mite=[0 0 0];target_l_subVt_dirswc=[0 0 0];
target_l_lowsubVt_swc=[0 0 0];target_l_lowsubVt_ota=[0 0 0];target_l_lowsubVt_otaref=[0 0 0];target_l_lowsubVt_mite=[0 0 0];target_l_lowsubVt_dirswc=[0 0 0];
for i=1:n
    // Switch programming <0>, Target programming <1> 
    // 1:Switch FGs, 2:OTA_ref FGs(Bias), 3:OTA FGs, 4:MITE, 5:BLE, 6:Direct SWC FGs
    if target_list(i,4) == 1 | target_list(i,4) == 5 then
        if target_list(i,3) > 10E-6 then
            temp2_highaboveVt_swc = temp2_highaboveVt_swc + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_highaboveVt_swc=n_target_highaboveVt_swc+1;
            target_l_highaboveVt_swc(n_target_highaboveVt_swc,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) <= 10E-6 & target_list(i,3) > 1E-7 then
            temp2_aboveVt_swc = temp2_aboveVt_swc + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_aboveVt_swc=n_target_aboveVt_swc+1;
            target_l_aboveVt_swc(n_target_aboveVt_swc,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) <= 1E-7 & target_list(i,3) >= 1E-9 then
            temp2_subVt_swc = temp2_subVt_swc + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_subVt_swc=n_target_subVt_swc+1;
            target_l_subVt_swc(n_target_subVt_swc,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) < 1E-9 then
            temp2_lowsubVt_swc = temp2_lowsubVt_swc + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_lowsubVt_swc=n_target_lowsubVt_swc+1;
            target_l_lowsubVt_swc(n_target_lowsubVt_swc,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
    end
    if target_list(i,4) == 3 then
        if target_list(i,3) > 10E-6 then
            temp2_highaboveVt_ota = temp2_highaboveVt_ota + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_highaboveVt_ota=n_target_highaboveVt_ota+1;
            target_l_highaboveVt_ota(n_target_highaboveVt_ota,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) <= 10E-6 & target_list(i,3) > 1E-7 then
            temp2_aboveVt_ota = temp2_aboveVt_ota + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_aboveVt_ota=n_target_aboveVt_ota+1;
            target_l_aboveVt_ota(n_target_aboveVt_ota,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) <= 1E-7 & target_list(i,3) >= 1E-9 then
            temp2_subVt_ota = temp2_subVt_ota + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_subVt_ota=n_target_subVt_ota+1;
            target_l_subVt_ota(n_target_subVt_ota,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) < 1E-9 then
            temp2_lowsubVt_ota = temp2_lowsubVt_ota + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_lowsubVt_ota=n_target_lowsubVt_ota+1;
            target_l_lowsubVt_ota(n_target_lowsubVt_ota,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
    end
    if target_list(i,4) == 2 then
        if target_list(i,3) > 1E-7 then
            temp2_aboveVt_otaref = temp2_aboveVt_otaref + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_aboveVt_otaref=n_target_aboveVt_otaref+1;
            target_l_aboveVt_otaref(n_target_aboveVt_otaref,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) <= 1E-7 & target_list(i,3) >= 1E-9 then
            temp2_subVt_otaref = temp2_subVt_otaref + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_subVt_otaref=n_target_subVt_otaref+1;
            target_l_subVt_otaref(n_target_subVt_otaref,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) < 1E-9 then
            temp2_lowsubVt_otaref = temp2_lowsubVt_otaref + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_lowsubVt_otaref=n_target_lowsubVt_otaref+1;
            target_l_lowsubVt_otaref(n_target_lowsubVt_otaref,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
    end
    if target_list(i,4) == 4 then
        if target_list(i,3) > 1E-7 then
            temp2_aboveVt_mite = temp2_aboveVt_mite + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_aboveVt_mite=n_target_aboveVt_mite+1;
            target_l_aboveVt_mite(n_target_aboveVt_mite,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) <= 1E-7 & target_list(i,3) >= 1E-9 then
            temp2_subVt_mite = temp2_subVt_mite + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_subVt_mite=n_target_subVt_mite+1;
            target_l_subVt_mite(n_target_subVt_mite,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) < 1E-9 then
            temp2_lowsubVt_mite = temp2_lowsubVt_mite + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_lowsubVt_mite=n_target_lowsubVt_mite+1;
            target_l_lowsubVt_mite(n_target_lowsubVt_mite,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
    end
    if target_list(i,4) == 6 then
        if target_list(i,3) > 1E-7 then
            temp2_aboveVt_dirswc = temp2_aboveVt_dirswc + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_aboveVt_dirswc=n_target_aboveVt_dirswc+1;
            target_l_aboveVt_dirswc(n_target_aboveVt_dirswc,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) <= 1E-7 & target_list(i,3) >= 1E-9 then
            temp2_subVt_dirswc = temp2_subVt_dirswc + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_subVt_dirswc=n_target_subVt_dirswc+1;
            target_l_subVt_dirswc(n_target_subVt_dirswc,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
        if target_list(i,3) < 1E-9 then
            temp2_lowsubVt_dirswc = temp2_lowsubVt_dirswc + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
            n_target_lowsubVt_dirswc=n_target_lowsubVt_dirswc+1;
            target_l_lowsubVt_dirswc(n_target_lowsubVt_dirswc,:) = [target_list(i,1) target_list(i,2) target_list(i,3)];
        end
    end
    
    if target_list(i,4) ~= 0 then
        temp2_tunnel_revtun = temp2_tunnel_revtun + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' 0x' + string(sprintf('%4.4x', target_list(i,5))) + ' 0x0000' + ' 0xffff' + ' '; // Row, Col, target, diff, # of pulses (Start values should be 0xffff. 0x0000 means the coarse program is over)
        n_target_tunnel_revtun=n_target_tunnel_revtun+1;
    end

end

target_list_info=[n_target_tunnel_revtun;n_target_highaboveVt_swc;n_target_highaboveVt_ota;n_target_aboveVt_swc;n_target_aboveVt_ota;n_target_aboveVt_otaref;n_target_aboveVt_mite;n_target_aboveVt_dirswc;n_target_subVt_swc;n_target_subVt_ota;n_target_subVt_otaref;n_target_subVt_mite;n_target_subVt_dirswc;n_target_lowsubVt_swc;n_target_lowsubVt_ota;n_target_lowsubVt_otaref;n_target_lowsubVt_mite;n_target_lowsubVt_dirswc;kappa_constant;]
fprintfMat('target_list', target_list_info, "%5.15f");

if n_target_tunnel_revtun ~= 0 then
    temp1 = '0x' + string(sprintf('%4.4x', n_target_tunnel_revtun)); temp = temp1 + temp2_tunnel_revtun; fd = mopen('target_info_tunnel_revtun','wt'); mputl(temp, fd); mclose(fd);
    zip_list = zip_list + 'target_list Vd_table_30mV ';
end

if n_target_highaboveVt_swc ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_swc_chip"+chip_num+brdtype+" pulse_width_table_swc");
    fprintfMat('target_list_highaboveVt_swc', target_l_highaboveVt_swc, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_highaboveVt_swc)); temp = temp1 + temp2_highaboveVt_swc; fd = mopen('target_info_highaboveVt_swc','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_highaboveVt_SWC ~/rasp30/prog_assembly/libs/asm_code/recover_inject_highaboveVt_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_highaboveVt_SWC ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_highaboveVt_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_highaboveVt_SWC ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_highaboveVt_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_highaboveVt_m_ave_04_SWC ~/rasp30/prog_assembly/libs/asm_code/fine_program_highaboveVt_m_ave_04_SWC.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_highaboveVt_swc pulse_width_table_swc recover_inject_highaboveVt_SWC.elf first_coarse_program_highaboveVt_SWC.elf measured_coarse_program_highaboveVt_SWC.elf fine_program_highaboveVt_m_ave_04_SWC.elf ';
end

if n_target_aboveVt_swc ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_swc_chip"+chip_num+brdtype+" pulse_width_table_swc");
    fprintfMat('target_list_aboveVt_swc', target_l_aboveVt_swc, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_aboveVt_swc)); temp = temp1 + temp2_aboveVt_swc; fd = mopen('target_info_aboveVt_swc','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_aboveVt_SWC ~/rasp30/prog_assembly/libs/asm_code/recover_inject_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_aboveVt_SWC ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_aboveVt_SWC ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_aboveVt_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_aboveVt_m_ave_04_SWC ~/rasp30/prog_assembly/libs/asm_code/fine_program_aboveVt_m_ave_04_SWC.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_aboveVt_swc pulse_width_table_swc recover_inject_aboveVt_SWC.elf first_coarse_program_aboveVt_SWC.elf measured_coarse_program_aboveVt_SWC.elf fine_program_aboveVt_m_ave_04_SWC.elf ';
end

if n_target_subVt_swc ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_swc_chip"+chip_num+brdtype+" pulse_width_table_swc");
    fprintfMat('target_list_subVt_swc', target_l_subVt_swc, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_subVt_swc)); temp = temp1 + temp2_subVt_swc; fd = mopen('target_info_subVt_swc','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_subVt_SWC ~/rasp30/prog_assembly/libs/asm_code/recover_inject_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_subVt_SWC ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_subVt_SWC ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_subVt_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_subVt_m_ave_04_SWC ~/rasp30/prog_assembly/libs/asm_code/fine_program_subVt_m_ave_04_SWC.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_subVt_swc pulse_width_table_swc recover_inject_subVt_SWC.elf first_coarse_program_subVt_SWC.elf measured_coarse_program_subVt_SWC.elf fine_program_subVt_m_ave_04_SWC.elf ';
end

if n_target_lowsubVt_swc ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_lowsubVt_swc_chip"+chip_num+brdtype+" pulse_width_table_lowsubVt_swc");
    fprintfMat('target_list_lowsubVt_swc', target_l_lowsubVt_swc, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_lowsubVt_swc)); temp = temp1 + temp2_lowsubVt_swc; fd = mopen('target_info_lowsubVt_swc','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_lowsubVt_SWC ~/rasp30/prog_assembly/libs/asm_code/recover_inject_lowsubVt_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_lowsubVt_SWC ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_lowsubVt_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_lowsubVt_SWC ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_lowsubVt_SWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_lowsubVt_m_ave_04_SWC ~/rasp30/prog_assembly/libs/asm_code/fine_program_lowsubVt_m_ave_04_SWC.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_lowsubVt_swc pulse_width_table_lowsubVt_swc recover_inject_lowsubVt_SWC.elf first_coarse_program_lowsubVt_SWC.elf measured_coarse_program_lowsubVt_SWC.elf fine_program_lowsubVt_m_ave_04_SWC.elf ';
end

if n_target_highaboveVt_ota ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_ota_chip"+chip_num+brdtype+" pulse_width_table_ota");
    fprintfMat('target_list_highaboveVt_ota', target_l_highaboveVt_ota, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_highaboveVt_ota)); temp = temp1 + temp2_highaboveVt_ota; fd = mopen('target_info_highaboveVt_ota','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_highaboveVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/recover_inject_highaboveVt_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_highaboveVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_highaboveVt_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_highaboveVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_highaboveVt_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_highaboveVt_m_ave_04_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/fine_program_highaboveVt_m_ave_04_CAB_ota.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_highaboveVt_ota recover_inject_highaboveVt_CAB_ota.elf first_coarse_program_highaboveVt_CAB_ota.elf measured_coarse_program_highaboveVt_CAB_ota.elf fine_program_highaboveVt_m_ave_04_CAB_ota.elf ';
end

if n_target_aboveVt_ota ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_ota_chip"+chip_num+brdtype+" pulse_width_table_ota");
    fprintfMat('target_list_aboveVt_ota', target_l_aboveVt_ota, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_aboveVt_ota)); temp = temp1 + temp2_aboveVt_ota; fd = mopen('target_info_aboveVt_ota','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_aboveVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/recover_inject_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_aboveVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_aboveVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_aboveVt_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_aboveVt_m_ave_04_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/fine_program_aboveVt_m_ave_04_CAB_ota.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_aboveVt_ota pulse_width_table_ota recover_inject_aboveVt_CAB_ota.elf first_coarse_program_aboveVt_CAB_ota.elf measured_coarse_program_aboveVt_CAB_ota.elf fine_program_aboveVt_m_ave_04_CAB_ota.elf ';
end

if n_target_subVt_ota ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_ota_chip"+chip_num+brdtype+" pulse_width_table_ota");
    fprintfMat('target_list_subVt_ota', target_l_subVt_ota, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_subVt_ota)); temp = temp1 + temp2_subVt_ota; fd = mopen('target_info_subVt_ota','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_subVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/recover_inject_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_subVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_subVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_subVt_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_subVt_m_ave_04_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/fine_program_subVt_m_ave_04_CAB_ota.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_subVt_ota pulse_width_table_ota recover_inject_subVt_CAB_ota.elf first_coarse_program_subVt_CAB_ota.elf measured_coarse_program_subVt_CAB_ota.elf fine_program_subVt_m_ave_04_CAB_ota.elf ';
end

if n_target_lowsubVt_ota ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_lowsubVt_ota_chip"+chip_num+brdtype+" pulse_width_table_lowsubVt_ota");
    fprintfMat('target_list_lowsubVt_ota', target_l_lowsubVt_ota, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_lowsubVt_ota)); temp = temp1 + temp2_lowsubVt_ota; fd = mopen('target_info_lowsubVt_ota','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_lowsubVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/recover_inject_lowsubVt_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_lowsubVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_lowsubVt_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_lowsubVt_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_lowsubVt_CAB_ota.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_lowsubVt_m_ave_04_CAB_ota ~/rasp30/prog_assembly/libs/asm_code/fine_program_lowsubVt_m_ave_04_CAB_ota.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_lowsubVt_ota pulse_width_table_lowsubVt_ota recover_inject_lowsubVt_CAB_ota.elf first_coarse_program_lowsubVt_CAB_ota.elf measured_coarse_program_lowsubVt_CAB_ota.elf fine_program_lowsubVt_m_ave_04_CAB_ota.elf ';
end

if n_target_aboveVt_otaref ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_otaref_chip"+chip_num+brdtype+" pulse_width_table_otaref");
    fprintfMat('target_list_aboveVt_otaref', target_l_aboveVt_otaref, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_aboveVt_otaref)); temp = temp1 + temp2_aboveVt_otaref; fd = mopen('target_info_aboveVt_otaref','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_aboveVt_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/recover_inject_CAB_ota_ref.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_aboveVt_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_CAB_ota_ref.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_aboveVt_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_aboveVt_CAB_ota_ref.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_aboveVt_m_ave_04_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/fine_program_aboveVt_m_ave_04_CAB_ota_ref.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_aboveVt_otaref pulse_width_table_otaref recover_inject_aboveVt_CAB_ota_ref.elf first_coarse_program_aboveVt_CAB_ota_ref.elf measured_coarse_program_aboveVt_CAB_ota_ref.elf fine_program_aboveVt_m_ave_04_CAB_ota_ref.elf ';
end

if n_target_subVt_otaref ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_otaref_chip"+chip_num+brdtype+" pulse_width_table_otaref");
    fprintfMat('target_list_subVt_otaref', target_l_subVt_otaref, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_subVt_otaref)); temp = temp1 + temp2_subVt_otaref; fd = mopen('target_info_subVt_otaref','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_subVt_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/recover_inject_CAB_ota_ref.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_subVt_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_CAB_ota_ref.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_subVt_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_subVt_CAB_ota_ref.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_subVt_m_ave_04_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/fine_program_subVt_m_ave_04_CAB_ota_ref.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_subVt_otaref pulse_width_table_otaref recover_inject_subVt_CAB_ota_ref.elf first_coarse_program_subVt_CAB_ota_ref.elf measured_coarse_program_subVt_CAB_ota_ref.elf fine_program_subVt_m_ave_04_CAB_ota_ref.elf ';
end

if n_target_lowsubVt_otaref ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_lowsubVt_otaref_chip"+chip_num+brdtype+" pulse_width_table_lowsubVt_otaref");
    fprintfMat('target_list_lowsubVt_otaref', target_l_lowsubVt_otaref, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_lowsubVt_otaref)); temp = temp1 + temp2_lowsubVt_otaref; fd = mopen('target_info_lowsubVt_otaref','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_lowsubVt_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/recover_inject_lowsubVt_CAB_ota_ref.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_lowsubVt_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_lowsubVt_CAB_ota_ref.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_lowsubVt_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_lowsubVt_CAB_ota_ref.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_lowsubVt_m_ave_04_CAB_ota_ref ~/rasp30/prog_assembly/libs/asm_code/fine_program_lowsubVt_m_ave_04_CAB_ota_ref.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_lowsubVt_otaref pulse_width_table_lowsubVt_otaref recover_inject_lowsubVt_CAB_ota_ref.elf first_coarse_program_lowsubVt_CAB_ota_ref.elf measured_coarse_program_lowsubVt_CAB_ota_ref.elf fine_program_lowsubVt_m_ave_04_CAB_ota_ref.elf ';
end

if n_target_aboveVt_mite ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_mite_chip"+chip_num+brdtype+" pulse_width_table_mite");
    fprintfMat('target_list_aboveVt_mite', target_l_aboveVt_mite, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_aboveVt_mite)); temp = temp1 + temp2_aboveVt_mite; fd = mopen('target_info_aboveVt_mite','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_aboveVt_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/recover_inject_CAB_mite.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_aboveVt_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_CAB_mite.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_aboveVt_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_aboveVt_CAB_mite.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_aboveVt_m_ave_04_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/fine_program_aboveVt_m_ave_04_CAB_mite.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_aboveVt_mite pulse_width_table_mite recover_inject_aboveVt_CAB_mite.elf first_coarse_program_aboveVt_CAB_mite.elf measured_coarse_program_aboveVt_CAB_mite.elf fine_program_aboveVt_m_ave_04_CAB_mite.elf ';
end

if n_target_subVt_mite ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_mite_chip"+chip_num+brdtype+" pulse_width_table_mite");
    fprintfMat('target_list_subVt_mite', target_l_subVt_mite, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_subVt_mite)); temp = temp1 + temp2_subVt_mite; fd = mopen('target_info_subVt_mite','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_subVt_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/recover_inject_CAB_mite.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_subVt_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_CAB_mite.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_subVt_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_subVt_CAB_mite.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_subVt_m_ave_04_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/fine_program_subVt_m_ave_04_CAB_mite.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_subVt_mite pulse_width_table_mite recover_inject_subVt_CAB_mite.elf first_coarse_program_subVt_CAB_mite.elf measured_coarse_program_subVt_CAB_mite.elf fine_program_subVt_m_ave_04_CAB_mite.elf ';
end

if n_target_lowsubVt_mite ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_lowsubVt_mite_chip"+chip_num+brdtype+" pulse_width_table_lowsubVt_mite");
    fprintfMat('target_list_lowsubVt_mite', target_l_lowsubVt_mite, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_lowsubVt_mite)); temp = temp1 + temp2_lowsubVt_mite; fd = mopen('target_info_lowsubVt_mite','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_lowsubVt_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/recover_inject_lowsubVt_CAB_mite.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_lowsubVt_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_lowsubVt_CAB_mite.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_lowsubVt_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_lowsubVt_CAB_mite.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_lowsubVt_m_ave_04_CAB_mite ~/rasp30/prog_assembly/libs/asm_code/fine_program_lowsubVt_m_ave_04_CAB_mite.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_lowsubVt_mite pulse_width_table_lowsubVt_mite recover_inject_lowsubVt_CAB_mite.elf first_coarse_program_lowsubVt_CAB_mite.elf measured_coarse_program_lowsubVt_CAB_mite.elf fine_program_lowsubVt_m_ave_04_CAB_mite.elf ';
end

if n_target_aboveVt_dirswc ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_dirswc_chip"+chip_num+brdtype+" pulse_width_table_dirswc");
    fprintfMat('target_list_aboveVt_dirswc', target_l_aboveVt_dirswc, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_aboveVt_dirswc)); temp = temp1 + temp2_aboveVt_dirswc; fd = mopen('target_info_aboveVt_dirswc','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_aboveVt_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/recover_inject_DIRSWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_aboveVt_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_DIRSWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_aboveVt_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_aboveVt_DIRSWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_aboveVt_m_ave_04_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/fine_program_aboveVt_m_ave_04_DIRSWC.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_aboveVt_dirswc pulse_width_table_dirswc recover_inject_aboveVt_DIRSWC.elf first_coarse_program_aboveVt_DIRSWC.elf measured_coarse_program_aboveVt_DIRSWC.elf fine_program_aboveVt_m_ave_04_DIRSWC.elf ';
end

if n_target_subVt_dirswc ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_dirswc_chip"+chip_num+brdtype+" pulse_width_table_dirswc");
    fprintfMat('target_list_subVt_dirswc', target_l_subVt_dirswc, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_subVt_dirswc)); temp = temp1 + temp2_subVt_dirswc; fd = mopen('target_info_subVt_dirswc','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_subVt_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/recover_inject_DIRSWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_subVt_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_DIRSWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_subVt_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_subVt_DIRSWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_subVt_m_ave_04_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/fine_program_subVt_m_ave_04_DIRSWC.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_subVt_dirswc pulse_width_table_dirswc recover_inject_subVt_DIRSWC.elf first_coarse_program_subVt_DIRSWC.elf measured_coarse_program_subVt_DIRSWC.elf fine_program_subVt_m_ave_04_DIRSWC.elf ';
end

if n_target_lowsubVt_dirswc ~= 0 then
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table/pulse_width_table_lowsubVt_dirswc_chip"+chip_num+brdtype+" pulse_width_table_lowsubVt_dirswc");
    fprintfMat('target_list_lowsubVt_dirswc', target_l_lowsubVt_dirswc, "%5.15f");
    temp1 = '0x' + string(sprintf('%4.4x', n_target_lowsubVt_dirswc)); temp = temp1 + temp2_lowsubVt_dirswc; fd = mopen('target_info_lowsubVt_dirswc','wt'); mputl(temp, fd); mclose(fd);
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh recover_inject_lowsubVt_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/recover_inject_lowsubVt_DIRSWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh first_coarse_program_lowsubVt_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/first_coarse_program_lowsubVt_DIRSWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh measured_coarse_program_lowsubVt_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/measured_coarse_program_lowsubVt_DIRSWC.s43 16384 16384 16384");
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh fine_program_lowsubVt_m_ave_04_DIRSWC ~/rasp30/prog_assembly/libs/asm_code/fine_program_lowsubVt_m_ave_04_DIRSWC.s43 16384 16384 16384");
    zip_list = zip_list + 'target_info_lowsubVt_dirswc pulse_width_table_lowsubVt_dirswc recover_inject_lowsubVt_DIRSWC.elf first_coarse_program_lowsubVt_DIRSWC.elf measured_coarse_program_lowsubVt_DIRSWC.elf fine_program_lowsubVt_m_ave_04_DIRSWC.elf ';
end

unix_g('mv chip_para_debug.asm chip_para_TR.asm chip_para_SP.asm chip_para_RI.asm chip_para_CP.asm chip_para_FP.asm *.l43 *.o pmem.x pmem_defs.asm ' + hid_dir);

///////////////////////////
// Make output_info file //
//////////////////////////
temp_mite=' '; n_target_mite=0; target_list_mite=[0 0]; temp1=0;

for i=1:n
    // Switch programming - 0 : Switch FGs, Target programming - 1 : Switch FGs , 2 : OTA_ref FGs (Bias), 3 : OTA FGs, 4 : MITE, 5 : BLE
    if target_list(i,4) == 4 then
        temp_mite = temp_mite + '0x' + string(sprintf('%4.4x', target_list(i,1))) + ' 0x'+ string(sprintf('%4.4x', target_list(i,2))) + ' '; // Row, Col
        n_target_mite = n_target_mite +1;
    end
end
temp1 = '0x' + string(sprintf('%4.4x', n_target_mite)); temp = temp1 + temp_mite; fd = mopen('output_info','wt'); mputl(temp, fd); mclose(fd);

unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh run_mode_after_program ~/rasp30/prog_assembly/libs/asm_code/voltage_measurement_ver01_afterprogram.s43 16384 16384 16384");

global RAMP_ADC_check sftreg_check Signal_DAC_check GPIO_IN_check MITE_ADC_check ONchip_ADC Counter_class;
if n_target_mite ~= 0 then MITE_ADC_check=1; end

if(extension == '.swcs') then    // When it uses swcs for programming, this is default set.
    RAMP_ADC_check=0; sftreg_check=0; Signal_DAC_check=0; GPIO_IN_check=0; MITE_ADC_check=0;
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/voltage_measurement_ver01_withoutMITE.s43 16384 16384 16384");
    zip_list = zip_list + 'voltage_meas.elf ';
end
if (Signal_DAC_check==1) & (GPIO_IN_check==0) & (MITE_ADC_check==0) then
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/voltage_measurement_ver01_withoutMITE.s43 16384 16384 16384");
    zip_list = zip_list + 'voltage_meas.elf ';
end
if (Signal_DAC_check==1) & (GPIO_IN_check==0) & (MITE_ADC_check==1) then
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/voltage_measurement_ver01_withMITE.s43 16384 16384 16384");
    zip_list = zip_list + 'output_info voltage_meas.elf ';
end
if (Signal_DAC_check==1) & (GPIO_IN_check==1) & (MITE_ADC_check==1) then
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/runmode_signalDAC_gpin_miteADC.s43 16384 16384 16384");
    zip_list = zip_list + 'gpin_vector output_info voltage_meas.elf ';
end
if (Signal_DAC_check==1) & (GPIO_IN_check==0) & (RAMP_ADC_check==1) then
    if sftreg_check==1 then unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/sftreg_adc.s43 16384 16384 16384"); disp('shift here');
    //else unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/Ramp_ADC_DAC.s43 16384 16384 16384"); disp('RAMP here'); end
else unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/Ramp_ADC_DAC.s43 16384 16384 16384");//please use this it creates issues in remote
 disp('RAMP here');
  end
    zip_list = zip_list + 'output_info voltage_meas.elf ';
end
if (Signal_DAC_check==1) & (GPIO_IN_check==1) & (RAMP_ADC_check==1) then
    unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/runmode_signalDAC_gpin_rampADC.s43 16384 16384 16384");
    zip_list = zip_list + 'gpin_vector output_info output_info voltage_meas.elf ';
end
if (Signal_DAC_check==1) & (ONchip_ADC==1) then
  unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/ADC_onchip.s43 16384 16384 16384")
    zip_list = zip_list + 'output_info output_info voltage_meas.elf ';
end

if (Signal_DAC_check==1) & (Counter_class==1) then
  unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/Counter.s43 16384 16384 16384")
    zip_list = zip_list + 'output_info output_info voltage_meas.elf ';
    disp('here')
end

if (Signal_DAC_check==1) & (Counter_class==1) & (GPIO_IN_check==1) then
  unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/Counter.s43 16384 16384 16384")
    zip_list = zip_list + 'output_info output_info voltage_meas.elf ';
    disp('here1')
end


input_vector_temp = fscanfMat(path+'input_vector');
if input_vector_temp(1,2) == 0 then unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh voltage_meas ~/rasp30/prog_assembly/libs/asm_code/voltage_measurement_ver01_just_runmode.s43 16384 16384 16384"); end
zip_list = zip_list + 'input_vector ';

unix_g('rm '+fname+'.zip');
unix_s('zip '+fname+'.zip'+zip_list);
unix_g('mv DAC_mapping_info input_vector input_vector_for_graph output_info pulse_width_table_swc pulse_width_table_ota pulse_width_table_otaref pulse_width_table_mite pulse_width_table_dirswc pulse_width_table_lowsubVt_swc pulse_width_table_lowsubVt_ota pulse_width_table_lowsubVt_otaref pulse_width_table_lowsubVt_mite pulse_width_table_lowsubVt_dirswc switch_info switch_list Vd_table_30mV *.elf target_info* target_list* mismatch_mapped_swc_list gpin_vector gpin_mapping_info ' + hid_dir);
unix_g('mv *.l43 *.o pmem.x pmem_defs.asm ' + hid_dir);
