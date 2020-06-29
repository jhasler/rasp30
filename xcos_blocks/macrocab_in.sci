function [x,y,typ]=macrocab_in(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1); 
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;
        while %t do
            [ok,global_in,local_in,fg_address,exprs]=scicos_getvalue('In',['Input:0-12, No use:-';'local input (Do not change)';'FG address (Do not change)'],list('str',-1,'str',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar= [fg_address'];
                model.rpar= [global_in,local_in];
                graphics.exprs=exprs; x.graphics=graphics; x.model=model;
                break;
            end
        end
    case 'define' then
        global_in="-";
        local_in="-";
        fg_address=[0];
        model=scicos_model(); model.sim=list('in_c',5);
        model.in=[]; model.in2=[]; model.intyp=[];
        model.out=-1; model.out2=1; model.outtyp=-1;
        model.ipar= [fg_address'];
        model.rpar= [global_in,local_in];
        model.state=zeros(1,1); model.blocktype='d'; model.dep_ut=[%t %f]; 

        exprs=[global_in;local_in;sci2exp(fg_address)]; 
        gr_i= ['text=[''Src'';'' Gate''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');'];
        x=standard_define([3 1],model,exprs,gr_i);
    end
endfunction
