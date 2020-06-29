function [x,y,typ]=meas_volt(job,arg1,arg2)
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
        graphics=arg1.graphics;exprs=graphics.exprs
        model=arg1.model;
        while %t do
            [ok, W, S, N, exprs] = scicos_getvalue('MITE ADC (14 bits, 200 SPS)',['Variable Name';'Sample Rate (0-200 Hz)';'Number of Waveforms'],list("str",-1, 'vec', 1, 'vec', 1),exprs)
            if ~ok then break,end
            if S < 0 then
                block_parameter_error(msprintf(gettext("Wrong value for ''Sample Rate'' parameter: %s."), S), ..
                gettext("Strictly positive value expected."));
                ok = %f
            end
            if ok then
                model.in = N 
                model.rpar = [S,N]
                model.opar=list(W)
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break
            end
        end
    case 'define' then
        W="output"
        S = 1
        N = 1
        model=scicos_model()
        model.sim=list('output_func',5)
        model.in=1
        model.in2=1
        model.intyp=-1
        model.opar=list(W)
        model.rpar=[S,N]
        model.blocktype='d'
        model.dep_ut=[%t %t]

        exprs=[W; string(S); string(N)]
        gr_i=['txt='' Measure Voltage '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([4 2],model, exprs,gr_i)
    end
endfunction
