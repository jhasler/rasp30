//**************************** C4 **************************************
if (blk_name.entries(bl) =='c4_sp') then
    plcvpr=%t
    j=scs_m.objs(blk_objs(bl)).model.ipar(1)
    freq_c=scs_m.objs(blk_objs(bl)).model.rpar'
//    tau1=1 ./(2*%pi *freq_c(1:j))//high
//    tau2=1 ./(2*%pi*freq_c(3*j+1:3*j+j))//low 
//    c2 = 35e-15 * ones(scs_m.objs(blk_objs(bl)).model.ipar(1),1)
//    c1 = 448e-15 * scs_m.objs(blk_objs(bl)).model.rpar(j*7)
//    cw = 420e-15  * ones(scs_m.objs(blk_objs(bl)).model.ipar(1),1)
//    kap = 0.54
//    Ut = 25e-3
//
//    if pass_num == 1 then
//       // cL = 600e-15 * ones(scs_m.objs(blk_objs(bl)).model.ipar(1),1)
//        cL = 600e-15 * ones(scs_m.objs(blk_objs(bl)).model.ipar(1),1)
//    else
//        ///c_net ='net'+string(blk(blk_objs(bl),2+numofip))
//      // cL = cap_info(c_net)(1:scs_m.objs(blk_objs(bl)).model.ipar(1),2)
//     //   cL = cap_add(cL,cap_info(c_net)(2,1),2) 
//      cL = 600e-15 * ones(scs_m.objs(blk_objs(bl)).model.ipar(1),1)
//    end

//    Ibias1=(((c1+c2+cw).*(cL+c2)-c2^2)* 2*Ut)./(kap*tau1.*c2)
//    Ibias2=(2*c2*Ut)./(kap*tau2)
//
Ibias1=freq_c(1:j)
Ibias2=freq_c(3*j+1:3*j+j)

    b_elements = elements_add(b_elements,scs_m.objs(bl).model.ipar(1),0, 2, 0, 0, 1, 0, 0,0)

    mputl("# C4",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        b_elements.b_ibias=b_elements.b_ibias+Ibias1(ss)+Ibias2(ss)+scs_m.objs(blk_objs(bl)).model.rpar(7*ss-4)+scs_m.objs(blk_objs(bl)).model.rpar(7*ss-5)+scs_m.objs(blk_objs(bl)).model.rpar(7*ss-1)+scs_m.objs(blk_objs(bl)).model.rpar(7*ss-2)+10e-6;
        c4sp_str= '.subckt c4_sp in[0]=net' + string(blk(blk_objs(bl),2))+"_1 in[1]=net"+string(blk(blk_objs(bl),3))+"_1 out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+"_" + string(ss)+" #c4_sp_ota_bias[0] =" +string(sprintf('%1.3e',Ibias1(ss)))+"&c4_sp_ota_bias[1] =" +string(sprintf('%1.3e',Ibias2(ss)));
        c4sp_str= c4sp_str +"&c4_sp_fg[0] =0&c4_sp_ota_small_cap[0] =0&c4_sp_ota_small_cap[1] =0&c4_sp_ota_p_bias[0] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(7*ss-4)))+"&c4_sp_ota_n_bias[0] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(7*ss-5)))+"&c4_sp_ota_p_bias[1] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(7*ss-1)))+"&c4_sp_ota_n_bias[1] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(7*ss-2)));
        capcap = scs_m.objs(blk_objs(bl)).model.rpar(ss*7);
        select capcap
        case 1 then c4sp_str= c4sp_str +"&c4_sp_cap_1x[0] =0";
        case 2 then c4sp_str= c4sp_str +"&c4_sp_cap_2x[0] =0";
        case 3 then c4sp_str= c4sp_str +"&c4_sp_cap_3x[0] =0";
        case 4 then c4sp_str= c4sp_str +"&c4_sp_cap_3x[0] =0"+"&c4_sp_cap_1x[0] =0";
        case 5 then c4sp_str= c4sp_str +"&c4_sp_cap_3x[0] =0"+"&c4_sp_cap_2x[0] =0";
        case 6 then c4sp_str= c4sp_str +"&c4_sp_cap_3x[0] =0"+"&c4_sp_cap_2x[0] =0"+"&c4_sp_cap_1x[0] =0";
        else error("Capacitor cannot be compiled.");
        end
        mputl(c4sp_str,fd_w);
        mputl("  ",fd_w);
        select board_num
        case 2 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'7 '+string(ss)+' 0'];
        case 3 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'1 '+string(ss)+' 0'];   
        end
    end
end
