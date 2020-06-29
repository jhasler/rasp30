function [x,y,typ]=macrocab_fgota0(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1); 
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;
        while %t do
            [ok,sel_or_unsel,ibias_name,ibias_default,pbias_name,pbias_default,nbias_name,nbias_default,smallcap_bigcap,fg_address,exprs]=scicos_getvalue('OTA0',['Sel:Sel, Unsel:-';'bias name';'bias default value (A)';'(+) bias name';'(+) bias default value (A)';'(-) bias name';'(-) bias default value (A)';'Input Cap - Small:0, Big:1';'FG address (Do not change)'],list('str',-1,'str',-1,'str',-1,'str',-1,'str',-1,'str',-1,'str',-1,'str',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar= [fg_address'];
                model.rpar= [sel_or_unsel,ibias_name,ibias_default,pbias_name,pbias_default,nbias_name,nbias_default,smallcap_bigcap];
                graphics.exprs=exprs; x.graphics=graphics; x.model=model;
                break;
            end
        end
    case 'define' then
        sel_or_unsel="-";
        ibias_name="fgota0_ibias";
        ibias_default="2e-6";
        pbias_name="fgota0_pbias";
        pbias_default="2e-6";
        nbias_name="fgota0_nbias";
        nbias_default="2e-6";
        smallcap_bigcap="0";
        fg_address=[32;58;33;59;33;58;31;59;31;58];
        model=scicos_model(); model.sim=list('fgota_c',5);
        model.in=[1;1]; model.in2=[1;1]; model.intyp=[-1;-1];
        model.out=-1; model.out2=1; model.outtyp=-1;
        model.ipar= [fg_address'];
        model.rpar= [sel_or_unsel,ibias_name,ibias_default,pbias_name,pbias_default,nbias_name,nbias_default,smallcap_bigcap];
        model.state=zeros(1,1); model.blocktype='d'; model.dep_ut=[%t %f]; 

        exprs=[sel_or_unsel;ibias_name;ibias_default;pbias_name;pbias_default;nbias_name;nbias_default;smallcap_bigcap;sci2exp(fg_address)]; 
        gr_i= ['text=[''Src'';'' Gate''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');'];
        x=standard_define([6 2],model,exprs,gr_i);
    end
endfunction
