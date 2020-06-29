//************************* VDD In Digital *****************************
if (blk_name.entries(bl) =='vdd_dig') then
    if chgnet(6) == 0 then
        mputl("#VDD_DIG "+string(bl),fd_w);
        vdd_dig_str= ".subckt tgate in[0]=vcc in[1]=vcc out=vcc_dig";
        mputl(vdd_dig_str,fd_w);
        mputl("  ",fd_w);
        chgnet(6)=1;
    end
    plcloc=[plcloc;'vcc_dig','10 2 1'];
    chgnet_dict=[chgnet_dict;'net'+ string(blk(blk_objs(bl),2+numofip))+"_.",'vcc_dig'];
    chgnet_tf=%t;
end
