//**************************** hhn **********************************
if (blk_name.entries(bl) == "hhn") then
    mputl("#hhn",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        hhn_str= '.subckt hhn'+' in[0]=net'+string(blk(blk_objs(bl),2))+'_'+string(ss)+' in[1]=net'+string(blk(blk_objs(bl),3))+'_'+string(ss)+' in[2]=net'+string(blk(blk_objs(bl),4))+'_'+string(ss)+' in[3]=net'+string(blk(blk_objs(bl),5))+'_'+string(ss)+' out[0]=net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss)+' #hhn_ls =0'+'&hhn_fgswc_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+'&hhn_fgota1_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))+'&hhn_fgota1_pbias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss)))+'&hhn_fgota1_nbias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(4-1)+ss)))+'&hhn_fgota0_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss)))+'&hhn_fgota0_pbias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss)))+'&hhn_fgota0_nbias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(7-1)+ss)))+'&hhn_ota0_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(8-1)+ss)))+'&hhn_ota1_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(9-1)+ss)))
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 1 then hhn_str=hhn_str+'&hhn_cap0_1x_cs =1'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 2 then hhn_str=hhn_str+'&hhn_cap0_2x_cs =2'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 3 then hhn_str=hhn_str+'&hhn_cap0_1x_cs =3'+'&hhn_cap0_2x_cs =0'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 4 then hhn_str=hhn_str+'&hhn_cap0_4x_cs =4'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 5 then hhn_str=hhn_str+'&hhn_cap0_1x_cs =5'+'&hhn_cap0_4x_cs =0'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 6 then hhn_str=hhn_str+'&hhn_cap0_2x_cs =6'+'&hhn_cap0_4x_cs =0'; end
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(10-1)+ss) == 7 then hhn_str=hhn_str+'&hhn_cap0_1x_cs =7'+'&hhn_cap0_2x_cs =0'+'&hhn_cap0_4x_cs =0'; end
        mputl(hhn_str,fd_w);
        mputl("",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(11-1)+1+2*ss))+' 0'];
        end
    end
end
