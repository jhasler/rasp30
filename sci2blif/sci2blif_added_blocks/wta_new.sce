//**************************** wta_new **********************************
if (blk_name.entries(bl) == "wta_new") then
    mputl("#wta_new",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        wta_new_str= '.subckt wta_new'+' in[0]=net'+string(blk(blk_objs(bl),2))+'_'+string(ss)+' in[1]=net'+string(blk(blk_objs(bl),3))+'_1 in[2]=net'+string(blk(blk_objs(bl),4))+'_1 out[0]=net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss)+' #wta_new_ls =0'+'&wta_new_wta_bias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+'&wta_new_buf_bias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))
        mputl(wta_new_str,fd_w);
        mputl("",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+1+2*ss))+' 0'];
        end
    end
end
