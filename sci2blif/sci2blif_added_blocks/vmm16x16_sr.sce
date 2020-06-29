//******************* VMM 16x16 with Shift Register ********************
if (blk_name.entries(bl) =='vmm16x16_sr') then
    addvmm = %t;
    mputl("# VMM 16x16 with shift register",fd_w);
    temp_weight=evstr(scs_m.objs(bl).model.opar(1));
    size_weight=size(temp_weight); 
    if size_weight(1) ~= 16 | size_weight(2) ~= 16 then 
        disp("Size of vmm 16x16 weights matrix is not correct.");
    end

    // (1,1) of vmm16x16
    vmm16x16_sr_str= ".subckt vmm8inx8in" 
    vmm16x16_sr_str=vmm16x16_sr_str+" in[0]=net"+string(blk(blk_objs(bl),5))+"_dummy11";
    for ss=1:8
        vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),5))+"_"+string(ss);
    end
    for ss=9:16
        vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(ss-8);
    end
    vmm16x16_sr_str=vmm16x16_sr_str+" out[0]=net"+string(blk(blk_objs(bl),5))+"_dummy11"+" #vmm8inx8in_fg =0&vmm8inx8in_target =";
    for i=1:8
        for j=1:8
            vmm16x16_sr_str=vmm16x16_sr_str+string(sprintf('%1.2e',temp_weight(i,j)));
            if i == 8 & j == 8 then vmm16x16_sr_str=vmm16x16_sr_str;
            else vmm16x16_sr_str=vmm16x16_sr_str+",";
            end
        end
    end
    mputl(vmm16x16_sr_str,fd_w);
    mputl("  ",fd_w);

    // (1,2) of vmm16x16
    vmm16x16_sr_str= ".subckt vmm8inx8in" 
    vmm16x16_sr_str=vmm16x16_sr_str+" in[0]=net"+string(blk(blk_objs(bl),5))+"_dummy12";
    for ss=1:8
        vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),5))+"_"+string(ss+8);
    end
    for ss=9:16
        vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(ss-8);
    end
    vmm16x16_sr_str=vmm16x16_sr_str+" out[0]=net"+string(blk(blk_objs(bl),5))+"_dummy12"+" #vmm8inx8in_fg =0&vmm8inx8in_target =";
    for i=1:8
        for j=9:16
            vmm16x16_sr_str=vmm16x16_sr_str+string(sprintf('%1.2e',temp_weight(i,j)));
            if i == 8 & j == 16 then vmm16x16_sr_str=vmm16x16_sr_str;
            else vmm16x16_sr_str=vmm16x16_sr_str+",";
            end
        end
    end
    mputl(vmm16x16_sr_str,fd_w);
    mputl("  ",fd_w);

    // (2,1) of vmm16x16
    vmm16x16_sr_str= ".subckt vmm8inx8in" 
    vmm16x16_sr_str=vmm16x16_sr_str+" in[0]=net"+string(blk(blk_objs(bl),5))+"_dummy21";
    for ss=1:8
        vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),5))+"_"+string(ss);
    end
    for ss=9:16
        vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(ss);
    end
    vmm16x16_sr_str=vmm16x16_sr_str+" out[0]=net"+string(blk(blk_objs(bl),5))+"_dummy21"+" #vmm8inx8in_fg =0&vmm8inx8in_target =";
    for i=9:16
        for j=1:8
            vmm16x16_sr_str=vmm16x16_sr_str+string(sprintf('%1.2e',temp_weight(i,j)));
            if i == 16 & j == 8 then vmm16x16_sr_str=vmm16x16_sr_str;
            else vmm16x16_sr_str=vmm16x16_sr_str+",";
            end
        end
    end
    mputl(vmm16x16_sr_str,fd_w);
    mputl("  ",fd_w);

    // (2,2) of vmm16x16
    vmm16x16_sr_str= ".subckt vmm8inx8in" 
    vmm16x16_sr_str=vmm16x16_sr_str+" in[0]=net"+string(blk(blk_objs(bl),5))+"_dummy22";
    for ss=1:8
        vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),5))+"_"+string(ss+8);
    end
    for ss=9:16
        vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(ss);
    end
    vmm16x16_sr_str=vmm16x16_sr_str+" out[0]=net"+string(blk(blk_objs(bl),5))+"_dummy22"+" #vmm8inx8in_fg =0&vmm8inx8in_target =";
    for i=9:16
        for j=9:16
            vmm16x16_sr_str=vmm16x16_sr_str+string(sprintf('%1.2e',temp_weight(i,j)));
            if i == 16 & j == 16 then vmm16x16_sr_str=vmm16x16_sr_str;
            else vmm16x16_sr_str=vmm16x16_sr_str+",";
            end
        end
    end
    mputl(vmm16x16_sr_str,fd_w);
    mputl("  ",fd_w);

    //vmm16x16_sr_str= ".subckt sftreg3 in[0]=net"+string(blk(blk_objs(bl),2))+"_1"+" in[1]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[2]=net"+string(blk(blk_objs(bl),4))+"_1"+" in[3]=net"+string(blk(blk_objs(bl),5+numofip))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),5+numofip))+"_1"+" out[1]=net"+string(blk(blk_objs(bl),2+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),4+numofip))+"_1";
    vmm16x16_sr_str= ".subckt sftreg3 in[0]=net"+string(blk(blk_objs(bl),2))+"_1"+" in[1]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[2]=net"+string(blk(blk_objs(bl),4))+"_1"+" in[3]=net"+string(blk(blk_objs(bl),5+numofip))+"_1"+" out[0]=net_floated_"+string(internal_number)+" out[1]=net"+string(blk(blk_objs(bl),2+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),4+numofip))+"_1";
    internal_number=internal_number+1;
    for ss=1:16
        vmm16x16_sr_str=vmm16x16_sr_str+" out["+string(ss+3)+"]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(ss);
    end
    vmm16x16_sr_str=vmm16x16_sr_str+" #sftreg3_fg =0";
    mputl(vmm16x16_sr_str,fd_w);
    mputl("  ",fd_w);
    if scs_m.objs(bl).model.rpar(1) == 1 then
        plcvpr = %t;
        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),5+numofip))+"_1",string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),5))+"_dummy11",string(scs_m.objs(bl).model.rpar(4))+' '+string(scs_m.objs(bl).model.rpar(5))+' 0'];
        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),5))+"_dummy12",string(scs_m.objs(bl).model.rpar(6))+' '+string(scs_m.objs(bl).model.rpar(7))+' 0'];
        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),5))+"_dummy21",string(scs_m.objs(bl).model.rpar(8))+' '+string(scs_m.objs(bl).model.rpar(9))+' 0'];
        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),5))+"_dummy22",string(scs_m.objs(bl).model.rpar(10))+' '+string(scs_m.objs(bl).model.rpar(11))+' 0'];
    end
