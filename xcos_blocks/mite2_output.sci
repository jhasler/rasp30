function [x,y,typ]=mite2_output(job,arg1,arg2)
    // Copyright INRIA
    x=[];y=[];typ=[];
    select job
    case 'plot' then
        standard_draw(arg1)
    case 'getinputs' then //** GET INPUTS 
        [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then
        [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then
        [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;
        graphics=arg1.graphics
        model=arg1.model
        exprs=graphics.exprs
        while %t do
            [ok,value, exprs]=scicos_getvalue('Set MITE2 Block',['Value'],list('vec',-1),exprs)
            
            if ~ok then break,end

            if ok then
                model.rpar= [value]
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
    case 'define' then

        value = 21
        model=scicos_model()
        model.sim=list('mite2_output_c',5)
        model.in=-ones(2,1)
        model.in2=-ones(2,1)
        model.intyp=-ones(2,1)
        model.out=-ones(2,1)
        model.out2=-ones(2,1)
        model.outtyp=-ones(2,1)
        model.rpar= value
        model.blocktype='d'
        model.dep_ut=[%t %t]

        exprs=[sci2exp(value)]
        gr_i=['txt='' MITE2_OUTPUT '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([6 2],model, exprs,gr_i)
    end
endfunction
