function [Vfg]=diodeADC_h2v(hex, chip_num1, brdtype1)
    vdd=2.5;
    EKV_diodeADC_para=csvRead("~/rasp30/prog_assembly/libs/chip_parameters/EKV_diodeADC/EKV_diodeADC_chip"+chip_num1+brdtype1);
    Is=EKV_diodeADC_para(1); VT=EKV_diodeADC_para(2); kappa=EKV_diodeADC_para(3); Slope_v2h=EKV_diodeADC_para(4); Offset_v2h=EKV_diodeADC_para(5);
    Vfg=vdd-((hex-Offset_v2h)/Slope_v2h)/2;
endfunction

