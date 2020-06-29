//***************************** MITE2 **********************************
if (blk_name.entries(bl) =='mite2') then
    mputl("# MITE2",fd_w);
    mputl(".subckt mite2 in[0]=net"+string(blk(blk_objs(bl),2))+ " in[1]=net"+string(blk(blk_objs(bl),3))+ " out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+ " out[1]=net"+ string(blk(blk_objs(bl),3+numofip)),fd_w);
    mputl("  ",fd_w);
end
