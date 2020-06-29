//**************************** Hysteretic Differentiator  ******************************
if (blk_name.entries(bl) =='hystdiff') then 
    mputl("# histdiff",fd_w);
    for ss = 1:scs_m.objs(bl).model.ipar(1)
        mputl(".subckt hyst_diff in[0]=net"+string(blk(blk_objs(bl),2))+ "_" + string(ss)+" out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+ "_" + string(ss)+ " #hyst_diff_ls[0] =0&hyst_diff_ota1_ibias[0]=" +string(sprintf('%1.12f',scs_m.objs(blk_objs(bl)).model.rpar(1))),fd_w);
        mputl("  ",fd_w);
    end
end
