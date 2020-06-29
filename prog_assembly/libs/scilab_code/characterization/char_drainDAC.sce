global file_name path fname extension chip_num board_num brdtype;

drain_dac_ivdd60V_m=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_drainDAC/data_drainDAC_chip"+chip_num+brdtype+"_ivdd60V");

//polyfit
[p_drain_dac_2,S_drain_dac_2]=polyfit(drain_dac_ivdd60V_m(:,1), drain_dac_ivdd60V_m(:,2),7); //coefficients of polynomial that correspond to measured voltage value

// Eval
Drain_range_ivdd60V = hex2dec('00'):2:hex2dec('fe');
drain_dac_fit_ivdd60V = polyval(p_drain_dac_2,Drain_range_ivdd60V,S_drain_dac_2); 
Drain_DAC_ivdd60V=[Drain_range_ivdd60V(:) drain_dac_fit_ivdd60V(:)]; //voltage code range and corresponding voltage value
D_DAC_ivdd60V_copy = Drain_DAC_ivdd60V;
D_DAC_ivdd60V_copy_size = size(D_DAC_ivdd60V_copy);
//V_to_Ddac_ivdd60V = [0.5; 1; 1.5; 2;];
Vd_table_30mV_ivdd60V = [
2.40;2.37;2.34;2.31;2.28;2.25;2.22;2.19;2.16;2.13;2.10;2.07;2.04;2.01;1.98;1.95;1.92;1.89;1.86;1.83;
1.80;1.77;1.74;1.71;1.68;1.65;1.62;1.59;1.56;1.53;1.50;1.47;1.44;1.41;1.38;1.35;1.32;1.29;1.26;1.23;
1.20;1.17;1.14;1.11;1.08;1.05;1.02;0.99;0.96;0.93;0.90;0.87;0.84;0.81;0.78;0.75;0.72;0.69;0.66;0.63;
0.60;0.57;0.54;0.51;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;
0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;
0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;
0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;
0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;
0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;
0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;0.48;]; //reference drain dac values ...fine program 30mV pulse increments
V_to_Ddac_ivdd60V_size=size(Vd_table_30mV_ivdd60V);

for k=1:V_to_Ddac_ivdd60V_size(1,1)
    D_DAC_ivdd60V_copy(:,3)=abs(D_DAC_ivdd60V_copy(:,2)-Vd_table_30mV_ivdd60V(k,1));
    min_value = min(D_DAC_ivdd60V_copy(:,3));
    for h=1:D_DAC_ivdd60V_copy_size(1,1)
        if D_DAC_ivdd60V_copy(h,3) == min_value then
            Vd_table_30mV_ivdd60V(k,2) = D_DAC_ivdd60V_copy(h,1); //associated voltage code value in column two and voltage value in column one
        end
    end
end

temp = '';
for i=1:V_to_Ddac_ivdd60V_size(1,1)
    temp = temp + '0x' + string(sprintf('%2.2x', Vd_table_30mV_ivdd60V(i,2))) + '0e '; //0e - use dac and i2v mux control
end
fd = mopen('Vd_table_30mV','wt'); mputl(temp, fd); mclose(fd);

// Plot the data
scf(4);
clf(4);
plot2d("nn", drain_dac_ivdd60V_m(:,1), drain_dac_ivdd60V_m(:,2), style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
plot2d("nn", Drain_range_ivdd60V, drain_dac_fit_ivdd60V, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
a=gca();a.data_bounds=[0 0; 300 2.5];
legend("ivdd6V_0","in_lower_left");
xtitle("","ADC code","Vd (V)");

