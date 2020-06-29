function [x,y,typ]=adc_ip(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1);
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;  
        while %t do
            [ok,adc_num,exprs]=getvalue('Set ADC IP Block',['ADC number (1 or 2):'],list('vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.rpar=adc_num;
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break;
            end
        end
    case 'define' then
        adc_num =1;
        model=scicos_model();
        model.sim=list('adc_ip_c',5)
        model.in=[-1;];
        model.intyp=[-1];
        model.rpar=adc_num;
        model.blocktype='d';
        model.dep_ut=[%t %f];

        exprs=[sci2exp(adc_num)];
        gr_i=['txt='' ADC ip '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')'];
        x=standard_define([4 2],model, exprs,gr_i);
    end
endfunction
