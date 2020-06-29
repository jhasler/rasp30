function [x,y,typ]=vmm_sr(job,arg1,arg2)
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
            [ok,ipsize,Wts,exprs]=scicos_getvalue('Set VMM + SR Block',['Input Dimension [row,col]';'Weight Matrix'],list('vec',-1,'mat',[-1,-2]),exprs)

            if ~ok then break,end

            if ipsize(1) ~= size(Wts,1) then
                message('The row dimension of the input vector and the row dimension of the Weights matrix are not equal.');
                ok=%f;
            end
            if ok then
                model.opar=list(Wts);
                model.ipar=[size(Wts,2);ipsize'];
                model.in=[ipsize(1);-1;-1;-1]
                model.in2=[ipsize(2);1;1;1]
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
    case 'define' then
        ipsize=[4 1];
        Wts=[170E-09,40E-09,35E-09,35E-09;90E-09,90E-09,80E-09,80E-09;100E-09,85E-09,75E-09,85E-09;90E-09,100E-09,95E-09,70E-09]
        //lin_rng = 1;
//        tau_1 = 30*10^(-6);
//        tau_a = 1*10^(-3);
//        tau_z = 1*10^(-6);
//        tau_b = 30*10^(-6);
        model=scicos_model()
        model.sim=list('vmm_sr_c',5)
        model.in=[ipsize(1);-1;-1;-1]
        model.in2=[ipsize(2);1;1;1]
        model.intyp=[-1;-1; -1; -1]
        model.out=[-1;-1;-1;-1]
        model.out2=[1; 1; 1; 1]
        model.outtyp=[-1;-1;-1;-1]
        model.opar=list(Wts)
        //model.state=[zeros(num_st,1);0.5*ones(num_st,1);1;0.5*ones(num_st,1)]
        //model.rpar= [tau_1;tau_a;tau_z;tau_b;lin_rng;bufbias;pfetbias'];
        //model.ipar = [size(Wts,2);ipsize'];
        model.blocktype='d'
        model.dep_ut=[%f %t]

        exprs=[sci2exp(ipsize);sci2exp(Wts)]
        gr_i=['txt='' VMM + WTA '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([10 9],model, exprs,gr_i) //6 2
    end
endfunction
