//**************************** VolDivide1 **********************************
if (blk_name.entries(bl) == "VolDivide1") then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# VolDivide1 "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        sci2blif_str= ".subckt VolDivide1"+" in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" #VolDivide1_ls =0"+"&VolDivide1_fgota0_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+"&VolDivide1_fgota0_pbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))+"&VolDivide1_fgota0_nbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss)))+"&VolDivide1_ota0_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(4-1)+ss)))
        mputl(sci2blif_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+1+2*ss))+' 0'];
        end
    end
end
