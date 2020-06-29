function [x,y,typ]=generic_dig(job,arg1,arg2)
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
            [ok,vfpath,in,out,exprs]=scicos_getvalue('Set Generic Digital Block Parameters',['Verilog File Path';"Number of Inputs";"Number of Outputs"],list("str",-1,"vec",-1,"vec",-1),exprs);

            if ~ok then break,end
            
            if ok then
                model.in=-[1:in]'
                model.intyp=-ones(in,1)
                model.out=-[1:out]'
                model.outtyp=-ones(out,1)
                model.opar = list(vfpath)
                graphics.exprs=exprs
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        in=2
        out=1
        vfpath = '/home/ubuntu/'
        model=scicos_model()
        model.sim=list('generic_dig_c',5)
        model.in=-[1:in]'
        model.intyp=-ones(in,1)
        model.out=-[1:out]'
        model.outtyp=-ones(out,1)
        model.opar = list(vfpath)
        model.blocktype='c'
        model.dep_ut=[%t %f]

        exprs=[vfpath;string(in);string(out)]
        gr_i=['text=[''Clk'';'' Reset''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');']
        x=standard_define([6 2],model,exprs,gr_i)
    end
endfunction
