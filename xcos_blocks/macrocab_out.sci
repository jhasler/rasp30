function [x,y,typ]=macrocab_out(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1); 
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;
        while %t do
            [ok,global_out,local_out,fg_address,exprs]=scicos_getvalue('In',['Output:0-4, No use:-';'local output (Do not change)';'FG address (Do not change)'],list('str',-1,'str',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar= [fg_address'];
                model.rpar= [global_out,local_out];
                graphics.exprs=exprs; x.graphics=graphics; x.model=model;
                break;
            end
        end
    case 'define' then
        global_out="-";
        local_out="-";
        fg_address=[0];
        model=scicos_model(); model.sim=list('out_c',5);
        model.in=[1]; model.in2=[1]; model.intyp=[-1];
        model.out=[]; model.out2=[]; model.outtyp=[];
        model.ipar= [fg_address'];
        model.rpar= [global_out,local_out];
        model.state=zeros(1,1); model.blocktype='d'; model.dep_ut=[%t %f]; 

        exprs=[global_out;local_out;sci2exp(fg_address)]; 
        gr_i= ['text=[''Src'';'' Gate''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');'];
        x=standard_define([3 1],model,exprs,gr_i);
    end
endfunction
