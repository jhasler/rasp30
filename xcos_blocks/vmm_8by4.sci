function [x,y,typ]=vmm_8by4(job,arg1,arg2)
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
            [ok,ipsize,Wts,exprs]=scicos_getvalue('Set VMM Block',['Input Dimension [row,col]';'Weight Matrix'],list('vec',-1,'mat',[-1,-2]),exprs)

            if ~ok then break,end

       

            if ok then
                num_st = size(Wts,2)
                model.opar=list(Wts);
                model.ipar=[size(Wts,2);ipsize'];
                model.in=[ipsize(1);ipsize(2)]
                model.in2=[1;1]
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
    case 'define' then
        ipsize=[8 4];
        Wts=[1.00e-08,2.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,5.00e-08,3.00e-08,4.00e-08]
        num_st = size(Wts,2)
        model=scicos_model()
        model.sim=list('vmm_wta_c',5)
        model.in=[ipsize(1);ipsize(2)]
        model.in2=[1;1]
        model.intyp=[-1;-1]
        model.opar=list(Wts)
        model.ipar = [size(Wts,2);ipsize'];
        model.blocktype='d'
        model.dep_ut=[%f %t]
 
        exprs=[sci2exp(ipsize);sci2exp(Wts)]
        gr_i=['txt='' VMM '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([5 2],model, exprs,gr_i) //6 2
    end
endfunction
