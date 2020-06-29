//****************************** VMM ***********************************
if (blk_name.entries(bl) =='vmm_4') then 
    //disp("VMM block");
    mputl("# VMM",fd_w);
    vmm_str= '.subckt vmm_4x4 ';
    vmm_out=' ';
    for pst=0:3
        vmm_str=vmm_str + ' in['+string(pst)+']=net' + string(blk(blk_objs(bl),pst+2)); 
        vmm_out =vmm_out + ' out[' + string(pst)+']=vnet'+ string(blk(blk_objs(bl),pst+2+numofip)) ; //output block  
    end
    vmm_str=vmm_str+vmm_out;
    mputl(vmm_str,fd_w);
    mputl("  ",fd_w)
    vmmota_str1= '.subckt ota ';
    for pst=0:3
        vmmota_str=vmmota_str1 + 'in[0]=vnet' + string(blk(blk_objs(bl),pst+2+numofip)) + ' in[1]=net' + string(orignet) + ' out=net' + string(blk(blk_objs(bl),pst+2+numofip)); 
        mputl(vmmota_str,fd_w);
        vmmota_str=vmmota_str1 + 'in[0]=net' + string(blk(blk_objs(bl),pst+2+numofip)) + ' in[1]=net' + string(orignet+1) + ' out=vnet' + string(blk(blk_objs(bl),pst+2+numofip)); 
        orignet = orignet + 2;
        mputl(vmmota_str,fd_w);
        mputl("  ",fd_w);
    end
end
