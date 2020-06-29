exec('~/rasp30/prog_assembly/libs/scilab_code/read_tar_pgm_result.sce',-1);
time_scale=1e-5; // Time unit : 10us

while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_swc ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_swc.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_swc");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_swc.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_swc.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_swc; data_swc=read_tar_pgm_result('char_Scurve_swc.hex',m_graph,time_scale);
for i=3:m_graph
    data_swc(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_swc(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end
// data_swc(:,3) Hex@Vgm=0.6V, data_swc(:,4) Hex@Vgm=0V, data_swc(:,5) Current@Vgm=0.6V, data_swc(:,6) Current@Vgm=0V

scf(11);clf(11);
plot2d("nl", data_swc(:,2), data_swc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
fprintfMat("Scurve_at_Vg3.6V_swc.data", data_swc, "%5.15f");

data_size_temp=size(data_swc);

scf(12);clf(12);
plot2d("nn", data_swc(1:data_size_temp(1,1)-1,3), data_swc(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_swc = [(0:64:64*255)'];
pwt_swc = pwt_swc + hex_1na;
pwt_swc(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_swc','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_swc(i,3) > hex_1na then j=j+1; end
        if pwt_swc(k,1) > data_swc(i,3) then pwt_swc(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_swc(k,2))),fd_w);
end
mclose(fd_w);


while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_ota ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_ota.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_ota");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_ota.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_ota.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_ota; data_ota=read_tar_pgm_result('char_Scurve_ota.hex',m_graph,time_scale);
for i=3:m_graph
    data_ota(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_ota(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end

scf(13);clf(13);
plot2d("nl", data_ota(:,2), data_ota(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;

data_size_temp=size(data_ota) 
fprintfMat("Scurve_at_Vg3.6V_ota.data", data_ota, "%5.15f");

scf(14);clf(14);
plot2d("nn", data_ota(1:data_size_temp(1,1)-1,3), data_ota(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_ota = [(0:64:64*255)'];
pwt_ota = pwt_ota + hex_1na;
pwt_ota(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_ota','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_ota(i,3) > hex_1na then j=j+1; end
        if pwt_ota(k,1) > data_ota(i,3) then pwt_ota(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_ota(k,2))),fd_w);
end
mclose(fd_w);


while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_otaref ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_otaref.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_otaref");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_otaref.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_otaref.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_otaref; data_otaref=read_tar_pgm_result('char_Scurve_otaref.hex',m_graph,time_scale);
for i=3:m_graph
    data_otaref(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_otaref(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end
// data_otaref(:,3) Hex@Vgm=0.6V, data_otaref(:,4) Hex@Vgm=0V, data_otaref(:,5) Current@Vgm=0.6V, data_otaref(:,6) Current@Vgm=0V

scf(15);clf(15);
plot2d("nl", data_otaref(:,2), data_otaref(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
fprintfMat("Scurve_at_Vg3.6V_otaref.data", data_otaref, "%5.15f");

data_size_temp=size(data_otaref) 

scf(16);clf(16);
plot2d("nn", data_otaref(1:data_size_temp(1,1)-1,3), data_otaref(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_otaref = [(0:64:64*255)'];
pwt_otaref = pwt_otaref + hex_1na;
pwt_otaref(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_otaref','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_otaref(i,3) > hex_1na then j=j+1; end
        if pwt_otaref(k,1) > data_otaref(i,3) then pwt_otaref(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_otaref(k,2))),fd_w);
end
mclose(fd_w);


while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_mite ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_mite.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_mite");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_mite.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_mite.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_mite; data_mite=read_tar_pgm_result('char_Scurve_mite.hex',m_graph,time_scale);
for i=3:m_graph
    data_mite(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_mite(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end
// data_mite(:,3) Hex@Vgm=0.6V, data_mite(:,4) Hex@Vgm=0V, data_mite(:,5) Current@Vgm=0.6V, data_mite(:,6) Current@Vgm=0V

scf(17);clf(17);
plot2d("nl", data_mite(:,2), data_mite(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
fprintfMat("Scurve_at_Vg3.6V_mite.data", data_mite, "%5.15f");

data_size_temp=size(data_mite) 

scf(18);clf(18);
plot2d("nn", data_mite(1:data_size_temp(1,1)-1,3), data_mite(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_mite = [(0:64:64*255)'];
pwt_mite = pwt_mite + hex_1na;
pwt_mite(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_mite','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_mite(i,3) > hex_1na then j=j+1; end
        if pwt_mite(k,1) > data_mite(i,3) then pwt_mite(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_mite(k,2))),fd_w);
end
mclose(fd_w);


while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_dirswc ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_dirswc.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_aboveVt_dirswc");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_dirswc.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_dirswc.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_dirswc; data_dirswc=read_tar_pgm_result('char_Scurve_dirswc.hex',m_graph,time_scale);
for i=3:m_graph
    data_dirswc(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_dirswc(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end
// data_dirswc(:,3) Hex@Vgm=0.6V, data_dirswc(:,4) Hex@Vgm=0V, data_dirswc(:,5) Current@Vgm=0.6V, data_dirswc(:,6) Current@Vgm=0V

scf(19);clf(19);
plot2d("nl", data_dirswc(:,2), data_dirswc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
fprintfMat("Scurve_at_Vg3.6V_dirswc.data", data_dirswc, "%5.15f");

data_size_temp=size(data_dirswc) 

scf(20);clf(20);
plot2d("nn", data_dirswc(1:data_size_temp(1,1)-1,3), data_dirswc(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_dirswc = [(0:64:64*255)'];
pwt_dirswc = pwt_dirswc + hex_1na;
pwt_dirswc(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_dirswc','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_dirswc(i,3) > hex_1na then j=j+1; end
        if pwt_dirswc(k,1) > data_dirswc(i,3) then pwt_dirswc(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_dirswc(k,2))),fd_w);
end
mclose(fd_w);


scf(21);clf(21);
plot2d("nl", data_swc(:,2), data_swc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
plot2d("nl", data_ota(:,2), data_ota(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off';
plot2d("nl", data_otaref(:,2), data_otaref(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 3;p.children.line_mode = 'off';
plot2d("nl", data_mite(:,2), data_mite(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 4;p.children.line_mode = 'off';
plot2d("nl", data_dirswc(:,2), data_dirswc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 5;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
legend("swc","ota","otaref","mite","dirswc","in_lower_right");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
//a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=0.001;a.data_bounds(2,2)=1D-04;

scf(22);clf(22);
data_size_temp=size(data_swc);plot2d("nn", data_swc(1:data_size_temp(1,1)-1,3), data_swc(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
data_size_temp=size(data_ota);plot2d("nn", data_ota(1:data_size_temp(1,1)-1,3), data_ota(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off';
data_size_temp=size(data_otaref);plot2d("nn", data_otaref(1:data_size_temp(1,1)-1,3), data_otaref(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 3;p.children.line_mode = 'off';
data_size_temp=size(data_dirswc);plot2d("nn", data_dirswc(1:data_size_temp(1,1)-1,3), data_dirswc(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 5;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");
legend("swc","ota","otaref","dirswc","in_lower_right");
//a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;


while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_lowsubVt_swc ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_lowsubVt_swc.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_swc");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_lowsubVt_swc.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_lowsubVt_swc.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_lowsubVt_swc; data_lowsubVt_swc=read_tar_pgm_result('char_Scurve_lowsubVt_swc.hex',m_graph,time_scale);
for i=3:m_graph
    data_lowsubVt_swc(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_lowsubVt_swc(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end
// data_swc(:,3) Hex@Vgm=0.6V, data_swc(:,4) Hex@Vgm=0V, data_swc(:,5) Current@Vgm=0.6V, data_swc(:,6) Current@Vgm=0V

scf(31);clf(31);
plot2d("nl", data_lowsubVt_swc(:,2), data_lowsubVt_swc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
fprintfMat("Scurve_at_Vg3.6V_lowsubVt_swc.data", data_lowsubVt_swc, "%5.15f");

data_size_temp=size(data_lowsubVt_swc) 

scf(32);clf(32);
plot2d("nn", data_lowsubVt_swc(1:data_size_temp(1,1)-1,3), data_lowsubVt_swc(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_lowsubVt_swc = [(0:64:64*255)'];
pwt_lowsubVt_swc = pwt_lowsubVt_swc + hex_1na;
pwt_lowsubVt_swc(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_lowsubVt_swc','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_lowsubVt_swc(i,3) > hex_1na then j=j+1; end
        if pwt_lowsubVt_swc(k,1) > data_lowsubVt_swc(i,3) then pwt_lowsubVt_swc(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_lowsubVt_swc(k,2))),fd_w);
end
mclose(fd_w);


while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_lowsubVt_ota ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_lowsubVt_ota.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_ota");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_lowsubVt_ota.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_lowsubVt_ota.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_lowsubVt_ota; data_lowsubVt_ota=read_tar_pgm_result('char_Scurve_lowsubVt_ota.hex',m_graph,time_scale);
for i=3:m_graph
    data_lowsubVt_ota(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_lowsubVt_ota(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end

scf(33);clf(33);
plot2d("nl", data_lowsubVt_ota(:,2), data_lowsubVt_ota(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;

data_size_temp=size(data_lowsubVt_ota) 
fprintfMat("Scurve_at_Vg3.6V_lowsubVt_ota.data", data_lowsubVt_ota, "%5.15f");

scf(34);clf(34);
plot2d("nn", data_lowsubVt_ota(1:data_size_temp(1,1)-1,3), data_lowsubVt_ota(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_lowsubVt_ota = [(0:64:64*255)'];
pwt_lowsubVt_ota = pwt_lowsubVt_ota + hex_1na;
pwt_lowsubVt_ota(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_lowsubVt_ota','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_lowsubVt_ota(i,3) > hex_1na then j=j+1; end
        if pwt_lowsubVt_ota(k,1) > data_lowsubVt_ota(i,3) then pwt_lowsubVt_ota(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_lowsubVt_ota(k,2))),fd_w);
end
mclose(fd_w);


while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_lowsubVt_otaref ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_lowsubVt_otaref.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_otaref");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_lowsubVt_otaref.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_lowsubVt_otaref.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_lowsubVt_otaref; data_lowsubVt_otaref=read_tar_pgm_result('char_Scurve_lowsubVt_otaref.hex',m_graph,time_scale);
for i=3:m_graph
    data_lowsubVt_otaref(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_lowsubVt_otaref(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end
// data_lowsubVt_otaref(:,3) Hex@Vgm=0.6V, data_lowsubVt_otaref(:,4) Hex@Vgm=0V, data_lowsubVt_otaref(:,5) Current@Vgm=0.6V, data_lowsubVt_otaref(:,6) Current@Vgm=0V

scf(35);clf(35);
plot2d("nl", data_lowsubVt_otaref(:,2), data_lowsubVt_otaref(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
fprintfMat("Scurve_at_Vg3.6V_lowsubVt_otaref.data", data_lowsubVt_otaref, "%5.15f");

data_size_temp=size(data_lowsubVt_otaref) 

scf(36);clf(36);
plot2d("nn", data_lowsubVt_otaref(1:data_size_temp(1,1)-1,3), data_lowsubVt_otaref(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_lowsubVt_otaref = [(0:64:64*255)'];
pwt_lowsubVt_otaref = pwt_lowsubVt_otaref + hex_1na;
pwt_lowsubVt_otaref(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_lowsubVt_otaref','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_lowsubVt_otaref(i,3) > hex_1na then j=j+1; end
        if pwt_lowsubVt_otaref(k,1) > data_lowsubVt_otaref(i,3) then pwt_lowsubVt_otaref(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_lowsubVt_otaref(k,2))),fd_w);
end
mclose(fd_w);


while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_lowsubVt_mite ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_lowsubVt_mite.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_mite");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_lowsubVt_mite.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_lowsubVt_mite.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_lowsubVt_mite; data_lowsubVt_mite=read_tar_pgm_result('char_Scurve_lowsubVt_mite.hex',m_graph,time_scale);
for i=3:m_graph
    data_lowsubVt_mite(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_lowsubVt_mite(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end
// data_lowsubVt_mite(:,3) Hex@Vgm=0.6V, data_lowsubVt_mite(:,4) Hex@Vgm=0V, data_lowsubVt_mite(:,5) Current@Vgm=0.6V, data_lowsubVt_mite(:,6) Current@Vgm=0V

scf(37);clf(37);
plot2d("nl", data_lowsubVt_mite(:,2), data_lowsubVt_mite(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
fprintfMat("Scurve_at_Vg3.6V_lowsubVt_mite.data", data_lowsubVt_mite, "%5.15f");

data_size_temp=size(data_lowsubVt_mite) 

scf(38);clf(38);
plot2d("nn", data_lowsubVt_mite(1:data_size_temp(1,1)-1,3), data_lowsubVt_mite(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_lowsubVt_mite = [(0:64:64*255)'];
pwt_lowsubVt_mite = pwt_lowsubVt_mite + hex_1na;
pwt_lowsubVt_mite(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_lowsubVt_mite','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_lowsubVt_mite(i,3) > hex_1na then j=j+1; end
        if pwt_lowsubVt_mite(k,1) > data_lowsubVt_mite(i,3) then pwt_lowsubVt_mite(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_lowsubVt_mite(k,2))),fd_w);
end
mclose(fd_w);


while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_Scurve_lowsubVt_dirswc ~/rasp30/prog_assembly/libs/asm_code/char_Scurve_lowsubVt_dirswc.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/target_info_lowsubVt_dirswc");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_Scurve_lowsubVt_dirswc.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_Scurve_lowsubVt_dirswc.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_lowsubVt_dirswc; data_lowsubVt_dirswc=read_tar_pgm_result('char_Scurve_lowsubVt_dirswc.hex',m_graph,time_scale);
for i=3:m_graph
    data_lowsubVt_dirswc(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_lowsubVt_dirswc(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end
// data_lowsubVt_dirswc(:,3) Hex@Vgm=0.6V, data_lowsubVt_dirswc(:,4) Hex@Vgm=0V, data_lowsubVt_dirswc(:,5) Current@Vgm=0.6V, data_lowsubVt_dirswc(:,6) Current@Vgm=0V

scf(39);clf(39);
plot2d("nl", data_lowsubVt_dirswc(:,2), data_lowsubVt_dirswc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
fprintfMat("Scurve_at_Vg3.6V_lowsubVt_dirswc.data", data_lowsubVt_dirswc, "%5.15f");

data_size_temp=size(data_lowsubVt_dirswc) 

scf(40);clf(40);
plot2d("nn", data_lowsubVt_dirswc(1:data_size_temp(1,1)-1,3), data_lowsubVt_dirswc(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");

pwt_lowsubVt_dirswc = [(0:64:64*255)'];
pwt_lowsubVt_dirswc = pwt_lowsubVt_dirswc + hex_1na;
pwt_lowsubVt_dirswc(1,2)=0;
offset=0;
fd_w = mopen('pulse_width_table_lowsubVt_dirswc','wt');
for k=1:255
    j=0;
    for i=2:data_size_temp(1,1)
        if data_lowsubVt_dirswc(i,3) > hex_1na then j=j+1; end
        if pwt_lowsubVt_dirswc(k,1) > data_lowsubVt_dirswc(i,3) then pwt_lowsubVt_dirswc(k,2)=max(0,(j+offset)/2); end
    end
    mputl('0x'+string(sprintf('%4.4x', pwt_lowsubVt_dirswc(k,2))),fd_w);
end
mclose(fd_w);


scf(41);clf(41);
plot2d("nl", data_lowsubVt_swc(:,2), data_lowsubVt_swc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
plot2d("nl", data_lowsubVt_ota(:,2), data_lowsubVt_ota(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off';
plot2d("nl", data_lowsubVt_otaref(:,2), data_lowsubVt_otaref(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 3;p.children.line_mode = 'off';
plot2d("nl", data_lowsubVt_mite(:,2), data_lowsubVt_mite(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 4;p.children.line_mode = 'off';
plot2d("nl", data_lowsubVt_dirswc(:,2), data_lowsubVt_dirswc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 5;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
legend("lowsubVt_swc","lowsubVt_ota","lowsubVt_otaref","lowsubVt_mite","lowsubVt_dirswc","in_lower_right");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
//a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=0.001;a.data_bounds(2,2)=1D-04;

scf(42);clf(42);
data_size_temp=size(data_lowsubVt_swc);plot2d("nn", data_lowsubVt_swc(1:data_size_temp(1,1)-1,3), data_lowsubVt_swc(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
data_size_temp=size(data_lowsubVt_ota);plot2d("nn", data_lowsubVt_ota(1:data_size_temp(1,1)-1,3), data_lowsubVt_ota(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off';
data_size_temp=size(data_lowsubVt_otaref);plot2d("nn", data_lowsubVt_otaref(1:data_size_temp(1,1)-1,3), data_lowsubVt_otaref(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 3;p.children.line_mode = 'off';
data_size_temp=size(data_lowsubVt_dirswc);plot2d("nn", data_lowsubVt_dirswc(1:data_size_temp(1,1)-1,3), data_lowsubVt_dirswc(2:data_size_temp(1,1),3));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 5;p.children.line_mode = 'off';
xtitle("","hex_start", "hex_end");
legend("lowsubVt_swc","lowsubVt_ota","lowsubVt_otaref","lowsubVt_dirswc","in_lower_right");
//a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
