//**************************** common_source **********************************
if (blk_name.entries(bl) == "common_source") then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# common_source "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        sci2blif_str= ".subckt common_source"+" in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" #common_source_ls =0"+"&common_source_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))
        mputl(sci2blif_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1+2*ss))+' 0'];
        end
    end
end
