//*************************** DIV_BY_N *********************************
if (blk_name.entries(bl) =='div_by_n') then
    cd(vpr_path);
    //**********************************
    //Writing supporting list file
    //**********************************
    digifl='div_by_n'+ string(bl) +'.blif';
    digi='div_by_n'+string(bl);
    diginame='div_by_n'+string(bl);

    prime_ipnet='inputs'; 
    for s=2:(numofip+1)
        prime_ipnet=prime_ipnet+' '+string(blk(bl,s));
    end

    prime_opnet='outputs' 
    for s=(2+numofip): (1+numofip+numofop)
        prime_opnet=prime_opnet+' '+string(blk(bl,s));
    end

    fd_w2= mopen (digi+'_list.txt','wt')

    mputl(strcat(["obj"," ",fname])  ,fd_w2);
    mputl('numips '+string(length(scs_m.objs(blk(bl,1)).model.in)),fd_w2);
    mputl('numops '+string(length(scs_m.objs(blk(bl,1)).model.out)),fd_w2);
    mputl(prime_ipnet,fd_w2);
    mputl(prime_opnet,fd_w2);
    mclose(fd_w2);
    unix_w(' perl /home/ubuntu/rasp30/vtr_release/vtr_flow/scripts/run_vtr_flow.pl /home/ubuntu/rasp30/sci2blif/benchmarks/verilog/div_by_n.v /home/ubuntu/rasp30/vtr_release/vpr_rasp3/rasp3_arch.xml -ending_stage scripts -no_mem');
    unix_w('pwd ') ;
    unix_w('cp temp/div_by_n.pre-vpr.blif  ./'+digifl+' -rf'); 
    //unix_w('cp /home/ubuntu/rasp30/vtr_release/vtr_flow/temp/div2.pre-vpr.blif  /home/ubuntu/rasp30/vtr_release/vtr_flow/div2.blif -rf'); 
    unix_w('pwd ') ;
    //disp("Copied files");
    unix_w('bash genblif.sh '+diginame) ;
    unix_w('cp '+digifl+' '+path);
    cd(path)
    //unix_g('cp '+vpr_path+digifl+' . -rf');

    fext=fname+'.blif'
    unix_w('cat '+digifl+' >> '+fext);
end
