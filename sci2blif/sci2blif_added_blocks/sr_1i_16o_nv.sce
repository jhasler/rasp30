//***** Shift register 1input 16outputs (non vecterized version) *******
if (blk_name.entries(bl) =='sr_1i_16o_nv') then
    addvmm = %t;
    mputl("# Shift register 1input 16outputs",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_1i_16o_nv_str= ".subckt in2in_x1 in[0]=fbout_"+string(internal_number)+"_"+string(ss)+" in[1]=net"+string(blk(blk_objs(bl),5))+"_"+string(ss)+" in[2]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(ss)+" out[0]=fbout_"+string(internal_number)+"_"+string(ss);
        mputl(sr_1i_16o_nv_str,fd_w);
        mputl("  ",fd_w);
        sr_1i_16o_nv_str= ".subckt sftreg2 in[0]=net"+string(blk(blk_objs(bl),2))+"_1"+" in[1]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[2]=net"+string(blk(blk_objs(bl),4))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(ss)+" out[1]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" out[2]=net"+string(blk(blk_objs(bl),3+numofip))+"_"+string(ss)+" out[3]=net"+string(blk(blk_objs(bl),4+numofip))+"_"+string(ss)+" out[4]=net"+string(blk(blk_objs(bl),5+numofip))+"_"+string(ss)+" out[5]=net"+string(blk(blk_objs(bl),6+numofip))+"_"+string(ss)+" out[6]=net"+string(blk(blk_objs(bl),7+numofip))+"_"+string(ss)+" out[7]=net"+string(blk(blk_objs(bl),8+numofip))+"_"+string(ss)+" out[8]=net"+string(blk(blk_objs(bl),9+numofip))+"_"+string(ss)+" out[9]=net"+string(blk(blk_objs(bl),10+numofip))+"_"+string(ss)+" out[10]=net"+string(blk(blk_objs(bl),11+numofip))+"_"+string(ss)+" out[11]=net"+string(blk(blk_objs(bl),12+numofip))+"_"+string(ss)+" out[12]=net"+string(blk(blk_objs(bl),13+numofip))+"_"+string(ss)+" out[13]=net"+string(blk(blk_objs(bl),14+numofip))+"_"+string(ss)+" out[14]=net"+string(blk(blk_objs(bl),15+numofip))+"_"+string(ss)+" out[15]=net"+string(blk(blk_objs(bl),16+numofip))+"_"+string(ss)+" out[16]=net"+string(blk(blk_objs(bl),17+numofip))+"_"+string(ss)+" out[17]=net"+string(blk(blk_objs(bl),18+numofip))+"_"+string(ss)+" out[18]=net"+string(blk(blk_objs(bl),19+numofip))+"_"+string(ss)+" out[19]=net"+string(blk(blk_objs(bl),20+numofip))+"_"+string(ss)+" #sftreg2_fg =0";
        mputl(sr_1i_16o_nv_str,fd_w);
        mputl("  ",fd_w);
    end
    internal_number=internal_number+1;
end
