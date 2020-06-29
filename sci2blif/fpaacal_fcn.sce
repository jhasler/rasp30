global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
kappa_constant = 30; // relationship of target current between subVt and lowsubVt range.

function dir_callback() 
    [a,b]=unix_g('acroread /home/ubuntu/rasp30/sci2blif/documentation/cal_guide.pdf &');  
    if b == 1 then messagebox("Install Adobe Reader via the Documents menu on main RASP Design gui. ", "Adode Reader not installed yet!", "scilab"); end  
endfunction

function Choose_Board2_callback()
    global board_num brdtype
    Choose_Board2= findobj('tag','Choose_Board2');
    if (Choose_Board2.value == 1) then
    elseif (Choose_Board2.value == 2) then board_num=2; brdtype = ''; disp('You are now using the settings for the 3.0 Board');
    elseif (Choose_Board2.value == 3) then board_num=3; brdtype = '_30a'; disp('You are now using the settings for the 3.0 A Board');
    elseif (Choose_Board2.value == 4) then board_num=4; brdtype = '_30n'; disp('You are now using the settings for the 3.0 N Board');
    elseif (Choose_Board2.value == 5) then board_num=5; brdtype = '_30h'; disp('You are now using the settings for the 3.0 H Board');
    else
    end
endfunction

function Choose_Chip2_callback()
    global chip_num;
    Choose_Chip2 = findobj('tag','Choose_Chip2');
    chip_num = Choose_Chip2.string;   
endfunction

function Initate_Amm_callback()
    [amm_opt, amm_con] = unix_g('sudo chmod 777 /dev/prologix');  
    [amm_opt, amm_con1] = unix_g('sudo chmod 777 /dev/rasp30');
    if amm_con then messagebox(["Prologix GPIB-USB Controller is not connected under the VM Devices tab." "Please select Prologix and initiate again."],"Ammeter is not Connected via USB Devices" , "info", "modal");
    else disp("Ammeter has been initiated."); end
    if amm_con1 then messagebox(["FPAA Board is not connected under the VM Devices tab." "Please select the board and initiate again."],"FPAA Board is not Connected via USB Devices" , "info", "modal");
    else disp("FPAA Board has been initiated."); end
endfunction

