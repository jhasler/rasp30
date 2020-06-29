function [x,y,typ]=dac(job,arg1,arg2)
    // Copyright INRIA
    x=[];y=[];typ=[];
    select job
    case 'plot' then
        standard_draw(arg1)
    case 'getinputs' then //** GET INPUTS 
        [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then
        [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then
        [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;
        graphics=arg1.graphics
        model=arg1.model
        exprs=graphics.exprs
        while %t do //add the number of data pts to take
            [ok,name,out_num,value,exprs]=scicos_getvalue('Set DC Voltage Parameters',['Name of DC Source';'Number of Inputs';'Value'],list("str",-1,'vec',1,'col',-1),exprs)

            if ~ok then break,end

            if length(value) ~= out_num then
                message('The number of input voltage values that you have entered does not match the number of DAC blocks.');
                ok=%f;
            end
            
            for  ck_val=1:length(value) 
                       
                if(value(ck_val) < 0.14) then
                    message(msprintf('No voltage less than 0.14 is valid\nThe value you chose is: %d',value(ck_val)));
                    ok=%f;
                end
                
                if(value(ck_val) > 2.5) then
                    message(msprintf('No voltage greater than 2.5 is valid\nThe value you chose is: %d', value(ck_val)));
                    ok=%f;
                end

            end

            if ok then
                model.ipar = out_num;
                model.out= out_num;
                model.rpar= value;
                model.opar=list(name)
                model.sim=list('dac_c',5)
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
    case 'define' then
        name = 'input'
        value =1.5
        out_num = 1
        model=scicos_model()
        model.sim=list('dac_c',5)
        model.out= out_num
        model.out2= 1
        model.outtyp=-1
        model.rpar= value
        model.ipar = out_num
        model.opar=list(name)
        model.blocktype='d'
        model.dep_ut=[%t %t]

        exprs=[name;sci2exp(out_num);sci2exp(value)]
        gr_i=['txt='' DAC '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([3 2],model, exprs,gr_i)
    end
endfunction
