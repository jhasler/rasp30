if (blk_name.entries(bl) =='vmm_4by4') then 
    temp_weight=evstr(scs_m.objs(bl).model.opar(1));
    size_weight=size(temp_weight); 
    if size_weight(1) ~= 4 | size_weight(2) ~= 4 then 
        disp("Size of vmm 4x4 weights matrix is not correct.");
    end

    mputl("# VMM 4x4",fd_w);
    vmm4x4_str=".subckt vmm4x4 in[0]=net"+string(blk(blk_objs(bl),2))+"_1 in[1]=net"+string(blk(blk_objs(bl),2))+"_2 in[2]=net"+string(blk(blk_objs(bl),2))+"_3 in[3]=net"+string(blk(blk_objs(bl),2))+"_4 out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_1 out[1]=net"+string(blk(blk_objs(bl),2+numofip))+"_2 out[2]=net"+string(blk(blk_objs(bl),2+numofip))+"_3 out[3]=net"+string(blk(blk_objs(bl),2+numofip))+"_4 #vmm4x4_target ="
    for i=1:4
        for j=1:4
            vmm4x4_str=vmm4x4_str+string(sprintf('%1.2e',temp_weight(i,j)));
            if i == 4 & j == 4 then vmm4x4_str=vmm4x4_str;
            else vmm4x4_str=vmm4x4_str+",";
            end
        end
    end
    mputl(vmm4x4_str,fd_w);
    mputl("  ",fd_w);

    if scs_m.objs(bl).model.rpar(1) == 1 then
        plcvpr = %t;
        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
    end
end
