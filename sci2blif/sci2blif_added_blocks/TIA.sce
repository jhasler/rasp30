//************************* TIA ******************************
if (blk_name.entries(bl) =='TIA') then
 
    for ss=1:scs_m.objs(bl).model.ipar(1)
    mputl("# TIA",fd_w);
    tia_str= ".subckt TIA_blk in[0]=net"+string(blk(blk_objs(bl),2))+'_1 out[0]=net"+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss)+" #TIA_fgota_bias[0] =10e-6&TIA_ota_p_bias[0] =50e-9&TIA_ota_n_bias[0] =10e-9&TIA_fgota_bias[1] =100e-9&TIA_ota_p_bias[1] =50e-9&TIA_ota_n_bias[1] =2e-9&TIA_ota_bias[0] =1e-6&TIA_ota_buf_out[0] =2e-6&TIA_fg[0] =0";
    mputl(tia_str,fd_w);
    mputl("  ",fd_w);
    
        if scs_m.objs(bl).model.rpar(1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(1+2*ss))+' 0'];
        end
    end 
  
    mclose(fd_io);
end
