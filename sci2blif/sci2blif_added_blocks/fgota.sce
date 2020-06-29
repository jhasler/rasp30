//**************************** FG OTA *********************************
if(blk_name.entries(bl)=='fgota')  then
    //global board_num chip_num;
    exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2i.sce',-1); 
    select board_num 
    case 2 then brdtype1 = '';
    case 3 then brdtype1 = '_30a';
    case 4 then brdtype1 = '_30n';
    case 5 then brdtype1 = '_30h';
    else messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort;
    end
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# fgota "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
//        fgota_str= '.subckt fgota in[0]=net' + string(blk(blk_objs(bl),2)) +"_" +string(ss)+' in[1]=net'+string(blk(blk_objs(bl),3))+"_" +string(ss)+' out[0]=net'+ string(blk(blk_objs(bl),2+numofip))+ "_" +string(ss)+" #fgota_bias =" +string(sprintf('%e',scs_m.objs(blk_objs(bl)).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+"&fgota_p_bias ="+string(sprintf('%e',scs_m.objs(blk_objs(bl)).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))+"&fgota_n_bias ="+string(sprintf('%e',scs_m.objs(blk_objs(bl)).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss)));
        fgota_str= '.subckt fgota in[0]=net' + string(blk(blk_objs(bl),2)) +"_" +string(ss)+' in[1]=net'+string(blk(blk_objs(bl),3))+"_" +string(ss)+' out[0]=net'+ string(blk(blk_objs(bl),2+numofip))+ "_" +string(ss)+" #fgota_bias =" +string(sprintf('%e',scs_m.objs(blk_objs(bl)).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+"&fgota_p_bias ="+string(sprintf('%e',diodeADC_v2i(scs_m.objs(blk_objs(bl)).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss),chip_num,brdtype1)))+"&fgota_n_bias ="+string(sprintf('%e',diodeADC_v2i(scs_m.objs(blk_objs(bl)).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+ss),chip_num,brdtype1)));
        if scs_m.objs(blk_objs(bl)).model.rpar(scs_m.objs(bl).model.ipar(1)*(4-1)+ss) == 1 then
            fgota_str= fgota_str +"&fgota_small_cap =0";
        end
        mputl(fgota_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(5-1)+1+2*ss))+' 0'];
        end
    end
end

//exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2i.sce',-1);
//select board_num 
//case 2 then brdtype1 = '';
//case 3 then brdtype1 = '_30a';
//case 4 then brdtype1 = '_30n';
//case 5 then brdtype1 = '_30h';
//else messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort;
//end
//a=diodeADC_v2i(0.5,chip_num,brdtype1);
