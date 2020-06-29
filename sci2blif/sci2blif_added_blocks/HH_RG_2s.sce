//**************************** HH_RG_2s **********************************
if (blk_name.entries(bl) == "HH_RG_2s") then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# HH_RG_2s "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        sci2blif_str= ".subckt HH_RG_2s"+" in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" in[1]=net"+string(blk(blk_objs(bl),3))+"_"+string(ss)+" in[2]=net"+string(blk(blk_objs(bl),4))+"_"+string(ss)+" in[3]=net"+string(blk(blk_objs(bl),5))+"_"+string(ss)+" in[4]=net"+string(blk(blk_objs(bl),6))+"_"+string(ss)+" in[5]=net"+string(blk(blk_objs(bl),7))+"_"+string(ss)+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" out[1]=net"+string(blk(blk_objs(bl),3+numofip))+"_"+string(ss)+" #HH_RG_2s_ls =0"+"&HH_RG_2s_Nafb_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+"&HH_RG_2s_syn0_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))+"&HH_RG_2s_syn1_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss)))+"&HH_RG_2s_pfet_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(4-1)+ss)))+"&HH_RG_2s_nmr_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss)))+"&HH_RG_2s_Na_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss)))+"&HH_RG_2s_Na_pbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(7-1)+ss)))+"&HH_RG_2s_Na_nbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(8-1)+ss)))+"&HH_RG_2s_K_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(9-1)+ss)))+"&HH_RG_2s_K_pbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss)))+"&HH_RG_2s_K_nbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+ss)))+"&HH_RG_2s_buf_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(12-1)+ss)))+"&HH_RG_2s_comp_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(13-1)+ss)))
        sci2blif_str=sci2blif_str+"&";
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+ss) == 1 then sci2blif_str=sci2blif_str+"HH_RG_2s_cap0_1x_cs =1"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+ss) == 2 then sci2blif_str=sci2blif_str+"HH_RG_2s_cap0_2x_cs =2"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+ss) == 3 then sci2blif_str=sci2blif_str+"HH_RG_2s_cap0_1x_cs =3&HH_RG_2s_cap0_2x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+ss) == 4 then sci2blif_str=sci2blif_str+"HH_RG_2s_cap0_4x_cs =4"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+ss) == 5 then sci2blif_str=sci2blif_str+"HH_RG_2s_cap0_1x_cs =5&HH_RG_2s_cap0_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+ss) == 6 then sci2blif_str=sci2blif_str+"HH_RG_2s_cap0_2x_cs =6&HH_RG_2s_cap0_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(14-1)+ss) == 7 then sci2blif_str=sci2blif_str+"HH_RG_2s_cap0_1x_cs =7&HH_RG_2s_cap0_2x_cs =0&HH_RG_2s_cap0_4x_cs =0"; end
        mputl(sci2blif_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(15-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(15-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(15-1)+1+2*ss))+' 0'];
        end
    end
end
