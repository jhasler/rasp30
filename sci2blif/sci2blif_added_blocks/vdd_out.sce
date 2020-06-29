//************************** VDD Out (Macro block) *****************************
if(blk_name.entries(bl)=='vdd_out')  then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# vdd_out "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        mputl(".subckt vdd_out in[0]=fb_vddout_net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" in[1]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" out[0]=fb_vddout_net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" #vdd_out_c =0",fd_w);
        mputl(' ',fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'fb_vddout_net'+string(blk(blk_objs(bl),2))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+1+2*ss))+' 0'];
      //  disp(string(plcloc))
        end
    end
end
