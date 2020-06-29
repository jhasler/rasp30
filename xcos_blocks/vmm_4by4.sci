function [x,y,typ]=vmm_4by4(job,arg1,arg2)
    // Copyright INRIA
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1);
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; model=arg1.model; exprs=graphics.exprs;
        while %t do
            [ok,weight_vec,fix_loc,exprs]=scicos_getvalue('Set VMM 4x4 parameters',['Weight vector name';'Fix_location'],list('str',1,'vec',-1),exprs)

            if ~ok then break,end

            if ok then
                model.in=[1];
                model.out=[1];
                model.rpar= [fix_loc'];
                model.opar=list(weight_vec);
                graphics.exprs=exprs; x.graphics=graphics; x.model=model;
                break;
            end

        end
    case 'define' then
        fix_loc=[0;0;0];
        weight_vec="weight4x4";
        model=scicos_model()
        model.in=[1];
        model.in2=[1];
        model.intyp=[-1];
        model.out=[1];
        model.out2=[1];
        model.outtyp=[-1];
        model.rpar= [fix_loc'];
        model.opar=list(weight_vec);
        model.blocktype='d'
        model.dep_ut=[%f %t]
 
        exprs=[weight_vec;sci2exp(fix_loc)];
        gr_i=['txt='' VMM 4x4'';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')'];
        x=standard_define([7 2],model, exprs,gr_i);
    end
endfunction
