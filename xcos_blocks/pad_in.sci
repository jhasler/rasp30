function [x,y,typ]=pad_in(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1);
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; model=arg1.model; exprs=graphics.exprs;
        while %t do
            [ok,out_num,pin_num,exprs]=scicos_getvalue('Set IO PAD',['Number of IO';'pin_num'],list('vec',1,'vec',-1),exprs)
            if ~ok then break,end
            if ok then
                model.ipar=[out_num];
                model.rpar=[pin_num];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break;
            end

        end
    case 'define' then
        out_num = 1;
        pin_num = [1];
        model=scicos_model();
        model.sim=list('pad_in_c',5);
        model.out=[-1;];
        model.out2=[-1;];
        model.outtyp=[-1;];
        model.ipar=[out_num];
        model.rpar=[pin_num];
        model.blocktype='d';
        model.dep_ut=[%t %f];

        exprs=[sci2exp(out_num);sci2exp(pin_num)];
        gr_i=['txt='' IO PAD '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')'];
        x=standard_define([5 2],model, exprs,gr_i);
    end
endfunction
