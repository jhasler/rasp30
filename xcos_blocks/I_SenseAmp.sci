function [x,y,typ]=I_SenseAmp(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1)
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;graphics=arg1.graphics;model=arg1.model;exprs=graphics.exprs;
        while %t do
            [ok,num_of_blk,mblif_num,I_SenseAmp_fgota0_ibias,I_SenseAmp_fgota0_pbias,I_SenseAmp_fgota0_nbias,I_SenseAmp_ota0_ibias,I_SenseAmp_cap0,I_SenseAmp_cap1,fix_loc,exprs]=scicos_getvalue('New Block Parameter',['num_of_blk';'mblif_num';'I_SenseAmp_fgota0_ibias';'I_SenseAmp_fgota0_pbias';'I_SenseAmp_fgota0_nbias';'I_SenseAmp_ota0_ibias';'I_SenseAmp_cap0';'I_SenseAmp_cap1';'fix_loc'],list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar=[num_of_blk,mblif_num];
                model.rpar=[I_SenseAmp_fgota0_ibias,I_SenseAmp_fgota0_pbias,I_SenseAmp_fgota0_nbias,I_SenseAmp_ota0_ibias,I_SenseAmp_cap0,I_SenseAmp_cap1,fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
        I_SenseAmp_fgota0_ibias=2e-6;
        I_SenseAmp_fgota0_pbias=2e-6;
        I_SenseAmp_fgota0_nbias=2e-6;
        I_SenseAmp_ota0_ibias=2e-6;
        I_SenseAmp_cap0=1;
        I_SenseAmp_cap1=1;
        fix_loc=[0;0;0];
        model=scicos_model();
        model.sim=list('I_SenseAmp_c',5);
        model.in=[-1;-1];
        model.in2=[-1;-1];
        model.intyp=[-1;-1];
        model.out=[-1];
        model.out2=[-1];
        model.outtyp=[-1];
        model.ipar=[num_of_blk,mblif_num];
        model.rpar=[I_SenseAmp_fgota0_ibias,I_SenseAmp_fgota0_pbias,I_SenseAmp_fgota0_nbias,I_SenseAmp_ota0_ibias,I_SenseAmp_cap0,I_SenseAmp_cap1,fix_loc'];
        model.blocktype='d';
        model.dep_ut=[%f %t]; //[block input has direct feedthrough to output w/o ODE   block always active]
        
        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(I_SenseAmp_fgota0_ibias);sci2exp(I_SenseAmp_fgota0_pbias);sci2exp(I_SenseAmp_fgota0_nbias);sci2exp(I_SenseAmp_ota0_ibias);sci2exp(I_SenseAmp_cap0);sci2exp(I_SenseAmp_cap1);sci2exp(fix_loc)];
        gr_i=['text=[''I_SenseAmp''];';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([5 3],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
