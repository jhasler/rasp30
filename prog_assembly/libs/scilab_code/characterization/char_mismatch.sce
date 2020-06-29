global chip_num board_num brdtype;

unix_g("mkdir ~/rasp30/prog_assembly/work/calibration_step4");
cd("~/rasp30/prog_assembly/work/calibration_step4");
path =  pwd();
mkdir mmap_data_files;

file_name = path + "/mismatchmap.xcos";
mkdir .mismatchmap;
[path,fname,extension]=fileparts(file_name);
hid_dir=path+'.'+fname;

exec('~/rasp30/prog_assembly/libs/scilab_code/linefit.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/ekvfit_nfet.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2i.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_i2v.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2h.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_h2v.sce',-1);

Vto_mismatch_data=csvRead('./mmap_data_files/Vto_mismatch_data');

//scf(1);clf(1);
//for i=1:12
//    plot2d("nn", i, Vto_mismatch_data(i,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 1; // row0
//    plot2d("nn", i, Vto_mismatch_data(i+12,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 2; // row1
//    plot2d("nn", i, Vto_mismatch_data(i+24,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 3; // row2
//    plot2d("nn", i, Vto_mismatch_data(i+36,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 4; // row3
//    plot2d("nn", i, Vto_mismatch_data(i+48,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 5; // row4
//    plot2d("nn", i, Vto_mismatch_data(i+60,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 6; // row5
//    plot2d("nn", i, Vto_mismatch_data(i+72,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 7; // row6
//    plot2d("nn", i, Vto_mismatch_data(i+84,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 9; // row7
//    plot2d("nn", i, Vto_mismatch_data(i+96,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 10; // row8
//    plot2d("nn", i, Vto_mismatch_data(i+108,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 11; // row9
//    plot2d("nn", i, Vto_mismatch_data(i+120,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 12; // row10
//    plot2d("nn", i, Vto_mismatch_data(i+132,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 13; // row11
//    plot2d("nn", i, Vto_mismatch_data(i+144,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 14; // row12
//    plot2d("nn", i, Vto_mismatch_data(i+156,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 15; // row13
//    plot2d("nn", i, Vto_mismatch_data(i+168,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 16; // row14
//    plot2d("nn", i, Vto_mismatch_data(i+180,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 17; // row15
//    plot2d("nn", i, Vto_mismatch_data(i+192,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 18; // row16
//    plot2d("nn", i, Vto_mismatch_data(i+204,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 19; // row17
//    plot2d("nn", i, Vto_mismatch_data(i+216,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 20; // row18
//    plot2d("nn", i, Vto_mismatch_data(i+228,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 21; // row19
//    plot2d("nn", i, Vto_mismatch_data(i+240,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 22; // row20
//    plot2d("nn", i, Vto_mismatch_data(i+252,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 23; // row21
//    plot2d("nn", i, Vto_mismatch_data(i+264,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 24; // row22
//    plot2d("nn", i, Vto_mismatch_data(i+276,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 25; // row23
//    plot2d("nn", i, Vto_mismatch_data(i+288,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 26; // row24
//    plot2d("nn", i, Vto_mismatch_data(i+300,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 27; // row25
//    plot2d("nn", i, Vto_mismatch_data(i+312,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 28; // row26
//    plot2d("nn", i, Vto_mismatch_data(i+324,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 29; // row27
//    plot2d("nn", i, Vto_mismatch_data(i+336,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 30; // vdd1
//    plot2d("nn", i, Vto_mismatch_data(i+348,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 31; // vdd2
//    plot2d("nn", i, Vto_mismatch_data(i+364,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 32; // in12_1
//    plot2d("nn", i, Vto_mismatch_data(i+376,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 33; // in12_2
//    if i < 5 then
//        plot2d("nn", i, Vto_mismatch_data(i+360,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 35; // vdd3
//        plot2d("nn", i, Vto_mismatch_data(i+388,3));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off"; p.children.mark_foreground = 36; // in12_3
//    end
//end // 8, 34 : white
//a=gca();a.data_bounds=[0 -0.1; 12 +0.1];
//legend("r0","r1","r2","r3","r4","r5","r6","r7","r8","r9","r10","r11","r12","r13","r14","r15","r16","r17","r18","r19","r20","r21","r22","r23","r24","r25","r26","r27","vdd1","vdd2","in12_1","in12_2","vdd3","in12_3","in_upper_left");
//xtitle("","switch No.","Vth mismatch [V]");

histogram_edges = -0.05:0.0005:0.05;
scf(2);clf(2);
histo(Vto_mismatch_data(:,3),histogram_edges);p = get("hdl"); p.children.thickness = 3; p.children.line_mode="on";  p.children.line_style = 1;p.children.foreground=1;
//a=gca();a.data_bounds=[-0.05 0; 0.05 40];
xtitle("","Vth mismatch [V]","# of Vfg");

disp("Mean = "+string(1000*mean(Vto_mismatch_data(:,3)))+" mV");
disp("Sigma = "+string(1000*stdev(Vto_mismatch_data(:,3)))+" mV");

//disp(Vto_mismatch_data);
csvWrite(Vto_mismatch_data, 'mismatch_map');

//mismatchmap=csvRead('mismatch_map');
//[a1,b1]=unix_g('ls ~/rasp30/prog_assembly/libs/chip_parameters/mismatch_map/mismatch_map_chip'+chip_num+brdtype);
//if (b1==0) then // 0 if no error occurred, 1 if error.
//    mismatch_map_pre = csvRead('~/rasp30/prog_assembly/libs/chip_parameters/mismatch_map/mismatch_map_chip'+chip_num+brdtype);
//    combined_mismatchmap=[mismatch_map_pre;mismatchmap];  // Option 1: attach new one at the end of the previous one
//    //combined_mismatchmap=mismatch_map_pre; combined_mismatchmap(:,3)=combined_mismatchmap(:,3)+mismatchmap(:,3)/2; // Mismatch accumulation
//    //combined_mismatchmap=mismatch_map_pre; combined_mismatchmap(:,3)=combined_mismatchmap(:,3)+mismatchmap(:,3)/4; // Mismatch accumulation
//    //combined_mismatchmap=mismatch_map_pre; combined_mismatchmap(:,3)=combined_mismatchmap(:,3)+mismatchmap(:,3)/8; // Mismatch accumulation
//    //combined_mismatchmap=mismatch_map_pre; combined_mismatchmap(:,3)=combined_mismatchmap(:,3)+mismatchmap(:,3)/16; // Mismatch accumulation
//end
//if (b1~=0) then // 0 if no error occurred, 1 if error.
//    combined_mismatchmap=mismatchmap;
//end
//csvWrite(combined_mismatchmap, 'mismatch_map_combined');
//unix_w("cp mismatch_map_combined ~/rasp30/prog_assembly/libs/chip_parameters/mismatch_map/mismatch_map_chip"+chip_num+brdtype);

