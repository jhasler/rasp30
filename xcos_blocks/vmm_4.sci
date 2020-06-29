function [x,y,typ]=vmm_4(job,arg1,arg2)
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
            [ok,Wts,exprs]=scicos_getvalue('Set VMM Block',['Weight Matrix'],list('vec',-1),exprs)

            if ~ok then break,end

            if ok then
                model.sim=list('vmm_c',5)
                model.opar=list(Wts)
//                model.in=ipsize(1)
//                model.in2=ipsize(2)
//                model.out=ipsize(1)
//                model.out2=size(Wts,2)
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
    case 'define' then
        Wts=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
        model=scicos_model()
        model.sim=list('vmm_c',5)
        model.in=-[1:4]'
        model.intyp=-ones(4,1)
        model.out=-[1:4]'
        model.outtyp=-ones(4,1)
        model.opar=list()
        model.blocktype='d'
        model.dep_ut=[%t %f]

        exprs=[sci2exp(Wts)]
        gr_i=['txt='' VMM 4x4 '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([10 9],model, exprs,gr_i)
    end
endfunction
