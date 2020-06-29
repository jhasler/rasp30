//****************************** ADC (ip block) **********************************
if(blk_name.entries(bl)=='adc_ip')  then
    ONchip_ADC=1;
    adc_loc_idx = adc_loc_idx +1;
    ss=scs_m.objs(bl).model.rpar(1);
    Onchip_ADC_num(1,ss)=1;
    mputl("# ota_buf",fd_w);
    mputl(".subckt ota_buf in[0]=net"+ string(blk(blk_objs(bl),2))+"_"+string(1)+" out[0]=out_adc_"+string(adc_ip_net(adc_ip_idx2))+" #ota_buf_ls =0&ota_buf_bias =2e-6",fd_w);
    mputl("  ",fd_w);
    fd_io= mopen (fname+'.pads','a+');  // DEDICATED PADS code
    select board_num    
        case 2 then   mputl("out:out_adc_"+string(adc_ip_net(adc_ip_idx2))+" "+ adc_locin(1,adc_ip_net(adc_ip_idx2)).entries,fd_io);
        case 3 then   mputl("out:out_adc_"+string(adc_ip_net(adc_ip_idx2))+" " + adc_locin(2,adc_ip_net(adc_ip_idx2)).entries,fd_io);
    end
    adc_ip_idx2 = adc_ip_idx2 +1;
    mclose(fd_io);
end

