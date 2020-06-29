//**************************** HH Neuron  ******************************
if (blk_name.entries(bl) =='hhneuron') then 
    mputl("# HH Neuron",fd_w);
    for ss = 1:scs_m.objs(bl).model.ipar(1)
        mputl(".subckt hhneuron in[0]=net"+string(blk(blk_objs(bl),2))+ "_" + string(ss)+" in[1]=net"+string(blk(blk_objs(bl),3))+ "_" + string(ss)+" in[2]=net"+string(blk(blk_objs(bl),4))+ "_" + string(ss)+" in[3]=net"+string(blk(blk_objs(bl),5))+ "_" + string(ss)+" out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+ "_" + string(ss)+" out[1]=net"+ string(blk(blk_objs(bl),3+numofip))+ "_" + string(ss)+" out[2]=net"+ string(blk(blk_objs(bl),4+numofip))+ "_" + string(ss)+ " #hhneuron_fg[0] =0&hh_leak =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9*ss-8)))+"&hh_vinbias =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9*ss-7)))+"&hh_nabias =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9*ss-6)))+"&hh_kbias =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9*ss-5)))+"&hh_fbpfetbias =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9*ss-4)))+"&hh_ota_p_bias[0] =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9*ss-3)))+"&hh_ota_n_bias[0] =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9*ss-2)))+"&hh_ota_p_bias[1] =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9*ss-1)))+"&hh_ota_n_bias[1] =" +string(sprintf('%1.2e',scs_m.objs(blk_objs(bl)).model.rpar(9*ss))),fd_w);
        mputl("  ",fd_w)
    end
end
