//**************************** IO PAD OUT ******************************
if(blk_name.entries(bl)=='pad_out')  then
    fd_io= mopen (fname+'.pads','a+');  // DEDICATED PADS code
    for ss=1:scs_m.objs(bl).model.ipar(1)
        tmp_pad = strsplit(iopad_loc(loc_num,scs_m.objs(blk_objs(bl)).model.rpar(ss)).entries," ")
        if tmp_pad(3) == '3'  | tmp_pad(3)== '5' then tmp_pad(3) = '1';
        elseif tmp_pad(3) == '2' then tmp_pad(3) = '0';
        end
        if tmp_pad(4)=='#int[5]'|tmp_pad(4)=='#int[4]'|tmp_pad(4)=='#int[3]'|tmp_pad(4)=='#int[2]'|tmp_pad(4)=='#int[1]'|tmp_pad(4)=='#int[0]' then
            mputl('out:net'+ string(blk(blk_objs(bl),2)) + "_" + string(ss) + ' ' + iopad_loc(loc_num,scs_m.objs(blk_objs(bl)).model.rpar(ss)).entries,fd_io);
        else 
            mputl('out:net'+ string(blk(blk_objs(bl),2)) + "_" + string(ss) + ' ' + iopad_loc(loc_num,scs_m.objs(blk_objs(bl)).model.rpar(ss)).entries + 'tgate[' + tmp_pad(3)+ ']',fd_io);
        end
      if scs_m.objs(blk_objs(bl)).model.rpar(ss)==56 then
      Counter_class=1;
      end
       //  disp(iopad_loc(loc_num,scs_m.objs(blk_objs(bl)).model.rpar(1+ss)).entries)
       //  disp(scs_m.objs(blk_objs(bl)).model.rpar(1+ss))
    end
       
    mclose(fd_io);
end
