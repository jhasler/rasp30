//************************ Input2Input x6 ******************************
if (blk_name.entries(bl) =='in2in_x6') then
    //addvmm = %t;
    mputl("# Input 2 Input x6",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        in2in_x6_str= ".subckt in2in_x6 in[0]=fbout_"+string(internal_number)+"_"+string(ss)+" in[1]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" in[2]=net"+string(blk(blk_objs(bl),3))+"_"+string(ss)+" in[3]=net"+string(blk(blk_objs(bl),4))+"_"+string(ss)+" in[4]=net"+string(blk(blk_objs(bl),5))+"_"+string(ss)+" in[5]=net"+string(blk(blk_objs(bl),6))+"_"+string(ss)+" in[6]=net"+string(blk(blk_objs(bl),7))+"_"+string(ss)+" in[7]=net"+string(blk(blk_objs(bl),8))+"_"+string(ss)+" in[8]=net"+string(blk(blk_objs(bl),9))+"_"+string(ss)+" in[9]=net"+string(blk(blk_objs(bl),10))+"_"+string(ss)+" in[10]=net"+string(blk(blk_objs(bl),11))+"_"+string(ss)+" in[11]=net"+string(blk(blk_objs(bl),12))+"_"+string(ss)+" in[12]=net"+string(blk(blk_objs(bl),13))+"_"+string(ss)+" out[0]=fbout_"+string(internal_number)+"_"+string(ss);
        mputl(in2in_x6_str,fd_w);
        mputl("  ",fd_w);
        internal_number=internal_number+1;
    end
end
