function [x,y,typ]=mismatch_meas(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1); 
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1;
        graphics=arg1.graphics;
        exprs=graphics.exprs;
        model=arg1.model;
        while %t do
            [ok,num_of_blk exprs]=scicos_getvalue('Mismatch meas blocks',['No. of Mismatch meas blocks'],list('vec',1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar= num_of_blk;
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break;
            end
        end
    case 'define' then
        num_of_blk=1;
        model=scicos_model();
        //model.sim=list('nfet_c',5);
        model.in=[1;1;1];
        model.in2=[1;1;1];
        model.intyp=[-1;-1;-1];
        model.out=-1;
        model.out2=1;
        model.outtyp=-1;
        model.ipar=num_of_blk;
        model.state=zeros(1,1);
        model.blocktype='d';
        model.dep_ut=[%t %f]; 

        exprs=[sci2exp(num_of_blk)];
        gr_i= ['text=[''Src'';'' Gate''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');'];
        x=standard_define([8 2],model,exprs,gr_i);
    end
endfunction
