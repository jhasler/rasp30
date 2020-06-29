//*************** Shift register 16inputs 1output **********************
if (blk_name.entries(bl) =='sr_4i_1o') then
    addvmm = %t;
    mputl("# Shift register 4inputs 1output",fd_w);
    sr_4i_1o_str= ".subckt sftreg";
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_4i_1o_str=sr_4i_1o_str+" in["+string(ss-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss);
    end
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_4i_1o_str=sr_4i_1o_str+" in["+string(ss+4-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss);
    end
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_4i_1o_str=sr_4i_1o_str+" in["+string(ss+8-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss);
    end
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_4i_1o_str=sr_4i_1o_str+" in["+string(ss+12-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss);
    end
    sr_4i_1o_str=sr_4i_1o_str+" in[16]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[17]=net"+string(blk(blk_objs(bl),4))+"_1"+" in[18]=net"+string(blk(blk_objs(bl),5))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_1"+" out[1]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),4+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),5+numofip))+"_1 #sftreg_fg =0";
    mputl(sr_4i_1o_str,fd_w);
    mputl("  ",fd_w);
    plcvpr = %t;
    select board_num
    case 2 then plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",'10 2 0'];
    case 3 then plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",'5 2 0'];  // will be done.
    end
end
