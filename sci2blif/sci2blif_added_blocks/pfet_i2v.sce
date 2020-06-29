//**************************** pfet i2v ***********************************
if (blk_name.entries(bl) =='pfet_i2v') then
    mputl("# pfet_i2v",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        nfet_i2v_str=".subckt pfet_i2v in[0]=net"+string(blk(blk_objs(bl),2))+'_'+ string(ss)+" out=net"+ string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss)+" #pfet_i2v_fg =0&pfet_i2v_otabias ="+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(4)));
        mputl(nfet_i2v_str,fd_w);
        mputl("  ",fd_w);
    end
    if scs_m.objs(bl).model.rpar(1) == 1 then
        plcvpr = %t;
        plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_1',string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
    end
end