function Step_1_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    disp('Step_1: Diode ADC');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step01"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step01"); 
    path =  pwd();
    messagebox('Before pressing OK, please make the connections as shown in Configuration A.',"Diode ADC Setup", "info", ["OK"], "modal");
    // diode ADC
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_diodeADC_cal.sce",-1); //get hex measurements for diode ADC
    unix_w("cp data_diodeADC_ivdd25V ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_diodeADC/data_diodeADC_chip"+chip_num+brdtype+"_ivdd25V');
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_diodeADC.sce",-1); // Call Diode ADC polifit function for six reference currents
    disp('Step 1 is complete!');
endfunction

function Step_2_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    disp('Step 2: Drain DAC');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step02"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step02"); 
    path =  pwd();
    messagebox('Before pressing OK, please make the connections as shown in Configuration B.',"Drain DAC Setup", "info", ["OK"], "modal");
    // drain DAC
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_drainDAC_cal.sce",-1); //get voltage measurements for drain DAC codes
    unix_w("cp data_drainDAC_ivdd60V ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_drainDAC/data_drainDAC_chip"+chip_num+brdtype+"_ivdd60V');
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_drainDAC.sce",-1); // Call Drain DAC polifit function for matrix of reference drain dac voltages to get the voltage codes
    unix_w("cp Vd_table_30mV ~/rasp30/prog_assembly/libs/chip_parameters/Vd_table/Vd_table_30mV_chip"+chip_num+brdtype);
    disp('Step 2 is complete!');
endfunction

function Step_3_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    disp('Step 3: Gate DAC');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step03"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step03"); 
    path =  pwd();
    messagebox('Before pressing OK, please make the connections as shown in Configuration C.',"Gate DAC Setup", "info", ["OK"], "modal");
    // gate DAC
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC_cal.sce",-1);//get voltage measurements for gate DAC codes
    unix_w("cp data_gateDAC_ivdd25V ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd25V');
    unix_w("cp data_gateDAC_ivdd60V_0 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd60V_0');
    unix_w("cp data_gateDAC_ivdd60V_1 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd60V_1');
    unix_w("cp data_gateDAC_ivdd60V_0_ER ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd60V_0_ER');
    unix_w("cp data_gateDAC_ivdd60V_1_ER ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd60V_1_ER');
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC.sce",-1); // Call gate DAC polifit function for 5 of reference gate dac voltages to get the voltage codes
    // Plot the data
    scf(5);clf(5);
    plot2d("nn", gate_dac_ivdd25V_m(:,1), gate_dac_ivdd25V_m(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
    plot2d("nn", gate_dac_ivdd60V_m_0(:,1), gate_dac_ivdd60V_m_0(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
    plot2d("nn", gate_dac_ivdd60V_m_1(:,1), gate_dac_ivdd60V_m_1(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=3;
    plot2d("nn", gate_dac_ivdd60V_m_0ER(:,1), gate_dac_ivdd60V_m_0ER(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=4;
    plot2d("nn", gate_dac_ivdd60V_m_1ER(:,1), gate_dac_ivdd60V_m_1ER(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=5;
    plot2d("nn", Gate_range_ivdd25V, gate_dac_fit_ivdd25V, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", Gate_range_ivdd60V_0, gate_dac_fit_ivdd60V_0, style=2);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", Gate_range_ivdd60V_1, gate_dac_fit_ivdd60V_1, style=3);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", Gate_range_ivdd60V_0ER, gate_dac_fit_ivdd60V_0ER, style=4);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", Gate_range_ivdd60V_1ER, gate_dac_fit_ivdd60V_1ER, style=5);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    a=gca();a.data_bounds=[0 0; 300 6];
    legend("ivdd2.5V","ivdd6V_0","ivdd6V_1","ivdd6V_0ER","ivdd6V_1ER","in_lower_right");
    xtitle("","ADC code","Vg (V)");
    disp('Step 3 is complete!');
endfunction

function Step_4_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    disp('Step 4: Gate coupling of Recover Injection Parameters');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step04"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step04");
    path =  pwd();
    messagebox('Before pressing OK, please remove all Digilent connections as they are not needed.',"Step 4-6 Setup", "info", ["OK"], "modal");
    exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2i.sce',-1);
    exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_i2v.sce',-1);
    exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2h.sce',-1);
    exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_h2v.sce',-1);
    hex_1na=int(diodeADC_v2h(diodeADC_i2v(1e-09,chip_num,brdtype),chip_num,brdtype));
    // Copy default files (only once at the first time)
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/Default_chip_para_TR_SP_RI_CP_FP.sce",-1);
    pulse_width_table_path = "~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table";
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_swc_default "+pulse_width_table_path+"/pulse_width_table_swc_chip"+chip_num+brdtype);
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_ota_default "+pulse_width_table_path+"/pulse_width_table_ota_chip"+chip_num+brdtype);
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_otaref_default "+pulse_width_table_path+"/pulse_width_table_otaref_chip"+chip_num+brdtype);
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_mite_default "+pulse_width_table_path+"/pulse_width_table_mite_chip"+chip_num+brdtype);
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_dirswc_default "+pulse_width_table_path+"/pulse_width_table_dirswc_chip"+chip_num+brdtype);
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_lowsubVt_swc_default "+pulse_width_table_path+"/pulse_width_table_lowsubVt_swc_chip"+chip_num+brdtype);
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_lowsubVt_ota_default "+pulse_width_table_path+"/pulse_width_table_lowsubVt_ota_chip"+chip_num+brdtype);
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_lowsubVt_otaref_default "+pulse_width_table_path+"/pulse_width_table_lowsubVt_otaref_chip"+chip_num+brdtype);
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_lowsubVt_mite_default "+pulse_width_table_path+"/pulse_width_table_lowsubVt_mite_chip"+chip_num+brdtype);
    unix_w("cp "+pulse_width_table_path+"/pulse_width_table_lowsubVt_dirswc_default "+pulse_width_table_path+"/pulse_width_table_lowsubVt_dirswc_chip"+chip_num+brdtype);
    //Recover injection parameters
    // Gate coupling calibration
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_RI_chip"+chip_num+brdtype+".asm chip_para_RI.asm');
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_TR_chip"+chip_num+brdtype+".asm chip_para_TR.asm');
    disp('Step 4: In progress');
    unix_w("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh tunnel_revtun_SWC_CAB ~/rasp30/prog_assembly/libs/asm_code/tunnel_revtun_SWC_CAB_ver00.s43 16384 16384 16384");
    fd = mopen('target_info_swc','wt'); mputl('0x0001 0x002d 0x0110 0x2302 0x0000 0xffff', fd); mclose(fd); // 45(Row) 272(Col) 10E-06(Target Current) 1
    fd = mopen('target_info_ota','wt'); mputl('0x0001 0x0153 0x03a1 0x2302 0x0000 0xffff', fd); mclose(fd); // 339 929 10E-06 3
    fd = mopen('target_info_otaref','wt'); mputl('0x0001 0x0152 0x03a1 0x2302 0x0000 0xffff', fd); mclose(fd); // 338 929 10E-06 2
    fd = mopen('target_info_mite','wt'); mputl('0x0001 0x01d9 0x03d1 0x2302 0x0000 0xffff', fd); mclose(fd); // 473 977 10E-06 4
    fd = mopen('target_info_dirswc','wt'); mputl('0x0001 0x0026 0x03b1 0x2302 0x0000 0xffff', fd); mclose(fd); // 38 945 10E-06 6
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gate_coupling.sce",-1);
    unix_w("cp chip_para_RI.asm ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_RI_chip"+chip_num+brdtype+".asm");
    //////////////see if plot is okay if not open file
    disp('Step 4 is complete!');
endfunction

function Step_5_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    disp('Step 5: Pulse width table for coarse injection paramerters');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step05"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step05");
    path =  pwd();
    file_name = path + "/Scurve_char.xcos";
    [path,fname,extension]=fileparts(file_name);
    hid_dir=path+'.'+fname;
    unix_s('mkdir -p '+hid_dir);
    exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2i.sce',-1);
    exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_i2v.sce',-1);
    exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2h.sce',-1);
    exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_h2v.sce',-1);
    hex_1na=int(diodeADC_v2h(diodeADC_i2v(1e-09,chip_num,brdtype),chip_num,brdtype));
    //coarse program parameter
    // S curve calibration for pulse_width_table @ coarse program
    fd = mopen('input_vector','wt'); mputl('0x0000 0x0000 0x03e8 0xFFFF', fd); mclose(fd); // making fake input_vector
    fd = mopen('output_info','wt'); mputl('0x0000', fd); mclose(fd); // making fake output_info
    fd = mopen('Scurve_char.swcs','wt'); mputl('0 0 0 0',fd); mputl('45 272 1E-06 1',fd); mputl('339 929 1E-06 3',fd); mputl('338 929 1E-06 2',fd); mputl('473 977 1E-06 4',fd); mputl('38 945 1E-06 6',fd); mputl('46 272 50E-12 1',fd); mputl('339 945 50E-12 3',fd); mputl('338 961 50E-12 2',fd); mputl('473 978 50E-12 4',fd); mputl('39 945 50E-12 6',fd); mclose(fd);
    exec("~/rasp30/prog_assembly/libs/scilab_code/MakeProgramlilst_CompileAssembly.sce",-1);
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/Recover_Injection_for_Scurve.sce",-1);
    unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_CP_chip"+chip_num+brdtype+".asm "+ path+'/chip_para_CP.asm');
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_Scurve.sce",-1);
    pulse_width_table_path = "~/rasp30/prog_assembly/libs/chip_parameters/pulse_width_table";
    unix_w("cp pulse_width_table_swc "+pulse_width_table_path+"/pulse_width_table_swc_chip"+chip_num+brdtype);
    unix_w("cp pulse_width_table_ota "+pulse_width_table_path+"/pulse_width_table_ota_chip"+chip_num+brdtype);
    unix_w("cp pulse_width_table_otaref "+pulse_width_table_path+"/pulse_width_table_otaref_chip"+chip_num+brdtype);
    unix_w("cp pulse_width_table_mite "+pulse_width_table_path+"/pulse_width_table_mite_chip"+chip_num+brdtype);
    unix_w("cp pulse_width_table_dirswc "+pulse_width_table_path+"/pulse_width_table_dirswc_chip"+chip_num+brdtype);
    unix_w("cp pulse_width_table_lowsubVt_swc "+pulse_width_table_path+"/pulse_width_table_lowsubVt_swc_chip"+chip_num+brdtype);
    unix_w("cp pulse_width_table_lowsubVt_ota "+pulse_width_table_path+"/pulse_width_table_lowsubVt_ota_chip"+chip_num+brdtype);
    unix_w("cp pulse_width_table_lowsubVt_otaref "+pulse_width_table_path+"/pulse_width_table_lowsubVt_otaref_chip"+chip_num+brdtype);
    unix_w("cp pulse_width_table_lowsubVt_mite "+pulse_width_table_path+"/pulse_width_table_lowsubVt_mite_chip"+chip_num+brdtype);
    unix_w("cp pulse_width_table_lowsubVt_dirswc "+pulse_width_table_path+"/pulse_width_table_lowsubVt_dirswc_chip"+chip_num+brdtype);
    disp('Step 5 is complete!');
endfunction

function Step_6_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    showprog = 1;
    disp('Step 6: Check Coarse & Fine Program Parameters')
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step06"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step06");
    path =  pwd();
    file_name = path + "/Check_C_F_prog_para.xcos";
    [path,fname,extension]=fileparts(file_name);
    hid_dir=path+'.'+fname;
    unix_s('mkdir -p '+hid_dir);
    // Check Coarse & Fine Program parameters
    etc5_callback;
    fd = mopen('Check_C_F_prog_para.swcs','wt'); 
    mputl('325 37 7E-09 1',fd); mputl('325 38 12E-09 1',fd); mputl('325 39 58E-09 1',fd); mputl('325 40 93E-09 1',fd); // SWC sub Vt
    mputl('45 272 7E-09 1',fd); mputl('46 272 12E-09 1',fd); mputl('47 272 58E-09 1',fd); mputl('48 272 93E-09 1',fd); // SWC sub Vt
  //  mputl('49 272 500E-09 1',fd); mputl('50 272 1E-06 1',fd); mputl('51 272 5E-06 1',fd); mputl('52 272 10E-06 1',fd); // SWC above Vt
 // mputl('53 272 900E-12 1',fd); mputl('54 272 500E-12 1',fd); mputl('55 272 100E-12 1',fd); mputl('56 272 50E-12 1',fd); // SWC low sub Vt
  // mputl('358 18 2.000000e-10 1',fd); mputl('358 19 2.000000e-10 1',fd); mputl('358 20 2.000000e-10 1',fd); mputl('358 21 2.000000e-10 1',fd); // SWC low sub Vt
  // mputl('358 22 2.000000e-10 1',fd); mputl('358 23 2.000000e-10 1',fd); mputl('358 24 2.000000e-10 1',fd); mputl('358 25 2.000000e-10 1',fd); // SWC low sub Vt
 //   mputl('339 929 5E-09 3',fd); mputl('339 945 10E-09 3',fd); mputl('339 961 50E-09 3',fd); mputl('339 977 100E-09 3',fd); // OTA sub Vt
 //   mputl('339 930 500E-09 3',fd); mputl('339 946 1E-06 3',fd); mputl('339 962 5E-06 3',fd); mputl('339 978 10E-06 3',fd); // OTA above Vt
 //   mputl('339 931 900E-12 3',fd); mputl('339 947 500E-12 3',fd); mputl('339 963 100E-12 3',fd); mputl('339 979 50E-12 3',fd);  //OTA low sub Vt
 //   mputl('338 929 5E-09 2',fd); mputl('338 961 10E-09 2',fd); mputl('338 993 50E-09 2',fd); mputl('338 1009 100E-09 2',fd); // OTA_ref sub Vt
  //  mputl('338 930 500E-09 2',fd); mputl('338 962 1E-06 2',fd); mputl('338 994 5E-06 2',fd); mputl('338 1010 10E-06 2',fd); // OTA_ref above Vt
  //  mputl('338 931 900E-12 2',fd); mputl('338 963 500E-12 2',fd); mputl('338 995 100E-12 2',fd); mputl('338 1011 50E-12 2',fd); // OTA_ref low sub Vt
  //  mputl('473 977 5E-09 4',fd); mputl('473 978 10E-09 4',fd); mputl('473 979 50E-09 4',fd); mputl('473 980 100E-09 4',fd);  // MITE sub Vt
  //  mputl('473 981 500E-09 4',fd); mputl('473 982 1E-06 4',fd); mputl('473 983 5E-06 4',fd); mputl('473 984 10E-06 4',fd); // MITE above Vt
  //  mputl('473 985 900E-12 4',fd); mputl('473 986 500E-12 4',fd); mputl('473 1009 100E-12 4',fd); mputl('473 1010 50E-12 4',fd);  //MITE low sub Vt
  //  mputl('38 945 5E-09 6',fd); mputl('39 945 10E-09 6',fd); mputl('40 945 50E-09 6',fd); mputl('41 945 100E-09 6',fd); // DIR SWC sub Vt
  //  mputl('42 945 500E-09 6',fd); mputl('43 945 1E-06 6',fd); mputl('44 945 5E-06 6',fd); mputl('45 945 10E-06 6',fd); // DIR SWC above Vt
//    mputl('46 945 900E-12 6',fd); mputl('47 945 500E-12 6',fd); mputl('48 945 100E-12 6',fd); mputl('49 945 50E-12 6',fd);  //DIR SWC low sub Vt
    mclose(fd);
    fd = mopen('input_vector','wt'); mputl('0x0000 0x0000 0x03e8 0xFFFF', fd); mclose(fd); // making fake input_vector
    fd = mopen('output_info','wt'); mputl('0x0000', fd); mclose(fd); // making fake output_info
    exec("~/rasp30/prog_assembly/libs/scilab_code/MakeProgramlilst_CompileAssembly.sce",-1);
    exec('/home/ubuntu/rasp30/prog_assembly/libs/scilab_code/tunnel_revtun_ver00_gui.sce', -1);
    disp('tunnel , reverse tunnel done');
    exec('/home/ubuntu/rasp30/prog_assembly/libs/scilab_code/target_program_ver02_gui.sce', -1);
    disp('target_program done');
    disp('Step 6 is complete!');
endfunction

function Step_7_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    showprog = 0;
    disp('Step 7: Golden Nfet & Pfet');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step07"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step07");
    messagebox('Before pressing OK, please make the connections as shown in Configuration F.',"Golden Nfet & Pfet Setup", "info", ["OK"], "modal"); 
    // Golden nFET & pFET
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET_cal.sce",-1);
    unix_w("cp data_nFET_IVg_curve ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET/data_nFET_IVg_curve_chip"+chip_num+brdtype);
    unix_w("cp data_nFET_IVd_curve ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET/data_nFET_IVd_curve_chip"+chip_num+brdtype);
    unix_w("cp data_pFET_IVg_curve ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET/data_pFET_IVg_curve_chip"+chip_num+brdtype);
    unix_w("cp data_pFET_IVd_curve ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET/data_pFET_IVd_curve_chip"+chip_num+brdtype);
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET.sce");
    disp('Step 7 is complete!');
endfunction

function Step_8_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    showprog = 0;
    disp('Step 8: On-Chip DAC');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step08"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step08");
    path =  pwd();
    file_name = path + "/onchipDAC.xcos";
    mkdir .onchipDAC;
    [path,fname,extension]=fileparts(file_name);
    hid_dir=path+'.'+fname;
    messagebox('Before pressing OK, please make the connections as shown in Configuration E.',"On-Chip DAC Setup", "info", ["OK"], "modal");
    // Onchip DAC
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC_cal.sce",-1);
    //exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/DAC_cal.sce",-1);//Sahil added for dac with mite cal.
    
    unix_w("cp data_onchipDAC00 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC00_chip"+chip_num+brdtype);
    unix_w("cp data_onchipDAC01 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC01_chip"+chip_num+brdtype);
    unix_w("cp data_onchipDAC02 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC02_chip"+chip_num+brdtype);
    unix_w("cp data_onchipDAC03 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC03_chip"+chip_num+brdtype);
    unix_w("cp data_onchipDAC04 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC04_chip"+chip_num+brdtype);
    unix_w("cp data_onchipDAC05 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC05_chip"+chip_num+brdtype);
    unix_w("cp data_onchipDAC06 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC06_chip"+chip_num+brdtype);
    unix_w("cp data_onchipDAC07 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC07_chip"+chip_num+brdtype);
    unix_w("cp data_onchipDAC08 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC08_chip"+chip_num+brdtype);
    unix_w("cp data_onchipDAC09 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC09_chip"+chip_num+brdtype);
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC.sce"); // Call onchip ADC polifit function 
    // Plot the data
    scf(6);clf(6);
    plot2d("nn", onchip_dac00_char_data(:,1), onchip_dac00_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
    plot2d("nn", onchip_dac01_char_data(:,1), onchip_dac01_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
    plot2d("nn", onchip_dac02_char_data(:,1), onchip_dac02_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=3;
    plot2d("nn", onchip_dac03_char_data(:,1), onchip_dac03_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=5;
    plot2d("nn", onchip_dac04_char_data(:,1), onchip_dac04_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=6;
    plot2d("nn", onchip_dac05_char_data(:,1), onchip_dac05_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
    plot2d("nn", onchip_dac06_char_data(:,1), onchip_dac06_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
    plot2d("nn", onchip_dac07_char_data(:,1), onchip_dac07_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=3;
    plot2d("nn", onchip_dac08_char_data(:,1), onchip_dac08_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=5;
    plot2d("nn", onchip_dac09_char_data(:,1), onchip_dac09_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=6;
    plot2d("nn", DAC00_HEX_range, DAC00_fit, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", DAC01_HEX_range, DAC01_fit, style=2);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", DAC02_HEX_range, DAC02_fit, style=3);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", DAC03_HEX_range, DAC03_fit, style=5);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", DAC04_HEX_range, DAC04_fit, style=6);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", DAC05_HEX_range, DAC05_fit, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", DAC06_HEX_range, DAC06_fit, style=2);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", DAC07_HEX_range, DAC07_fit, style=3);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", DAC08_HEX_range, DAC08_fit, style=5);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    plot2d("nn", DAC09_HEX_range, DAC09_fit, style=6);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    a=gca();a.data_bounds=[0 0; 150 2.6];
    legend("DAC00","DAC01","DAC02","DAC03","DAC04","DAC05","DAC06","DAC07","DAC08","DAC09","in_upper_right");
    xtitle("","ADC code","Vg (V)");
    disp('Step 8 is complete!');
endfunction

function Step_9_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    showprog = 0;
    disp('Step 9: MITE ADC');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step09"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step09");
    path =  pwd();
    file_name = path + "/miteADC.xcos";
    mkdir .miteADC;
    [path,fname,extension]=fileparts(file_name);
    hid_dir=path+'.'+fname;
    // MITE ADC
    // Copy default files (only once at the first time)
    data_miteADC_path = "~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC";
    unix_w("cp "+data_miteADC_path+"/data_miteADC473_977_default "+data_miteADC_path+"/data_miteADC473_977_chip"+chip_num+brdtype);
    //unix_w("cp "+data_miteADC_path+"/data_miteADC473_978_default "+data_miteADC_path+"/data_miteADC473_978_chip"+chip_num+brdtype);
    //unix_w("cp "+data_miteADC_path+"/data_miteADC473_979_default "+data_miteADC_path+"/data_miteADC473_979_chip"+chip_num+brdtype);
    // Start miteADC calibration
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC_cal.sce",-1);
    unix_w("cp data_miteADC473_977 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
    //unix_w("cp data_miteADC473_978 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_978_chip"+chip_num+brdtype);
    //unix_w("cp data_miteADC473_979 ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_979_chip"+chip_num+brdtype);
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC.sce");
    // Plot the data
    scf(7);clf(7);
    plot2d("nn", mite_473_977_10uA(:,1), mite_473_977_10uA(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
    //plot2d("nn", mite_473_978_10uA(:,1), mite_473_978_10uA(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
    //plot2d("nn", mite_473_979_10uA(:,1), mite_473_979_10uA(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=3;
    plot2d("nn", MITE_range_977, MITE_fit_977, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    //plot2d("nn", MITE_range_978, MITE_fit_978, style=2);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    //plot2d("nn", MITE_range_979, MITE_fit_979, style=3);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
    a=gca();//a.data_bounds=[0 0; 150 2.6];
    legend("mite_473_977","in_upper_right"); //legend("mite_473_977","mite_473_978","mite_473_979","in_upper_right");
    xtitle("","ADC code","Vg (V)");
    disp('Step 9 is complete!');
endfunction

function Step_10_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    showprog = 0;
    disp('Step 10: FG OTA DAC');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step10"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step10");
    // FG OTA DAC calibration
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_FGOTADAC_cal.sce",-1);
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_FGOTADAC.sce",-1);
    unix_w("cp data_fgotadac ~/rasp30/prog_assembly/libs/scilab_code/characterization/char_fgotaDAC/data_fgotadac_chip"+chip_num+brdtype);
    disp('Step 10 is complete!');
endfunction

function Step_11_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    showprog = 0;
    disp('Step 11: Ramp ADC');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step11"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step11");
    // Compiled Ramp ADC calibration




    disp('Step 11 is complete!');
endfunction

function Step_12_callback()
    global file_name path fname extension chip_num board_num brdtype hex_1na showprog;
    showprog = 0;
    disp('Step 12: Vt0 Mismatch');
    unix_g("mkdir ~/rasp30/prog_assembly/work"); //create temp folder for calibration
    unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step12"); //create temp folder to store intermediate files
    cd("~/rasp30/prog_assembly/work/calibration_step12");
    // Mismatch calibration
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_mismatch_meas_cal.sce",-1);
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_mismatch_cal.sce",-1);
    exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_mismatch.sce",-1);
    mismatchmap=csvRead('mismatch_map');
    [a1,b1]=unix_g('ls ~/rasp30/prog_assembly/libs/chip_parameters/mismatch_map/mismatch_map_chip'+chip_num+brdtype);
    if (b1==0) then // 0 if no error occurred, 1 if error.
        mismatch_map_pre = csvRead('~/rasp30/prog_assembly/libs/chip_parameters/mismatch_map/mismatch_map_chip'+chip_num+brdtype);
        combined_mismatchmap=[mismatch_map_pre;mismatchmap];  // Option 1: attach new one at the end of the previous one
        //combined_mismatchmap=mismatch_map_pre; combined_mismatchmap(:,3)=combined_mismatchmap(:,3)+mismatchmap(:,3)/2; // Mismatch accumulation
        //combined_mismatchmap=mismatch_map_pre; combined_mismatchmap(:,3)=combined_mismatchmap(:,3)+mismatchmap(:,3)/4; // Mismatch accumulation
        //combined_mismatchmap=mismatch_map_pre; combined_mismatchmap(:,3)=combined_mismatchmap(:,3)+mismatchmap(:,3)/8; // Mismatch accumulation
        //combined_mismatchmap=mismatch_map_pre; combined_mismatchmap(:,3)=combined_mismatchmap(:,3)+mismatchmap(:,3)/16; // Mismatch accumulation
    end
    if (b1~=0) then // 0 if no error occurred, 1 if error.
        combined_mismatchmap=mismatchmap;
    end
    csvWrite(combined_mismatchmap, 'mismatch_map_combined');
    unix_w("cp mismatch_map_combined ~/rasp30/prog_assembly/libs/chip_parameters/mismatch_map/mismatch_map_chip"+chip_num+brdtype);
    disp('Step 12 is complete!');
endfunction
