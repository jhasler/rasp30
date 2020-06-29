//************************** Generic Digital ***************************
if (blk_name.entries(bl) =='generic_dig') then
    cd(vpr_path);
    //*********** Writing supporting list file ***************
    blname = fileparts(scs_m.objs(bl).model.opar(1),'fname');
    blkin = length(scs_m.objs(blk(bl,1)).model.in);
    blkout = length(scs_m.objs(blk(bl,1)).model.out);
    prime_ipnet='inputs'; 
    for s=2:(1+blkin)
        prime_ipnet=prime_ipnet+' '+string(blk(bl,s))+'_1';
    end

    prime_opnet='outputs' 
    for s=(2+numofip): (1+numofip+blkout)
        prime_opnet=prime_opnet+' '+string(blk(bl,s))+'_1';
    end

    fd_w2= mopen (blname+'_list.txt','wt')

    mputl(strcat(["obj"," ",fname])  ,fd_w2);
    mputl('numips '+string(blkin),fd_w2);
    mputl('numops '+string(blkout),fd_w2);
    mputl(prime_ipnet,fd_w2);
    mputl(prime_opnet,fd_w2);
    mclose(fd_w2);
    unix_w('perl /home/ubuntu/rasp30/vtr_release/vtr_flow/scripts/run_vtr_flow.pl '+ scs_m.objs(bl).model.opar(1) +' /home/ubuntu/rasp30/vpr2swcs/arch/rasp3_arch.xml -ending_stage scripts -no_mem'); // /home/ubuntu/rasp30/vtr_release/vpr/ARCH/arch.xml
    unix_w('pwd ') ;
    unix_w('cp temp/'+blname+'.pre-vpr.blif  ./'+blname+ '.blif -rf'); 
    unix_g('pwd ') ;
    unix_w('bash /home/ubuntu/rasp30/vtr_release/vtr_flow/genblif.sh '+ blname) ;
    unix_g('cp '+ blname +'.blif '+path)
    cd(path)
    
    

    fext=fname+'.blif'
    unix_g('cat '+blname +'.blif >> '+fext);
    //end;//elseif div2
end
