global file_name path fname extension chip_num board_num hex_1na;

exec('~/rasp30/prog_assembly/libs/scilab_code/read_tar_pgm_result.sce',-1);
time_scale=1e-5; // Time unit : 10us
Vg06VtoVg00V=hex_1na; // hex value for 1nA

while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 tunnel_revtun_SWC_CAB.elf");
    if (b1==0) then break end // 0 if no error occurred, 1 if error.
    disp("connection issue -> it is trying again");
    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
    sleep(2000);
end

while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_gate_coupling_swc ~/rasp30/prog_assembly/libs/asm_code/char_gate_coupling_swc.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name target_info_swc");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_gate_coupling_swc.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_gate_coupling_swc.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_swc; m_graph=4; data_swc=read_tar_pgm_result('char_gate_coupling_swc.hex',m_graph,time_scale);
for i=3:m_graph
    data_swc(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_swc(:,i),chip_num,brdtype),chip_num,brdtype);
end
// data_swc(:,3) Hex@Vgm=0.6V, data_swc(:,4) Hex@Vgm=0V, data_swc(:,5) Current@Vgm=0.6V, data_swc(:,6) Current@Vgm=0V

//polyfit
data_swc_sz=size(data_swc);
start_hex=0;
for k=1:data_swc_sz(1,1)
    if data_swc(k,5) < 1E-09 then start_hex = k; end
end
[p1_vg06_vg00_swc,S1_vg06_vg00_swc]=polyfit(data_swc(start_hex:start_hex+5,3), data_swc(start_hex:start_hex+5,4),1);
ADC_vg06_vg00_swc = data_swc(1,3):1:data_swc(data_swc_sz(1,1),3);
fit_vg06_vg00_swc = polyval(p1_vg06_vg00_swc,ADC_vg06_vg00_swc,S1_vg06_vg00_swc);
Vg06VtoVg00V_swc=[Vg06VtoVg00V]; // 1nA
Vg06VtoVg00V_swc_sz = size(Vg06VtoVg00V_swc);
ADC_vg06_vg00_swc_sz = size(ADC_vg06_vg00_swc);

for k=1:Vg06VtoVg00V_swc_sz(1,1)
    for h=1:ADC_vg06_vg00_swc_sz(1,2)
        if ADC_vg06_vg00_swc(h) < Vg06VtoVg00V_swc(k,1) then Vg06VtoVg00V_swc(k,2)=fit_vg06_vg00_swc(h); end
    end
end

