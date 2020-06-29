//**************************** Ladder Filter *********yeahbuddy******
if (blk_name.entries(bl) =='ladder_filter') then
    ladder_count=ladder_count+1;
    plcvpr = %t;      
    mputl("# Ladder Filter",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        if ss==1 & scs_m.objs(bl).model.ipar(1)>1 then
            ladder_filter_str= '.subckt ladder_filter in[0]=net' + string(blk(blk_objs(bl),2)) + '_'+string(ss)+' in[1]=in'+string(ss)+'_'+string(ss)+' out[0]=net' +string(blk(blk_objs(bl),2+numofip))+'_'+string(ss)+' out[1]=out'+string(ss)+'_'+string(ss)+' out[2]=net' + string(blk(blk_objs(bl),4+numofip))+'_'+string(ss) + ' #c4_ota_bias[0] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(2*ss-1)))+"&c4_ota_bias[1] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(2*ss)))+"&ladder_filter_fg[0] =0&c4_ota_p_bias[0] =50e-9&c4_ota_n_bias[0] =50e-9&c4_ota_p_bias[1] =50e-9&c4_ota_n_bias[1] =50e-9&speech_peakotabias[0] =2e-6';
            select board_num
            case 2 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'6 '+string(ss+ladder_count)+' 0'];
            case 3 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'3 '+string(ss+ladder_count)+' 0'];   
            end

        elseif ss>1 & ss~=scs_m.objs(bl).model.ipar(1) & scs_m.objs(bl).model.ipar(1)>1
            ladder_filter_str= '.subckt ladder_filter in[0]=out'+string(ss-1)+'_'+string(ss-1)+' in[1]=in'+string(ss)+'_'+string(ss)+' out[0]=in'+string(ss-1)+'_'+string(ss-1)+' out[1]=out'+string(ss)+'_'+string(ss)+' out[2]=net' + string(blk(blk_objs(bl),4+numofip))+'_'+string(ss) + ' #c4_ota_bias[0] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(2*ss-1)))+"&c4_ota_bias[1] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(2*ss)))+"&ladder_filter_fg[0] =0&c4_ota_p_bias[0] =50e-9&c4_ota_n_bias[0] =50e-9&c4_ota_p_bias[1] =50e-9&c4_ota_n_bias[1] =50e-9&speech_peakotabias[0] =2e-6';

        elseif ss==scs_m.objs(bl).model.ipar(1) & scs_m.objs(bl).model.ipar(1)>1
            disp(length(scs_m.objs(bl).model.ipar(1)))
            ladder_filter_str= '.subckt ladder_filter in[0]=out'+string(ss-1)+'_'+string(ss-1)+' in[1]=out_fb out[0]=in'+string(ss-1)+'_'+string(ss-1)+' out[1]=out_fb out[2]=net' + string(blk(blk_objs(bl),4+numofip))+'_'+string(ss) + ' #c4_ota_bias[0] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(2*ss-1)))+"&c4_ota_bias[1] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(2*ss)))+"&ladder_filter_fg[0] =0&c4_ota_p_bias[0] =50e-9&c4_ota_n_bias[0] =50e-9&c4_ota_p_bias[1] =50e-9&c4_ota_n_bias[1] =50e-9&speech_peakotabias[0] =2e-6';

        elseif scs_m.objs(bl).model.ipar(1)==1
            ladder_filter_str= '.subckt ladder_filter in[0]=net' + string(blk(blk_objs(bl),2)) + '_'+string(ss)+' in[1]=net' + string(blk(blk_objs(bl),3)) + '_'+string(ss)+' out[0]=net' +string(blk(blk_objs(bl),2+numofip))+'_'+string(ss)+' out[1]=net' +string(blk(blk_objs(bl),3+numofip))+'_'+string(ss)+' out[2]=net' + string(blk(blk_objs(bl),4+numofip))+'_'+string(ss) + ' #c4_ota_bias[0] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(2*ss-1)))+"&c4_ota_bias[1] =" +string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.rpar(2*ss)))+"&ladder_filter_fg[0] =0&c4_ota_p_bias[0] =50e-9&c4_ota_n_bias[0] =50e-9&c4_ota_p_bias[1] =50e-9&c4_ota_n_bias[1] =50e-9&speech_peakotabias[0] =2e-6';
        end

        mputl(ladder_filter_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.ipar(1)==1
            select board_num
            case 2 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'6 '+string(ss+ladder_count)+' 0'];
            case 3 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'3 '+string(ss+ladder_count)+' 0'];   
            end
        elseif ss>1
            select board_num
            case 2 then plcloc=[plcloc;'in'+string(ss-1)+'_'+string(ss-1),'6 '+string(ss+ladder_count)+' 0'];
            case 3 then plcloc=[plcloc;'in'+string(ss-1)+'_'+string(ss-1),'3 '+string(ss+ladder_count)+' 0'];   
            end
        end
    end
end
