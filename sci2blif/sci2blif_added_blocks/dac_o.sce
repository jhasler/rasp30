//***************************** DC OUT **********************************
if(blk_name.entries(bl)=='dac_o')  then
    Signal_DAC_check=1;
    dc.entries=[]
    // DEDICATED PADS code
    fd_io= mopen(fname+'.pads','a+')
    for ss=1:scs_m.objs(bl).model.ipar(1)
        dac_loc_idx = dac_loc_idx +1;
        dc(1,1).entries(1,ss)= strtod(dac_loc(loc_num,dac_loc_idx).entries(2))
        mputl('out:net'+ string(blk(blk_objs(bl),2)) + "_"+ string(ss)+' ' + dac_loc(loc_num,dac_loc_idx).entries(1),fd_io);
    end
    mclose(fd_io);
    dc_dac = dc(1,1).entries(1,:)
    exec("~/rasp30/prog_assembly/libs/scilab_code/dc_compile.sce",-1);
    dc_compile(scs_m.objs(bl).model.opar(1),scs_m.objs(bl).model.rpar(1)',dc_dac);
end
