//**************************** OTA Buffer ******************************
if (blk_name.entries(bl) =='ota_buf') then 
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# ota_buf "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        mputl(".subckt ota_buf in[0]=net"+string(blk(blk_objs(bl),2))+ "_" + string(ss)+" out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+ "_" + string(ss)+ " #ota_buf_ls =0&ota_buf_bias =10e-6",fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(1+2*ss))+' 0'];
        end
    end
end
