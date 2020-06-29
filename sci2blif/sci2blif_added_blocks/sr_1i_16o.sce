//************** Shift Register 1input 16outputs ***********************
if (blk_name.entries(bl) == 'sr_1i_16o') then
    addvmm = %t;
    mputl("# Shift register 1input 16outputs",fd_w);
    sr_1i_16o_str= ".subckt sftreg3 in[0]=net"+string(blk(blk_objs(bl),2))+"_1"+" in[1]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[2]=net"+string(blk(blk_objs(bl),4))+"_1"+" in[3]=net"+string(blk(blk_objs(bl),5))+"_1"+" out[0]=net_floated_"+string(internal_number)+" out[1]=net"+string(blk(blk_objs(bl),2+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),4+numofip))+"_1";
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_1i_16o_str=sr_1i_16o_str+" out["+string(ss+3)+"]=net"+string(blk(blk_objs(bl),5+numofip))+"_"+string(ss);
    end
    sr_1i_16o_str=sr_1i_16o_str+" #sftreg3_fg =0";
    mputl(sr_1i_16o_str,fd_w);
    mputl("  ",fd_w);
    if scs_m.objs(bl).model.rpar(1) == 1 then
        plcvpr = %t;
        plcloc=[plcloc;'net_floated_'+string(internal_number),string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
    end
    internal_number=internal_number+1;
end

//if (blk_name.entries(bl) == 'sr_1i_16o') then
//    addvmm = %t;
//    mputl("# Shift register 1input 16outputs",fd_w);
//    sr_1i_16o_str= ".subckt in2in_x1 in[0]=fbout_"+string(internal_number)+"_1"+" in[1]=net"+string(blk(blk_objs(bl),5))+"_1"+" in[2]=net"+string(blk(blk_objs(bl),5))+"_internal"+" out[0]=fbout_"+string(internal_number)+"_1";
//    mputl(sr_1i_16o_str,fd_w);
//    mputl("  ",fd_w);
//    sr_1i_16o_str= ".subckt sftreg2 in[0]=net"+string(blk(blk_objs(bl),2))+"_1"+" in[1]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[2]=net"+string(blk(blk_objs(bl),4))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),5))+"_internal"+" out[1]=net"+string(blk(blk_objs(bl),2+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),4+numofip))+"_1";
//    for ss=1:scs_m.objs(bl).model.ipar(1)
//        sr_1i_16o_str=sr_1i_16o_str+" out["+string(ss+3)+"]=net"+string(blk(blk_objs(bl),5+numofip))+"_"+string(ss);
//    end
//    sr_1i_16o_str=sr_1i_16o_str+" #sftreg2_fg =0";
//    mputl(sr_1i_16o_str,fd_w);
//    mputl("  ",fd_w);
//    if scs_m.objs(bl).model.rpar(1) == 1 then
//        plcvpr = %t;
//        plcloc=[plcloc;'net'+string(blk(blk_objs(bl),5))+'_internal',string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
//    end
//    internal_number=internal_number+1;
//end
