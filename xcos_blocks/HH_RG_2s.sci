function [x,y,typ]=HH_RG_2s(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1)
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;graphics=arg1.graphics;model=arg1.model;exprs=graphics.exprs;
        while %t do
            [ok,num_of_blk,mblif_num,HH_RG_2s_Nafb_ibias,HH_RG_2s_syn0_ibias,HH_RG_2s_syn1_ibias,HH_RG_2s_pfet_ibias,HH_RG_2s_nmr_ibias,HH_RG_2s_Na_ibias,HH_RG_2s_Na_pbias,HH_RG_2s_Na_nbias,HH_RG_2s_K_ibias,HH_RG_2s_K_pbias,HH_RG_2s_K_nbias,HH_RG_2s_buf_ibias,HH_RG_2s_comp_ibias,HH_RG_2s_cap0,fix_loc,exprs]=scicos_getvalue('New Block Parameter',['num_of_blk';'mblif_num';'HH_RG_2s_Nafb_ibias';'HH_RG_2s_syn0_ibias';'HH_RG_2s_syn1_ibias';'HH_RG_2s_pfet_ibias';'HH_RG_2s_nmr_ibias';'HH_RG_2s_Na_ibias';'HH_RG_2s_Na_pbias';'HH_RG_2s_Na_nbias';'HH_RG_2s_K_ibias';'HH_RG_2s_K_pbias';'HH_RG_2s_K_nbias';'HH_RG_2s_buf_ibias';'HH_RG_2s_comp_ibias';'HH_RG_2s_cap0';'fix_loc'],list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar=[num_of_blk,mblif_num];
                model.rpar=[HH_RG_2s_Nafb_ibias,HH_RG_2s_syn0_ibias,HH_RG_2s_syn1_ibias,HH_RG_2s_pfet_ibias,HH_RG_2s_nmr_ibias,HH_RG_2s_Na_ibias,HH_RG_2s_Na_pbias,HH_RG_2s_Na_nbias,HH_RG_2s_K_ibias,HH_RG_2s_K_pbias,HH_RG_2s_K_nbias,HH_RG_2s_buf_ibias,HH_RG_2s_comp_ibias,HH_RG_2s_cap0,fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
        HH_RG_2s_Nafb_ibias=50e-9;
        HH_RG_2s_syn0_ibias=50e-9;
        HH_RG_2s_syn1_ibias=50e-9;
        HH_RG_2s_pfet_ibias=50e-9;
        HH_RG_2s_nmr_ibias=50e-9;
        HH_RG_2s_Na_ibias=2e-6;
        HH_RG_2s_Na_pbias=2e-6;
        HH_RG_2s_Na_nbias=2e-6;
        HH_RG_2s_K_ibias=2e-6;
        HH_RG_2s_K_pbias=2e-6;
        HH_RG_2s_K_nbias=2e-6;
        HH_RG_2s_buf_ibias=2e-6;
        HH_RG_2s_comp_ibias=2e-6;
        HH_RG_2s_cap0=1;
        fix_loc=[0;0;0];
        model=scicos_model();
        model.sim=list('HH_RG_2s_c',5);
        model.in=[-1;-1;-1;-1;-1;-1];
        model.in2=[-1;-1;-1;-1;-1;-1];
        model.intyp=[-1;-1;-1;-1;-1;-1];
        model.out=[-1;-1];
        model.out2=[-1;-1];
        model.outtyp=[-1;-1];
        model.ipar=[num_of_blk,mblif_num];
        model.rpar=[HH_RG_2s_Nafb_ibias,HH_RG_2s_syn0_ibias,HH_RG_2s_syn1_ibias,HH_RG_2s_pfet_ibias,HH_RG_2s_nmr_ibias,HH_RG_2s_Na_ibias,HH_RG_2s_Na_pbias,HH_RG_2s_Na_nbias,HH_RG_2s_K_ibias,HH_RG_2s_K_pbias,HH_RG_2s_K_nbias,HH_RG_2s_buf_ibias,HH_RG_2s_comp_ibias,HH_RG_2s_cap0,fix_loc'];
        model.blocktype='d';
        model.dep_ut=[%f %t]; //[block input has direct feedthrough to output w/o ODE   block always active]
        
        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(HH_RG_2s_Nafb_ibias);sci2exp(HH_RG_2s_syn0_ibias);sci2exp(HH_RG_2s_syn1_ibias);sci2exp(HH_RG_2s_pfet_ibias);sci2exp(HH_RG_2s_nmr_ibias);sci2exp(HH_RG_2s_Na_ibias);sci2exp(HH_RG_2s_Na_pbias);sci2exp(HH_RG_2s_Na_nbias);sci2exp(HH_RG_2s_K_ibias);sci2exp(HH_RG_2s_K_pbias);sci2exp(HH_RG_2s_K_nbias);sci2exp(HH_RG_2s_buf_ibias);sci2exp(HH_RG_2s_comp_ibias);sci2exp(HH_RG_2s_cap0);sci2exp(fix_loc)];
        gr_i=['text=[''HH_RG_2s''];';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([5 3],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
