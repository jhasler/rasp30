function [x,y,typ]=join(job,arg1,arg2)
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
        while %t do
            [ok,in_out_num,out_num,exprs]=scicos_getvalue('Join Block Parameters',['Number of Join Blocks';'Number of Outputs'],list('vec',1,'vec',1),exprs)

            if ~ok then break,end

            if ok then
                model.ipar= in_out_num;
                model.rpar= out_num;
                model.out= -ones(out_num,1)
                model.out2=ones(out_num,1)
                model.outtyp=-ones(out_num,1)
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end
        end

    case 'define' then
        in_out_num=1
        out_num=1
        model=scicos_model()
        model.sim=list('join_c',5)
        model.in=-1
        model.in2=1 
        model.intyp=-1 
        model.out=[-1]
        model.out2=[1]
        model.outtyp=[-1]
        model.ipar = in_out_num;
        model.rpar = out_num;
        model.blocktype='d'
        model.dep_ut=[%t %t] 

        exprs=[sci2exp(in_out_num);sci2exp(out_num)]
        gr_i=['txt='' Join'';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([3 3],model, exprs,gr_i)
    end
endfunction
