//************** Shift Register 1input 16outputs with node set***********************
if (blk_name.entries(bl) == 'sr_1i_16o_nodeset') then
    addvmm = %t;
    mputl("# Shift register 1input 16outputs nodeset",fd_w);
    sr_1i_16o_nodeset_str= ".subckt sftreg4 in[0]=net"+string(blk(blk_objs(bl),2))+"_1"+" in[1]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[2]=net"+string(blk(blk_objs(bl),4))+"_1"+" in[3]=net"+string(blk(blk_objs(bl),6))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),5))+"_1"+" out[1]=net"+string(blk(blk_objs(bl),2+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),4+numofip))+"_1";
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_1i_16o_nodeset_str=sr_1i_16o_nodeset_str+" out["+string(ss+3)+"]=net"+string(blk(blk_objs(bl),5+numofip))+"_"+string(ss);
    end
    sr_1i_16o_nodeset_str=sr_1i_16o_nodeset_str+" #sftreg4_fg =0&sftreg4_otabias =2e-6";
    mputl(sr_1i_16o_nodeset_str,fd_w);
    mputl("  ",fd_w);
    if scs_m.objs(bl).model.rpar(1) == 1 then
        plcvpr = %t;
        plcloc=[plcloc;'net_floated_'+string(internal_number),string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
    end
end

