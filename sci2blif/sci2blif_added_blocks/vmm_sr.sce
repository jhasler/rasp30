//*********************** VMM Shift Register ***************************
if (blk_name.entries(bl) =='vmm_sr') then 
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
    mputl("# VMM + SR",fd_w);
    mputl(".subckt vmm4x4_SR in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(1)+ " in[1]=net"+string(blk(blk_objs(bl),2))+"_"+string(2)+ " in[2]=net"+string(blk(blk_objs(bl),2))+"_"+string(3)+ " in[3]=net"+string(blk(blk_objs(bl),2))+"_"+string(4)+ " in[4]=net"+string(blk(blk_objs(bl),3))+"_"+string(1)+ " in[5]=net"+string(blk(blk_objs(bl),4))+"_"+string(1)+ " in[6]=net"+string(blk(blk_objs(bl),5))+"_"+string(1)+ " out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(1)+ " out[1]=net"+string(blk(blk_objs(bl),3+numofip))+"_"+string(1)+ " out[2]=net"+string(blk(blk_objs(bl),4+numofip))+"_"+string(1)+ " out[3]=net"+string(blk(blk_objs(bl),5+numofip))+"_"+string(1)+ " #vmm4x4_target =" +string(sprintf(tar1,tar2)) + "&vmm_volatile =0",fd_w)
    mputl("  ",fd_w);
end
