function [x,y,typ]=ota(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1);
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;
        while %t do
            [ok,num_of_blk,mblif_num,ibias,fix_loc,exprs]=getvalue('Set OTA block parameters', ['No. of OTAs';'Macro-blif Number';'Ibias';'Fix_location'],list('vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar=[num_of_blk,mblif_num];
                model.rpar=[ibias,fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break;
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
        ibias=1e-6;
        fix_loc=[0;0;0];
        model=scicos_model();
        model.sim=list('ota_c',5);
        model.in=[-1;-1];
        model.in2=[-1;-1];
        model.intyp=[-1;-1];
        model.out=[-1;];
        model.out2=[-1;];
        model.outtyp=[-1;];
        model.ipar=[num_of_blk,mblif_num];
        model.rpar=[ibias,fix_loc'];
        model.blocktype='c';
        model.dep_ut=[%t %f];

        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(ibias);sci2exp(fix_loc)];
        gr_i=['text=[''OTA''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');'];
        x=standard_define([5 2],model,exprs,gr_i);
    end
endfunction
