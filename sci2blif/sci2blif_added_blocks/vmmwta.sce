//************************* VMM_WTA ************************************
if (blk_name.entries(bl) =='vmmwta') then 
    addvmm = %t;
    cap_info = cap_info2(cap_info,pass_num,'vmm_out1', bl)
    cap_info = cap_info2(cap_info,pass_num,'vmm_out2', bl)
    cap_info = cap_info2(cap_info,pass_num,'vmm_out3', bl)
    cap_info = cap_info2(cap_info,pass_num,'vmm_out4', bl)
    cap_info = cap_info2(cap_info,pass_num,'nfet_d', bl)
    b_elements = elements_add(b_elements,1,0, 0, 6, 0, 0, 0, 0,1)

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
    mputl("# VMM + WTA",fd_w);
    mputl(".subckt vmm4x4 in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(1)+ " in[1]=net"+string(blk(blk_objs(bl),2))+"_"+string(2)+ " in[2]=net"+string(blk(blk_objs(bl),2))+"_"+string(3)+ " in[3]=net"+string(blk(blk_objs(bl),2))+"_"+string(4)+ " out[0]=vmm_out1 out[1]=vmm_out2 out[2]=vmm_out3 out[3]=vmm_out4 #vmm4x4_target =" +string(sprintf(tar1,tar2)),fd_w)
    mputl("  ",fd_w);
    mputl(".subckt wta_new in[0]=vmm_out1 in[1]=nfet_d in[2]=unconn out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+"_" + string(1)+" #wta_new_ls =0&wta_new_buf_bias =" +string(sprintf('%1.1e',scs_m.objs(blk_objs(bl)).model.rpar(6)))+"&wta_new_wta_bias =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(7))),fd_w)
    mputl("  ",fd_w);
    mputl(".subckt wta_new in[0]=vmm_out2 in[1]=nfet_d in[2]=unconn out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+"_" + string(2)+" #wta_new_ls =0&wta_new_buf_bias =" +string(sprintf('%1.1e',scs_m.objs(blk_objs(bl)).model.rpar(6)))+"&wta_new_wta_bias =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(8))),fd_w)
    mputl("  ",fd_w);
    mputl(".subckt wta_new in[0]=vmm_out3 in[1]=nfet_d in[2]=unconn out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+"_" + string(3)+" #wta_new_ls =0&wta_new_buf_bias =" +string(sprintf('%1.1e',scs_m.objs(blk_objs(bl)).model.rpar(6)))+"&wta_new_wta_bias =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9))),fd_w)
    mputl("  ",fd_w);
    mputl(".subckt wta_new in[0]=vmm_out4 in[1]=nfet_d in[2]=unconn out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+"_" + string(4)+" #wta_new_ls =0&wta_new_buf_bias =" +string(sprintf('%1.1e',scs_m.objs(blk_objs(bl)).model.rpar(6)))+"&wta_new_wta_bias =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(10))),fd_w)
    mputl("  ",fd_w);
    mputl(".subckt nfet in[0]=net"+string(blk(blk_objs(bl),3))+"_"+string(1)+ " in[1]=unconn out=nfet_d",fd_w);
    mputl("  ",fd_w);
end
