//************************** GND IN Digital (Macro block) ****************************
if (blk_name.entries(bl) =='gnd_dig') then
    if chgnet(3) == 0 then
        mputl("#GND_DIG "+string(bl),fd_w)
        gnd_dig_str= ".subckt tgate in[0]=vcc in[1]=gnd out=gnd_dig";
        mputl(gnd_dig_str,fd_w);
        mputl("  ",fd_w);
        chgnet(3)=1;
    end
    chgnet_dict=[chgnet_dict;'net'+ string(blk(blk_objs(bl),2+numofip))+"_.",'gnd_dig'];
    chgnet_tf=%t;
end
