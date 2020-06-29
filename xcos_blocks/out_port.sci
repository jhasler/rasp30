function [x,y,typ]=out_port(job,arg1,arg2)
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
        while %t do //add the number of data pts to take
            [ok,port_num,exprs]=scicos_getvalue('Set Output Port Parameters',['Output Port Number'],list('vec',1),exprs)

            if ~ok then break,end

            if ok then
                model.rpar= port_num
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
    case 'define' then
        port_num = 1
        model=scicos_model()
        model.sim=list('out_port_c',5)
        model.in= 1
        model.in2= 1
        model.intyp=-1
        model.rpar= port_num
        model.blocktype='d'
        model.dep_ut=[%f %t]

        exprs=[sci2exp(port_num)]
        gr_i=['txt='' Output Port '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([3 3],model, exprs,gr_i)
    end
endfunction
