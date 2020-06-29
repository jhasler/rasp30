gate_dac_ivdd25V_m=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd25V");
gate_dac_ivdd60V_m_0=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd60V_0");
gate_dac_ivdd60V_m_1=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd60V_1");
gate_dac_ivdd60V_m_0ER=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd60V_0_ER");
gate_dac_ivdd60V_m_1ER=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_gateDAC/data_gateDAC_chip"+chip_num+brdtype+"_ivdd60V_1_ER");

//polyfit
[p_gate_dac_1,S_gate_dac_1]=polyfit(gate_dac_ivdd25V_m(:,1), gate_dac_ivdd25V_m(:,2),7);//coefficients of polynomial that correspond to measured voltage value
[p_gate_dac_2_0,S_gate_dac_2_0]=polyfit(gate_dac_ivdd60V_m_0(:,1), gate_dac_ivdd60V_m_0(:,2),7);//coefficients of polynomial that correspond to measured voltage value
[p_gate_dac_2_1,S_gate_dac_2_1]=polyfit(gate_dac_ivdd60V_m_1(:,1), gate_dac_ivdd60V_m_1(:,2),7);//coefficients of polynomial that correspond to measured voltage value
[p_gate_dac_2_0ER,S_gate_dac_2_0ER]=polyfit(gate_dac_ivdd60V_m_0ER(:,1), gate_dac_ivdd60V_m_0ER(:,2),7);//coefficients of polynomial that correspond to measured voltage value
[p_gate_dac_2_1ER,S_gate_dac_2_1ER]=polyfit(gate_dac_ivdd60V_m_1ER(:,1), gate_dac_ivdd60V_m_1ER(:,2),7);//coefficients of polynomial that correspond to measured voltage value

// Eval
Gate_range_ivdd25V = hex2dec('00'):1:hex2dec('fe');
gate_dac_fit_ivdd25V = polyval(p_gate_dac_1,Gate_range_ivdd25V,S_gate_dac_1);
Gate_DAC_ivdd25V=[Gate_range_ivdd25V(:) gate_dac_fit_ivdd25V(:)];//voltage code range and corresponding voltage value
Gate_range_ivdd60V_0 = hex2dec('00'):1:hex2dec('fe');
gate_dac_fit_ivdd60V_0 = polyval(p_gate_dac_2_0,Gate_range_ivdd60V_0,S_gate_dac_2_0);
Gate_DAC_ivdd60V_0=[Gate_range_ivdd60V_0(:) gate_dac_fit_ivdd60V_0(:)];//voltage code range and corresponding voltage value
Gate_range_ivdd60V_1 = hex2dec('00'):1:hex2dec('fe');
gate_dac_fit_ivdd60V_1 = polyval(p_gate_dac_2_1,Gate_range_ivdd60V_1,S_gate_dac_2_1);
Gate_DAC_ivdd60V_1=[Gate_range_ivdd60V_1(:) gate_dac_fit_ivdd60V_1(:)];//voltage code range and corresponding voltage value
Gate_range_ivdd60V_0ER = hex2dec('00'):1:hex2dec('fe');
gate_dac_fit_ivdd60V_0ER = polyval(p_gate_dac_2_0ER,Gate_range_ivdd60V_0ER,S_gate_dac_2_0ER);
Gate_DAC_ivdd60V_0ER=[Gate_range_ivdd60V_0ER(:) gate_dac_fit_ivdd60V_0ER(:)];//voltage code range and corresponding voltage value
Gate_range_ivdd60V_1ER = hex2dec('00'):1:hex2dec('fe');
gate_dac_fit_ivdd60V_1ER = polyval(p_gate_dac_2_1ER,Gate_range_ivdd60V_1ER,S_gate_dac_2_1ER);
Gate_DAC_ivdd60V_1ER=[Gate_range_ivdd60V_1ER(:) gate_dac_fit_ivdd60V_1ER(:)];//voltage code range and corresponding voltage value

G_DAC_ivdd25V_copy = Gate_DAC_ivdd25V;
G_DAC_ivdd25V_copy_size = size(G_DAC_ivdd25V_copy);
V_to_Gdac_ivdd25V = linspace(0,2.5,26)'; //reference gate dac values
V_to_Gdac_ivdd25V_size=size(V_to_Gdac_ivdd25V);
for k=1:V_to_Gdac_ivdd25V_size(1,1)
    G_DAC_ivdd25V_copy(:,3)=abs(G_DAC_ivdd25V_copy(:,2)-V_to_Gdac_ivdd25V(k,1));
    min_value = min(G_DAC_ivdd25V_copy(:,3));
    for h=1:G_DAC_ivdd25V_copy_size(1,1)
        if G_DAC_ivdd25V_copy(h,3) == min_value then
            V_to_Gdac_ivdd25V(k,2) = G_DAC_ivdd25V_copy(h,1);//associated voltage code value in column two and voltage value in column one
        end
    end
end
disp(V_to_Gdac_ivdd25V);

V_to_Gdac_ivdd60V=linspace(0,6,61)';//reference gate dac values
V_to_Gdac_ivdd60V_s=size(V_to_Gdac_ivdd60V);

