//************************ Input2Input x1 ******************************
if (blk_name.entries(bl) =='in2in_x1') then
    //addvmm = %t;
    mputl("# Input 2 Input x1",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        in2in_x1_str= ".subckt in2in_x1 in[0]=fbout_"+string(internal_number)+"_"+string(ss)+" in[1]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" in[2]=net"+string(blk(blk_objs(bl),3))+"_"+string(ss)+" out[0]=fbout_"+string(internal_number)+"_"+string(ss);
        mputl(in2in_x1_str,fd_w);
        mputl("  ",fd_w);
        internal_number=internal_number+1;
    end
end
