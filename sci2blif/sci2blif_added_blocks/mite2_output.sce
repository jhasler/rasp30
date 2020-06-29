//************************** MITE2_OUTPUT ******************************
if (blk_name.entries(bl) =='mite2_output') then
    mputl("# MITE2_OUTPUT",fd_w);
    mputl(".subckt mite2 in[0]=net"+string(blk(blk_objs(bl),2))+ " in[1]=net"+string(blk(blk_objs(bl),3))+ " out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+ " out[1]=net"+ string(blk(blk_objs(bl),3+numofip)),fd_w);
    mputl("  ",fd_w);
    exec("~/rasp30/prog_assembly/libs/scilab_code/output_compile.sce",-1);
    output_compile(1,1);
end