end



//if (blk_name.entries(bl) =='vmm16x16_sr') then
//    addvmm = %t;
//    mputl("# VMM 16x16 with shift register",fd_w);
//    a=1;b=1;c=1;
//    for j=1:4
//        vmm16x16_sr_str= ".subckt vmm8x4_in"
//        //for ss=1:scs_m.objs(bl).model.ipar(1)
//        for ss=1:8
//            vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss-1)+"]=net"+string(blk(blk_objs(bl),5))+"_"+string(ss);
//        end
//        for ss=1:4
//            vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss+7)+"]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(a);
//            a=a+1;
//        end
//        vmm16x16_sr_str=vmm16x16_sr_str+" in[12]=net"+string(blk(blk_objs(bl),5))+"_"+string(c)+"_fbout"+" out[0]=net"+string(blk(blk_objs(bl),5))+"_"+string(c)+"_fbout"+" #vmm8x4_in_target =";
//        for i=1:32
//            vmm16x16_sr_str=vmm16x16_sr_str+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(c,i)));
//            if i ~= 32 then vmm16x16_sr_str=vmm16x16_sr_str+","; end
//        end
//        mputl(vmm16x16_sr_str,fd_w);
//        mputl("  ",fd_w);
//        c=c+1;
//        vmm16x16_sr_str= ".subckt vmm8x4_in"
//        //for ss=1:scs_m.objs(bl).model.ipar(1)
//        for ss=9:16
//            vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss-9)+"]=net"+string(blk(blk_objs(bl),5))+"_"+string(ss);
//        end
//        for ss=1:4
//            vmm16x16_sr_str=vmm16x16_sr_str+" in["+string(ss+7)+"]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(b);
//            b=b+1;
//        end
//        vmm16x16_sr_str=vmm16x16_sr_str+" in[12]=net"+string(blk(blk_objs(bl),5))+"_"+string(c)+"_fbout"+" out[0]=net"+string(blk(blk_objs(bl),5))+"_"+string(c)+"_fbout"+" #vmm8x4_in_target =";
//        for i=1:32
//            vmm16x16_sr_str=vmm16x16_sr_str+string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(c,i)));
//            if i ~= 32 then vmm16x16_sr_str=vmm16x16_sr_str+","; end
//        end
//        mputl(vmm16x16_sr_str,fd_w);
//        mputl("  ",fd_w);
//        c=c+1;
//    end
//    vmm16x16_sr_str= ".subckt sftreg2 in[0]=net"+string(blk(blk_objs(bl),2))+"_1"+" in[1]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[2]=net"+string(blk(blk_objs(bl),4))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),5+numofip))+"_1"+" out[1]=net"+string(blk(blk_objs(bl),2+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),4+numofip))+"_1";
//    for ss=1:16
//        vmm16x16_sr_str=vmm16x16_sr_str+" out["+string(ss+3)+"]=net"+string(blk(blk_objs(bl),5))+"_internal_"+string(ss);
//    end
//    vmm16x16_sr_str=vmm16x16_sr_str+" #sftreg2_fg =0";
//    mputl(vmm16x16_sr_str,fd_w);
//    mputl("  ",fd_w);
//    if scs_m.objs(bl).model.ipar(3) == 1 then
//        plcvpr = %t;
//        plcloc=[plcloc;'net'+string(blk(blk_objs(bl),5+numofip))+"_1",string(scs_m.objs(bl).model.ipar(4))+' '+string(scs_m.objs(bl).model.ipar(5))+' 0'];
//    end
//end


