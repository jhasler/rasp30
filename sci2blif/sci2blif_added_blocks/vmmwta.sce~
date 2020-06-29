//************************* VMM_WTA ************************************
if (blk_name.entries(bl) =='vmmwta') then 
    addvmm = %t;
    cap_info = cap_info2(cap_info,pass_num,'vw_nfetd', bl)

    k =scs_m.objs(blk_objs(bl)).model.opar(1);
    tar1=[];
    tar2=[];
    tar3=[];
    for j=1:12
        if j == 12 then tar1=tar1+'%1.2e';
        else tar1=tar1+'%1.2e,';
        end
    end
    j = size(k,2)+1;
    for i=1:size(k,1) 
        tar3='k('+string(i)+',:) ';
        for n = j:12
            tar3=tar3+'50e-12 ';
        end
        tar2(i,:)=evstr(tar3);          
    end
    mputl("# VMM+WTA",fd_w);
    vmm12_1 =".subckt vmm12x1";
    for i = 1:size(k,2)
        vmm12_1 = vmm12_1 + " in["+ string(i-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(i);
        last_input=i;
    end
    if j < 13 then
        for i = j:12
            vmm12_1 = vmm12_1 + " in["+ string(i-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(last_input+1);
        end
    end
    for i = 1:size(k,1)
    //disp(i)
        vmm12_1o = vmm12_1 + " in[12]=vw_nfetd" +" out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+"_" + string(i)+" #vmm12x1_fg =0&vmm12x1_pfetbias ="+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(6+i)))+ "&vmm12x1_offsetbias ="+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(8+i)))+ "&vmm12x1_otabias ="+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(6)));
      // vmm12_1o = vmm12_1 + " in[12]=net"+string(blk(blk_objs(bl),3))+'_1 out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+"_" + string(i)+" #vmm12x1_fg =0&vmm12x1_pfetbias ="+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(6+i)))+ "&nmirror_bias =50e-11&vmm12x1_offsetbias =3e-11&vmm12x1_otabias ="+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(6)));
     vmm12_1target="&vmm12x1_target =" +string(sprintf(tar1,tar2(i,:)));
      //disp(string(sprintf(tar1,tar2(i,:))))
        mputl(vmm12_1o+vmm12_1target,fd_w);
        mputl("  ",fd_w);
        vmm12_1target=[];
        vmm12_1o=[];
        select board_num
        case 2 then
            if sftreg_count >0
                plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(i),'10 '+string(sftreg_count+i)+' 0'];
            else
                plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(i),'10 '+string(i+2s)+' 0'];
            end
        case 3 then
            if sftreg_count >0
                plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(i),'5 '+string(sftreg_count+i)+' 0'];
            else
                plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(i),'5 '+string(i)+' 0'];         
            end
        end
    end
   // mputl(".subckt nfet in[0]=net"+string(blk(blk_objs(bl),3))+'_1'+ " in[1]=gnd" + " out[0]=vw_nfetd",fd_w);
    //mputl(".subckt nmirror_vmm in[0]=vcc out=net"+string(blk(blk_objs(bl),3))+'_1 #nmirror_bias =15e-9",fd_w);
   mputl(".subckt nmirror_vmm in[0]=net"+string(blk(blk_objs(bl),3))+'_1 out=vw_nfetd #nmirror_bias =115e-9",fd_w);
    
    
    select board_num
    case 2 then

        plcloc=[plcloc;'vw_nfetd','11 2 0'];
    case 3 then
        plcloc=[plcloc;'vw_nfetd','5 2 0'];
    end
    mputl("  ",fd_w);
end
