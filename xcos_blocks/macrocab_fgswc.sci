function [x,y,typ]=macrocab_fgswc(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1); 
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;
        while %t do
            [ok,sel_or_unsel,ibias_name,ibias_default,fg_address,exprs]=scicos_getvalue('FG switch',['Connection:C, Target program:T, Unsel:-';'bias name';'bias default value (A)';'FG address (Do not change)'],list('str',-1,'str',-1,'str',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar= [fg_address'];
                model.rpar= [sel_or_unsel,ibias_name,ibias_default];
                graphics.exprs=exprs; x.graphics=graphics; x.model=model;
                break;
            end
        end
    case 'define' then
        sel_or_unsel="-";
        ibias_name="fgswc_ibias";
        ibias_default="50e-9";
        fg_address=[0;0];
        model=scicos_model(); model.sim=list('fgswitch_c',5);
        model.in=[]; model.in2=[]; model.intyp=[];
        model.out=[]; model.out2=[]; model.outtyp=[];
        model.ipar= [fg_address'];
        model.rpar= [sel_or_unsel,ibias_name,ibias_default];
        model.state=zeros(1,1); model.blocktype='d'; model.dep_ut=[%t %f]; 

        exprs=[sel_or_unsel;ibias_name;ibias_default;sci2exp(fg_address)]; 
        gr_i= ['text=[''Src'';'' Gate''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');'];
        x=standard_define([2 2],model,exprs,gr_i);
    end
endfunction
