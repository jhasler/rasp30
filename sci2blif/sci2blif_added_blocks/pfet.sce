//****************************** PFET **********************************
if (blk_name.entries(bl) =='pfet') then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# pfet "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        pfet_str=".subckt pfet in[0]=net"+string(blk(blk_objs(bl),3))+'_'+string(ss)+" in[1]=net" + string(blk(blk_objs(bl),2))+'_'+string(ss)+" out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+'_'+string(ss);
        mputl(pfet_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+1+2*ss))+' 0'];
        end
    end
    //fd_info= mopen('info.txt','a+');
    //mputl('Pfet gate=net"+string(blk(blk_objs(bl),3))+" source=net" + string(blk(blk_objs(bl),2))',fd_info);
    //mclose(fd_info);
end
