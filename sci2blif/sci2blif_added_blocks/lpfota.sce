//**************************** LPF OTA *********************************
if(blk_name.entries(bl)=='lpfota')  then
global lpf_ota_count
if lpf_ota_count==0
lpf_ota_count=1
else
lpf_ota_count=lpf_ota_count+1;
end
    jj = 1:scs_m.objs(bl).model.ipar(1)
    freq=scs_m.objs(bl).model.rpar(jj)//tau is not this
    Ut = 26e-3;
    kap = 0.7;
    if pass_num == 1 then
        Ccap = 10e-12
    else
        //c_net ='net'+string(blk(blk_objs(bl),2+numofip))
        //Ccap = cap_info(c_net)(1:scs_m.objs(blk_objs(bl)).model.ipar(1),2)
        //Ccap = cap_add(Ccap,cap_info(c_net)(2,1),1) 
         Ccap = 10e-12
    end
   // Ibias= (2*Ccap*Ut)./(kap*tau);
    
    Gm=2*3.14*freq*Ccap;
    disp(Gm)
    
    Ibias= Gm*2*Ut./kap;//Sahil added to correct the frequency which was way off..The expression done before are incorrect
    disp(Ibias)
    b_elements = elements_add(b_elements,scs_m.objs(bl).model.ipar(1),1, 0, 0, 0, 0, 0, 0,0)
    mputl("# LPF",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        b_elements.b_ibias=b_elements.b_ibias+Ibias(ss)
        ota_str= '.subckt ota in[0]=net' + string(blk(blk_objs(bl),2))+"_" + string(ss)+' in[1]=net'+ string(blk(blk_objs(bl),2+numofip))+"_" + string(ss)+' out[0]=net'+ string(blk(blk_objs(bl),2+numofip))+"_" + string(ss)+" #ota_bias =" +string(sprintf('%1.12f',Ibias(ss)));
        mputl(ota_str,fd_w);
        mputl("  ",fd_w);
                select board_num
        case 2 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'3 '+string(lpf_ota_count)+' 0'];
        case 3 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'1 '+string(lpf_ota_count)+' 0'];   
        end
    end
end
