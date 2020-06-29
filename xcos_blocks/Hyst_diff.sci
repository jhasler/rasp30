function [x,y,typ]=Hyst_diff(job,arg1,arg2)
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
        while %t do
            [ok, in_out_num, Hyst_diff_ota1_ibias, exprs]=scicos_getvalue('New Block Parameter',['number of blocks'; 'Hyst_diff_ota1_ibias'],list('vec',-1, 'vec', -1),exprs)
            
            if ~ok then break,end
            if ok then
                model.in=in_out_num
                model.out=in_out_num
                model.ipar=in_out_num
                model.rpar=[Hyst_diff_ota1_ibias ]
                graphics.exprs=exprs;
                model.state=[1 1.25].*ones(1,2*in_out_num)
                x.graphics=graphics;
                x.model=model
                break;
            end
        end
    case 'define' then
        in_out_num=1
        Hyst_diff_ota1_ibias=2e-6;
        model=scicos_model()
        model.sim=list('Hyst_diff_c',5)
        model.in=in_out_num
        model.in2=1
        model.intyp=-1
        model.out=in_out_num
        model.out2=1
        model.outtyp=-1
        model.ipar=in_out_num
        model.state=[1 1.25].*ones(1,2*in_out_num)
        model.rpar=[Hyst_diff_ota1_ibias ]
        model.blocktype='d'
        model.dep_ut=[%f %t] //[block input has direct feedthrough to output w/o ODE   block always active]
        
        exprs=[sci2exp(in_out_num);sci2exp(Hyst_diff_ota1_ibias)]
        gr_i=['txt=[''Hyst_diff''];';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([5 2],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
