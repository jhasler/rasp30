//**************************** I_SenseAmp **********************************
if (blk_name.entries(bl) == "I_SenseAmp") then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# I_SenseAmp "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        sci2blif_str= ".subckt I_SenseAmp"+" in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" in[1]=net"+string(blk(blk_objs(bl),3))+"_"+string(ss)+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" #I_SenseAmp_ls =0"+"&I_SenseAmp_fgota0_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+"&I_SenseAmp_fgota0_pbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))+"&I_SenseAmp_fgota0_nbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss)))+"&I_SenseAmp_ota0_ibias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(4-1)+ss)))
        sci2blif_str=sci2blif_str+"&";
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss) == 1 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap0_1x_cs =1"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss) == 2 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap0_2x_cs =2"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss) == 3 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap0_1x_cs =3&I_SenseAmp_cap0_2x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss) == 4 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap0_4x_cs =4"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss) == 5 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap0_1x_cs =5&I_SenseAmp_cap0_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss) == 6 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap0_2x_cs =6&I_SenseAmp_cap0_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss) == 7 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap0_1x_cs =7&I_SenseAmp_cap0_2x_cs =0&I_SenseAmp_cap0_4x_cs =0"; end

        sci2blif_str=sci2blif_str+"&";
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss) == 1 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap1_1x_cs =1"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss) == 2 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap1_2x_cs =2"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss) == 3 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap1_1x_cs =3&I_SenseAmp_cap1_2x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss) == 4 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap1_4x_cs =4"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss) == 5 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap1_1x_cs =5&I_SenseAmp_cap1_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss) == 6 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap1_2x_cs =6&I_SenseAmp_cap1_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss) == 7 then sci2blif_str=sci2blif_str+"I_SenseAmp_cap1_1x_cs =7&I_SenseAmp_cap1_2x_cs =0&I_SenseAmp_cap1_4x_cs =0"; end
        mputl(sci2blif_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(7-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(7-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(7-1)+1+2*ss))+' 0'];
        end
    end
end
