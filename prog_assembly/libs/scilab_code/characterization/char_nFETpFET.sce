global chip_num board_num;

exec('~/rasp30/prog_assembly/libs/scilab_code/linefit.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/ekvfit_nfet.sce',-1);
vdd=2.5;

nFET_IVg=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET/data_nFET_IVg_curve_chip"+chip_num+brdtype);
//nFET_IVg=csvRead("data_nFET_IVg_curve");
plotting="off";  // "on_all" or "on_final" or "off"
epsilon=0.005; // epsilon=0.005;
[nFET_Is, nFET_VT, nFET_kappa]=ekvfit_nfet(nFET_IVg(:,1), nFET_IVg(:,2), epsilon, plotting);
//nFET_Is=64.1e-9; nFET_VT=0.39; nFET_kappa=0.781;
nFET_IVg(:,3) = nFET_Is*(log(1+exp((nFET_kappa*(nFET_IVg(:,1)-nFET_VT))/(2*0.0258))))^2;

pFET_IVg=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET/data_pFET_IVg_curve_chip"+chip_num+brdtype);
//pFET_IVg=csvRead("data_pFET_IVg_curve");
pFET_IVg_flip=flipdim(pFET_IVg,1);
pFET_IVg_flip(:,1)=2.5-pFET_IVg_flip(:,1);
plotting="off";  // "on_all" or "on_final" or "off"
epsilon=0.002; // epsilon=0.005;
[pFET_Is, pFET_VT, pFET_kappa]=ekvfit_nfet(pFET_IVg_flip(:,1), pFET_IVg_flip(:,2), epsilon, plotting);
pFET_IVg_flip(:,3) = pFET_Is*(log(1+exp((pFET_kappa*(pFET_IVg_flip(:,1)-pFET_VT))/(2*0.0258))))^2;

// Plot the data
scf(8);clf(8);
plot2d("nl", nFET_IVg(:,1), nFET_IVg(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
plot2d("nl", pFET_IVg_flip(:,1), pFET_IVg_flip(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
plot2d("nl", nFET_IVg(:,1), nFET_IVg(:,3), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
plot2d("nl", pFET_IVg_flip(:,1), pFET_IVg_flip(:,3), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";p.children.foreground=2;
a=gca();a.data_bounds=[0 1e-11; 2.5 1e-4];
legend("nFET Measurement","pFET Measurement","nFET EKV fit","pFET EKV fit","in_lower_right");
xtitle("","Vg(V)","Id(A)");
title(['EKV Fit: nFET_I_s = '+string(nFET_Is*1e9)+'nA, nFET_V_T = '+string(nFET_VT)+'V, nFET_Kappa = '+string(nFET_kappa);'EKV Fit: pFET_I_s = '+string(pFET_Is*1e9)+'nA, pFET_V_T = '+string(pFET_VT)+'V, pFET_Kappa = '+string(pFET_kappa);]);

nFET_IVd=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET/data_nFET_IVd_curve_chip"+chip_num+brdtype);
temp_diff=diff(log(nFET_IVd(:,2)));
//nFET_sigma=mean((2*0.0258)*temp_diff(9:35)/0.05);   // 9 -> 0.6V, 35 -> 1.9V
nFET_sigma=mean((2*0.0258)*temp_diff(13:35)/0.05);   // 13 -> 0.8V, 35 -> 1.9V
//nFET_IVd(:,3)=nFET_IVd(9,2)*exp(nFET_sigma*(nFET_IVd(:,1)-nFET_IVd(9,1))/(2*0.0258));
nFET_IVd(:,3)=nFET_IVd(13,2)*exp(nFET_sigma*(nFET_IVd(:,1)-nFET_IVd(13,1))/(2*0.0258));
pFET_IVd=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_nFETpFET/data_pFET_IVd_curve_chip"+chip_num+brdtype);
pFET_IVd_flip=flipdim(pFET_IVd,1);
pFET_IVd_flip(:,1)=2.5-pFET_IVd_flip(:,1);
temp_diff=diff(log(pFET_IVd_flip(:,2)));
pFET_sigma=mean((2*0.0258)*temp_diff(13:39)/0.05);   // 13 -> 0.6V, 39 -> 1.9V
pFET_IVd_flip(:,3)=pFET_IVd_flip(13,2)*exp(pFET_sigma*(pFET_IVd_flip(:,1)-pFET_IVd_flip(13,1))/(2*0.0258));

scf(9);clf(9);
plot2d("nl", nFET_IVd(:,1), nFET_IVd(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
plot2d("nl", nFET_IVd(:,1), nFET_IVd(:,3), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
plot2d("nl", pFET_IVd_flip(:,1), pFET_IVd_flip(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
plot2d("nl", pFET_IVd_flip(:,1), pFET_IVd_flip(:,3), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";p.children.foreground=2;
//a=gca();a.data_bounds=[0 1e-8; 2.5 8e-8];
legend("nFET Measurement","nFET EKV fit","pFET Measurement","pFET EKV fit","in_lower_right");
xtitle("","Vd(V)","Id(A)");
title(['EKV Fit: nFET sigma = '+string(nFET_sigma)+', pFET sigma = '+string(pFET_sigma)]);



