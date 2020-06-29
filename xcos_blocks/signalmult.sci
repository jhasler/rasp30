function [x,y,typ]=signalmult(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1); 
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; model=arg1.model; exprs=graphics.exprs;
    case 'define' then
        model=scicos_model();
        model.sim=list('signalmult_c',5);
        model.in=-ones(4,1);
        model.in2=-ones(4,1);
        model.intyp=-ones(4,1);
        model.out=-ones(2,1);
        model.out2=-ones(2,1);
        model.outtyp=-ones(2,1); 
        model.blocktype='d';
        model.dep_ut=[%t %t];

        exprs=[];
        gr_i=['txt='' MULT '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')'];
        x=standard_define([3 4],model, exprs,gr_i);
    end
endfunction