scf(11);clf(11);
plot2d("nl", data_swc(:,2), data_swc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
plot2d("nl", data_swc(:,2), data_swc(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;

scf(2);clf(2);
plot2d("nn", data_swc(:,3), data_swc(:,4));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
plot2d("nn", ADC_vg06_vg00_swc, fit_vg06_vg00_swc);p = get("hdl");p.children.line_mode = 'on';p.children.mark_mode = 'off';
xtitle("","ADC values @ Vg=0V", "ADC values @ Vg=0.6V");
//a=gca();a.data_bounds(1,1)=3000;a.data_bounds(1,2)=3000;a.data_bounds(2,1)=9000;a.data_bounds(2,2)=9000;

while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 tunnel_revtun_SWC_CAB.elf");
    if (b1==0) then break end // 0 if no error occurred, 1 if error.
    disp("connection issue -> it is trying again");
    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
    sleep(2000);
end

while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_gate_coupling_ota ~/rasp30/prog_assembly/libs/asm_code/char_gate_coupling_ota.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name target_info_ota");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_gate_coupling_ota.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_gate_coupling_ota.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_ota; m_graph=4; data_ota=read_tar_pgm_result('char_gate_coupling_ota.hex',m_graph,time_scale);
for i=3:m_graph
    data_ota(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_ota(:,i),chip_num,brdtype),chip_num,brdtype);
end
// data_ota(:,3) Hex@Vgm=0.6V, data_ota(:,4) Hex@Vgm=0V, data_ota(:,5) Current@Vgm=0.6V, data_ota(:,6) Current@Vgm=0V

//polyfit
data_ota_sz=size(data_ota);
start_hex=0;
for k=1:data_ota_sz(1,1)
    if data_ota(k,5) < 1E-09 then start_hex = k; end
end
[p1_vg06_vg00_ota,S1_vg06_vg00_ota]=polyfit(data_ota(start_hex:start_hex+5,3), data_ota(start_hex:start_hex+5,4),1);
ADC_vg06_vg00_ota = data_ota(1,3):1:data_ota(data_ota_sz(1,1),3);
fit_vg06_vg00_ota = polyval(p1_vg06_vg00_ota,ADC_vg06_vg00_ota,S1_vg06_vg00_ota);
Vg06VtoVg00V_ota=[Vg06VtoVg00V]; // 1nA
Vg06VtoVg00V_ota_sz = size(Vg06VtoVg00V_ota);
ADC_vg06_vg00_ota_sz = size(ADC_vg06_vg00_ota);

for k=1:Vg06VtoVg00V_ota_sz(1,1)
    for h=1:ADC_vg06_vg00_ota_sz(1,2)
        if ADC_vg06_vg00_ota(h) < Vg06VtoVg00V_ota(k,1) then Vg06VtoVg00V_ota(k,2)=fit_vg06_vg00_ota(h); end
    end
end

scf(3);clf(3);
plot2d("nl", data_ota(:,2), data_ota(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off'
plot2d("nl", data_ota(:,2), data_ota(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off'
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;

scf(4);clf(4);
plot2d("nn", data_ota(:,3), data_ota(:,4));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off'
plot2d("nn", ADC_vg06_vg00_ota, fit_vg06_vg00_ota);p = get("hdl");p.children.line_mode = 'on';p.children.mark_mode = 'off';
xtitle("","ADC values @ Vg=0V", "ADC values @ Vg=0.6V");
//a=gca();a.data_bounds(1,1)=3000;a.data_bounds(1,2)=3000;a.data_bounds(2,1)=9000;a.data_bounds(2,2)=9000;


while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 tunnel_revtun_SWC_CAB.elf");
    if (b1==0) then break end // 0 if no error occurred, 1 if error.
    disp("connection issue -> it is trying again");
    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
    sleep(2000);
end

while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_gate_coupling_otaref ~/rasp30/prog_assembly/libs/asm_code/char_gate_coupling_otaref.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name target_info_otaref");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_gate_coupling_otaref.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_gate_coupling_otaref.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_otaref; m_graph=4; data_otaref=read_tar_pgm_result('char_gate_coupling_otaref.hex',m_graph,time_scale);
for i=3:m_graph
    data_otaref(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_otaref(:,i),chip_num,brdtype),chip_num,brdtype);
end
// data_otaref(:,3) Hex@Vgm=0.6V, data_otaref(:,4) Hex@Vgm=0V, data_otaref(:,5) Current@Vgm=0.6V, data_otaref(:,6) Current@Vgm=0V

//polyfit
data_otaref_sz=size(data_otaref);
start_hex=0;
for k=1:data_otaref_sz(1,1)
    if data_otaref(k,5) < 1E-09 then start_hex = k; end
end
//[p1_vg06_vg00_otaref,S1_vg06_vg00_otaref]=polyfit(data_otaref(start_hex:start_hex+100,3), data_otaref(start_hex:start_hex+100,4),1);
[p1_vg06_vg00_otaref,S1_vg06_vg00_otaref]=polyfit(data_otaref(start_hex:start_hex+5,3), data_otaref(start_hex:start_hex+5,4),1);
ADC_vg06_vg00_otaref = data_otaref(1,3):1:data_otaref(data_otaref_sz(1,1),3);
fit_vg06_vg00_otaref = polyval(p1_vg06_vg00_otaref,ADC_vg06_vg00_otaref,S1_vg06_vg00_otaref);
Vg06VtoVg00V_otaref=[Vg06VtoVg00V]; // 1nA
Vg06VtoVg00V_otaref_sz = size(Vg06VtoVg00V_otaref);
ADC_vg06_vg00_otaref_sz = size(ADC_vg06_vg00_otaref);

for k=1:Vg06VtoVg00V_otaref_sz(1,1)
    for h=1:ADC_vg06_vg00_otaref_sz(1,2)
        if ADC_vg06_vg00_otaref(h) < Vg06VtoVg00V_otaref(k,1) then Vg06VtoVg00V_otaref(k,2)=fit_vg06_vg00_otaref(h); end
    end
end

scf(5);clf(5);
plot2d("nl", data_otaref(:,2), data_otaref(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off'
plot2d("nl", data_otaref(:,2), data_otaref(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off'
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;

scf(6);clf(6);
plot2d("nn", data_otaref(:,3), data_otaref(:,4));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off'
plot2d("nn", ADC_vg06_vg00_otaref, fit_vg06_vg00_otaref);p = get("hdl");p.children.line_mode = 'on';p.children.mark_mode = 'off';
xtitle("","ADC values @ Vg=0V", "ADC values @ Vg=0.6V");
//a=gca();a.data_bounds(1,1)=3000;a.data_bounds(1,2)=3000;a.data_bounds(2,1)=9000;a.data_bounds(2,2)=9000;


while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 tunnel_revtun_SWC_CAB.elf");
    if (b1==0) then break end // 0 if no error occurred, 1 if error.
    disp("connection issue -> it is trying again");
    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
    sleep(2000);
end

while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_gate_coupling_mite ~/rasp30/prog_assembly/libs/asm_code/char_gate_coupling_mite.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name target_info_mite");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_gate_coupling_mite.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_gate_coupling_mite.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_mite; m_graph=4; data_mite=read_tar_pgm_result('char_gate_coupling_mite.hex',m_graph,time_scale);
for i=3:m_graph
    data_mite(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_mite(:,i),chip_num,brdtype),chip_num,brdtype);
end
// data_mite(:,3) Hex@Vgm=0.6V, data_mite(:,4) Hex@Vgm=0V, data_mite(:,5) Current@Vgm=0.6V, data_mite(:,6) Current@Vgm=0V

//polyfit
data_mite_sz=size(data_mite);
start_hex=0;
for k=1:data_mite_sz(1,1)
    if data_mite(k,5) < 1E-09 then start_hex = k; end
end
[p1_vg06_vg00_mite,S1_vg06_vg00_mite]=polyfit(data_mite(start_hex:start_hex+5,3), data_mite(start_hex:start_hex+5,4),1);
ADC_vg06_vg00_mite = data_mite(1,3):1:data_mite(data_mite_sz(1,1),3);
fit_vg06_vg00_mite = polyval(p1_vg06_vg00_mite,ADC_vg06_vg00_mite,S1_vg06_vg00_mite);
Vg06VtoVg00V_mite=[Vg06VtoVg00V]; // 1nA
Vg06VtoVg00V_mite_sz = size(Vg06VtoVg00V_mite);
ADC_vg06_vg00_mite_sz = size(ADC_vg06_vg00_mite);

for k=1:Vg06VtoVg00V_mite_sz(1,1)
    for h=1:ADC_vg06_vg00_mite_sz(1,2)
        if ADC_vg06_vg00_mite(h) < Vg06VtoVg00V_mite(k,1) then Vg06VtoVg00V_mite(k,2)=fit_vg06_vg00_mite(h); end
    end
end

scf(7);clf(7);
plot2d("nl", data_mite(:,2), data_mite(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off'
plot2d("nl", data_mite(:,2), data_mite(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off'
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;

scf(8);clf(8);
plot2d("nn", data_mite(:,3), data_mite(:,4));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off'
plot2d("nn", ADC_vg06_vg00_mite, fit_vg06_vg00_mite);p = get("hdl");p.children.line_mode = 'on';p.children.mark_mode = 'off';
xtitle("","ADC values @ Vg=0V", "ADC values @ Vg=0.6V");
//a=gca();a.data_bounds(1,1)=3000;a.data_bounds(1,2)=3000;a.data_bounds(2,1)=9000;a.data_bounds(2,2)=9000;


while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 tunnel_revtun_SWC_CAB.elf");
    if (b1==0) then break end // 0 if no error occurred, 1 if error.
    disp("connection issue -> it is trying again");
    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
    sleep(2000);
end

while 1==1,
    [a1,b1]=unix_g("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh char_gate_coupling_dirswc ~/rasp30/prog_assembly/libs/asm_code/char_gate_coupling_dirswc.s43 16384 16384 16384");
    [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name target_info_dirswc");
    if (b1==0) & (b2==0) then
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 char_gate_coupling_dirswc.elf");
        [a4,b4]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name char_gate_coupling_dirswc.hex");
    end
    if (b1==0) & (b2==0) & (b3==0) & (b4==0) then break end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) | (b4==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

clear data_dirswc; m_graph=4; data_dirswc=read_tar_pgm_result('char_gate_coupling_dirswc.hex',m_graph,time_scale);
for i=3:m_graph
    data_dirswc(:,i+2)=diodeADC_v2i(diodeADC_h2v(data_dirswc(:,i),chip_num,brdtype),chip_num,brdtype);
end
// data_dirswc(:,3) Hex@Vgm=0.6V, data_dirswc(:,4) Hex@Vgm=0V, data_dirswc(:,5) Current@Vgm=0.6V, data_dirswc(:,6) Current@Vgm=0V

//polyfit
data_dirswc_sz=size(data_dirswc);
start_hex=0;
for k=1:data_dirswc_sz(1,1)
    if data_dirswc(k,5) < 1E-09 then start_hex = k; end
end
[p1_vg06_vg00_dirswc,S1_vg06_vg00_dirswc]=polyfit(data_dirswc(start_hex:start_hex+5,3), data_dirswc(start_hex:start_hex+5,4),1);
ADC_vg06_vg00_dirswc = data_dirswc(1,3):1:data_dirswc(data_dirswc_sz(1,1),3);
fit_vg06_vg00_dirswc = polyval(p1_vg06_vg00_dirswc,ADC_vg06_vg00_dirswc,S1_vg06_vg00_dirswc);
Vg06VtoVg00V_dirswc=[Vg06VtoVg00V]; // 1nA
Vg06VtoVg00V_dirswc_sz = size(Vg06VtoVg00V_dirswc);
ADC_vg06_vg00_dirswc_sz = size(ADC_vg06_vg00_dirswc);

for k=1:Vg06VtoVg00V_dirswc_sz(1,1)
    for h=1:ADC_vg06_vg00_dirswc_sz(1,2)
        if ADC_vg06_vg00_dirswc(h) < Vg06VtoVg00V_dirswc(k,1) then Vg06VtoVg00V_dirswc(k,2)=fit_vg06_vg00_dirswc(h); end
    end
end

scf(9);clf(9);
plot2d("nl", data_dirswc(:,2), data_dirswc(:,5));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
plot2d("nl", data_dirswc(:,2), data_dirswc(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;

scf(10);clf(10);
plot2d("nn", data_dirswc(:,3), data_dirswc(:,4));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
plot2d("nn", ADC_vg06_vg00_dirswc, fit_vg06_vg00_dirswc);p = get("hdl");p.children.line_mode = 'on';p.children.mark_mode = 'off';
xtitle("","ADC values @ Vg=0V", "ADC values @ Vg=0.6V");
//a=gca();a.data_bounds(1,1)=3000;a.data_bounds(1,2)=3000;a.data_bounds(2,1)=9000;a.data_bounds(2,2)=9000;


scf(101);clf(101);
plot2d("nl", data_swc(:,2), data_swc(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
plot2d("nl", data_ota(:,2), data_ota(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 2;p.children.line_mode = 'off';
plot2d("nl", data_otaref(:,2), data_otaref(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 3;p.children.line_mode = 'off';
plot2d("nl", data_mite(:,2), data_mite(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 4;p.children.line_mode = 'off';
plot2d("nl", data_dirswc(:,2), data_dirswc(:,6));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 5;p.children.line_mode = 'off';
xtitle("","time [s]", "Id [A]");
legend("swc","ota","otaref","mite","dirswc","in_lower_right");
a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1);a.data_bounds(2,2)=1D-04;
//a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=1;a.data_bounds(2,2)=1D-04;
//a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=0.1;a.data_bounds(2,2)=1D-04;
//a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=0.01;a.data_bounds(2,2)=1D-04;


Vg06VtoVg00V_swc(2,2)= Vg06VtoVg00V_swc(1,2)-(Vg06VtoVg00V_swc(1,2)-Vg06VtoVg00V_swc(1,1))/10;
Vg06VtoVg00V_swc(3,2)= Vg06VtoVg00V_swc(1,2)-(Vg06VtoVg00V_swc(1,2)-Vg06VtoVg00V_swc(1,1))*4/10;
Vg06VtoVg00V_swc(4,2)=Vg06VtoVg00V_swc(1,1);
Vg06VtoVg00V_swc(5,2)=data_swc(1,3)+50;
disp("Vg06VtoVg00V_swc");
disp(Vg06VtoVg00V_swc);
Vg06VtoVg00V_ota(2,2)= Vg06VtoVg00V_ota(1,2)-(Vg06VtoVg00V_ota(1,2)-Vg06VtoVg00V_ota(1,1))/10;
Vg06VtoVg00V_ota(3,2)= Vg06VtoVg00V_ota(1,2)-(Vg06VtoVg00V_ota(1,2)-Vg06VtoVg00V_ota(1,1))*4/10;
Vg06VtoVg00V_ota(4,2)=Vg06VtoVg00V_ota(1,1);
Vg06VtoVg00V_ota(5,2)=data_ota(1,3)+50;
disp("Vg06VtoVg00V_ota");
disp(Vg06VtoVg00V_ota);
Vg06VtoVg00V_otaref(2,2)= Vg06VtoVg00V_otaref(1,2)-(Vg06VtoVg00V_otaref(1,2)-Vg06VtoVg00V_otaref(1,1))/10;
Vg06VtoVg00V_otaref(3,2)= Vg06VtoVg00V_otaref(1,2)-(Vg06VtoVg00V_otaref(1,2)-Vg06VtoVg00V_otaref(1,1))*4/10;
Vg06VtoVg00V_otaref(4,2)=Vg06VtoVg00V_otaref(1,1);
Vg06VtoVg00V_otaref(5,2)=data_otaref(1,3)+50;
disp("Vg06VtoVg00V_otaref");
disp(Vg06VtoVg00V_otaref);
Vg06VtoVg00V_mite(2,2)= Vg06VtoVg00V_mite(1,2)-(Vg06VtoVg00V_mite(1,2)-Vg06VtoVg00V_mite(1,1))/10;
Vg06VtoVg00V_mite(3,2)= Vg06VtoVg00V_mite(1,2)-(Vg06VtoVg00V_mite(1,2)-Vg06VtoVg00V_mite(1,1))*4/10;
Vg06VtoVg00V_mite(4,2)=Vg06VtoVg00V_mite(1,1);
Vg06VtoVg00V_mite(5,2)=data_mite(1,3)+50;
disp("Vg06VtoVg00V_mite");
disp(Vg06VtoVg00V_mite);
Vg06VtoVg00V_dirswc(2,2)= Vg06VtoVg00V_dirswc(1,2)-(Vg06VtoVg00V_dirswc(1,2)-Vg06VtoVg00V_dirswc(1,1))/10;
Vg06VtoVg00V_dirswc(3,2)= Vg06VtoVg00V_dirswc(1,2)-(Vg06VtoVg00V_dirswc(1,2)-Vg06VtoVg00V_dirswc(1,1))*4/10;
Vg06VtoVg00V_dirswc(4,2)=Vg06VtoVg00V_dirswc(1,1);
Vg06VtoVg00V_dirswc(5,2)=data_dirswc(1,3)+50;
disp("Vg06VtoVg00V_dirswc");
disp(Vg06VtoVg00V_dirswc);

fd_w= mopen ('chip_para_RI.asm','wt')
mputl("/* RI (Recover Injection Above & Sub threshold) parameters */",fd_w);

mputl(".set RI_GATE_S_SWC, 0x0040 /* Gate(SWC) = gnd */",fd_w);
mputl(".set RI_VC1_SWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_swc(1,2)))+" /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */",fd_w);
mputl(".set RI_VC2_SWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_swc(2,2)))+" /* Ivfg*2/5 @Vgm=0V */",fd_w);
mputl(".set RI_VC3_SWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_swc(3,2)))+" /* Ivfg*1/10 @Vgm=0V */",fd_w);
mputl(".set RI_VC4_SWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_swc(4,2)))+" /* Ivfg=1nA @Vgm=0V */",fd_w);
mputl(".set RI_VD1_SWC, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RI_VD2_SWC, 0xfe0e /* Vd @ pre-final stage */",fd_w);
mputl(".set RI_INJ_T_SWC, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RI_NUM_SWC, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mputl(".set RI_GATE_S_OTA, "+RI_GATE_S_OTA+" /* Gate(OTA) = 2.5V */",fd_w);
mputl(".set RI_VC1_OTA, "+string(sprintf('%1.0f',Vg06VtoVg00V_ota(1,2)))+" /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */",fd_w);
mputl(".set RI_VC2_OTA, "+string(sprintf('%1.0f',Vg06VtoVg00V_ota(2,2)))+" /* Ivfg*2/5 @Vgm=0V */",fd_w);
mputl(".set RI_VC3_OTA, "+string(sprintf('%1.0f',Vg06VtoVg00V_ota(3,2)))+" /* Ivfg*1/10 @Vgm=0V */",fd_w);
mputl(".set RI_VC4_OTA, "+string(sprintf('%1.0f',Vg06VtoVg00V_ota(4,2)))+" /* Ivfg=1nA @Vgm=0V */",fd_w);
mputl(".set RI_VD1_OTA, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RI_VD2_OTA, 0xfe0e /* Vd @ pre-final stage */",fd_w);
mputl(".set RI_INJ_T_OTA, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RI_NUM_OTA, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mputl(".set RI_GATE_S_OTAREF, 0x0040 /* Gate(OTAREF) = gnd */",fd_w);
mputl(".set RI_VC1_OTAREF, "+string(sprintf('%1.0f',Vg06VtoVg00V_otaref(1,2)))+" /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */",fd_w);
mputl(".set RI_VC2_OTAREF, "+string(sprintf('%1.0f',Vg06VtoVg00V_otaref(2,2)))+" /* Ivfg*2/5 @Vgm=0V */",fd_w);
mputl(".set RI_VC3_OTAREF, "+string(sprintf('%1.0f',Vg06VtoVg00V_otaref(3,2)))+" /* Ivfg*1/10 @Vgm=0V */",fd_w);
mputl(".set RI_VC4_OTAREF, "+string(sprintf('%1.0f',Vg06VtoVg00V_otaref(4,2)))+" /* Ivfg=1nA @Vgm=0V */",fd_w);
mputl(".set RI_VD1_OTAREF, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RI_VD2_OTAREF, 0xfe0e /* Vd @ pre-final stage */",fd_w);
mputl(".set RI_INJ_T_OTAREF, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RI_NUM_OTAREF, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mputl(".set RI_GATE_S_MITE, "+RI_GATE_S_MITE+" /* Gate(MITE) = 2.0V */",fd_w);
mputl(".set RI_VC1_MITE, "+string(sprintf('%1.0f',Vg06VtoVg00V_mite(1,2)))+" /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */",fd_w);
mputl(".set RI_VC2_MITE, "+string(sprintf('%1.0f',Vg06VtoVg00V_mite(2,2)))+" /* Ivfg*2/5 @Vgm=0V */",fd_w);
mputl(".set RI_VC3_MITE, "+string(sprintf('%1.0f',Vg06VtoVg00V_mite(3,2)))+" /* Ivfg*1/10 @Vgm=0V */",fd_w);
mputl(".set RI_VC4_MITE, "+string(sprintf('%1.0f',Vg06VtoVg00V_mite(4,2)))+" /* Ivfg=1nA @Vgm=0V */",fd_w);
mputl(".set RI_VD1_MITE, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RI_VD2_MITE, 0xfe0e /* Vd @ pre-final stage */",fd_w);
mputl(".set RI_INJ_T_MITE, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RI_NUM_MITE, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mputl(".set RI_GATE_S_DIRSWC, "+RI_GATE_S_DIRSWC+" /* Gate(DIRSWC) = 1.4V */",fd_w);
mputl(".set RI_VC1_DIRSWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_dirswc(1,2)))+" /* Ivfg @Vgm=0V -> 1nA@Vgm=0.6V */",fd_w);
mputl(".set RI_VC2_DIRSWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_dirswc(2,2)))+" /* Ivfg*2/5 @Vgm=0V */",fd_w);
mputl(".set RI_VC3_DIRSWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_dirswc(3,2)))+" /* Ivfg*1/10 @Vgm=0V */",fd_w);
mputl(".set RI_VC4_DIRSWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_dirswc(4,2)))+" /* Ivfg=1nA @Vgm=0V */",fd_w);
mputl(".set RI_VD1_DIRSWC, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RI_VD2_DIRSWC, 0xfe0e /* Vd @ pre-final stage */",fd_w);
mputl(".set RI_INJ_T_DIRSWC, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RI_NUM_DIRSWC, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mputl("/* RIL (Recover Injection low sub threshold) parameters */",fd_w);
mputl(".set RIL_GATE_S_SWC, 0x0040 /* Gate(SWC) = gnd */",fd_w);
mputl(".set RIL_VC1_SWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_swc(4,2)))+" /* Ivfg=1n A@Vgm=0V */",fd_w);
mputl(".set RIL_VC2_SWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_swc(5,2)))+" /* Ivfg=lowest current @Vgm=0V */",fd_w);
mputl(".set RIL_VD1_SWC, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RIL_INJ_T_SWC, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RIL_NUM_SWC, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mputl(".set RIL_GATE_S_OTA, "+RIL_GATE_S_OTA+" /* Gate(OTA) = 2.5V */",fd_w);
mputl(".set RIL_VC1_OTA, "+string(sprintf('%1.0f',Vg06VtoVg00V_ota(4,2)))+" /* Ivfg=1n A@Vgm=0V */",fd_w);
mputl(".set RIL_VC2_OTA, "+string(sprintf('%1.0f',Vg06VtoVg00V_ota(5,2)))+" /* Ivfg=lowest current @Vgm=0V */",fd_w);
mputl(".set RIL_VD1_OTA, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RIL_INJ_T_OTA, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RIL_NUM_OTA, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mputl(".set RIL_GATE_S_OTAREF, 0x0040 /* Gate(OTAREF) = gnd */",fd_w);
mputl(".set RIL_VC1_OTAREF, "+string(sprintf('%1.0f',Vg06VtoVg00V_otaref(4,2)))+" /* Ivfg=1n A@Vgm=0V */",fd_w);
mputl(".set RIL_VC2_OTAREF, "+string(sprintf('%1.0f',Vg06VtoVg00V_otaref(5,2)))+" /* Ivfg=lowest current @Vgm=0V */",fd_w);
mputl(".set RIL_VD1_OTAREF, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RIL_INJ_T_OTAREF, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RIL_NUM_OTAREF, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mputl(".set RIL_GATE_S_MITE, "+RIL_GATE_S_MITE+" /* Gate(MITE) = 2.0V */",fd_w);
mputl(".set RIL_VC1_MITE, "+string(sprintf('%1.0f',Vg06VtoVg00V_mite(4,2)))+" /* Ivfg=1n A@Vgm=0V */",fd_w);
mputl(".set RIL_VC2_MITE, "+string(sprintf('%1.0f',Vg06VtoVg00V_mite(5,2)))+" /* Ivfg=lowest current @Vgm=0V */",fd_w);
mputl(".set RIL_VD1_MITE, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RIL_INJ_T_MITE, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RIL_NUM_MITE, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mputl(".set RIL_GATE_S_DIRSWC, "+RIL_GATE_S_DIRSWC+" /* Gate(DIRSWC) = 1.4V */",fd_w);
mputl(".set RIL_VC1_DIRSWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_dirswc(4,2)))+" /* Ivfg=1n A@Vgm=0V */",fd_w);
mputl(".set RIL_VC2_DIRSWC, "+string(sprintf('%1.0f',Vg06VtoVg00V_dirswc(5,2)))+" /* Ivfg=lowest current @Vgm=0V */",fd_w);
mputl(".set RIL_VD1_DIRSWC, 0xea0e /* Vd @ final stage */",fd_w);
mputl(".set RIL_INJ_T_DIRSWC, 1 /* Injection time unit (*10us) */",fd_w);
mputl(".set RIL_NUM_DIRSWC, 300 /* # of Recover Injection */",fd_w);mputl("",fd_w);

mclose(fd_w);
