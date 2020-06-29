function [x,y,typ]=sft_reg(job,arg1,arg2)
    // Copyright INRIA
    x=[];y=[];typ=[];
    select job
    case 'plot' then
        standard_draw(arg1)
    case 'getinputs' then
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
            [ok,in_out_num,gbias,fbias,cap1,exprs]=getvalue('Set Shift Register Parameters',..
            [''],list(),exprs)

            if ~ok then break,end

            if ok then
                graphics.exprs=exprs;
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then

        model=scicos_model()
        model.sim=list('c4sp_fc',5)
        model.in=[-1;-1;-1;-1]
        model.in2=[1;1;1;1]
        model.intyp=[-1;-1;-1;-1]
        model.out=[-1;-1;-1;-1;-1;-1;-1]
        model.out2=[1;1;1;1;1;1;1]
        model.outtyp=[-1;-1;-1;-1;-1;-1;-1]
        model.blocktype='d'
        model.dep_ut=[%f %t]

        exprs=[]
        gr_i=['txt=''C4 '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([11 9],model,exprs,gr_i)
    end
endfunction
