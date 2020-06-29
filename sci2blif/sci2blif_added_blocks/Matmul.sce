//**************************** Matmul **********************************
if (blk_name.entries(bl) == "Matmul") then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        l=mgetl('/home/ubuntu/rasp30/sci2blif/sci2blif_added_blocks/b.txt');
        sci2blif_str=evstr(l);
        mputl(sci2blif_str,fd_w);
        mputl("  ",fd_w);

     end
end
