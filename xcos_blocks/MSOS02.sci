function [x,y,typ]=MSOS02(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1)
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;graphics=arg1.graphics;model=arg1.model;exprs=graphics.exprs;
        while %t do
            [ok,num_of_blk,mblif_num,MSOS02_Ibias2,MSOS02_Wbp,MSOS02_Wbn,MSOS02_Ibias1,MSOS02_Wap,MSOS02_Wan,MSOS02_Feedback,MSOS02_Buffer,fix_loc,exprs]=scicos_getvalue('New Block Parameter',['num_of_blk';'mblif_num';'MSOS02_Ibias2';'MSOS02_Wbp';'MSOS02_Wbn';'MSOS02_Ibias1';'MSOS02_Wap';'MSOS02_Wan';'MSOS02_Feedback';'MSOS02_Buffer';'fix_loc'],list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar=[num_of_blk,mblif_num];
                model.rpar=[MSOS02_Ibias2,MSOS02_Wbp,MSOS02_Wbn,MSOS02_Ibias1,MSOS02_Wap,MSOS02_Wan,MSOS02_Feedback,MSOS02_Buffer,fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
        MSOS02_Ibias2=2e-7;
        MSOS02_Wbp=1e-6;
        MSOS02_Wbn=1e-6;
        MSOS02_Ibias1=2e-7;
        MSOS02_Wap=1e-6;
        MSOS02_Wan=1e-6;
        MSOS02_Feedback=4e-9;
        MSOS02_Buffer=3e-6;
        fix_loc=[0;0;0];
        model=scicos_model();
        model.sim=list('MSOS02_c',5);
        model.in=[-1];
        model.in2=[-1];
        model.intyp=[-1];
        model.out=[-1];
        model.out2=[-1];
        model.outtyp=[-1];
        model.ipar=[num_of_blk,mblif_num];
        model.rpar=[MSOS02_Ibias2,MSOS02_Wbp,MSOS02_Wbn,MSOS02_Ibias1,MSOS02_Wap,MSOS02_Wan,MSOS02_Feedback,MSOS02_Buffer,fix_loc'];
        model.blocktype='d';
        model.dep_ut=[%f %t]; //[block input has direct feedthrough to output w/o ODE   block always active]
        
        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(MSOS02_Ibias2);sci2exp(MSOS02_Wbp);sci2exp(MSOS02_Wbn);sci2exp(MSOS02_Ibias1);sci2exp(MSOS02_Wap);sci2exp(MSOS02_Wan);sci2exp(MSOS02_Feedback);sci2exp(MSOS02_Buffer);sci2exp(fix_loc)];
        gr_i=['text=[''MSOS02''];';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([5 3],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
