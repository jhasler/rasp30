function [x,y,typ]=div2(job,arg1,arg2)
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
            [ok,vfpath,exprs]=scicos_getvalue('Set Generic Digital Block Parameters',['Verilog File Path'],list("str",-1),exprs);

            if ~ok then break,end
            
            if ok then

                graphics.exprs=exprs
                model.opar = list(vfpath)
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        vfpath = '/home/ubuntu/rasp30/sci2blif/benchmarks/verilog/div2.v'
        model=scicos_model()
        model.sim=list('div_func',5)
        model.in=-[1:2]'
        model.intyp=-ones(2,1)
        model.out=-1
        model.outtyp=-1
        model.opar = list(vfpath)
        model.blocktype='c'
        model.dep_ut=[%t %f]

        exprs=[vfpath]
        gr_i=['text=[''Clk'';'' Reset''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');']
        x=standard_define([11 10],model,exprs,gr_i)
    end
endfunction
