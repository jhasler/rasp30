function [x,y,typ]=sin_block(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then
        standard_draw(arg1)
    case 'getinputs' then
        x=[];y=[];typ=[];
    case 'getoutputs' then
        [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then
        [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;
        graphics=arg1.graphics;exprs=graphics.exprs
        model=arg1.model;
        while %t do
            [ok, out_num, M, F, P, exprs] = scicos_getvalue('Set Sine Generator Block', ..
            ['Number of Sine Waves';"Magnitude"; "Frequency (Hz)"; gettext("Phase (deg)")], ..
            list("vec",1,"vec",-1,"vec",-1,"vec",-1), exprs);
            
            if ~ok then break,end
            
            if length(M) ~= out_num then
                message('The number of magnitude values that you have entered does not match the number of sine waves.');
                ok=%f;
            end
            if length(F) ~= out_num then
                message('The number of frequency values that you have entered does not match the number of sine waves.');
                ok=%f;
            end
            if length(P) ~= out_num then
                message('The number of phase values that you have entered does not match the number of sine waves.');
                ok=%f;
            end
            
            for  ck_val=1:length(F)
                if F(ck_val) < 0 then
                    block_parameter_error(msprintf(gettext("Wrong value for ''Frequency'' parameter: %0.3f."), F(ck_val)), ..
                    gettext("Strictly positive integer expected."));
                    ok = %f
                end
            end
            if ok then
                model.ipar = out_num;
                model.out= out_num;
                model.rpar=[M;F;P]
                graphics.exprs=exprs;
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        init_rpar=[1;100;0]
        out_num = 1
        model=scicos_model()
        model.sim=list('sin_block_c',5)
        model.out= out_num
        model.out2= 1
        model.outtyp=-1
        model.ipar = out_num
        model.rpar=init_rpar
        model.blocktype='d'
        model.dep_ut=[%t %t]

        exprs=[sci2exp(out_num);string(init_rpar(1));string(init_rpar(2));string(init_rpar(3))]
        gr_i=['txt=[''sinusoid'';''generator''];';
        'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([3 2],model,exprs,gr_i)
    end
endfunction
