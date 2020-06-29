global chip_num board_num brdtype;

diode_ivdd25V=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_diodeADC/data_diodeADC_chip"+chip_num+brdtype+"_ivdd25V");

//polyfit
[p1,S1]=polyfit(diode_ivdd25V(:,4), log(diode_ivdd25V(:,2)),10); //coefficients of polynomial that correspond to current
//[p_i2vout,S_i2vout]=polyfit(diode_ivdd25V(1:21,4), diode_ivdd25V(1:21,3),1);

size_diode_ivdd25V=size(diode_ivdd25V);

// Eval
ADC_range_ivdd25V = diode_ivdd25V(1,4):1:diode_ivdd25V(size_diode_ivdd25V(1,1),4);
diode_fit_ivdd25V = polyval(p1,ADC_range_ivdd25V,S1);
//i2vout_fit_ivdd25V = polyval(p_i2vout,ADC_range_ivdd25V,S_i2vout);
ADC_Current=[ADC_range_ivdd25V(:) exp(diode_fit_ivdd25V(:))]; //hex range and corresponding current value

ADC_Current_copy = ADC_Current;
ADC_Current_copy_size = size(ADC_Current_copy);
Current_to_ADC = [10E-06; 1E-06; 100E-09; 10E-09; 1E-09; 100E-12]; //refence current values to be hex code
Current_to_ADC_size=size(Current_to_ADC);

for k=1:Current_to_ADC_size(1,1)
    ADC_Current_copy(:,3)=abs(ADC_Current_copy(:,2)-Current_to_ADC(k,1));
    min_value = min(ADC_Current_copy(:,3));
    for h=1:ADC_Current_copy_size(1,1)
        if ADC_Current_copy(h,3) == min_value then
            Current_to_ADC(k,2) = ADC_Current_copy(h,1); //associated hex value in column two and current value in column one
        end
    end
end

//disp(Current_to_ADC);

//// Plot the data
//scf(1);clf(1);
//plot2d("nl", diode_ivdd25V(:,4), diode_ivdd25V(:,2), style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
//plot2d("nl", ADC_range_ivdd25V, exp(diode_fit_ivdd25V), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//legend(" Data1","Polynomial Model1","Data2","Polynomial Model2","in_upper_left");
//xtitle("","ADC data","Ichar(A)");


exec('~/rasp30/prog_assembly/libs/scilab_code/linefit.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/ekvfit_diodeADC.sce',-1);

diodeADC_iv=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_diodeADC/data_diodeADC_chip"+chip_num+brdtype+"_ivdd25V");

Isat=diodeADC_iv(:,2);
Vout=diodeADC_iv(:,3);
Hex_code=diodeADC_iv(:,4);

epsilon=0.003;//0.004;
plotting="off"; //"on_all" or "on_final" or "off"
[Is, VT, kappa]=ekvfit_diodeADC(Vout, Isat, epsilon, plotting);
//disp('EKV Fit: I_s = '+string(Is)+'A, V_T = '+string(VT)+'V, Kappa = '+string(kappa));

epsilon=1;
[WIfirst, WIlast, Slope_v2h, Offset_v2h, WIN]=linefit(Vout, Hex_code, epsilon);

csvWrite([Is, VT, kappa, Slope_v2h, Offset_v2h],'EKV_diodeADC');
unix_w("cp EKV_diodeADC ~/rasp30/prog_assembly/libs/chip_parameters/EKV_diodeADC/EKV_diodeADC_chip"+chip_num+brdtype);

EKV_diodeADC_para=csvRead("~/rasp30/prog_assembly/libs/chip_parameters/EKV_diodeADC/EKV_diodeADC_chip"+chip_num+brdtype);
Is=EKV_diodeADC_para(1); VT=EKV_diodeADC_para(2); kappa=EKV_diodeADC_para(3); Slope_v2h=EKV_diodeADC_para(4); Offset_v2h=EKV_diodeADC_para(5);

exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2i.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_i2v.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2h.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_h2v.sce',-1);

//Isat2=diodeADC_v2i(Vout, chip_num, brdtype);
//Vout2=diodeADC_i2v(Isat2, chip_num, brdtype);

vdd=2.5;
Vfg=vdd-(Vout/2);

scf(2);clf(2);
plot2d("nl",Vfg, Isat, style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 1; p.children.line_mode="off"; 
plot2d("nl", Vfg, diodeADC_v2i(Vfg, chip_num, brdtype), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
legend("Data","EKV fit","in_lower_left");
xtitle("","Vfg(V)","Isat(A)"); a=gca();a.data_bounds=[1.3 1e-13; 2.4 5e-4];
title(['EKV Fit: I_s = '+string(Is*1e9)+'nA, V_T = '+string(VT)+'V, Kappa = '+string(kappa)]);
scf(3);clf(3);
plot2d("nn",Vfg, Isat, style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 1; p.children.line_mode="off"; 
plot2d("nn", Vfg, diodeADC_v2i(Vfg, chip_num, brdtype), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
legend("Data","EKV fit","in_upper_right");
xtitle("","Vfg(V)","Isat(A)"); //a=gca();a.data_bounds=[0 1e-10; 2.5 1e-3];
title(['EKV Fit: I_s = '+string(Is*1e9)+'nA, V_T = '+string(VT)+'V, Kappa = '+string(kappa)]);
scf(4);clf(4);
plot2d("nn", 2*(vdd-Vfg), Hex_code, style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 1; p.children.line_mode="off";
plot2d("nn", 2*(vdd-Vfg), diodeADC_v2h(Vfg, chip_num, brdtype), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
legend("Data","Data for linefit","linefit","in_lower_left");
//a=gca();a.data_bounds=[0 1e-10; 2.5 1e-3];
xtitle("","Vprog(V)","Hex_code");
title(['m = '+string(Slope_v2h)+'nA, b = '+string(Offset_v2h)]);

scf(5);clf(5);
plot2d("nl", diode_ivdd25V(:,4), diode_ivdd25V(:,2), style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 1; p.children.line_mode="off";
plot2d("nl", ADC_range_ivdd25V, exp(diode_fit_ivdd25V), style=5);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
plot2d("nl", diodeADC_v2h(Vfg, chip_num, brdtype), diodeADC_v2i(Vfg, chip_num, brdtype), style=2);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
legend("data","Polyfit","EKV_fit","in_lower_right");
xtitle("","Hex_code","Isat(A)");
title('Polyfit vs. EKVfit');

Current_to_ADC(:,3)=diodeADC_v2h(diodeADC_i2v(Current_to_ADC(:,1), chip_num, brdtype), chip_num, brdtype);

disp(Current_to_ADC);
