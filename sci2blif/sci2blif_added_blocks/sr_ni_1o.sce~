//**************************** sr_ni_1o **********************************
if (blk_name.entries(bl) == "sr_ni_1o") then
    mputl("#sr_ni_1o",fd_w);
    sr_ni_1o_str= ".subckt sftreg";
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_ni_1o_str=sr_ni_1o_str+" in["+string(ss-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss);
    end
    for ss=scs_m.objs(bl).model.ipar(1):15
        sr_ni_1o_str=sr_ni_1o_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),4+numofip))+"_1";
    end
    sr_ni_1o_str=sr_ni_1o_str+" in[16]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[17]=net"+string(blk(blk_objs(bl),4))+"_1"+" in[18]=net"+string(blk(blk_objs(bl),5))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_1"+" out[1]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),4+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),5+numofip))+"_1 #sftreg_fg =0";
    mputl(sr_ni_1o_str,fd_w);
    mputl("  ",fd_w);

    if scs_m.objs(bl).model.rpar(1) == 1 then
        plcvpr = %t;
        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
    end
end
