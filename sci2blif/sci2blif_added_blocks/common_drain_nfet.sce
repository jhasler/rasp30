//**************************** common_drain_nfet **********************************
if (blk_name.entries(bl) == "common_drain_nfet") then
    mputl("#common_drain_nfet",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        common_drain_nfet_str= '.subckt common_drain_nfet'+' in[0]=net'+string(blk(blk_objs(bl),2))+'_'+string(ss)+' out[0]=net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss)+' #common_drain_nfet_ls =0'+'&common_drain_nfet_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))
        mputl(common_drain_nfet_str,fd_w);
        mputl("",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1+2*ss))+' 0'];
        end
    end
end
