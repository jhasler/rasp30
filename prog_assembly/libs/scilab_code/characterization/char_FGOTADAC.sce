global file_name path fname extension chip_num board_num hex_1na showprog;

fgotadac_cal=csvRead('data_fgotadac');
[p_DC_in,S_DC_in]=polyfit(fgotadac_cal(4:8,2),log(fgotadac_cal(4:8,1)),1);

scf(100);clf(100);
plot2d("ln",fgotadac_cal(:,1), fgotadac_cal(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.mark_foreground = 1;p.children.line_mode = 'off';
plot2d("ln",exp(p_DC_in(1)*fgotadac_cal(:,2)+p_DC_in(2)),fgotadac_cal(:,2));p = get("hdl");p.children.line_mode = 'on';p.children.mark_mode = 'off';
//a=gca();a.data_bounds=[1 1.3; 1.7 1.8];
xtitle("","Vout[V]@Vg=0.6V", " Vout[V]@Vg=0V");

