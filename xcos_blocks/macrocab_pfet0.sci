function [x,y,typ]=macrocab_pfet0(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1); 
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'define' then
        model=scicos_model(); model.sim=list('pfet_c',5);
        model.in=[1;1]; model.in2=[1;1]; model.intyp=[-1;-1];
        model.out=-1; model.out2=1; model.outtyp=-1;
        model.state=zeros(1,1); model.blocktype='d'; model.dep_ut=[%t %f]; 

        exprs=[]; //exprs=[sel_or_unsel]; //exprs=[sci2exp(sel_or_unsel)];
        gr_i= ['text=[''Src'';'' Gate''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');'];
        x=standard_define([4 2],model,exprs,gr_i);
    end
endfunction
