function [x,y,typ]=output_f(job,arg1,arg2)
    // Copyright INRIA
    x=[];y=[];typ=[];
    select job
    case 'plot' then
        standard_draw(arg1)
    case 'getinputs' then
        [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then
        [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then
        [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;
        graphics=arg1.graphics;exprs=graphics.exprs
        model=arg1.model;
        while %t do
            [ok,in_out_num,exprs]=getvalue('Set floated ouput Parameters',['Number of floated output blocks'],list('vec',1),exprs)

            if ~ok then break,end

            if ok then
                model.in=-1
                model.ipar=in_out_num
                graphics.exprs=exprs;
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        in_out_num =1
        model=scicos_model()
        model.in=-1
        model.in2=1
        model.intyp=-1
        model.ipar=in_out_num
        model.blocktype='d'
        model.dep_ut=[%f %t]

        exprs=[sci2exp(in_out_num)]
        gr_i=['txt=''Floated ouput '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([3 2],model,exprs,gr_i)
    end
endfunction
