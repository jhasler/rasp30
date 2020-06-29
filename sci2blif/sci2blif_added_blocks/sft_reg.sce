//************************** Shift Register ****************************
if (blk_name.entries(bl) =='sft_reg') then
    addvmm = %t;
    mputl("# 4-bit Shift Register",fd_w);
    mputl(".subckt SR4 in[0]=net"+string(blk(blk_objs(bl),2))+'_1'+" in[1]=net" + string(blk(blk_objs(bl),3))+'_1' + "in[2]=net"+string(blk(blk_objs(bl),4))+'_1'+" in[3]=net" + string(blk(blk_objs(bl),5))+'_1' +" out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+'_1'+" out[1]=net"+ string(blk(blk_objs(bl),3+numofip))+'_1'+" out[2]=net"+ string(blk(blk_objs(bl),4+numofip))+'_1'+" out[3]=net"+ string(blk(blk_objs(bl),5+numofip))+'_1'+" out[4]=net"+ string(blk(blk_objs(bl),6+numofip))+'_1'+" out[5]=net"+ string(blk(blk_objs(bl),7+numofip))+'_1'+" out[6]=net"+ string(blk(blk_objs(bl),8+numofip))+'_1'+"#SR_fg =0&vmm_volatile =0",fd_w);
    mputl("  ",fd_w);
end
