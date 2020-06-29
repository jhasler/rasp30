//****************************** GPIO In Fix location *******************************
if (blk_name.entries(bl) =='gpio_in_fixloc') then
    GPIO_IN_check=1;
    gpin.entries=[]
    gi_idx2=size(evstr(scs_m.objs(bl).model.opar(1)), "r");
    fd_io= mopen (fname+'.pads','a+');  // DEDICATED PADS code
    for ii = 1:gi_idx2
        if scs_m.objs(bl).model.rpar(2) == 1 then
            gpin(1,1).entries(1,ii)= strtod(gpin_loc(loc_num,scs_m.objs(bl).model.rpar(3+ii-1)).entries(2));
            mputl('net'+ string(blk(blk_objs(bl),2+numofip)) + "_"+ string(ii) +' ' + gpin_loc(loc_num,scs_m.objs(bl).model.rpar(3+ii-1)).entries(1),fd_io);
        else
            gpin_loc_idx = gpin_loc_idx +1;
            gpin(1,1).entries(1,ii)= strtod(gpin_loc(loc_num,gpin_loc_idx).entries(2));
            mputl('net'+ string(blk(blk_objs(bl),2+numofip)) + "_"+ string(ii) +' ' + gpin_loc(loc_num,gpin_loc_idx).entries(1),fd_io);
        end
    end
    mclose(fd_io);
    genarb_gpin = gpin(1,1).entries(1,:);
    exec("~/rasp30/prog_assembly/libs/scilab_code/genarb_gpin_compile.sce",-1);
    genarb_gpin_compile(scs_m.objs(bl).model.opar(1),scs_m.objs(bl).model.rpar(1),genarb_gpin,0); // regen = 0
end
