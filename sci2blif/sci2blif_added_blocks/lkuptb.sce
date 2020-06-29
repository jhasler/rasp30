//**************************** LOOKUP Table ********************************
if(blk_name.entries(bl)=='lkuptb')  then
    disp(scs_m.objs(blk_objs(bl)).model.rpar(1))
    mputl("# LOOKUP Table-> "+scs_m.objs(blk_objs(bl)).model.opar(1),fd_w);
    truecase_ss=strsplit(scs_m.objs(blk_objs(bl)).model.opar(2),";");
    for ss=1:scs_m.objs(bl).model.ipar(2)
        truecase=strsplit(truecase_ss(ss)," ");
        if scs_m.objs(bl).model.ipar(1) == 1 then
            lkuptb_str='.names'+' net' + string(blk(blk_objs(bl),2))+"_" + string(ss)+' tg4logic_1 tg4logic_2 tg4logic_3'+' net'+ string(blk(blk_objs(bl),2+numofip))+"_" + string(ss);
        end
        if scs_m.objs(bl).model.ipar(1) == 2 then
            lkuptb_str='.names'+' net' + string(blk(blk_objs(bl),2))+"_" + string(ss)+' net'+ string(blk(blk_objs(bl),3))+"_" + string(ss)+' tg4logic_1 tg4logic_2'+' net'+ string(blk(blk_objs(bl),2+numofip))+"_" + string(ss);
        end
        if scs_m.objs(bl).model.ipar(1) == 3 then
            lkuptb_str='.names'+' net' + string(blk(blk_objs(bl),2))+"_" + string(ss)+' net'+ string(blk(blk_objs(bl),3))+"_" + string(ss)+' net' + string(blk(blk_objs(bl),4))+"_" + string(ss)+' tg4logic_1'+' net'+ string(blk(blk_objs(bl),2+numofip))+"_" + string(ss);
        end
        if scs_m.objs(bl).model.ipar(1) == 4 then
            lkuptb_str='.names'+' net' + string(blk(blk_objs(bl),2))+"_" + string(1)+' net'+ string(blk(blk_objs(bl),3))+"_" + string(1)+' net' + string(blk(blk_objs(bl),4))+"_" + string(1)+' net'+ string(blk(blk_objs(bl),5))+"_" + string(1)+' net'+ string(blk(blk_objs(bl),2+numofip))+"_" + string(ss);
        end
        mputl(lkuptb_str,fd_w);
        for i=1:size(truecase,1)
            mputl(truecase(i)+' 1',fd_w);
        end
        mputl("  ",fd_w)
        if scs_m.objs(bl).model.rpar(1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+"_" + string(ss),string(scs_m.objs(bl).model.rpar(2*ss))+' '+string(scs_m.objs(bl).model.rpar(2*ss+1))+' 0'];
        end
    end
end
