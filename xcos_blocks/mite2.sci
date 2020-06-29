function [x,y,typ]=mite2(job,arg1,arg2)
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
            [ok,value, exprs]=scicos_getvalue('Set MITE2 Block',['Value'],list('vec',-1),exprs)

            if ~ok then break,end

            //            if ipsize(1) ~= size(Wts,1) then
            //                message('The row dimension of the input vector and the row dimension of the Weights matrix are not equal.');
            //                ok=%f;
            //            end

            if ok then

                //                model.in=ipsize(1)
                //                model.in2=ipsize(2)
                //                model.out=size(Wts,2)
                //                model.out2=ipsize(1,2)
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
    case 'define' then

        value = 103
        model=scicos_model()
        model.sim=list('mite2_c',5)
        model.in=-ones(2,1)
        model.in2=-ones(2,1)
        model.intyp=-ones(2,1)
        model.out=-ones(2,1)
        model.out2=-ones(2,1)
        model.outtyp=-ones(2,1)
//        model.opar=
//        model.state=
//        model.rpar= 
//        model.ipar = 
        model.blocktype='d'
        model.dep_ut=[%t %t]

        exprs=[sci2exp(value)]
        gr_i=['txt='' MITE2 '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([4 2],model, exprs,gr_i)
    end
endfunction