G_DAC_ivdd60V_0_copy = Gate_DAC_ivdd60V_0;
G_DAC_ivdd60V_0_copy_s = size(G_DAC_ivdd60V_0_copy);
for k=1:V_to_Gdac_ivdd60V_s(1,1)
    G_DAC_ivdd60V_0_copy(:,3)=abs(G_DAC_ivdd60V_0_copy(:,2)-V_to_Gdac_ivdd60V(k,1));
    min_value = min(G_DAC_ivdd60V_0_copy(:,3));
    for h=1:G_DAC_ivdd60V_0_copy_s(1,1)
        if G_DAC_ivdd60V_0_copy(h,3) == min_value then
            V_to_Gdac_ivdd60V(k,2) = G_DAC_ivdd60V_0_copy(h,1);//associated voltage code value in column two and voltage value in column one
        end
    end
end
G_DAC_ivdd60V_1_copy = Gate_DAC_ivdd60V_1;
G_DAC_ivdd60V_1_copy_s = size(G_DAC_ivdd60V_1_copy);
for k=1:V_to_Gdac_ivdd60V_s(1,1)
    G_DAC_ivdd60V_1_copy(:,3)=abs(G_DAC_ivdd60V_1_copy(:,2)-V_to_Gdac_ivdd60V(k,1));
    min_value = min(G_DAC_ivdd60V_1_copy(:,3));
    for h=1:G_DAC_ivdd60V_1_copy_s(1,1)
        if G_DAC_ivdd60V_1_copy(h,3) == min_value then
            V_to_Gdac_ivdd60V(k,3) = G_DAC_ivdd60V_1_copy(h,1);//associated voltage code value in column two and voltage value in column one
        end
    end
end
G_DAC_ivdd60V_0ER_copy = Gate_DAC_ivdd60V_0ER;
G_DAC_ivdd60V_0ER_copy_s = size(G_DAC_ivdd60V_0ER_copy);
for k=1:V_to_Gdac_ivdd60V_s(1,1)
    G_DAC_ivdd60V_0ER_copy(:,3)=abs(G_DAC_ivdd60V_0ER_copy(:,2)-V_to_Gdac_ivdd60V(k,1));
    min_value = min(G_DAC_ivdd60V_0ER_copy(:,3));
    for h=1:G_DAC_ivdd60V_0ER_copy_s(1,1)
        if G_DAC_ivdd60V_0ER_copy(h,3) == min_value then
            V_to_Gdac_ivdd60V(k,4) = G_DAC_ivdd60V_0ER_copy(h,1);
        end
    end
end
G_DAC_ivdd60V_1ER_copy = Gate_DAC_ivdd60V_1ER;
G_DAC_ivdd60V_1ER_copy_s = size(G_DAC_ivdd60V_1ER_copy);
for k=1:V_to_Gdac_ivdd60V_s(1,1)
    G_DAC_ivdd60V_1ER_copy(:,3)=abs(G_DAC_ivdd60V_1ER_copy(:,2)-V_to_Gdac_ivdd60V(k,1));
    min_value = min(G_DAC_ivdd60V_1ER_copy(:,3));
    for h=1:G_DAC_ivdd60V_1ER_copy_s(1,1)
        if G_DAC_ivdd60V_1ER_copy(h,3) == min_value then
            V_to_Gdac_ivdd60V(k,5) = G_DAC_ivdd60V_1ER_copy(h,1);//associated voltage code value in column two and voltage value in column one
        end
    end
end
disp(V_to_Gdac_ivdd60V);

//// Plot the data
//scf(5);
//clf(5);
//plot2d("nn", gate_dac_ivdd25V_m(:,1), gate_dac_ivdd25V_m(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
//plot2d("nn", gate_dac_ivdd60V_m_0(:,1), gate_dac_ivdd60V_m_0(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
//plot2d("nn", gate_dac_ivdd60V_m_1(:,1), gate_dac_ivdd60V_m_1(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=3;
//plot2d("nn", gate_dac_ivdd60V_m_0ER(:,1), gate_dac_ivdd60V_m_0ER(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=4;
//plot2d("nn", gate_dac_ivdd60V_m_1ER(:,1), gate_dac_ivdd60V_m_1ER(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=5;
//plot2d("nn", Gate_range_ivdd25V, gate_dac_fit_ivdd25V, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", Gate_range_ivdd60V_0, gate_dac_fit_ivdd60V_0, style=2);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", Gate_range_ivdd60V_1, gate_dac_fit_ivdd60V_1, style=3);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", Gate_range_ivdd60V_0ER, gate_dac_fit_ivdd60V_0ER, style=4);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", Gate_range_ivdd60V_1ER, gate_dac_fit_ivdd60V_1ER, style=5);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//a=gca();a.data_bounds=[0 0; 300 6];
//legend("ivdd2.5V","ivdd6V_0","ivdd6V_1","ivdd6V_0ER","ivdd6V_1ER","in_lower_right");
//xtitle("","ADC code","Vg (V)");
