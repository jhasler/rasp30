function [x,y,typ]=GENARB_f(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then
        standard_draw(arg1)
    case 'getinputs' then
        x=[];y=[];typ=[];
    case 'getoutputs' then
        [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then
        [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;
        graphics=arg1.graphics;exprs=graphics.exprs
        model=arg1.model;
        while %t do
            [ok, W, S, L, exprs] = scicos_getvalue([msprintf(gettext("Set %s block parameters"), "GENARB_f");" "; ..
            gettext("Arbitrary waveform generator");" "], ..
            [gettext("Waveform Variable Name"); gettext("Sample Rate (Hz)"); gettext("Loopback? (Y/N)")], ..
            list("str",-1,"vec",1,"str",1), exprs);
            if ~ok then break,end
            if S < 0 then
                block_parameter_error(msprintf(gettext("Wrong value for ''Sample Rate'' parameter: %s."), S), ..
                gettext("Strictly positive value expected."));
                ok = %f
            end
            if ok then
                mat_sz = size(evstr(W))
                model.out = mat_sz(1,1)
                model.rpar=[S]
                model.opar=list(W,L)
                graphics.exprs=exprs;
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        S=5
        W="myVariable"
        L="Y"
        model=scicos_model()
        model.sim=list('genarb_func',5)
        model.out=1
        model.out2=1
        model.outtyp=-1
        model.rpar=[S]
        model.opar=list(W,L)
        model.blocktype='d'
        model.dep_ut=[%t %t]

        exprs=[W;string(S);L]
        gr_i=['txt=[''arbitrary waveform'';''generator''];';
        'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([6 2],model,exprs,gr_i)
    end
endfunction
