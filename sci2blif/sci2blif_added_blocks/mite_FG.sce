//****************************** MITE***********************************
if (blk_name.entries(bl) =='mite_FG') then
     plcvpr=%t
 global mite_count
     mite_count=mite_count+1;
     
    for ss=1:scs_m.objs(bl).model.opar(1)
        mputl("# MITE1",fd_w);
        if scs_m.objs(bl).model.rpar(1) == 2
        mputl(".subckt mite in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(1)+" in[1]=net"+string(blk(blk_objs(bl),3))+"_"+string(ss)+" in[2]=net"+string(blk(blk_objs(bl),4))+"_"+string(ss)+" out=net"+ string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" #mite_cmirror =0&mite_fg0 ="+string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.opar(2*ss))),fd_w);
        else
        mputl(".subckt mite in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(1)+" in[1]=net"+string(blk(blk_objs(bl),3))+"_"+string(1)+" in[2]=net"+string(blk(blk_objs(bl),4))+"_"+string(1)+" out=net"+ string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" #mite_fg0 ="+string(sprintf('%1.3e',scs_m.objs(blk_objs(bl)).model.opar(2)(ss))),fd_w);
        end
        //string(sprintf('%e',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(22+4-1)+ss)))
        mputl("  ",fd_w);
        
        if scs_m.objs(bl).model.rpar(1) == 1 then
         select board_num
        case 2 then
                plcloc=[plcloc;'net'+ string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
        case 3 then
                plcloc=[plcloc;'net'+ string(blk(blk_objs(bl),2+numofip))+"_"+string(ss),string(scs_m.objs(bl).model.rpar(2))+' '+string(scs_m.objs(bl).model.rpar(3))+' 0'];
         end
         end
end
end
