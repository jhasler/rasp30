//**************************** vmm6x2 **********************************
if (blk_name.entries(bl) == "vmm6x2") then
    for ss=1:scs_m.objs(bl).model.ipar(1)

l=mgetl('/home/ubuntu/rasp30/sci2blif/sci2blif_added_blocks/a.txt');
        sci2blif_str=evstr(l);




        mputl(sci2blif_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(35-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(35-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(35-1)+1+2*ss))+' 0'];
        end
    end
end
