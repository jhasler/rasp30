//**************************** SubbandArray **********************************
if (blk_name.entries(bl) == "SubbandArray") then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# SubbandArray "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
         sci2blif_str= ".subckt SubbandArray"+" in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(1)+" in[1]=net"+string(blk(blk_objs(bl),3))+"_"+string(1)+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" out[1]=net"+string(blk(blk_objs(bl),3+numofip))+"_"+string(ss)+" #SubbandArray_ls =0&SubbandArray_FBbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))+"&SubbandArray_FBpbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss)))+"&SubbandArray_FBnbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(4-1)+ss)))+"&SubbandArray_FFbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss)))+"&SubbandArray_FFpbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss)))+"&SubbandArray_FFnbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(7-1)+ss)))+"&SubbandArray_Maxota ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(8-1)+ss)))+"&SubbandArray_LPF ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(9-1)+ss)))

        //sci2blif_str= ".subckt SubbandArray"+" in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(1)+" in[1]=net"+string(blk(blk_objs(bl),3))+"_"+string(1)+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" out[1]=net"+string(blk(blk_objs(bl),3+numofip))+"_"+string(ss)+" #SubbandArray_ls =0"+"&SubbandArray_Maxpfet ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+"&SubbandArray_FBbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))+"&SubbandArray_FBpbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss)))+"&SubbandArray_FBnbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(4-1)+ss)))+"&SubbandArray_FFbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss)))+"&SubbandArray_FFpbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss)))+"&SubbandArray_FFnbias ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(7-1)+ss)))+"&SubbandArray_Maxota ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(8-1)+ss)))+"&SubbandArray_LPF ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(9-1)+ss)))
        sci2blif_str=sci2blif_str+"&";
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 1 then sci2blif_str=sci2blif_str+"SubbandArray_FFcap_1x_cs =1"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 2 then sci2blif_str=sci2blif_str+"SubbandArray_FFcap_2x_cs =2"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 3 then sci2blif_str=sci2blif_str+"SubbandArray_FFcap_1x_cs =3&SubbandArray_FFcap_2x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 4 then sci2blif_str=sci2blif_str+"SubbandArray_FFcap_4x_cs =4"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 5 then sci2blif_str=sci2blif_str+"SubbandArray_FFcap_1x_cs =5&SubbandArray_FFcap_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 6 then sci2blif_str=sci2blif_str+"SubbandArray_FFcap_2x_cs =6&SubbandArray_FFcap_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 7 then sci2blif_str=sci2blif_str+"SubbandArray_FFcap_1x_cs =7&SubbandArray_FFcap_2x_cs =0&SubbandArray_FFcap_4x_cs =0"; end

        sci2blif_str=sci2blif_str+"&";
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+ss) == 1 then sci2blif_str=sci2blif_str+"SubbandArray_FBcap_1x_cs =1"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+ss) == 2 then sci2blif_str=sci2blif_str+"SubbandArray_FBcap_2x_cs =2"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+ss) == 3 then sci2blif_str=sci2blif_str+"SubbandArray_FBcap_1x_cs =3&SubbandArray_FBcap_2x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+ss) == 4 then sci2blif_str=sci2blif_str+"SubbandArray_FBcap_4x_cs =4"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+ss) == 5 then sci2blif_str=sci2blif_str+"SubbandArray_FBcap_1x_cs =5&SubbandArray_FBcap_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+ss) == 6 then sci2blif_str=sci2blif_str+"SubbandArray_FBcap_2x_cs =6&SubbandArray_FBcap_4x_cs =0"; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+ss) == 7 then sci2blif_str=sci2blif_str+"SubbandArray_FBcap_1x_cs =7&SubbandArray_FBcap_2x_cs =0&SubbandArray_FBcap_4x_cs =0"; end
        mputl(sci2blif_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(12-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(12-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(12-1)+1+2*ss))+' 0'];
        end
    end
end
