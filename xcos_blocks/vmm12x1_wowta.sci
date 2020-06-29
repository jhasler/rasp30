function [x,y,typ]=vmm12x1_wowta(job,arg1,arg2)
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
            [ok,ipsize,Wts,offsetbias,exprs]=scicos_getvalue('Set VMM12x1 Block',['Input Dimension [row,col]';'Weight Matrix';'Offset bias'],list('vec',-1,'mat',[-1,-2],'vec',-1),exprs)

            if ~ok then break,end  

            if ok then
                num_st = size(Wts,2)
                model.opar=list(Wts);
                model.rpar= [offsetbias'];
                model.ipar=[size(Wts,2);ipsize'];
                model.in=[ipsize(1)]
                model.in2=[ipsize(2)]
                model.out=size(Wts,2)
                model.out2=ipsize(1,2)
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
    case 'define' then
        ipsize=[12 1];
        Wts=[4e-06,1e-09,1e-09,1e-09,1e-09,3e-06,3e-06,1e-09,1e-09,1e-09,1e-09,1e-09]
        offsetbias = 5e-9
        num_st = size(Wts,2)
        model=scicos_model()
        model.sim=list('vmm_wta_c',5)
        model.in=[ipsize(1)]
        model.in2=[ipsize(2)]
        model.intyp=[-1]
        model.out=size(Wts,2)
        model.out2=ipsize(1,2)
        model.outtyp=-1
        model.opar=list(Wts)
        model.ipar = [size(Wts,2);ipsize'];
        model.rpar= [offsetbias'];
        model.blocktype='d'
        model.dep_ut=[%f %t]

        exprs=[sci2exp(ipsize);sci2exp(Wts);sci2exp(offsetbias)]
        gr_i=['txt='' VMM12x1 '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([11 3],model, exprs,gr_i) //6 2
    end
endfunction
