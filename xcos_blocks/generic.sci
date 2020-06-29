function [x,y,typ]=generic(job,arg1,arg2)
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
            [ok,name, blkips, blkops, simfl, blkst, parname, parval, isvctd, xobfl,exprs]=scicos_getvalue('Design a Block',['Name';'Number of Inputs'; 'Number of Outputs'; 'Simulation File Path';'State Variable(s) initial value(s)';'Parameter List Name';'Parameter List Value'; 'Vectorized: [1:N, N:1, N:N, N:M]'; 'Xcos or Blif File Path'],list('str',-1,'vec',1,'vec',1,'str',-1,'vec',-1,'str',-1,'vec', -1, 'str', -1,'str', -1),exprs)

            if ~ok then break,end

            if ok then
                model.opar=list(name,simfl,parname,isvctd,xobfl) 
                model.rpar= [blkips,blkops,parval]
                model.state=blkst
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
    case 'define' then
        name='Generic Name'
        blkips=1
        blkops=1 
        simfl='/home/ubuntu/....' 
        blkst=0
        parname=['Capacitance (F)';' Ibias (A)']
        parval=[10e-15 ,50e-9] 
        isvctd='If Not Vectorized->Leave blank' 
        xobfl='/home/ubuntu/....' 
        model=scicos_model()
        model.sim=list('blank_c',5)
        model.opar=list(name,simfl,parname,isvctd,xobfl) 
        model.rpar= [blkips,blkops,parval]
        model.state=blkst
        model.blocktype='d'
        model.dep_ut=[%f %f]

        exprs=[name; sci2exp(blkips); sci2exp(blkops); simfl; sci2exp(blkst); sci2exp(parname); sci2exp(parval); isvctd; xobfl] 
        gr_i=['txt='' Blank '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([4 2],model, exprs,gr_i) 
    end
endfunction
