function [x,y,typ]=gpio_in_fixloc(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1)
    case 'getinputs' then x=[];y=[];typ=[];
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;
        graphics=arg1.graphics;exprs=graphics.exprs;
        model=arg1.model;
        while %t do
            [ok, W, S,fix_loc, exprs] = scicos_getvalue([msprintf(gettext("Set %s block parameters"), "GPIO_In");" "; gettext("GPIO In (0~15) generator");" "], [gettext("GPIO in Variable Name"); gettext("Sample Rate (Hz)");'Fix_location'], list("str",-1,"vec",1,"vec",-1), exprs);
            if ~ok then break,end
            if ok then
                mat_sz = size(evstr(W));
                model.out = mat_sz(1,1);
                model.rpar=[S,fix_loc'];
                //model.ipar=[gpio_in_num];
                model.opar=list(W);
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break
            end
        end
    case 'define' then
        S=5;
        //gpio_in_num=[0];
        W="gpio_in_var";
        fix_loc=[0;0];
        model=scicos_model();
        //model.sim=list('genarb_func',5)
        model.out=1;
        model.out2=1;
        model.outtyp=-1;
        model.rpar=[S,fix_loc'];
        //model.ipar=[gpio_in_num];
        model.opar=list(W);
        model.blocktype='d';
        model.dep_ut=[%t %t];

        exprs=[W;string(S); sci2exp(fix_loc)];
        gr_i=['txt=[''arbitrary waveform'';''generator''];'; 'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');'];
        x=standard_define([6 2],model,exprs,gr_i);
    end
endfunction
