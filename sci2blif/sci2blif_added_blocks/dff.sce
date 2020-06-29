//**************************** D flip Flop ********************************
if(blk_name.entries(bl)=='dff')  then
    mputl("# D Flip Flop ",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        // dff_str='.names'+' net' + string(blk(blk_objs(bl),2))+"_"+string(ss)+' tg4logic_1 tg4logic_2 tg4logic_3'+' internal_'+ string(internal_number)+"_"+string(ss);
        //mputl(dff_str,fd_w);
        //mputl('1--- 1',fd_w);
        //mputl("  ",fd_w);
        dff_str='.subckt latch_custom'+' D[0]=net' + string(blk(blk_objs(bl),2))+"_"+string(ss)+' clk[0]=net'+string(blk(blk_objs(bl),3))+"_" +string(1)+' reset[0]=net'+string(blk(blk_objs(bl),4))+"_" +string(1)+' Q[0]=net'+string(blk(blk_objs(bl),2+numofip))+"_" +string(ss);
        mputl(dff_str,fd_w);
        mputl("  ",fd_w);
       // internal_number=internal_number+1;
    end
    if scs_m.objs(bl).model.rpar(1) == 1 then
        plcvpr = %t;
        //            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_1',' '+string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
        plcloc=[plcloc;'internal_'+ string(internal_number-1)+'_1',string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
    end
end
