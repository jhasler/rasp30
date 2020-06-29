//************************ IO PAD IN Digital ***************************
if(blk_name.entries(bl)=='pad_ind')  then
    fd_io= mopen (fname+'.pads','a+');  // DEDICATED PADS code
    for ss=1:scs_m.objs(bl).model.ipar(1)
        tmp_pad = strsplit(iopad_loc(loc_num,scs_m.objs(blk_objs(bl)).model.rpar(1+ss)).entries," ")
        if tmp_pad(3) == '3' then tmp_pad(3) = '1'; end
    mputl('net'+ string(blk(blk_objs(bl),2+numofip)) + "_" + string(ss) + ' ' + iopad_loc(loc_num,scs_m.objs(blk_objs(bl)).model.rpar(1+ss)).entries + 'dig_buff_in[' + tmp_pad(3)+ ']',fd_io);        end
    mclose(fd_io);
end
