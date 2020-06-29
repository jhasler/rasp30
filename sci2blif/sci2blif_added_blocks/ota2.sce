//***************************** OTA ************************************
if(blk_name.entries(bl)=='ota2')  then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# ota2 "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        ota_str='.subckt ota2 in[0]=net' + string(blk(blk_objs(bl),2))+"_" +string(ss)+' in[1]=net'+string(blk(blk_objs(bl),3))+"_" +string(ss)+' out=net'+string(blk(blk_objs(bl),2+numofip))+"_" +string(ss)+" #ota2_bias =" + string(sprintf('%e',scs_m.objs(blk_objs(bl)).model.rpar(ss)));
        mputl(ota_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1+2*ss))+' 0'];
        end
    end
end
