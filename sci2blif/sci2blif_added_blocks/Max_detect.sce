//**************************** Max_detect **********************************
if (blk_name.entries(bl) == "Max_detect") then
    mputl("#Max_detect",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        Max_detect_str= '.subckt Max_detect'+' in[0]=net'+string(blk(blk_objs(bl),2))+'_'+string(ss)+' out[0]=net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss)+' #Max_detect_ls =0'+'&Max_detect_fgswc_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(1-1)+ss)))+'&Max_detect_ota0_ibias ='+string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+ss)))
        mputl(Max_detect_str,fd_w);
    mputl("",fd_w);
    plcvpr=%t
   // select board_num
     //     case 2 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'6 '+string(ss)+' 0'];
      //  case 3 then plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss),'1 '+string(ss)+' 0'];   
        //end
         disp(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+1))
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+1) == 1 then
            plcvpr = %t;
           
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(3-1)+1+2*ss))+' 0'];
        end
        
        
    end
end
