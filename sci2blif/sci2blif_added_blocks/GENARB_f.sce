//****************************** Arb Gen *******************************
if (blk_name.entries(bl) =='GENARB_f') then
    Signal_DAC_check=1;
    arb_gen.entries=[]
    ga_idx2=size(evstr(scs_m.objs(bl).model.opar(1)), "r")
    fd_io= mopen (fname+'.pads','a+');  // DEDICATED PADS code
    for ii = 1:ga_idx2
        dac_loc_idx = dac_loc_idx +1;
        arb_gen(1,1).entries(1,ii)= strtod(dac_loc(loc_num,dac_loc_idx).entries(2))
        mputl('net'+ string(blk(blk_objs(bl),2+numofip)) + "_"+ string(ii) +' ' + dac_loc(loc_num,dac_loc_idx).entries(1),fd_io);
    end
    mclose(fd_io);
    genarb_dac = arb_gen(1,1).entries(1,:);
    exec("~/rasp30/prog_assembly/libs/scilab_code/genarb_compile.sce",-1);
    genarb_compile(scs_m.objs(bl).model.opar(1),scs_m.objs(bl).model.rpar(1),genarb_dac,0); // regen = 0
end
