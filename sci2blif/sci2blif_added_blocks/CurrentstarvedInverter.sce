//************************* Current Starved Inverter ******************************
if (blk_name.entries(bl) =='CurrentstarvedInverter') then
    addvmm = %t;
    mputl("# CurrentstarvedInverter",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        cap_str= ".subckt INV_cs in[0]=net"+string(blk(blk_objs(bl),2))+'_'+ string(ss)+" in[1]=net"+string(blk(blk_objs(bl),3))+'_'+ string(ss)+" out=net"+ string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss) + " #INV_cs_fg =0&INV_cs_NBIAS ="+string(sprintf('%1.12f',scs_m.objs(blk_objs(bl)).model.rpar(2*ss-1)))+"&INV_cs_PBIAS ="+string(sprintf('%1.12f',scs_m.objs(blk_objs(bl)).model.rpar(2*ss)));
        mputl(cap_str,fd_w);
        mputl("  ",fd_w);
    end
end
