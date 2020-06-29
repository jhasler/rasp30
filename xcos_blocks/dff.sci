function [x,y,typ]=dff(job,arg1,arg2)
    // Copyright INRIA
    // Sihwan
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
        graphics=arg1.graphics;exprs=graphics.exprs
        model=arg1.model;
        while %t do
            [ok,in_out_num,fix_loc,exprs]=getvalue('Set D Flip Flop Parameters',['Number of DFF blocks';'Fix_location'],list('vec',1,'vec',-1),exprs)

            if ~ok then break,end

            if ok then
                model.in=[-1;-1;-1]
                model.out=-1
                model.ipar=in_out_num
                model.rpar= [fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        in_out_num=1
        fix_loc=[0 0 0]
        model=scicos_model()
        model.in=[-1;-1;-1]
        model.in2=[1;1;1]
        model.intyp=[-1;-1;-1]
        model.out=-1
        model.out2=1
        model.outtyp=-1
        model.ipar=in_out_num
        model.rpar= [fix_loc'];
        model.blocktype='c'
        model.dep_ut=[%t %f]

        exprs=[sci2exp(in_out_num);sci2exp(fix_loc)]
        gr_i=['text=''DFF'';';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');']
        x=standard_define([8 4],model,exprs,gr_i)
    end
endfunction
