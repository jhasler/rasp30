//**************************** SOSLPF **********************************
if (blk_name.entries(bl) == "SOSLPF") then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# SOSLPF "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        sci2blif_str= ".subckt SOSLPF"+" in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" #SOSLPF_ls =0"+"&SOSLPF_Ibias2 ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+"&SOSLPF_FG2p ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))+"&SOSLPF_FG2n ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss)))+"&SOSLPF_Ibias1 ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(4-1)+ss)))+"&SOSLPF_FG1p ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+ss)))+"&SOSLPF_FG1n ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(6-1)+ss)))+"&SOSLPF_Feedback ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(7-1)+ss)))+"&SOSLPF_Buffer ="+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(8-1)+ss)))
        mputl(sci2blif_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(9-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(9-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(9-1)+1+2*ss))+' 0'];
        end
    end
end
