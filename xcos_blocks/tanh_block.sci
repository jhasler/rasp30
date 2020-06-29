function [x,y,typ]=tanh_block(job,arg1,arg2)
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
            [ok,in,out,xx,rpar,exprs]=getvalue('Set TANH NEW block parameters',..
            ['Number of input ports or vector of sizes';..
            'no of o/ps';'State';'Tau'],..
            list('vec',-1,'vec',-1,'vec',-1,'vec',1),exprs)
            if ~ok then break,end

            if in<1|in>31 then
                message('Block must have at least one input port and at most 31')
                ok=%f
            else
                it=-ones(in,1)
                ot=-ones(out,1)
                inp=[-[1:in]',ones(in,1)]
                oup=[-[1:out]',ones(out,1)]
                model.rpar = rpar
                model.state = xx
                [model,graphics,ok]=set_io(model,graphics,...
                list(inp,it),...
                list(oup,ot),[],[])
            end
            if ok then
                graphics.exprs=exprs;
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        in=1
        out=1
        state= 0
        tau = 60e-6
        model=scicos_model()
        model.sim=list('tanh_func',5)
        model.in=-[1:in]'
        model.intyp=-ones(in,1)
        model.out=-[1:out]'
        model.outtyp=-ones(out,1)
        model.rpar = tau
        model.state= state
        model.nzcross=1;
        model.blocktype='c'
        model.dep_ut=[%t %t]

        exprs=[sci2exp(in) ; sci2exp(out); sci2exp(state) ; sci2exp(tau)]
        gr_i=['txt=''TANH '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([5 2],model,exprs,gr_i)
    end
endfunction
