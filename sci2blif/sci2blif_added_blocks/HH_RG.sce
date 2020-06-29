//**************************** HH_RG **********************************
if (blk_name.entries(bl) == "HH_RG") then
    mputl("#HH_RG",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        HH_RG_str= '.subckt HH_RG'+' in[0]=net'+string(blk(blk_objs(bl),2))+'_'+string(ss)+' in[1]=net'+string(blk(blk_objs(bl),3))+'_'+string(ss)+' in[2]=net'+string(blk(blk_objs(bl),4))+'_'+string(ss)+' in[3]=net'+string(blk(blk_objs(bl),5))+'_'+string(ss)+' in[4]=net'+string(blk(blk_objs(bl),6))+'_'+string(ss)+' out[0]=net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss)+' out[1]=net'+string(blk(blk_objs(bl),3+numofip))+'_'+string(ss)+' #HH_RG_ls =0'+'&HH_RG_Nafb_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+'&HH_RG_in0_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))+'&HH_RG_pfet_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss)))+'&HH_RG_nmr_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(4-1)+ss)))+'&HH_RG_Na_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss)))+'&HH_RG_Na_pbias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss)))+'&HH_RG_Na_nbias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(7-1)+ss)))+'&HH_RG_K_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(8-1)+ss)))+'&HH_RG_K_pbias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(9-1)+ss)))+'&HH_RG_K_nbias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss)))+'&HH_RG_buf_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+ss)))+'&HH_RG_comp_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(12-1)+ss)))
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(13-1)+ss) == 1 then HH_RG_str=HH_RG_str+'&HH_RG_cap0_1x_cs =0'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(13-1)+ss) == 2 then HH_RG_str=HH_RG_str+'&HH_RG_cap0_2x_cs =0'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(13-1)+ss) == 3 then HH_RG_str=HH_RG_str+'&HH_RG_cap0_1x_cs =0'+'&HH_RG_cap0_2x_cs =0'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(13-1)+ss) == 4 then HH_RG_str=HH_RG_str+'&HH_RG_cap0_4x_cs =0'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(13-1)+ss) == 5 then HH_RG_str=HH_RG_str+'&HH_RG_cap0_1x_cs =0'+'&HH_RG_cap0_4x_cs =0'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(13-1)+ss) == 6 then HH_RG_str=HH_RG_str+'&HH_RG_cap0_2x_cs =0'+'&HH_RG_cap0_4x_cs =0'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(13-1)+ss) == 7 then HH_RG_str=HH_RG_str+'&HH_RG_cap0_1x_cs =0'+'&HH_RG_cap0_2x_cs =0'+'&HH_RG_cap0_4x_cs =0'; end
        mputl(HH_RG_str,fd_w);
        mputl("",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+1+2*ss))+' 0'];
        end
    end
end
