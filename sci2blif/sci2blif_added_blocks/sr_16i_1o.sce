//*************** Shift register 16inputs 1output **********************
if (blk_name.entries(bl) =='sr_16i_1o') then
    addvmm = %t;
    plcvpr = %t;
    mputl("# Shift register 16inputs 1output",fd_w);
    sr_1i_16o_str= ".subckt sftreg";
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_1i_16o_str=sr_1i_16o_str+" in["+string(ss-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss);
    end
//    sr_1i_16o_str=sr_1i_16o_str+" in[0]=net"+string(blk(blk_objs(bl),2))+"_1 in[1]=gnd_dig in[2]=gnd_dig in[3]=gnd_dig in[4]=gnd_dig in[5]=gnd_dig in[6]=gnd_dig in[7]=gnd_dig in[8]=gnd_dig in[9]=gnd_dig in[10]=gnd_dig in[11]=gnd_dig in[12]=gnd_dig in[13]=gnd_dig in[14]=gnd_dig in[15]=gnd_dig" // temporary for sr leakage test
    for ss=scs_m.objs(bl).model.ipar(1):16-1
        sr_1i_16o_str=sr_1i_16o_str+" in["+string(ss)+"]=net"+string(blk(blk_objs(bl),4))+"_1";
    end
    sr_1i_16o_str=sr_1i_16o_str+" in[16]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[17]=net"+string(blk(blk_objs(bl),4))+"_1"+" in[18]=net"+string(blk(blk_objs(bl),5))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_1 #sftreg_fg =0";//out[1]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),4+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),5+numofip))+"_1 ;
    mputl(sr_1i_16o_str,fd_w)
    mputl("  ",fd_w)
    if scs_m.objs(bl).model.rpar(1) == 1 then
        plcvpr = %t;
        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
    end
end





//if (blk_name.entries(bl) =='sr_16i_1o') then
//sftreg_count=sftreg_count+1;//Sahil added.Cant figure out the best way to handle multiple shift registers which are not vectorized for plcloc
//    addvmm = %t;
//    plcvpr = %t;
//    mputl("# Shift register 16inputs 1output",fd_w);
//    sr_1i_16o_str= ".subckt sftreg";
//    if chip_num=='13' then
//        for ss=1:scs_m.objs(bl).model.ipar(1)
//            sr_1i_16o_str=sr_1i_16o_str+" in["+string(ss-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss);
//        end
//        sr_1i_16o_str=sr_1i_16o_str+" in[16]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[17]=net"+string(blk(blk_objs(bl),4))+"_1"+" in[18]=net"+string(blk(blk_objs(bl),5))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_1 #sftreg_fg =0";
//        mputl(sr_1i_16o_str,fd_w);
//        mputl("  ",fd_w);
//        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",'11 2 0'];
//    else
//        for ss=1:scs_m.objs(bl).model.ipar(1)
//            sr_1i_16o_str=sr_1i_16o_str+" in["+string(ss-1)+"]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss);
//        end
//            for ss=scs_m.objs(bl).model.ipar(1)+1:16
//            sr_1i_16o_str=sr_1i_16o_str+" in["+string(ss-1)+"]=net"+string(blk(blk_objs(bl),4))+"_1";
//        end
//        
//        sr_1i_16o_str=sr_1i_16o_str+" in[16]=net"+string(blk(blk_objs(bl),3))+"_1"+" in[17]=net"+string(blk(blk_objs(bl),4))+"_1"+" in[18]=net"+string(blk(blk_objs(bl),5))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_1 #sftreg_fg =0";
////out[1]=net"+string(blk(blk_objs(bl),3+numofip))+"_1"+" out[2]=net"+string(blk(blk_objs(bl),4+numofip))+"_1"+" out[3]=net"+string(blk(blk_objs(bl),5+numofip))+"_1"+" 
//        select board_num
//        case 2 then 
//        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",'11 '+string(sftreg_count+1)+' 0'];
//        case 3 then 
//        plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",'5 '+string(sftreg_count+4)+' 0'];  
//        end
//        mputl(sr_1i_16o_str,fd_w)
//        mputl("  ",fd_w)
//    end
//    sftreg_check=1; //global sftreg_check
//end

