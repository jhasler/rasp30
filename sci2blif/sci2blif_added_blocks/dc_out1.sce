//***************************** DC OUT *********************************
if(blk_name.entries(bl)=='dc_out1')  then
    dac_loc_idx = dac_loc_idx +1;
    // DEDICATED PADS code
    fd_io= mopen(fname+'.pads','a+')
    mputl('out:net'+ string(blk(blk_objs(bl),2+numofip)) + ' ' + dac_loc(loc_num,dac_loc_idx).entries(1),fd_io);
    mclose(fd_io);
end
