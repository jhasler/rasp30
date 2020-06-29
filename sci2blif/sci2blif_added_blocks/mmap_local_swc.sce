//**************************** Mismatch map (local swc) ***********************************
if (blk_name.entries(bl) =='mmap_local_swc') then
    addvmm = %t;
    mputl("# mmap_local_swc",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mmap_local_swc_str=".subckt mmap_local_swc in[0]=net"+string(blk(blk_objs(bl),2))+'_'+ string(ss)+" in[1]=net"+string(blk(blk_objs(bl),3))+'_'+ string(ss)+" in[2]=net"+string(blk(blk_objs(bl),4))+'_'+ string(ss)+" out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss)+" out[1]=net"+ string(blk(blk_objs(bl),3+numofip))+'_'+ string(ss)+" out[2]=net"+ string(blk(blk_objs(bl),4+numofip))+'_'+ string(ss)+" out[3]=net"+ string(blk(blk_objs(bl),5+numofip))+'_'+ string(ss)+" #mmap_ls_fg =0&mmap_ls_in_r"+string(scs_m.objs(blk_objs(bl)).model.rpar(4))+"_vdd =0&mmap_ls_in_r"+string(scs_m.objs(blk_objs(bl)).model.rpar(4))+" ="+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(5)));
        mputl(mmap_local_swc_str,fd_w);
        mputl("  ",fd_w);
    end
    if scs_m.objs(bl).model.rpar(1) == 1 then
        plcvpr = %t;
        plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_1',string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
    end
end
