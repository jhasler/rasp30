function [x,y,typ]=fgota(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1);
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;
        while %t do
//            [ok,num_of_blk,mblif_num,ibias,p_ibias,n_ibias,smcap,fix_loc,exprs]=getvalue('Set FG OTA Parameters',['No. of FG OTAs';'Macro-blif Number';'Ibias';'P Ibias'; 'N Ibias';'Use small cap Yes-1 No-0';'Fix_location'],list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs);
            [ok,num_of_blk,mblif_num,ibias,Vfg_p,Vfg_n,smcap,fix_loc,exprs]=getvalue('Set FG OTA Parameters',['No. of FG OTAs';'Macro-blif Number';'Ibias';'Vfg_p'; 'Vfg_n';'Use small cap Yes-1 No-0';'Fix_location'],list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar=[num_of_blk,mblif_num];
//                model.rpar=[ibias,p_ibias,n_ibias,smcap,fix_loc'];
                model.rpar=[ibias,Vfg_p,Vfg_n,smcap,fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
        ibias=10e-9;
//        p_ibias=10e-9;
//        n_ibias=10e-9;
        Vfg_p=1.9;
        Vfg_n=1.9;
        smcap=1;
        fix_loc=[0;0;0];
        model=scicos_model();
        model.sim=list('ota_func',5);
        model.in=[-1;-1];
        model.in2=[-1;-1];
        model.intyp=[-1;-1];
        model.out=[-1;];
        model.out2=[-1;];
        model.outtyp=[-1;];
        model.ipar=[num_of_blk,mblif_num];
//        model.rpar=[ibias,p_ibias,n_ibias,smcap,fix_loc'];
        model.rpar=[ibias,Vfg_p,Vfg_n,smcap,fix_loc'];
        model.blocktype='c';
        model.dep_ut=[%t %f];

//        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(ibias);sci2exp(p_ibias);sci2exp(n_ibias);sci2exp(smcap);sci2exp(fix_loc)];
        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(ibias);sci2exp(Vfg_p);sci2exp(Vfg_n);sci2exp(smcap);sci2exp(fix_loc)];
        gr_i=['text=[''FG''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');'];
        x=standard_define([5 2],model,exprs,gr_i);
    end
endfunction
