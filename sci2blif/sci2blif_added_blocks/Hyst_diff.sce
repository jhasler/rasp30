//**************************** Hyst_diff **********************************
if (blk_name.entries(bl) == "Hyst_diff") then
    mputl("#Hyst_diff",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        Hyst_diff_str= '.subckt Hyst_diff'+' in[0]=net'+string(blk(blk_objs(bl),2))+'_'+string(ss)+' out[0]=net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss)+' #Hyst_diff_ls =0'+'&Hyst_diff_ota1_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))
        mputl(Hyst_diff_str,fd_w);
    mputl("",fd_w);
    end
end
