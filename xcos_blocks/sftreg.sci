function [x,y,typ]=sftreg(job,arg1,arg2)
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
            [ok,nob,exprs]=scicos_getvalue(['Set Shift Register Block'],['Number of Bits'],list('vec',-1),exprs)

            if ~ok then break,end

            if ok then
                model.in=size([-[1:nob]';-1],1)
                model.out=size([-[1:nob]';-1],1)
                inp=[[-[1:nob]';-1],ones(nob+1,1)]
                oup=[[-[1:nob]';-1],ones(nob+1,1)]
                it=-ones(nob+1,1)
                ot=-ones(nob+1,1)
                [model,graphics,ok]=set_io(model,graphics,list(inp,it),list(oup,ot),ones(2,1),ones(2,1))
                graphics.exprs=exprs ;
                x.graphics=graphics ;
                x.model=model ;
                break
            end

        end
    case 'define' then
        nob=8
        model=scicos_model()
        model.sim=list('sftreg_c',5)
        model.in=[-[1:nob]';-1]
        model.out=[-[1:nob]';-1]
        model.evtin=-[1:2]'
        model.evtout=-[1:2]'
        model.blocktype='c'
        model.dep_ut=[%t %f]

        exprs=[sci2exp(nob)]
        gr_i=['txt='' Shift Register '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([10 10],model, exprs,gr_i)
    end
endfunction
