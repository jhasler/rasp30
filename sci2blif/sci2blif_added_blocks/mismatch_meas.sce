//****************************** Mismatch measure block **********************************
if (blk_name.entries(bl) =='mismatch_meas') then
    addvmm = %t;
    mputl("#MISMATCH_MEAS "+string(bl),fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl(".subckt mismatch_meas in[0]=net"+string(blk(blk_objs(bl),2))+'_'+ string(ss)+ " in[1]=net" + string(blk(blk_objs(bl),3)) +'_'+ string(ss)+ " in[2]=net" + string(blk(blk_objs(bl),4)) +'_'+ string(ss)+" out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+'_'+ string(ss)+" #mismatch_meas_fg =0&mismatch_meas_pfetg_fgotabias =2e-06&mismatch_meas_pfetg_fgotapbias =3e-06&mismatch_meas_pfetg_fgotanbias =6.92e-08&mismatch_meas_out_fgotabias =2e-06&mismatch_meas_out_fgotapbias =4.12e-07&mismatch_meas_out_fgotanbias =4.43e-08&mismatch_meas_cal_bias =50e-09",fd_w);
        mputl("  ",fd_w);
    end
end
