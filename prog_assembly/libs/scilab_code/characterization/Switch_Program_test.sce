global file_name path fname extension chip_num board_num brdtype hex_1nA hex_1na;
kappa_constant = 30; // relationship of target current between subVt and lowsubVt range.
//chip_num="16"; board_num=2; brdtype = ''; // 2: 3.0, 3: 3.0a, '':3.0 '_30a':3.0a
chip_num="13"; board_num=3; brdtype = '_30a'; // 2: 3.0, 3: 3.0a, '':3.0 '_30a':3.0a

cd("~/rasp30/prog_assembly/work/calibration_step3");
path =  pwd();
file_name = path + "/onchipDAC.xcos";
mkdir .onchipDAC;
[path,fname,extension]=fileparts(file_name);
hid_dir=path+'.'+fname;

DAC_blif = mopen('onchipDAC.blif','wb'); mputl('.model DAC',DAC_blif); mputl('.inputs net1_1 net3_1',DAC_blif); mputl('.outputs net2_1 net3_1',DAC_blif); mputl('',DAC_blif); mputl('#onchipDAC_cal',DAC_blif); mputl('.subckt ota in[0]=net1_1 in[1]=net2_1 out[0]=net2_1 ',DAC_blif); mputl('.end',DAC_blif); mclose(DAC_blif);
etc5_callback;

DAC_pads = mopen('onchipDAC.pads','wb'); mputl('net3_1 9 0 1 #int[1]',DAC_pads); mputl('net1_1 11 0 0 #tgate[0]',DAC_pads); mputl('out:net2_1 12 0 0 #tgate[0]',DAC_pads); mputl('out:net3_1 9 0 0 #tgate[0]',DAC_pads); mclose(DAC_pads);

unix_g('python ~/rasp30/vpr2swcs/genswcs.py -c onchipDAC -d .');

fd = mopen('input_vector','wt'); mputl('0x0000 0x0000 0x03e8 0xFFFF', fd); mclose(fd); // making fake input_vector
fd = mopen('output_info','wt'); mputl('0x0000', fd); mclose(fd); // making fake output_info

exec("~/rasp30/prog_assembly/libs/scilab_code/MakeProgramlilst_CompileAssembly.sce",-1);
exec('/home/ubuntu/rasp30/prog_assembly/libs/scilab_code/tunnel_revtun_ver00_gui.sce', -1);
disp('tunnel , reverse tunnel done');
exec('/home/ubuntu/rasp30/prog_assembly/libs/scilab_code/switch_program_ver05_gui.sce', -1);
disp('switch_program done');
exec('/home/ubuntu/rasp30/prog_assembly/libs/scilab_code/dc_setup_gui.sce', -1);
disp('DC setup done');
