//**************************** Measure Volt (mite_adc) ****************************
if (blk_name.entries(bl) =='meas_volt') then

global MITE_ADC_check;
if MITE_ADC_check==0
MITE_ADC_check=1;
else
MITE_ADC_check=MITE_ADC_check+1;
end

    cap_info = cap_info2(cap_info,pass_num,'out_mite_adc', bl)
    mputl("# MITE_ADC",fd_w);
    for meas = 1:scs_m.objs(bl).model.rpar(2)
       
        mputl(".subckt meas_volt_mite in[0]=net"+string(blk(blk_objs(bl),2))+'_'+ string(meas)+' out[0]=out_mite_adc_"+string(MITE_ADC_check)+" #meas_fg =0.00001',fd_w);
        
        mputl("  ",fd_w);
       select board_num
        case 2 then plcloc=[plcloc;'out_mite_adc_"+string(MITE_ADC_check),'14 '+string(MITE_ADC_check)+' 0'] ;
        case 3 then plcloc=[plcloc;'out_mite_adc_"+string(MITE_ADC_check),'7 '+string(MITE_ADC_check)+' 0'] ;
        //disp(plcloc)
        end
    end
    plcvpr = %t;
    fd_io= mopen (fname+'.pads','a+')
    select board_num
    case 2 then mputl("out:out_mite_adc_"+string(MITE_ADC_check)+" "+string(MITE_ADC_check+7-1)+" 0 0 #tgate[0]",fd_io);
    case 3 then mputl("out:out_mite_adc_"+string(MITE_ADC_check)+" "+string(MITE_ADC_check+8-1)+" 1 0 #int[0]",fd_io);
    end
    mclose(fd_io);
end
