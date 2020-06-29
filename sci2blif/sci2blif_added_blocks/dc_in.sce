//**************************** DC_in ***********************************
if (blk_name.entries(bl) =='dc_in') then
    mputl("# dc_in",fd_w);
    DC_in_char = [3.0e-06 2.4462;2.5e-06 2.4163;2.0e-06 2.2968;1.5e-06 2.0720;1.0e-06 1.7760;0.9e-06 1.7016;0.8e-06 1.6102;0.7e-06 1.5330;0.6e-06 1.4284;0.5e-06 1.3176;0.4e-06 1.1920;0.3e-06 1.0064;0.2e-06 0.7770;0.15e-06 0.6270;0.10e-06 0.4000;0.08e-06 0.3044;0.05e-06 0.1250];
    [p_DC_in,S_DC_in]=polyfit(DC_in_char(:,2),log(DC_in_char(:,1)),1);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        dc_in_str= ".subckt fgota in[0]=vcc in[1]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" #fgota_bias =2e-06&fgota_p_bias =2e-06&fgota_n_bias ="+string(sprintf('%1.2e',exp(polyval(p_DC_in,scs_m.objs(blk_objs(bl)).model.rpar(ss),S_DC_in))))+"&fgota_small_cap =0";
        mputl(dc_in_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(1+scs_m.objs(bl).model.ipar(1)) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(2+scs_m.objs(bl).model.ipar(1)+(ss-1)*2))+' '+string(scs_m.objs(bl).model.rpar(3+scs_m.objs(bl).model.ipar(1)+(ss-1)*2))+' 0'];
        end
    end
end
