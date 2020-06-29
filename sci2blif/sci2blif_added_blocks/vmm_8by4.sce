//************************* VMM_8by4 ************************************
if (blk_name.entries(bl) =='vmm_8by4') then 
    addvmm = %t;
    k =scs_m.objs(blk_objs(bl)).model.opar(1);
    tar1=[];
    tar2=[];
    for i=1:size(k,1) 
        for j=1:size(k,2)
            if (j == size(k,2)) & (i == size(k,1)) then tar1=tar1+'%1.2e';
            else tar1=tar1+'%1.2e,';
            end
        end
        tar2=tar2+'k('+string(i)+',:) ';
    end
    tar2= evstr(tar2);
    mputl("# VMM ",fd_w);
    mputl(".subckt vmm8x4_in in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(1)+ " in[1]=net"+string(blk(blk_objs(bl),2))+"_"+string(2)+ " in[2]=net"+string(blk(blk_objs(bl),2))+"_"+string(3)+ " in[3]=net"+string(blk(blk_objs(bl),2))+"_"+string(4)+ " in[4]=net"+string(blk(blk_objs(bl),2))+"_"+string(5)+ " in[5]=net"+string(blk(blk_objs(bl),2))+"_"+string(6)+ " in[6]=net"+string(blk(blk_objs(bl),2))+"_"+string(7)+ " in[7]=net"+string(blk(blk_objs(bl),2))+"_"+string(8)+ " in[8]=net"+string(blk(blk_objs(bl),3))+"_"+string(1)+ " in[9]=net"+string(blk(blk_objs(bl),3))+"_"+string(2)+ " in[10]=net"+string(blk(blk_objs(bl),3))+"_"+string(3)+ " in[11]=net"+string(blk(blk_objs(bl),3))+"_"+string(4)+ " in[12]=net"+string(blk(blk_objs(bl),2))+"_out"+ " out[0]=net"+string(blk(blk_objs(bl),2))+"_out"+" #vmm8x4_in_target =" +string(sprintf(tar1,tar2)),fd_w)
    mputl("  ",fd_w);
end
