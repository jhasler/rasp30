//************************* VMM_WTA ************************************
if (blk_name.entries(bl) =='vmm12x1_wowta') then 
    global shift_number_mismatch
    addvmm = %t;
    plcvpr=%t
    k =scs_m.objs(blk_objs(bl)).model.opar(1);
    m1=scs_m.objs(blk_objs(bl)).model.ipar(2);//row (basically number of WTA)
    n1=scs_m.objs(blk_objs(bl)).model.ipar(3);//column(basically number of inputs to VMM)
   
    tar1=[];
    tar2=[];
    tar3=[];
    for j=1:12
        if j == 12 then tar1=tar1+'%1.2e';
        else tar1=tar1+'%1.2e,';
        end
    end
    j = n1;
    for i=1:m1
        tar3='k('+string(i)+',:) ';
        for n = j+1:12
            tar3=tar3+'1e-12 ';
        end
        tar2(i,:)=evstr(tar3);          
    end
    mputl("# VMM12x1",fd_w);
    vmm12_1 =".subckt vmm12x1_wowta";
    for i = 1:n1
        vmm12_1 = vmm12_1 + " in["+ string(i-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(i);
          last_input=i;
    end
    if j < 13 then
        for i = j+1:12
            //vmm12_1 = vmm12_1 + " in["+ string(i-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(last_input+1);
            vmm12_1 = vmm12_1 + " in["+ string(i-1)+"]=unconn";
        end
    end
    for i = 1:size(k,1)
  //  disp(i)
    //disp(string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(i))))
        vmm12_1o = vmm12_1 + " out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+"_" + string(i)+" #vmm12x1_wowta_fg =0&vmm12x1_offsetbias ="+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(i)));
        vmm12_1target="&vmm12x1_target =" +string(sprintf(tar1,tar2(i,:)));
        mputl(vmm12_1o+vmm12_1target,fd_w);
        mputl("  ",fd_w);
        vmm12_1target=[];
        vmm12_1o=[];
        select board_num
        case 2 then
            if sftreg_count >0
                plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(i),'10 '+string(i+1)+' 0'];
            else
                plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(i),'10 '+string(i+1)+' 0'];
               // plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(i),'10 '+string(shift_number_mismatch)+' 0'];
            end
        case 3 then
            if sftreg_count >0
                plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(i),'5 '+string(sftreg_count+i)+' 0'];
            else
                plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(i),'5 '+string(i)+' 0'];         
            end
        end
    end
    mputl("  ",fd_w);
end
